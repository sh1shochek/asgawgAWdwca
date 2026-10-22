-- ReplicatedStorage.Controllers.GraphicsQualityController
-- Script path: ReplicatedStorage.Controllers.GraphicsQualityController
-- Decompile time: 6.81 ms

-- Decompiled with Potassium's decompiler.

local v1 = {};
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local MaterialService = game:GetService("MaterialService");
local Lighting = game:GetService("Lighting");
local Players = game:GetService("Players");
local Workspace = game:GetService("Workspace");
local DataController = require(ReplicatedStorage.Controllers.DataController);
local script_PotatoColors = require(script.PotatoColors);
local u2 = {
    BloomEffect = true,
    SunRaysEffect = true,
    DepthOfFieldEffect = true,
    Clouds = true
};
local u3 = {
    SurfaceAppearance = true,
    Texture = true
};
local u4 = {
    ["bush 1"] = true,
    ["bush 2"] = true,
    ["tree 1"] = true,
    grass = true,
    trees = true
};
local LocalPlayer = Players.LocalPlayer;
local u5 = false;
local u6 = {};
local u7 = {};
local u8 = setmetatable({}, {
    __mode = "k"
});
local u9 = setmetatable({}, {
    __mode = "k"
});

local function assetIdOf(p10: string) -- Line: 77
    return tonumber(string.match(p10, "(%d+)$"));
end;

local function colorOf(p11) -- Line: 83
    return Color3.fromRGB(p11[1], p11[2], p11[3]);
end;

local function multiplyColors(p12, p13) -- Line: 89
    return Color3.new(p12.R * p13.R, p12.G * p13.G, p12.B * p13.B);
end;

local function tintForMaterialVariant(p14: userdata) -- Line: 97
    -- upvalues: u8 (copy), u7 (copy), script_PotatoColors (copy)
    if u8[p14] then
        return;
    end;

    u8[p14] = true;
    local v15;

    if p14.MaterialVariant == "" then
        v15 = u7[p14.Material];
    else
        v15 = p14.MaterialVariant;
    end;

    local v16;

    if v15 then
        v16 = script_PotatoColors.MaterialVariants[`{p14.Material.Name}/{v15}`];
    else
        v16 = nil;
    end;

    if v16 then
        local Color = p14.Color;
        local Color3_fromRGB_ret = Color3.fromRGB(v16[1], v16[2], v16[3]);
        p14.Color = Color3.new(Color.R * Color3_fromRGB_ret.R, Color.G * Color3_fromRGB_ret.G, Color.B * Color3_fromRGB_ret.B);
    end;
end;

local function tintForRemovedSurface(p17: userdata) -- Line: 114
    -- upvalues: script_PotatoColors (copy), u9 (copy)
    local Parent = p17.Parent;

    if not (Parent and Parent:IsA("BasePart")) then
        return;
    end;

    local v18 = 1;
    local v19 = 1;
    local v20, v21, v22;

    if p17:IsA("Texture") then
        local v23 = tonumber(string.match(p17.Texture, "(%d+)$"));

        if v23 then
            v20 = script_PotatoColors.Textures[v23];
        else
            v20 = nil;
        end;

        v21 = p17.Texture;
        v22 = p17.Color3;
        v18 = 1 - p17.Transparency;
    else
        if not (p17:IsA("SurfaceAppearance") and Parent:IsA("MeshPart")) then
            return;
        end;

        local v24 = tonumber(string.match(Parent.MeshId, "(%d+)$"));

        if v24 then
            v20 = script_PotatoColors.SurfaceAppearances[v24];
        else
            v20 = nil;
        end;

        v22 = p17.Color;
        v21 = "SurfaceAppearance";
    end;

    if not (v20 and v21) then
        return;
    end;

    if p17:IsA("Texture") or p17.AlphaMode == Enum.AlphaMode.Overlay then
        v19 = v20[4];
    end;

    local v25 = u9[Parent];

    if not v25 then
        v25 = {};
        u9[Parent] = v25;
    end;

    if v25[v21] then
        return;
    end;

    v25[v21] = true;
    local Color = Parent.Color;
    local Color3_fromRGB_ret = Color3.fromRGB(v20[1], v20[2], v20[3]);
    Parent.Color = Color:Lerp(Color3.new(Color3_fromRGB_ret.R * v22.R, Color3_fromRGB_ret.G * v22.G, Color3_fromRGB_ret.B * v22.B), v19 * v18);
end;

local function stripMaterialInstance(p26: userdata) -- Line: 165
    if p26:IsA("MaterialVariant") then
        p26:Destroy();
    end;
end;

local function stripEffectInstance(p27: userdata) -- Line: 173
    -- upvalues: u2 (copy)
    if u2[p27.ClassName] then
        p27:Destroy();
    end;
end;

local function isInsideRig(p28: userdata) -- Line: 183
    -- upvalues: Workspace (copy)
    local Parent = p28.Parent;

    while Parent and Parent ~= Workspace do
        if Parent:IsA("Model") and (Parent:FindFirstChild("HumanoidRootPart") or (Parent:FindFirstChildOfClass("Humanoid") or Parent:FindFirstChildOfClass("AnimationController"))) then
            return true;
        end;

        Parent = Parent.Parent;
    end;

    return false;
end;

local function stripMapInstance(p29: userdata) -- Line: 203
    -- upvalues: u3 (copy), isInsideRig (copy), tintForRemovedSurface (copy), tintForMaterialVariant (copy), u4 (copy)
    if (u3[p29.ClassName] or p29:IsA("BasePart")) and isInsideRig(p29) then
        return;
    end;

    if not u3[p29.ClassName] then
        if p29:IsA("BasePart") then
            p29.CastShadow = false;
            tintForMaterialVariant(p29);

            if u4[p29.Name] and not p29.CanCollide then
                p29.Transparency = 1;

                return;
            end;
        elseif p29:IsA("Light") then
            p29.Shadows = false;
        end;

        return;
    end;

    tintForRemovedSurface(p29);
    p29:Destroy();
end;

local function stripContainer(p30: userdata, u31: function, p32: boolean) -- Line: 227
    local v33;

    if p32 then
        v33 = p30.DescendantAdded;
    else
        v33 = p30.ChildAdded;
    end;

    v33:Connect(function(p34: userdata) -- Line: 230
        -- upvalues: u31 (copy)
        task.defer(u31, p34);
    end);
    local v35;

    if p32 then
        v35 = p30:GetDescendants();
    else
        v35 = p30:GetChildren();
    end;

    for i, v in v35 do
        if v.Parent then
            u31(v);
        end;

        if i % 2000 == 0 then
            task.wait();
        end;
    end;
end;

local function resetBaseMaterialOverrides() -- Line: 249
    -- upvalues: MaterialService (copy), u7 (copy)
    for _, v in Enum.Material:GetEnumItems() do
        local success, result = pcall(MaterialService.GetBaseMaterialOverride, MaterialService, v);

        if success and result ~= "" then
            u7[v] = result;
        end;

        pcall(MaterialService.SetBaseMaterialOverride, MaterialService, v, "");
    end;
end;

local function stopAnimatedProps() -- Line: 261
    -- upvalues: u6 (ref)
    local v36 = u6;
    u6 = {};

    for _, v in v36 do
        task.spawn(v);
    end;
end;

local function applyPotatoMode() -- Line: 271
    -- upvalues: u5 (ref), stopAnimatedProps (copy), resetBaseMaterialOverrides (copy), stripContainer (copy), MaterialService (copy), stripMaterialInstance (copy), Lighting (copy), stripEffectInstance (copy), Workspace (copy), stripMapInstance (copy)
    if u5 then
        return;
    end;

    u5 = true;
    stopAnimatedProps();
    resetBaseMaterialOverrides();
    task.spawn(stripContainer, MaterialService, stripMaterialInstance, true);
    task.spawn(stripContainer, Lighting, stripEffectInstance, false);
    task.spawn(stripContainer, Workspace.Terrain, stripEffectInstance, false);
    local Map = Workspace:FindFirstChild("Map");

    if Map then
        task.spawn(stripContainer, Map, stripMapInstance, true);
    end;

    Workspace.ChildAdded:Connect(function(p37: userdata) -- Line: 288
        -- upvalues: stripContainer (ref), stripMapInstance (ref)
        if p37.Name == "Map" then
            task.spawn(stripContainer, p37, stripMapInstance, true);
        end;
    end);
end;

function v1.RunAnimatedProp(p38: function) -- Line: 302
    -- upvalues: u5 (ref), u6 (ref)
    if u5 then
        return nil;
    end;

    local u39 = p38();

    if not u39 then
        return nil;
    end;

    local u40 = {};
    u6[u40] = u39;

    return function() -- Line: 315
        -- upvalues: u6 (ref), u40 (copy), u39 (copy)
        if u6[u40] then
            u6[u40] = nil;
            u39();
        end;
    end;
end;

function v1.Start() -- Line: 326
    -- upvalues: DataController (copy), LocalPlayer (copy), applyPotatoMode (copy)
    DataController.CreateListener(LocalPlayer, "Settings.Video.Presets.Potato Mode", function(p41) -- Line: 328
        -- upvalues: applyPotatoMode (ref)
        if p41 == true then
            applyPotatoMode();
        end;

        return nil;
    end);
end;

return v1;