-- ReplicatedStorage.ClientModules.NewMapAdded.MapLighting
-- Script path: ReplicatedStorage.ClientModules.NewMapAdded.MapLighting
-- Decompile time: 27.71 ms

-- Decompiled with Potassium's decompiler.

local u1 = {};
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Lighting = game:GetService("Lighting");
local workspace_Terrain = workspace.Terrain;
local GameStats = ReplicatedStorage:WaitForChild("GameStats");
local Assets = ReplicatedStorage:WaitForChild("Assets");
local Maps = Assets:WaitForChild("Maps");
local u2 = Assets:FindFirstChild("ExperimentalBloom") or Assets:WaitForChild("ExperimentalBloom");
local u3 = {};
local u4 = {};
local u5 = {};
local u6 = {};
local u7 = {};
local u8 = {};
local u9 = {};
local u10 = {};
local u11 = {};
local u12 = {};
local u13 = {};
local u14 = {};
local u15 = {};
local u16 = {};
local u17 = {};
local u18 = {};
local u19 = {};
local u20 = {};
local u21 = {};
local u22 = nil;
local u23 = false;
local u24 = nil;
local u25 = nil;
local u26 = false;
local u27 = setmetatable({}, {
    __mode = "k"
});

local function ApplyPostProcessingSetting() -- Line: 44
    -- upvalues: Lighting (copy), u26 (ref), u24 (ref), u27 (copy)
    for _, descendant in Lighting:GetDescendants() do
        if descendant:IsA("PostEffect") then
            if u26 and not u24.FramePriority.MainMenu then
                if u27[descendant] == nil then
                    u27[descendant] = descendant.Enabled;
                end;

                descendant.Enabled = false;
            elseif u27[descendant] ~= nil then
                descendant.Enabled = u27[descendant];
                u27[descendant] = nil;
            end;
        end;
    end;
end;

function u1.Init(p28, p29, p30) -- Line: 60
    -- upvalues: u24 (ref), u25 (ref), u1 (copy), Lighting (copy), u26 (ref), u27 (copy)
    u24 = p29;
    u25 = p30;

    if not u1.PostEffectAddedConnection then
        u1.PostEffectAddedConnection = Lighting.DescendantAdded:Connect(function(p31) -- Line: 65
            -- upvalues: u26 (ref), u24 (ref), u27 (ref)
            if p31:IsA("PostEffect") then
                if u26 and not u24.FramePriority.MainMenu then
                    if u27[p31] == nil then
                        u27[p31] = p31.Enabled;
                    end;

                    p31.Enabled = false;

                    return;
                end;

                if u27[p31] ~= nil then
                    p31.Enabled = u27[p31];
                    u27[p31] = nil;
                end;
            end;
        end);
    end;
end;

function u1.UpdateMapSettings(p32) -- Line: 81
    -- upvalues: u5 (ref), u6 (ref), u7 (ref), u8 (ref), u9 (ref), u10 (ref), u11 (ref), u12 (ref), u13 (ref), u14 (ref), u15 (ref), u16 (ref), u17 (ref), u18 (ref), u19 (ref), u20 (ref), u21 (ref)
    local v33 = p32 or {};
    u5 = v33;
    u6 = v33;
    u7 = v33;
    u8 = v33;
    u9 = v33;
    u10 = v33;
    u11 = v33;
    u12 = v33;
    u13 = v33;
    u14 = v33;
    u15 = v33;
    u16 = v33;
    u17 = v33;
    u18 = v33;
    u19 = v33;
    u20 = v33;
    u21 = v33;
end;

local u34 = nil;
local u35 = nil;

function u1.ApplyMapSettings(p36, p37) -- Line: 108
    -- upvalues: u34 (ref), u35 (ref), u22 (ref), u1 (copy)
    u34 = workspace:FindFirstChild("Map");
    u35 = p36;
    u1.UpdateMapSettings(u22 and u22.Maps and u22.Maps[p36]);

    if p37 ~= false then
        u1.OverrideEverything();
    end;
end;

function u1.ClearLightingData() -- Line: 119
    -- upvalues: u4 (copy)
    table.clear(u4);
end;

function u1.ApplyNoTexture(p38: boolean) -- Line: 123
    -- upvalues: u6 (ref), u3 (copy), GameStats (copy)
    if p38 == nil then
        local v39 = u6 and u6["Map Settings"] or {};

        if type(v39) == "table" then
            p38 = v39["No Texture"] or table.find(v39, "No Texture") or false;
        else
            p38 = false;
        end;
    end;

    if not p38 then
        for i, v in u3 do
            local v40;

            if v.Parent then
                if v.Parent.Parent then
                    i.Parent = v.Parent;
                    v40 = i;
                else
                    v40 = i;
                end;
            elseif i.Parent then
                v40 = i;

                for i2, v2 in v do
                    v40[i2] = v2;
                end;
            else
                v40 = i;
            end;

            u3[v40] = nil;
        end;

        return;
    end;

    local Map = workspace:FindFirstChild("Map");

    if Map and GameStats:GetAttribute("Map") ~= "burger" then
        for _, descendant in Map:GetDescendants() do
            if not u3[descendant] then
                if descendant:IsA("BasePart") then
                    local v41 = {
                        Material = descendant.Material,
                        MaterialVariant = descendant.MaterialVariant
                    };
                    local v42;

                    if descendant:IsA("MeshPart") then
                        v42 = descendant.TextureID or nil;
                    else
                        v42 = nil;
                    end;

                    v41.TextureID = v42;
                    u3[descendant] = v41;
                    descendant.Material = Enum.Material.SmoothPlastic;
                    descendant.MaterialVariant = "PotatoSmooth";

                    if descendant:IsA("MeshPart") then
                        descendant.TextureID = "";
                    end;
                elseif descendant:IsA("Decal") then
                    u3[descendant] = {
                        Transparency = descendant.Transparency
                    };
                    descendant.Transparency = 1;
                elseif descendant:IsA("SurfaceAppearance") then
                    u3[descendant] = {
                        Parent = descendant.Parent
                    };
                    descendant.Parent = nil;
                end;
            end;
        end;
    end;
end;

local u43 = nil;
local u44 = nil;

function u1.ApplyPotatoSettings(p45: boolean) -- Line: 192
    -- upvalues: u24 (ref), u5 (ref), u43 (ref), u44 (ref), u34 (ref), u35 (ref), Maps (copy), u1 (copy)
    if u24.HasFramePriority() then
        return;
    end;

    if p45 == nil then
        p45 = u5["Potato Environment"];
    end;

    local Map = workspace:FindFirstChild("Map");

    if u43 then
        local v46;

        if Map then
            v46 = Map:FindFirstChild("Geometry");
        else
            v46 = Map;
        end;

        if u44 ~= v46 then
            u43:Destroy();
            u43 = nil;
            u44 = nil;
        end;
    end;

    if Map and Map == u34 then
        local v47 = u35;

        if v47 ~= "burger" then
            local Geometry = Map.Geometry;

            if p45 then
                local v48 = Maps:FindFirstChild(v47);

                if v48 then
                    v48 = v48:FindFirstChild("PotatoSettings");
                end;

                local v49 = v48 and Geometry:FindFirstChild("DefaultSettings");

                if v49 then
                    u1.ApplyNoTexture(false);
                    u43 = v49;
                    u44 = Geometry;
                    v49.Parent = nil;
                    v48:Clone().Parent = Geometry;
                    u1.ApplyNoTexture();
                end;
            else
                local PotatoSettings = Geometry:FindFirstChild("PotatoSettings");

                if PotatoSettings and u43 then
                    u1.ApplyNoTexture(false);
                    PotatoSettings:Destroy();
                    u43.Parent = Geometry;
                    u43 = nil;
                    u44 = nil;
                    u1.ApplyNoTexture();
                end;
            end;
        end;
    end;
end;

function u1.ApplyNoShadows(p50: boolean) -- Line: 253
    -- upvalues: u6 (ref), u24 (ref), Lighting (copy)
    if p50 == nil then
        local v51 = u6 and u6["Map Settings"] or {};

        if type(v51) == "table" then
            p50 = v51["No Shadows"] or table.find(v51, "No Shadows") or false;
        else
            p50 = false;
        end;
    end;

    if p50 and u24.HasFramePriority() then
        return;
    end;

    Lighting.GlobalShadows = not p50;
end;

function u1.ApplyExperimentalBloom(p52: boolean) -- Line: 268
    -- upvalues: u6 (ref), u24 (ref), GameStats (copy), u1 (copy), Lighting (copy), ReplicatedStorage (copy), u2 (copy)
    if p52 == nil then
        local v53 = u6["Map Settings"] or {};

        if type(v53) == "table" then
            p52 = v53["Remove Bloom"] or table.find(v53, "Remove Bloom") or false;
        else
            p52 = false;
        end;
    end;

    if u24.HasFramePriority() then
        return;
    end;

    if workspace:FindFirstChild("Map") and GameStats:GetAttribute("Map") ~= "burger" then
        if p52 then
            u1.ApplyOverrideBloom(false);
            local v54 = Lighting:FindFirstChildOfClass("BloomEffect");

            if v54 then
                v54.Parent = ReplicatedStorage;
            end;

            u2:Clone().Parent = Lighting;

            return;
        end;

        u1.ApplyOverrideBloom();
        local ExperimentalBloom = Lighting:FindFirstChild("ExperimentalBloom");

        if ExperimentalBloom then
            ExperimentalBloom:Destroy();
            ReplicatedStorage:FindFirstChildOfClass("BloomEffect").Parent = Lighting;
        end;
    end;
end;

function u1.ApplyOverrideFog(p55: boolean) -- Line: 307
    -- upvalues: u24 (ref), u4 (copy), Lighting (copy), u7 (ref), u14 (ref)
    if u24.HasFramePriority() then
        return;
    end;

    local FogData = u4.FogData;

    if not FogData then
        u4.FogData = {
            FogColor = Lighting.FogColor,
            FogEnd = Lighting.FogEnd,
            FogStart = Lighting.FogStart,
            Override = false
        };
        FogData = u4.FogData;
    end;

    local v56;

    if p55 == nil or not p55 then
        v56 = u7 and u7["Override Fog"] and not u14["Override Atmosphere"];
    else
        v56 = p55;
    end;

    if p55 == nil then
        p55 = v56;
    end;

    if not p55 then
        if FogData.Override then
            Lighting.FogColor = FogData.FogColor;
            Lighting.FogEnd = FogData.FogEnd;
            Lighting.FogStart = FogData.FogStart;
            FogData.Override = false;
        end;

        return;
    end;

    local v57 = u7["Fog Color"];
    Lighting.FogColor = Color3.fromRGB(v57[1], v57[2], v57[3]);
    Lighting.FogStart = u7["Fog Start"];
    Lighting.FogEnd = u7["Fog End"];
    FogData.Override = true;
end;

function u1.ApplyOverrideAmbient(p58: boolean) -- Line: 347
    -- upvalues: u24 (ref), u4 (copy), Lighting (copy), u8 (ref)
    if u24.HasFramePriority() then
        return;
    end;

    local AmbientData = u4.AmbientData;

    if not AmbientData then
        u4.AmbientData = {
            Ambient = Lighting.Ambient,
            OutdoorAmbient = Lighting.OutdoorAmbient,
            ColorShift_Bottom = Lighting.ColorShift_Bottom,
            ColorShift_Top = Lighting.ColorShift_Bottom,
            Override = false
        };
        AmbientData = u4.AmbientData;
    end;

    if p58 == nil or not p58 then
        p58 = u8["Override Ambient"];
    end;

    if not p58 then
        if AmbientData.Override then
            Lighting.Ambient = AmbientData.Ambient;
            Lighting.OutdoorAmbient = AmbientData.OutdoorAmbient;
            Lighting.ColorShift_Bottom = AmbientData.ColorShift_Bottom;
            Lighting.ColorShift_Top = AmbientData.ColorShift_Top;
            AmbientData.Override = false;
        end;

        return;
    end;

    local Ambient = u8.Ambient;
    local v59 = u8["Outdoor Ambient"];
    local v60 = u8["Color Shift Bottom"];
    local v61 = u8["Color Shift Top"];
    Lighting.Ambient = Color3.fromRGB(Ambient[1], Ambient[2], Ambient[3]);
    Lighting.OutdoorAmbient = Color3.fromRGB(v59[1], v59[2], v59[3]);
    Lighting.ColorShift_Bottom = Color3.fromRGB(v60[1], v60[2], v60[3]);
    Lighting.ColorShift_Top = Color3.fromRGB(v61[1], v61[2], v61[3]);
    AmbientData.Override = true;
end;

function u1.ApplyOverrideTime(p62) -- Line: 390
    -- upvalues: u24 (ref), u4 (copy), Lighting (copy), u9 (ref)
    if u24.HasFramePriority() then
        return;
    end;

    local TimeData = u4.TimeData;

    if not TimeData then
        u4.TimeData = {
            Time = Lighting.ClockTime,
            Override = false
        };
        TimeData = u4.TimeData;
    end;

    if p62 == nil or not p62 then
        p62 = u9["Override Time"];
    end;

    if not p62 then
        if TimeData.Override then
            Lighting.ClockTime = TimeData.Time;
            TimeData.Override = false;
        end;

        return;
    end;

    Lighting.ClockTime = u9["Clock Time"];
    TimeData.Override = true;
end;

function u1.ApplyOverrideShadowAngle(p63) -- Line: 419
    -- upvalues: u24 (ref), u4 (copy), Lighting (copy), u10 (ref)
    if u24.HasFramePriority() then
        return;
    end;

    local ShadowData = u4.ShadowData;

    if not ShadowData then
        u4.ShadowData = {
            GeographicLatitude = Lighting.GeographicLatitude,
            Override = false
        };
        ShadowData = u4.ShadowData;
    end;

    if p63 == nil or not p63 then
        p63 = u10["Override Shadow Angle"];
    end;

    if not p63 then
        if ShadowData.Override then
            Lighting.GeographicLatitude = ShadowData.Time;
            ShadowData.Override = false;
        end;

        return;
    end;

    Lighting.GeographicLatitude = u10["Shadow Angle"];
    ShadowData.Override = true;
end;

function u1.ApplyOverrideBrightness(p64) -- Line: 448
    -- upvalues: u24 (ref), u4 (copy), Lighting (copy), u11 (ref)
    if u24.HasFramePriority() then
        return;
    end;

    local BrightnessData = u4.BrightnessData;

    if not BrightnessData then
        u4.BrightnessData = {
            Brightness = Lighting.Brightness,
            Override = false
        };
        BrightnessData = u4.BrightnessData;
    end;

    if p64 == nil or not p64 then
        p64 = u11["Override Brightness"];
    end;

    if not p64 then
        if BrightnessData.Override then
            Lighting.Brightness = BrightnessData.Brightness;
            BrightnessData.Override = false;
        end;

        return;
    end;

    Lighting.Brightness = u11.Brightness;
    BrightnessData.Override = true;
end;

function u1.ApplyOverrideExposureCompensation(p65) -- Line: 477
    -- upvalues: u24 (ref), u4 (copy), Lighting (copy), u12 (ref)
    if u24.HasFramePriority() then
        return;
    end;

    local ExposureCompensation = u4.ExposureCompensation;

    if not ExposureCompensation then
        u4.ExposureCompensationData = {
            ExposureCompensation = Lighting.ExposureCompensation,
            Override = false
        };
        ExposureCompensation = u4.ExposureCompensationData;
    end;

    if p65 == nil or not p65 then
        p65 = u12["Override Exposure Compensation"];
    end;

    if not p65 then
        if ExposureCompensation.Override then
            Lighting.ExposureCompensation = ExposureCompensation.Brightness;
            ExposureCompensation.Override = false;
        end;

        return;
    end;

    Lighting.ExposureCompensation = u12["Exposure Compensation"];
    ExposureCompensation.Override = true;
end;

function u1.ApplyOverrideEnvironment(p66) -- Line: 506
    -- upvalues: u24 (ref), u4 (copy), Lighting (copy), u13 (ref)
    if u24.HasFramePriority() then
        return;
    end;

    local EnvironmentData = u4.EnvironmentData;

    if not EnvironmentData then
        u4.EnvironmentData = {
            EnvironmentDiffuseScale = Lighting.EnvironmentDiffuseScale,
            EnvironmentSpecularScale = Lighting.EnvironmentSpecularScale,
            Override = false
        };
        EnvironmentData = u4.EnvironmentData;
    end;

    if p66 == nil or not p66 then
        p66 = u13["Override Environment Scales"];
    end;

    if not p66 then
        if EnvironmentData.Override then
            Lighting.EnvironmentDiffuseScale = EnvironmentData.EnvironmentDiffuseScale;
            Lighting.EnvironmentSpecularScale = EnvironmentData.EnvironmentSpecularScale;
            EnvironmentData.Override = false;
        end;

        return;
    end;

    Lighting.EnvironmentDiffuseScale = u13["Diffuse Scale"];
    Lighting.EnvironmentSpecularScale = u13["Specular Scale"];
    EnvironmentData.Override = true;
end;

function u1.ApplyOverrideAtmosphere(p67) -- Line: 539
    -- upvalues: u24 (ref), u14 (ref), u1 (copy), Lighting (copy), ReplicatedStorage (copy)
    if u24.HasFramePriority() then
        return;
    end;

    if p67 == nil or not p67 then
        p67 = u14["Override Atmosphere"];
    end;

    if not p67 then
        u1.ApplyOverrideFog();
        local OverridedAtmosphere = Lighting:FindFirstChild("OverridedAtmosphere");

        if OverridedAtmosphere then
            OverridedAtmosphere:Destroy();
        end;

        local Atmosphere = ReplicatedStorage:FindFirstChild("Atmosphere");

        if Atmosphere then
            Atmosphere.Parent = Lighting;
        end;

        return;
    end;

    u1.ApplyOverrideFog(false);
    local Atmosphere = Lighting:FindFirstChild("Atmosphere");

    if Atmosphere then
        Atmosphere.Parent = ReplicatedStorage;
    end;

    local OverridedAtmosphere = Lighting:FindFirstChild("OverridedAtmosphere");

    if not OverridedAtmosphere then
        OverridedAtmosphere = Instance.new("Atmosphere");
        OverridedAtmosphere.Name = "OverridedAtmosphere";
        OverridedAtmosphere.Parent = Lighting;
    end;

    OverridedAtmosphere.Density = u14["Atmosphere Density"];
    OverridedAtmosphere.Offset = u14["Atmosphere Offset"];
    OverridedAtmosphere.Glare = u14["Atmosphere Glare"];
    OverridedAtmosphere.Haze = u14["Atmosphere Haze"];
    local v68 = u14["Atmosphere Color"];
    OverridedAtmosphere.Color = Color3.fromRGB(v68[1], v68[2], v68[3]);
    local v69 = u14["Atmosphere Decay"];
    OverridedAtmosphere.Decay = Color3.fromRGB(v69[1], v69[2], v69[3]);
end;

function u1.ApplyOverrideBloom(p70) -- Line: 591
    -- upvalues: u24 (ref), u15 (ref), u6 (ref), Lighting (copy), ReplicatedStorage (copy)
    if u24.HasFramePriority() then
        return;
    end;

    if p70 == nil or not p70 then
        p70 = u15 and u15["Override Bloom"] and not u6["Map Settings"]["Experimental Bloom"];
    end;

    if not p70 then
        local OverridedBloom = Lighting:FindFirstChild("OverridedBloom");

        if OverridedBloom then
            OverridedBloom:Destroy();
        end;

        local Bloom = ReplicatedStorage:FindFirstChild("Bloom");

        if Bloom then
            Bloom.Parent = Lighting;
        end;

        return;
    end;

    local Bloom = Lighting:FindFirstChild("Bloom");

    if Bloom then
        Bloom.Parent = ReplicatedStorage;
    end;

    local OverridedBloom = Lighting:FindFirstChild("OverridedBloom");

    if not OverridedBloom then
        OverridedBloom = Instance.new("BloomEffect");
        OverridedBloom.Name = "OverridedBloom";
        OverridedBloom.Parent = Lighting;
    end;

    OverridedBloom.Intensity = u15["Bloom Intensity"];
    OverridedBloom.Size = u15["Bloom Size"];
    OverridedBloom.Threshold = u15["Bloom Threshold"];
end;

function u1.ApplyOverrideBlur(p71) -- Line: 630
    -- upvalues: u24 (ref), u15 (ref), Lighting (copy), ReplicatedStorage (copy), u16 (ref)
    if u24.HasFramePriority() then
        return;
    end;

    if p71 == nil or not p71 then
        p71 = u15["Override Blur"];
    end;

    if not p71 then
        local OverridedBlur = Lighting:FindFirstChild("OverridedBlur");

        if OverridedBlur then
            OverridedBlur:Destroy();
        end;

        local Blur = ReplicatedStorage:FindFirstChild("Blur");

        if Blur then
            Blur.Parent = Lighting;
        end;

        return;
    end;

    local Blur = Lighting:FindFirstChild("Blur");

    if Blur then
        Blur.Parent = ReplicatedStorage;
    end;

    local OverridedBlur = Lighting:FindFirstChild("OverridedBlur");

    if not OverridedBlur then
        OverridedBlur = Instance.new("BlurEffect");
        OverridedBlur.Name = "OverridedBlur";
        OverridedBlur.Parent = Lighting;
    end;

    OverridedBlur.Size = u16["Blur Size"];
end;

function u1.ApplyOverrideColorCorrection(p72) -- Line: 668
    -- upvalues: u24 (ref), u17 (ref), Lighting (copy), ReplicatedStorage (copy)
    if u24.HasFramePriority() then
        return;
    end;

    if p72 == nil or not p72 then
        p72 = u17["Override Color Correction"];
    end;

    if not p72 then
        local OverridedColorCorrection = Lighting:FindFirstChild("OverridedColorCorrection");

        if OverridedColorCorrection then
            OverridedColorCorrection:Destroy();
        end;

        local ColorCorrection = ReplicatedStorage:FindFirstChild("ColorCorrection");

        if ColorCorrection then
            ColorCorrection.Parent = Lighting;
        end;

        return;
    end;

    local ColorCorrection = Lighting:FindFirstChild("ColorCorrection");

    if ColorCorrection then
        ColorCorrection.Parent = ReplicatedStorage;
    end;

    local OverridedColorCorrection = Lighting:FindFirstChild("OverridedColorCorrection");

    if not OverridedColorCorrection then
        OverridedColorCorrection = Instance.new("ColorCorrectionEffect");
        OverridedColorCorrection.Name = "OverridedColorCorrection";
        OverridedColorCorrection.Parent = Lighting;
    end;

    OverridedColorCorrection.Brightness = u17["Color Correction Brightness"];
    OverridedColorCorrection.Contrast = u17["Color Correction Contrast"];
    OverridedColorCorrection.Saturation = u17["Color Correction Saturation"];
    local v73 = u17["Color Correction Tint Color"];
    OverridedColorCorrection.TintColor = Color3.fromRGB(v73[1], v73[2], v73[3]);
end;

function u1.ApplyOverrideSunRays(p74) -- Line: 711
    -- upvalues: u24 (ref), u18 (ref), Lighting (copy), ReplicatedStorage (copy)
    if u24.HasFramePriority() then
        return;
    end;

    if p74 == nil or not p74 then
        p74 = u18["Override Sun Rays"];
    end;

    if not p74 then
        local OverridedSunRays = Lighting:FindFirstChild("OverridedSunRays");

        if OverridedSunRays then
            OverridedSunRays:Destroy();
        end;

        local SunRays = ReplicatedStorage:FindFirstChild("SunRays");

        if SunRays then
            SunRays.Parent = Lighting;
        end;

        return;
    end;

    local SunRays = Lighting:FindFirstChild("SunRays");

    if SunRays then
        SunRays.Parent = ReplicatedStorage;
    end;

    local OverridedSunRays = Lighting:FindFirstChild("OverridedSunRays");

    if not OverridedSunRays then
        OverridedSunRays = Instance.new("SunRaysEffect");
        OverridedSunRays.Name = "OverridedSunRays";
        OverridedSunRays.Parent = Lighting;
    end;

    OverridedSunRays.Intensity = u18["Sun Rays Intensity"];
    OverridedSunRays.Spread = u18["Sun Rays Spread"];
end;

function u1.ApplyOverrideDepthOfField(p75) -- Line: 750
    -- upvalues: u24 (ref), u19 (ref), Lighting (copy), ReplicatedStorage (copy)
    if u24.HasFramePriority() then
        return;
    end;

    if p75 == nil or not p75 then
        p75 = u19["Override Depth Of Field"];
    end;

    if not p75 then
        local OverridedDepthOfField = Lighting:FindFirstChild("OverridedDepthOfField");

        if OverridedDepthOfField then
            OverridedDepthOfField:Destroy();
        end;

        local DepthOfField = ReplicatedStorage:FindFirstChild("DepthOfField");

        if DepthOfField then
            DepthOfField.Parent = Lighting;
        end;

        return;
    end;

    local DepthOfField = Lighting:FindFirstChild("DepthOfField");

    if DepthOfField then
        DepthOfField.Parent = ReplicatedStorage;
    end;

    local OverridedDepthOfField = Lighting:FindFirstChild("OverridedDepthOfField");

    if not OverridedDepthOfField then
        OverridedDepthOfField = Instance.new("DepthOfFieldEffect");
        OverridedDepthOfField.Name = "OverridedDepthOfField";
        OverridedDepthOfField.Parent = Lighting;
    end;

    OverridedDepthOfField.FarIntensity = u19["Depth Of Field Far Intensity"];
    OverridedDepthOfField.FocusDistance = u19["Depth Of Field Focus Distance"];
    OverridedDepthOfField.InFocusRadius = u19["Depth Of Field In Focus Radius"];
    OverridedDepthOfField.NearIntensity = u19["Depth Of Field Near Intensity"];
end;

function u1.ApplyOverrideColorGrading(p76) -- Line: 792
    -- upvalues: u24 (ref), u20 (ref), Lighting (copy), ReplicatedStorage (copy)
    if u24.HasFramePriority() then
        return;
    end;

    if p76 == nil or not p76 then
        p76 = u20["Override Color Grading"];
    end;

    if p76 then
        local ColorGrading = Lighting:FindFirstChild("ColorGrading");

        if ColorGrading then
            ColorGrading.Parent = ReplicatedStorage;
        end;

        local OverridedColorGrading = Lighting:FindFirstChild("OverridedColorGrading");

        if not OverridedColorGrading then
            OverridedColorGrading = Instance.new("ColorGradingEffect");
            OverridedColorGrading.Name = "OverridedColorGrading";
            OverridedColorGrading.Parent = Lighting;
        end;

        local v77 = Enum.TonemapperPreset[u20["Color Grading Tone Map"]];

        if v77 then
            OverridedColorGrading.TonemapperPreset = v77;
        end;
    else
        local OverridedColorGrading = Lighting:FindFirstChild("OverridedColorGrading");

        if OverridedColorGrading then
            OverridedColorGrading:Destroy();
        end;

        local ColorGrading = ReplicatedStorage:FindFirstChild("ColorGrading");

        if ColorGrading then
            ColorGrading.Parent = Lighting;
        end;
    end;
end;

function u1.ApplyOverrideClouds(p78) -- Line: 835
    -- upvalues: u24 (ref), u21 (ref), workspace_Terrain (copy)
    if u24.HasFramePriority() then
        return;
    end;

    if p78 == nil or not p78 then
        p78 = u21["Override Clouds"];
    end;

    if not p78 then
        local OverridedClouds = workspace_Terrain:FindFirstChild("OverridedClouds");

        if OverridedClouds then
            OverridedClouds:Destroy();
        end;

        local Clouds = workspace_Terrain:FindFirstChild("Clouds");

        if Clouds then
            Clouds.Enabled = false;
        end;

        return;
    end;

    local Clouds = workspace_Terrain:FindFirstChild("Clouds");

    if Clouds then
        Clouds.Enabled = false;
    end;

    local OverridedClouds = workspace_Terrain:FindFirstChild("OverridedClouds");

    if not OverridedClouds then
        OverridedClouds = Instance.new("Clouds");
        OverridedClouds.Name = "OverridedClouds";
        OverridedClouds.Parent = workspace_Terrain;
    end;

    OverridedClouds.Cover = u21["Clouds Cover"];
    OverridedClouds.Density = u21["Clouds Density"];
    local v79 = u21["Clouds Color"];
    OverridedClouds.Color = Color3.fromRGB(v79[1], v79[2], v79[3]);
end;

function u1.OverrideEverything(p80: boolean) -- Line: 877
    -- upvalues: u1 (copy)
    u1.ApplyPotatoSettings(p80);
    u1.ApplyNoTexture(p80);
    u1.ApplyOverrideFog(p80);
    u1.ApplyOverrideBloom(p80);
    u1.ApplyOverrideSunRays(p80);
    u1.ApplyOverrideBloom(p80);
    u1.ApplyOverrideBlur(p80);
    u1.ApplyOverrideTime(p80);
    u1.ApplyOverrideAmbient(p80);
    u1.ApplyExperimentalBloom(p80);
    u1.ApplyOverrideAtmosphere(p80);
    u1.ApplyOverrideExposureCompensation(p80);
    u1.ApplyNoShadows(p80);
    u1.ApplyOverrideBrightness(p80);
    u1.ApplyOverrideShadowAngle(p80);
    u1.ApplyOverrideColorGrading(p80);
    u1.ApplyOverrideDepthOfField(p80);
    u1.ApplyOverrideColorCorrection(p80);
    u1.ApplyOverrideEnvironment(p80);
    u1.ApplyOverrideClouds(p80);
end;

function u1.UpdatePlayerSettings() -- Line: 902
    -- upvalues: u22 (ref), u25 (ref), u26 (ref), ApplyPostProcessingSetting (copy), u34 (ref), u1 (copy), u35 (ref), u23 (ref), GameStats (copy), u7 (ref), u8 (ref), u9 (ref), u10 (ref), u11 (ref), u12 (ref), u13 (ref), u14 (ref), u15 (ref), u16 (ref), u17 (ref), u18 (ref), u19 (ref), u20 (ref), u21 (ref)
    u22 = u25:GetPlayerSettings();
    local v81 = u22.Game and u22.Game["Graphics & Visuals"];
    u26 = v81 and v81["Remove Post Processing Effects"] or false;
    ApplyPostProcessingSetting();

    if u34 and workspace:FindFirstChild("Map") == u34 then
        u1.UpdateMapSettings(u22.Maps[u35]);
    end;

    if u23 then
        return;
    end;

    u23 = true;
    u25:AddConnection("Game", "Graphics & Visuals", "Remove Post Processing Effects", function(p82) -- Line: 918
        -- upvalues: u26 (ref), ApplyPostProcessingSetting (ref)
        u26 = p82;
        ApplyPostProcessingSetting();
    end);

    for i, _ in pairs(u22.Maps) do
        u25:AddConnection("Maps", i, "Potato Environment", function(p83) -- Line: 926
            -- upvalues: GameStats (ref), i (copy), u1 (ref)
            if GameStats:GetAttribute("Map") == i then
                u1.ApplyPotatoSettings(p83);
            end;
        end);
        u25:AddConnection("Maps", i, "Map Settings", function(p84) -- Line: 932
            -- upvalues: GameStats (ref), i (copy), u1 (ref)
            if GameStats:GetAttribute("Map") == i then
                for i2, v in p84 do
                    if i2 == "No Texture" then
                        u1.ApplyNoTexture(v);
                    elseif i2 == "No Shadows" then
                        u1.ApplyNoShadows(v);
                    elseif i2 == "Remove Bloom" then
                        u1.ApplyExperimentalBloom(v);
                    end;
                end;
            end;
        end);
        u25:AddConnection("Maps", i, "Override Fog", function(p85) -- Line: 948
            -- upvalues: GameStats (ref), i (copy), u7 (ref), u1 (ref)
            if GameStats:GetAttribute("Map") == i then
                u7["Override Fog"] = p85;
                u1.ApplyOverrideFog();
            end;
        end);
        u25:AddConnection("Maps", i, "Fog Color", function(p86) -- Line: 955
            -- upvalues: GameStats (ref), i (copy), u7 (ref), u1 (ref)
            if GameStats:GetAttribute("Map") == i then
                u7["Fog Color"] = p86;
                u1.ApplyOverrideFog();
            end;
        end);
        u25:AddConnection("Maps", i, "Fog Start", function(p87) -- Line: 962
            -- upvalues: GameStats (ref), i (copy), u7 (ref), u1 (ref)
            if GameStats:GetAttribute("Map") == i then
                u7["Fog Start"] = p87;
                u1.ApplyOverrideFog();
            end;
        end);
        u25:AddConnection("Maps", i, "Fog End", function(p88) -- Line: 969
            -- upvalues: GameStats (ref), i (copy), u7 (ref), u1 (ref)
            if GameStats:GetAttribute("Map") == i then
                u7["Fog End"] = p88;
                u1.ApplyOverrideFog();
            end;
        end);
        u25:AddConnection("Maps", i, "Override Ambient", function(p89) -- Line: 978
            -- upvalues: GameStats (ref), i (copy), u8 (ref), u1 (ref)
            if GameStats:GetAttribute("Map") == i then
                u8["Override Ambient"] = p89;
                u1.ApplyOverrideAmbient();
            end;
        end);
        u25:AddConnection("Maps", i, "Ambient", function(p90) -- Line: 985
            -- upvalues: GameStats (ref), i (copy), u8 (ref), u1 (ref)
            if GameStats:GetAttribute("Map") == i then
                u8.Ambient = p90;
                u1.ApplyOverrideAmbient();
            end;
        end);
        u25:AddConnection("Maps", i, "Outdoor Ambient", function(p91) -- Line: 992
            -- upvalues: GameStats (ref), i (copy), u8 (ref), u1 (ref)
            if GameStats:GetAttribute("Map") == i then
                u8["Outdoor Ambient"] = p91;
                u1.ApplyOverrideAmbient();
            end;
        end);
        u25:AddConnection("Maps", i, "Color Shift Bottom", function(p92) -- Line: 999
            -- upvalues: GameStats (ref), i (copy), u8 (ref), u1 (ref)
            if GameStats:GetAttribute("Map") == i then
                u8["Color Shift Bottom"] = p92;
                u1.ApplyOverrideAmbient();
            end;
        end);
        u25:AddConnection("Maps", i, "Color Shift Top", function(p93) -- Line: 1006
            -- upvalues: GameStats (ref), i (copy), u8 (ref), u1 (ref)
            if GameStats:GetAttribute("Map") == i then
                u8["Color Shift Top"] = p93;
                u1.ApplyOverrideAmbient();
            end;
        end);
        u25:AddConnection("Maps", i, "Override Time", function(p94) -- Line: 1015
            -- upvalues: GameStats (ref), i (copy), u9 (ref), u1 (ref)
            if GameStats:GetAttribute("Map") == i then
                u9["Override Time"] = p94;
                u1.ApplyOverrideTime();
            end;
        end);
        u25:AddConnection("Maps", i, "Clock Time", function(p95) -- Line: 1022
            -- upvalues: GameStats (ref), i (copy), u9 (ref), u1 (ref)
            if GameStats:GetAttribute("Map") == i then
                u9["Clock Time"] = p95;
                u1.ApplyOverrideTime();
            end;
        end);
        u25:AddConnection("Maps", i, "Override Shadow Angle", function(p96) -- Line: 1031
            -- upvalues: GameStats (ref), i (copy), u10 (ref), u1 (ref)
            if GameStats:GetAttribute("Map") == i then
                u10["Override Shadow Angle"] = p96;
                u1.ApplyOverrideShadowAngle();
            end;
        end);
        u25:AddConnection("Maps", i, "Shadow Angle", function(p97) -- Line: 1038
            -- upvalues: GameStats (ref), i (copy), u10 (ref), u1 (ref)
            if GameStats:GetAttribute("Map") == i then
                u10["Shadow Angle"] = p97;
                u1.ApplyOverrideShadowAngle();
            end;
        end);
        u25:AddConnection("Maps", i, "Override Brightness", function(p98) -- Line: 1047
            -- upvalues: GameStats (ref), i (copy), u11 (ref), u1 (ref)
            if GameStats:GetAttribute("Map") == i then
                u11["Override Brightness"] = p98;
                u1.ApplyOverrideBrightness();
            end;
        end);
        u25:AddConnection("Maps", i, "Brightness", function(p99) -- Line: 1054
            -- upvalues: GameStats (ref), i (copy), u11 (ref), u1 (ref)
            if GameStats:GetAttribute("Map") == i then
                u11.Brightness = p99;
                u1.ApplyOverrideBrightness();
            end;
        end);
        u25:AddConnection("Maps", i, "Override Exposure Compensation", function(p100) -- Line: 1063
            -- upvalues: GameStats (ref), i (copy), u12 (ref), u1 (ref)
            if GameStats:GetAttribute("Map") == i then
                u12["Override Exposure Compensation"] = p100;
                u1.ApplyOverrideExposureCompensation();
            end;
        end);
        u25:AddConnection("Maps", i, "Exposure Compensation", function(p101) -- Line: 1070
            -- upvalues: GameStats (ref), i (copy), u12 (ref), u1 (ref)
            if GameStats:GetAttribute("Map") == i then
                u12["Exposure Compensation"] = p101;
                u1.ApplyOverrideExposureCompensation();
            end;
        end);
        u25:AddConnection("Maps", i, "Override Environment Scales", function(p102) -- Line: 1079
            -- upvalues: GameStats (ref), i (copy), u13 (ref), u1 (ref)
            if GameStats:GetAttribute("Map") == i then
                u13["Override Environment Scales"] = p102;
                u1.ApplyOverrideEnvironment();
            end;
        end);
        u25:AddConnection("Maps", i, "Diffuse Scale", function(p103) -- Line: 1086
            -- upvalues: GameStats (ref), i (copy), u13 (ref), u1 (ref)
            if GameStats:GetAttribute("Map") == i then
                u13["Diffuse Scale"] = p103;
                u1.ApplyOverrideEnvironment();
            end;
        end);
        u25:AddConnection("Maps", i, "Specular Scale", function(p104) -- Line: 1093
            -- upvalues: GameStats (ref), i (copy), u13 (ref), u1 (ref)
            if GameStats:GetAttribute("Map") == i then
                u13["Specular Scale"] = p104;
                u1.ApplyOverrideEnvironment();
            end;
        end);
        u25:AddConnection("Maps", i, "Override Atmosphere", function(p105) -- Line: 1102
            -- upvalues: GameStats (ref), i (copy), u14 (ref), u1 (ref)
            if GameStats:GetAttribute("Map") == i then
                u14["Override Atmosphere"] = p105;
                u1.ApplyOverrideAtmosphere();
            end;
        end);
        u25:AddConnection("Maps", i, "Atmosphere Density", function(p106) -- Line: 1109
            -- upvalues: GameStats (ref), i (copy), u14 (ref), u1 (ref)
            if GameStats:GetAttribute("Map") == i then
                u14["Atmosphere Density"] = p106;
                u1.ApplyOverrideAtmosphere();
            end;
        end);
        u25:AddConnection("Maps", i, "Atmosphere Offset", function(p107) -- Line: 1116
            -- upvalues: GameStats (ref), i (copy), u14 (ref), u1 (ref)
            if GameStats:GetAttribute("Map") == i then
                u14["Atmosphere Offset"] = p107;
                u1.ApplyOverrideAtmosphere();
            end;
        end);
        u25:AddConnection("Maps", i, "Atmosphere Glare", function(p108) -- Line: 1123
            -- upvalues: GameStats (ref), i (copy), u14 (ref), u1 (ref)
            if GameStats:GetAttribute("Map") == i then
                u14["Atmosphere Glare"] = p108;
                u1.ApplyOverrideAtmosphere();
            end;
        end);
        u25:AddConnection("Maps", i, "Atmosphere Haze", function(p109) -- Line: 1130
            -- upvalues: GameStats (ref), i (copy), u14 (ref), u1 (ref)
            if GameStats:GetAttribute("Map") == i then
                u14["Atmosphere Haze"] = p109;
                u1.ApplyOverrideAtmosphere();
            end;
        end);
        u25:AddConnection("Maps", i, "Atmosphere Color", function(p110) -- Line: 1137
            -- upvalues: GameStats (ref), i (copy), u14 (ref), u1 (ref)
            if GameStats:GetAttribute("Map") == i then
                u14["Atmosphere Color"] = p110;
                u1.ApplyOverrideAtmosphere();
            end;
        end);
        u25:AddConnection("Maps", i, "Atmosphere Decay", function(p111) -- Line: 1144
            -- upvalues: GameStats (ref), i (copy), u14 (ref), u1 (ref)
            if GameStats:GetAttribute("Map") == i then
                u14["Atmosphere Decay"] = p111;
                u1.ApplyOverrideAtmosphere();
            end;
        end);
        u25:AddConnection("Maps", i, "Override Bloom", function(p112) -- Line: 1153
            -- upvalues: GameStats (ref), i (copy), u15 (ref), u1 (ref)
            if GameStats:GetAttribute("Map") == i then
                u15["Override Bloom"] = p112;
                u1.ApplyOverrideBloom();
            end;
        end);
        u25:AddConnection("Maps", i, "Bloom Intensity", function(p113) -- Line: 1160
            -- upvalues: GameStats (ref), i (copy), u15 (ref), u1 (ref)
            if GameStats:GetAttribute("Map") == i then
                u15["Bloom Intensity"] = p113;
                u1.ApplyOverrideBloom();
            end;
        end);
        u25:AddConnection("Maps", i, "Bloom Size", function(p114) -- Line: 1167
            -- upvalues: GameStats (ref), i (copy), u15 (ref), u1 (ref)
            if GameStats:GetAttribute("Map") == i then
                u15["Bloom Size"] = p114;
                u1.ApplyOverrideBloom();
            end;
        end);
        u25:AddConnection("Maps", i, "Bloom Threshold", function(p115) -- Line: 1174
            -- upvalues: GameStats (ref), i (copy), u15 (ref), u1 (ref)
            if GameStats:GetAttribute("Map") == i then
                u15["Bloom Threshold"] = p115;
                u1.ApplyOverrideBloom();
            end;
        end);
        u25:AddConnection("Maps", i, "Override Blur", function(p116) -- Line: 1183
            -- upvalues: GameStats (ref), i (copy), u16 (ref), u1 (ref)
            if GameStats:GetAttribute("Map") == i then
                u16["Override Blur"] = p116;
                u1.ApplyOverrideBlur();
            end;
        end);
        u25:AddConnection("Maps", i, "Blur Size", function(p117) -- Line: 1190
            -- upvalues: GameStats (ref), i (copy), u16 (ref), u1 (ref)
            if GameStats:GetAttribute("Map") == i then
                u16["Blur Size"] = p117;
                u1.ApplyOverrideBlur();
            end;
        end);
        u25:AddConnection("Maps", i, "Override Color Correction", function(p118) -- Line: 1200
            -- upvalues: GameStats (ref), i (copy), u17 (ref), u1 (ref)
            if GameStats:GetAttribute("Map") == i then
                u17["Override Color Correction"] = p118;
                u1.ApplyOverrideColorCorrection();
            end;
        end);
        u25:AddConnection("Maps", i, "Color Correction Brightness", function(p119) -- Line: 1207
            -- upvalues: GameStats (ref), i (copy), u17 (ref), u1 (ref)
            if GameStats:GetAttribute("Map") == i then
                u17["Color Correction Brightness"] = p119;
                u1.ApplyOverrideColorCorrection();
            end;
        end);
        u25:AddConnection("Maps", i, "Color Correction Contrast", function(p120) -- Line: 1214
            -- upvalues: GameStats (ref), i (copy), u17 (ref), u1 (ref)
            if GameStats:GetAttribute("Map") == i then
                u17["Color Correction Contrast"] = p120;
                u1.ApplyOverrideColorCorrection();
            end;
        end);
        u25:AddConnection("Maps", i, "Color Correction Saturation", function(p121) -- Line: 1221
            -- upvalues: GameStats (ref), i (copy), u17 (ref), u1 (ref)
            if GameStats:GetAttribute("Map") == i then
                u17["Color Correction Saturation"] = p121;
                u1.ApplyOverrideColorCorrection();
            end;
        end);
        u25:AddConnection("Maps", i, "Color Correction Tint Color", function(p122) -- Line: 1228
            -- upvalues: GameStats (ref), i (copy), u17 (ref), u1 (ref)
            if GameStats:GetAttribute("Map") == i then
                u17["Color Correction Tint Color"] = p122;
                u1.ApplyOverrideColorCorrection();
            end;
        end);
        u25:AddConnection("Maps", i, "Override Sun Rays", function(p123) -- Line: 1237
            -- upvalues: GameStats (ref), i (copy), u18 (ref), u1 (ref)
            if GameStats:GetAttribute("Map") == i then
                u18["Override Sun Rays"] = p123;
                u1.ApplyOverrideSunRays();
            end;
        end);
        u25:AddConnection("Maps", i, "Sun Rays Intensity", function(p124) -- Line: 1244
            -- upvalues: GameStats (ref), i (copy), u18 (ref), u1 (ref)
            if GameStats:GetAttribute("Map") == i then
                u18["Sun Rays Intensity"] = p124;
                u1.ApplyOverrideSunRays();
            end;
        end);
        u25:AddConnection("Maps", i, "Sun Rays Spread", function(p125) -- Line: 1251
            -- upvalues: GameStats (ref), i (copy), u18 (ref), u1 (ref)
            if GameStats:GetAttribute("Map") == i then
                u18["Sun Rays Spread"] = p125;
                u1.ApplyOverrideSunRays();
            end;
        end);
        u25:AddConnection("Maps", i, "Override Depth Of Field", function(p126) -- Line: 1260
            -- upvalues: GameStats (ref), i (copy), u19 (ref), u1 (ref)
            if GameStats:GetAttribute("Map") == i then
                u19["Override Depth Of Field"] = p126;
                u1.ApplyOverrideDepthOfField();
            end;
        end);
        u25:AddConnection("Maps", i, "Depth Of Field Far Intensity", function(p127) -- Line: 1267
            -- upvalues: GameStats (ref), i (copy), u19 (ref), u1 (ref)
            if GameStats:GetAttribute("Map") == i then
                u19["Depth Of Field Far Intensity"] = p127;
                u1.ApplyOverrideDepthOfField();
            end;
        end);
        u25:AddConnection("Maps", i, "Depth Of Field Focus Distance", function(p128) -- Line: 1274
            -- upvalues: GameStats (ref), i (copy), u19 (ref), u1 (ref)
            if GameStats:GetAttribute("Map") == i then
                u19["Depth Of Field Focus Distance"] = p128;
                u1.ApplyOverrideDepthOfField();
            end;
        end);
        u25:AddConnection("Maps", i, "Depth Of Field In Focus Radius", function(p129) -- Line: 1281
            -- upvalues: GameStats (ref), i (copy), u19 (ref), u1 (ref)
            if GameStats:GetAttribute("Map") == i then
                u19["Depth Of Field In Focus Radius"] = p129;
                u1.ApplyOverrideDepthOfField();
            end;
        end);
        u25:AddConnection("Maps", i, "Depth Of Field Near Intensity", function(p130) -- Line: 1288
            -- upvalues: GameStats (ref), i (copy), u19 (ref), u1 (ref)
            if GameStats:GetAttribute("Map") == i then
                u19["Depth Of Field Near Intensity"] = p130;
                u1.ApplyOverrideDepthOfField();
            end;
        end);
        u25:AddConnection("Maps", i, "Override Color Grading", function(p131) -- Line: 1297
            -- upvalues: GameStats (ref), i (copy), u20 (ref), u1 (ref)
            if GameStats:GetAttribute("Map") == i then
                u20["Override Color Grading"] = p131;
                u1.ApplyOverrideColorGrading();
            end;
        end);
        u25:AddConnection("Maps", i, "Color Grading Tone Map", function(p132) -- Line: 1304
            -- upvalues: GameStats (ref), i (copy), u20 (ref), u1 (ref)
            if GameStats:GetAttribute("Map") == i then
                u20["Color Grading Tone Map"] = p132;
                u1.ApplyOverrideColorGrading();
            end;
        end);
        u25:AddConnection("Maps", i, "Override Clouds", function(p133) -- Line: 1313
            -- upvalues: GameStats (ref), i (copy), u21 (ref), u1 (ref)
            if GameStats:GetAttribute("Map") == i then
                u21["Override Clouds"] = p133;
                u1.ApplyOverrideClouds();
            end;
        end);
        u25:AddConnection("Maps", i, "Clouds Cover", function(p134) -- Line: 1320
            -- upvalues: GameStats (ref), i (copy), u21 (ref), u1 (ref)
            if GameStats:GetAttribute("Map") == i then
                u21["Clouds Cover"] = p134;
                u1.ApplyOverrideClouds();
            end;
        end);
        u25:AddConnection("Maps", i, "Clouds Density", function(p135) -- Line: 1327
            -- upvalues: GameStats (ref), i (copy), u21 (ref), u1 (ref)
            if GameStats:GetAttribute("Map") == i then
                u21["Clouds Density"] = p135;
                u1.ApplyOverrideClouds();
            end;
        end);
        u25:AddConnection("Maps", i, "Clouds Color", function(p136) -- Line: 1334
            -- upvalues: GameStats (ref), i (copy), u21 (ref), u1 (ref)
            if GameStats:GetAttribute("Map") == i then
                u21["Clouds Color"] = p136;
                u1.ApplyOverrideClouds();
            end;
        end);
    end;
end;

return u1;