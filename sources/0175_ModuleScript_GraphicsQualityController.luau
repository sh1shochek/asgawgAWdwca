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
local LocalPlayer = Players.LocalPlayer;
local u4 = false;
local u5 = {};
local u6 = {};
local u7 = setmetatable({}, {
    __mode = "k"
});
local u8 = setmetatable({}, {
    __mode = "k"
});

local function assetIdOf(p9: string) -- Line: 69
    return tonumber(string.match(p9, "(%d+)$"));
end;

local function colorOf(p10) -- Line: 75
    return Color3.fromRGB(p10[1], p10[2], p10[3]);
end;

local function multiplyColors(p11, p12) -- Line: 81
    return Color3.new(p11.R * p12.R, p11.G * p12.G, p11.B * p12.B);
end;

local function tintForMaterialVariant(p13: userdata) -- Line: 89
    -- upvalues: u7 (copy), u6 (copy), script_PotatoColors (copy)
    if u7[p13] then
        return;
    end;

    u7[p13] = true;
    local v14;

    if p13.MaterialVariant == "" then
        v14 = u6[p13.Material];
    else
        v14 = p13.MaterialVariant;
    end;

    local v15;

    if v14 then
        v15 = script_PotatoColors.MaterialVariants[`{p13.Material.Name}/{v14}`];
    else
        v15 = nil;
    end;

    if v15 then
        local Color = p13.Color;
        local Color3_fromRGB_ret = Color3.fromRGB(v15[1], v15[2], v15[3]);
        p13.Color = Color3.new(Color.R * Color3_fromRGB_ret.R, Color.G * Color3_fromRGB_ret.G, Color.B * Color3_fromRGB_ret.B);
    end;
end;

local function tintForRemovedSurface(p16: userdata) -- Line: 106
    -- upvalues: script_PotatoColors (copy), u8 (copy)
    local Parent = p16.Parent;

    if not (Parent and Parent:IsA("BasePart")) then
        return;
    end;

    local v17 = 1;
    local v18 = 1;
    local v19, v20, v21;

    if p16:IsA("Texture") then
        local v22 = tonumber(string.match(p16.Texture, "(%d+)$"));

        if v22 then
            v19 = script_PotatoColors.Textures[v22];
        else
            v19 = nil;
        end;

        v20 = p16.Texture;
        v21 = p16.Color3;
        v17 = 1 - p16.Transparency;
    else
        if not (p16:IsA("SurfaceAppearance") and Parent:IsA("MeshPart")) then
            return;
        end;

        local v23 = tonumber(string.match(Parent.MeshId, "(%d+)$"));

        if v23 then
            v19 = script_PotatoColors.SurfaceAppearances[v23];
        else
            v19 = nil;
        end;

        v21 = p16.Color;
        v20 = "SurfaceAppearance";
    end;

    if not (v19 and v20) then
        return;
    end;

    if p16:IsA("Texture") or p16.AlphaMode == Enum.AlphaMode.Overlay then
        v18 = v19[4];
    end;

    local v24 = u8[Parent];

    if not v24 then
        v24 = {};
        u8[Parent] = v24;
    end;

    if v24[v20] then
        return;
    end;

    v24[v20] = true;
    local Color = Parent.Color;
    local Color3_fromRGB_ret = Color3.fromRGB(v19[1], v19[2], v19[3]);
    Parent.Color = Color:Lerp(Color3.new(Color3_fromRGB_ret.R * v21.R, Color3_fromRGB_ret.G * v21.G, Color3_fromRGB_ret.B * v21.B), v18 * v17);
end;

local function stripMaterialInstance(p25: userdata) -- Line: 157
    if p25:IsA("MaterialVariant") then
        p25:Destroy();
    end;
end;

local function stripEffectInstance(p26: userdata) -- Line: 165
    -- upvalues: u2 (copy)
    if u2[p26.ClassName] then
        p26:Destroy();
    end;
end;

local function isInsideRig(p27: userdata) -- Line: 175
    -- upvalues: Workspace (copy)
    local Parent = p27.Parent;

    while Parent and Parent ~= Workspace do
        if Parent:IsA("Model") and (Parent:FindFirstChild("HumanoidRootPart") or (Parent:FindFirstChildOfClass("Humanoid") or Parent:FindFirstChildOfClass("AnimationController"))) then
            return true;
        end;

        Parent = Parent.Parent;
    end;

    return false;
end;

local function stripMapInstance(p28: userdata) -- Line: 195
    -- upvalues: u3 (copy), isInsideRig (copy), tintForRemovedSurface (copy), tintForMaterialVariant (copy)
    if (u3[p28.ClassName] or p28:IsA("BasePart")) and isInsideRig(p28) then
        return;
    end;

    if u3[p28.ClassName] then
        tintForRemovedSurface(p28);
        p28:Destroy();

        return;
    end;

    if not p28:IsA("BasePart") then
        if p28:IsA("Light") then
            p28.Shadows = false;
        end;

        return;
    end;

    p28.CastShadow = false;
    tintForMaterialVariant(p28);
end;

local function stripContainer(p29: userdata, u30: function, p31: boolean) -- Line: 216
    local v32;

    if p31 then
        v32 = p29.DescendantAdded;
    else
        v32 = p29.ChildAdded;
    end;

    v32:Connect(function(p33: userdata) -- Line: 219
        -- upvalues: u30 (copy)
        task.defer(u30, p33);
    end);
    local v34;

    if p31 then
        v34 = p29:GetDescendants();
    else
        v34 = p29:GetChildren();
    end;

    for i, v in v34 do
        if v.Parent then
            u30(v);
        end;

        if i % 2000 == 0 then
            task.wait();
        end;
    end;
end;

local function resetBaseMaterialOverrides() -- Line: 238
    -- upvalues: MaterialService (copy), u6 (copy)
    for _, v in Enum.Material:GetEnumItems() do
        local success, result = pcall(MaterialService.GetBaseMaterialOverride, MaterialService, v);

        if success and result ~= "" then
            u6[v] = result;
        end;

        pcall(MaterialService.SetBaseMaterialOverride, MaterialService, v, "");
    end;
end;

local function stopAnimatedProps() -- Line: 250
    -- upvalues: u5 (ref)
    local v35 = u5;
    u5 = {};

    for _, v in v35 do
        task.spawn(v);
    end;
end;

local function applyPotatoMode() -- Line: 260
    -- upvalues: u4 (ref), stopAnimatedProps (copy), resetBaseMaterialOverrides (copy), stripContainer (copy), MaterialService (copy), stripMaterialInstance (copy), Lighting (copy), stripEffectInstance (copy), Workspace (copy), stripMapInstance (copy)
    if u4 then
        return;
    end;

    u4 = true;
    stopAnimatedProps();
    resetBaseMaterialOverrides();
    task.spawn(stripContainer, MaterialService, stripMaterialInstance, true);
    task.spawn(stripContainer, Lighting, stripEffectInstance, false);
    task.spawn(stripContainer, Workspace.Terrain, stripEffectInstance, false);
    local Map = Workspace:FindFirstChild("Map");

    if Map then
        task.spawn(stripContainer, Map, stripMapInstance, true);
    end;

    Workspace.ChildAdded:Connect(function(p36: userdata) -- Line: 277
        -- upvalues: stripContainer (ref), stripMapInstance (ref)
        if p36.Name == "Map" then
            task.spawn(stripContainer, p36, stripMapInstance, true);
        end;
    end);
end;

function v1.RunAnimatedProp(p37: function) -- Line: 291
    -- upvalues: u4 (ref), u5 (ref)
    if u4 then
        return nil;
    end;

    local u38 = p37();

    if not u38 then
        return nil;
    end;

    local u39 = {};
    u5[u39] = u38;

    return function() -- Line: 304
        -- upvalues: u5 (ref), u39 (copy), u38 (copy)
        if u5[u39] then
            u5[u39] = nil;
            u38();
        end;
    end;
end;

function v1.Start() -- Line: 315
    -- upvalues: DataController (copy), LocalPlayer (copy), applyPotatoMode (copy)
    DataController.CreateListener(LocalPlayer, "Settings.Video.Presets.Potato Mode", function(p40) -- Line: 317
        -- upvalues: applyPotatoMode (ref)
        if p40 == true then
            applyPotatoMode();
        end;

        return nil;
    end);
end;

return v1;