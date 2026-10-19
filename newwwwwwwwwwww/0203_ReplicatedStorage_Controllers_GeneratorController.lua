-- GeneratorController (ModuleScript)
-- full path: ReplicatedStorage.Controllers.GeneratorController

-- Decompiled with Potassium's decompiler.

local u1 = {};
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Workspace = game:GetService("Workspace");
local RunServiceController = require(ReplicatedStorage.Controllers.RunServiceController);
local Sound = require(ReplicatedStorage.Classes.Sound);
local Observers = require(ReplicatedStorage.Packages.Observers);
local Signal = require(ReplicatedStorage.Packages.Signal);
local Janitor = require(ReplicatedStorage.Shared.Janitor);
local GeneratorProtocol = require(ReplicatedStorage.Components.Common.GeneratorProtocol);
local GameState = require(ReplicatedStorage.Database.Components.GameState);
local HEALTH_ATTRIBUTE = GeneratorProtocol.HEALTH_ATTRIBUTE;
local MAX_HEALTH_ATTRIBUTE = GeneratorProtocol.MAX_HEALTH_ATTRIBUTE;
local DESTROYED_ATTRIBUTE = GeneratorProtocol.DESTROYED_ATTRIBUTE;
local KEY_ATTRIBUTE = GeneratorProtocol.KEY_ATTRIBUTE;
local TIER_TEXTURES = GeneratorProtocol.TIER_TEXTURES;
local u2 = #TIER_TEXTURES + 1;
local u3 = { 0, 4, 10, 20, 32 };
local u4 = {
    Color3.fromRGB(200, 200, 200),
    Color3.fromRGB(170, 170, 170),
    Color3.fromRGB(110, 110, 110),
    Color3.fromRGB(55, 55, 55),
    Color3.fromRGB(25, 25, 25)
};
local u5 = { 2, 2.5, 3.5, 4.5, 5.5 };
local u6 = { 0, 0, 3, 9, 2 };
local u7 = { 1.2, 1, 0.8, 0.6, 0 };
local u8 = { 1, 0.96, 0.9, 0.82, 0 };
local Color3_fromRGB_ret = Color3.fromRGB(230, 238, 255);
local Color3_fromRGB_ret2 = Color3.fromRGB(214, 41, 41);
local Color3_fromRGB_ret3 = Color3.fromRGB(165, 183, 212);
local u9 = {};
local u10 = Signal.new();
u1.StateChanged = u10;
local u11 = nil;
local u12 = nil;
local u13 = false;

local function makeSmoke(p14: userdata) -- Line: 157
    local ParticleEmitter = Instance.new("ParticleEmitter");
    ParticleEmitter.Name = "Smoke";
    ParticleEmitter.Texture = "rbxasset://textures/particles/smoke_main.dds";
    ParticleEmitter.Rate = 0;
    ParticleEmitter.Lifetime = NumberRange.new(2.5, 4);
    ParticleEmitter.Speed = NumberRange.new(2, 4);
    ParticleEmitter.SpreadAngle = Vector2.new(12, 12);
    ParticleEmitter.Rotation = NumberRange.new(0, 360);
    ParticleEmitter.RotSpeed = NumberRange.new(-20, 20);
    ParticleEmitter.Acceleration = Vector3.new(0, 1.5, 0);
    ParticleEmitter.Drag = 1;
    ParticleEmitter.Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0.35), NumberSequenceKeypoint.new(0.7, 0.75), NumberSequenceKeypoint.new(1, 1) });
    ParticleEmitter.LightInfluence = 0.9;
    ParticleEmitter.EmissionDirection = Enum.NormalId.Top;
    ParticleEmitter.Parent = p14;

    return ParticleEmitter;
end;

local function makeSparks(p15: userdata, p16: string, p17: boolean) -- Line: 180
    local ParticleEmitter = Instance.new("ParticleEmitter");
    ParticleEmitter.Name = p16;
    ParticleEmitter.Texture = "rbxasset://textures/particles/sparkles_main.dds";
    ParticleEmitter.Rate = 0;
    ParticleEmitter.Lifetime = NumberRange.new(0.3, 0.8);
    local v18;

    if p17 then
        v18 = NumberRange.new(6, 14);
    else
        v18 = NumberRange.new(14, 30);
    end;

    ParticleEmitter.Speed = v18;
    ParticleEmitter.SpreadAngle = Vector2.new(70, 70);
    ParticleEmitter.Acceleration = Vector3.new(0, -40, 0);
    ParticleEmitter.Drag = 2;
    ParticleEmitter.LightEmission = 1;
    ParticleEmitter.LightInfluence = 0;
    ParticleEmitter.Brightness = 3;
    ParticleEmitter.Color = ColorSequence.new(Color3.fromRGB(255, 220, 140), Color3.fromRGB(255, 120, 40));
    ParticleEmitter.Size = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0.25), NumberSequenceKeypoint.new(1, 0.05) });
    ParticleEmitter.Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(1, 1) });
    ParticleEmitter.EmissionDirection = Enum.NormalId.Top;
    ParticleEmitter.Parent = p15;

    return ParticleEmitter;
end;

local function collectFadeTargets(p19: userdata) -- Line: 209
    local v20 = {};

    for _, descendant in p19:GetDescendants() do
        if descendant:IsA("GuiObject") then
            v20[#v20 + 1] = {
                Property = "BackgroundTransparency",
                Instance = descendant,
                Base = descendant.BackgroundTransparency
            };

            if descendant:IsA("TextLabel") then
                v20[#v20 + 1] = {
                    Property = "TextTransparency",
                    Instance = descendant,
                    Base = descendant.TextTransparency
                };
            elseif descendant:IsA("ImageLabel") then
                v20[#v20 + 1] = {
                    Property = "ImageTransparency",
                    Instance = descendant,
                    Base = descendant.ImageTransparency
                };
            end;
        elseif descendant:IsA("UIStroke") then
            v20[#v20 + 1] = {
                Property = "Transparency",
                Instance = descendant,
                Base = descendant.Transparency
            };
        end;
    end;

    return v20;
end;

local function makeMarker(p21: userdata, p22: string) -- Line: 228
    -- upvalues: ReplicatedStorage (copy), collectFadeTargets (copy)
    local v23 = ReplicatedStorage.Assets.UI.Survival.GeneratorStatus:Clone();
    v23.StudsOffsetWorldSpace = Vector3.new(0, p21.Size.Y / 2 + 2.5, 0);
    local Panel = v23.Panel;
    Panel.Letter.Text = p22;
    v23.Parent = p21;

    return {
        Visible = 1,
        Gui = v23,
        Bar = Panel.Track.Bar,
        Amount = Panel.Amount,
        Letter = Panel.Letter,
        LetterStroke = Panel.Letter.UIStroke,
        Fade = collectFadeTargets(v23)
    };
end;

local function refreshMarker(p24: table, p25: table) -- Line: 246
    -- upvalues: Color3_fromRGB_ret2 (copy), Color3_fromRGB_ret (copy), Color3_fromRGB_ret3 (copy)
    local Destroyed = p24.Destroyed;
    local v26 = p24.MaxHealth <= 0 and 0 or math.clamp(p24.Health / p24.MaxHealth, 0, 1);
    p25.Bar.Size = UDim2.fromScale(v26, 1);
    local v27;

    if Destroyed or v26 <= 0.25 then
        v27 = Color3_fromRGB_ret2;
    else
        v27 = Color3_fromRGB_ret;
    end;

    p25.Bar.BackgroundColor3 = v27;
    p25.Amount.Text = Destroyed and "OFFLINE" or `{math.floor(v26 * 100 + 0.5)}%`;
    local Amount = p25.Amount;
    local v28;

    if Destroyed then
        v28 = Color3_fromRGB_ret2;
    else
        v28 = Color3.new(1, 1, 1);
    end;

    Amount.TextColor3 = v28;
    local v29;

    if Destroyed then
        v29 = Color3_fromRGB_ret2;
    else
        v29 = Color3_fromRGB_ret3;
    end;

    p25.Letter.TextColor3 = v29;
    p25.LetterStroke.Color = v29;
end;

local function refresh(p30: table) -- Line: 259
    -- upvalues: GeneratorProtocol (copy), u2 (copy), TIER_TEXTURES (copy), u3 (copy), u4 (copy), u5 (copy), u6 (copy), u7 (copy), u8 (copy), u12 (ref), refreshMarker (copy)
    local Visuals = p30.Visuals;

    if not Visuals then
        return;
    end;

    local v31 = GeneratorProtocol.TierFor(p30.Health, p30.MaxHealth);
    local v32;

    if p30.Destroyed then
        v32 = u2;
    else
        v32 = v31;
    end;

    local Part = Visuals.Part;

    if v31 ~= Visuals.Tier and Part:IsA("MeshPart") then
        Part.TextureID = TIER_TEXTURES[v31] or TIER_TEXTURES[#TIER_TEXTURES];
    end;

    Visuals.Tier = v31;
    Visuals.Smoke.Rate = u3[v32];
    Visuals.Smoke.Color = ColorSequence.new(u4[v32]);
    Visuals.Smoke.Size = NumberSequence.new({ NumberSequenceKeypoint.new(0, u5[v32] * 0.5), NumberSequenceKeypoint.new(1, u5[v32] * 1.6) });
    Visuals.Embers.Rate = u6[v32];
    Visuals.Light.Brightness = u7[v32];
    Visuals.Light.Enabled = u7[v32] > 0;
    local Hum = Visuals.Hum;

    if u8[v32] > 0 then
        if not (Hum and Hum.Parent) and u12 then
            Hum = u12:play({
                Name = "Generator Hum",
                Parent = Part
            });
            Visuals.Hum = Hum;
        end;

        if Hum then
            Hum.PlaybackSpeed = u8[v32];
        end;
    elseif Hum then
        Hum:Destroy();
        Visuals.Hum = nil;
    end;

    refreshMarker(p30, Visuals.Marker);
end;

local function snapshot(p33: table, p34: number) -- Line: 296
    return {
        Key = p33.Key,
        Health = p33.Health,
        MaxHealth = p33.MaxHealth,
        Destroyed = p33.Destroyed,
        Drop = p34
    };
end;

local function notify(p35: table, p36: number) -- Line: 306
    -- upvalues: u10 (copy)
    u10:Fire({
        Key = p35.Key,
        Health = p35.Health,
        MaxHealth = p35.MaxHealth,
        Destroyed = p35.Destroyed,
        Drop = p36
    });
end;

local function playSound(p37: table, p38: string) -- Line: 310
    -- upvalues: u12 (ref)
    if u12 then
        u12:play({
            Parent = p37.Part,
            Name = p38
        });
    end;
end;

local function playDestroyed(p39: table) -- Line: 316
    -- upvalues: u12 (ref)
    local Visuals = p39.Visuals;

    if not Visuals then
        return;
    end;

    if u12 then
        u12:play({
            Name = "Generator Destroyed",
            Parent = Visuals.Part
        });
    end;

    Visuals.Sparks:Emit(72);
    Visuals.Smoke:Emit(24);
end;

local function detachVisuals(p40: table) -- Line: 326
    local Visuals = p40.Visuals;

    if not Visuals then
        return;
    end;

    p40.Visuals = nil;
    local v41 = {
        Visuals.Smoke,
        Visuals.Sparks,
        Visuals.Embers,
        Visuals.Light,
        Visuals.Marker.Gui
    };

    if Visuals.Hum then
        table.insert(v41, Visuals.Hum);
    end;

    for _, v in v41 do
        if v.Parent then
            v:Destroy();
        end;
    end;
end;

local function attachVisuals(p42: table, p43: userdata) -- Line: 344
    -- upvalues: detachVisuals (copy), makeSmoke (copy), makeSparks (copy), makeMarker (copy), refresh (copy)
    detachVisuals(p42);
    local PointLight = Instance.new("PointLight");
    PointLight.Name = "Glow";
    PointLight.Color = Color3.fromRGB(255, 190, 120);
    PointLight.Range = 14;
    PointLight.Shadows = false;
    PointLight.Parent = p43;
    p42.Visuals = {
        Hum = nil,
        Tier = 0,
        Part = p43,
        Smoke = makeSmoke(p43),
        Sparks = makeSparks(p43, "HitSparks", false),
        Embers = makeSparks(p43, "Embers", true),
        Light = PointLight,
        Marker = makeMarker(p43, p42.Key)
    };
    refresh(p42);
end;

local function findMesh(p44: userdata) -- Line: 365
    return p44:FindFirstChildWhichIsA("MeshPart") or p44:FindFirstChildWhichIsA("BasePart");
end;

local function flicker(p45: number) -- Line: 370
    -- upvalues: u9 (copy), u7 (copy)
    local v46 = math.sin(p45 * 23) * 0.5 * math.sin(p45 * 7.3) + 0.5;

    for _, v in u9 do
        local Visuals = v.Visuals;

        if Visuals and (not v.Destroyed and Visuals.Tier >= 3) then
            Visuals.Light.Brightness = u7[Visuals.Tier] * (1 - (Visuals.Tier >= 4 and 0.6 or 0.24) * v46);
        end;
    end;
end;

local function fadeMarkers() -- Line: 383
    -- upvalues: Workspace (copy), u9 (copy), u13 (ref)
    local CurrentCamera = Workspace.CurrentCamera;

    if not CurrentCamera then
        return;
    end;

    local ViewportSize = CurrentCamera.ViewportSize;
    local v47 = ViewportSize.X / 2;
    local v48 = ViewportSize.Y / 2;
    local math_max_ret = math.max(v48, 1);

    for _, v in u9 do
        local Visuals = v.Visuals;

        if Visuals then
            local v49, v50 = CurrentCamera:WorldToViewportPoint(Visuals.Part.Position);
            local v51 = 1;

            if u13 then
                v51 = 0;
            elseif v50 then
                local v52 = v49.X - v47;
                local v53 = v49.Y - v48;
                local v54 = (math.sqrt(v52 * v52 + v53 * v53) / math_max_ret - 0.3) / 0.3;
                v51 = math.clamp(v54, 0, 1);
            end;

            local Marker = Visuals.Marker;

            if v51 ~= Marker.Visible then
                Marker.Visible = v51;

                for _, v2 in Marker.Fade do
                    v2.Instance[v2.Property] = v2.Base + (1 - v2.Base) * (1 - v51);
                end;
            end;
        end;
    end;
end;

local function update() -- Line: 417
    -- upvalues: flicker (copy), fadeMarkers (copy)
    flicker(os.clock());
    fadeMarkers();
end;

local function observeGenerator(u55: userdata) -- Line: 423
    -- upvalues: u9 (copy), KEY_ATTRIBUTE (copy), HEALTH_ATTRIBUTE (copy), MAX_HEALTH_ATTRIBUTE (copy), DESTROYED_ATTRIBUTE (copy), Janitor (copy), u11 (ref), RunServiceController (copy), update (copy), detachVisuals (copy), u10 (copy), attachVisuals (copy), refresh (copy), u12 (ref)
    if not u55:IsA("Model") or u9[u55] then
        return nil;
    end;

    local Attribute = u55:GetAttribute(KEY_ATTRIBUTE);
    local u56 = {
        Visuals = nil,
        Model = u55,
        Key = typeof(Attribute) ~= "string" and "?" or Attribute,
        Health = tonumber(u55:GetAttribute(HEALTH_ATTRIBUTE)) or 0,
        MaxHealth = tonumber(u55:GetAttribute(MAX_HEALTH_ATTRIBUTE)) or 1,
        Destroyed = u55:GetAttribute(DESTROYED_ATTRIBUTE) == true
    };
    local u57 = Janitor.new();
    u9[u55] = u56;

    if not u11 then
        u11 = RunServiceController.BindToRenderSteppedEvent("GeneratorController.Update", update);
    end;

    u57:Add(function() -- Line: 442
        -- upvalues: u9 (ref), u55 (copy), detachVisuals (ref), u56 (copy), u11 (ref), u10 (ref)
        u9[u55] = nil;
        detachVisuals(u56);

        if next(u9) == nil then
            if u11 then
                u11:Disconnect();
                u11 = nil;
            end;

            u10:Fire({
                Key = "",
                Health = 0,
                MaxHealth = 0,
                Destroyed = false,
                Drop = 0
            });
        end;
    end, true);
    local v58 = u55:FindFirstChildWhichIsA("MeshPart") or u55:FindFirstChildWhichIsA("BasePart");

    if v58 then
        attachVisuals(u56, v58);
    end;

    u57:Add(u55.ChildAdded:Connect(function(p59) -- Line: 458
        -- upvalues: u56 (copy), attachVisuals (ref)
        if p59:IsA("BasePart") and (not u56.Visuals or p59:IsA("MeshPart")) then
            attachVisuals(u56, p59);
        end;
    end));
    u57:Add(u55.ChildRemoved:Connect(function(p60) -- Line: 463
        -- upvalues: u56 (copy), detachVisuals (ref), u55 (copy), attachVisuals (ref)
        local Visuals = u56.Visuals;

        if Visuals and Visuals.Part == p60 then
            detachVisuals(u56);
            local v61 = u55;
            local v62 = v61:FindFirstChildWhichIsA("MeshPart") or v61:FindFirstChildWhichIsA("BasePart");

            if v62 then
                attachVisuals(u56, v62);
            end;
        end;
    end));
    u57:Add(u55:GetAttributeChangedSignal(KEY_ATTRIBUTE):Connect(function() -- Line: 473
        -- upvalues: u55 (copy), KEY_ATTRIBUTE (ref), u56 (copy), refresh (ref), u10 (ref)
        local Attribute2 = u55:GetAttribute(KEY_ATTRIBUTE);
        u56.Key = typeof(Attribute2) ~= "string" and "?" or Attribute2;
        refresh(u56);
        local v63 = u56;
        u10:Fire({
            Drop = 0,
            Key = v63.Key,
            Health = v63.Health,
            MaxHealth = v63.MaxHealth,
            Destroyed = v63.Destroyed
        });
    end));
    u57:Add(u55:GetAttributeChangedSignal(HEALTH_ATTRIBUTE):Connect(function() -- Line: 479
        -- upvalues: u55 (copy), HEALTH_ATTRIBUTE (ref), u56 (copy), u12 (ref), refresh (ref), u10 (ref)
        local v64 = tonumber(u55:GetAttribute(HEALTH_ATTRIBUTE)) or 0;
        local v65 = u56.Health - v64;
        u56.Health = v64;
        local Visuals = u56.Visuals;

        if v65 > 0 and (not u56.Destroyed and Visuals) then
            local Sparks = Visuals.Sparks;
            local math_round_ret = math.round(18 * v65 / 6);
            Sparks:Emit((math.clamp(math_round_ret, 6, 60)));

            if u12 then
                u12:play({
                    Name = "Generator Hit",
                    Parent = Visuals.Part
                });
            end;
        end;

        refresh(u56);
        local v66 = u56;
        local math_max_ret = math.max(v65, 0);
        u10:Fire({
            Key = v66.Key,
            Health = v66.Health,
            MaxHealth = v66.MaxHealth,
            Destroyed = v66.Destroyed,
            Drop = math_max_ret
        });
    end));
    u57:Add(u55:GetAttributeChangedSignal(MAX_HEALTH_ATTRIBUTE):Connect(function() -- Line: 492
        -- upvalues: u56 (copy), u55 (copy), MAX_HEALTH_ATTRIBUTE (ref), refresh (ref), u10 (ref)
        u56.MaxHealth = tonumber(u55:GetAttribute(MAX_HEALTH_ATTRIBUTE)) or 1;
        refresh(u56);
        local v67 = u56;
        u10:Fire({
            Drop = 0,
            Key = v67.Key,
            Health = v67.Health,
            MaxHealth = v67.MaxHealth,
            Destroyed = v67.Destroyed
        });
    end));
    u57:Add(u55:GetAttributeChangedSignal(DESTROYED_ATTRIBUTE):Connect(function() -- Line: 497
        -- upvalues: u55 (copy), DESTROYED_ATTRIBUTE (ref), u56 (copy), u12 (ref), refresh (ref), u10 (ref)
        local v68 = u55:GetAttribute(DESTROYED_ATTRIBUTE) == true;
        local v69;

        if v68 then
            v69 = not u56.Destroyed;
        else
            v69 = v68;
        end;

        u56.Destroyed = v68;
        local v70 = v69 and u56.Visuals;

        if v70 then
            if u12 then
                u12:play({
                    Name = "Generator Destroyed",
                    Parent = v70.Part
                });
            end;

            v70.Sparks:Emit(72);
            v70.Smoke:Emit(24);
        end;

        refresh(u56);
        local v71 = u56;
        u10:Fire({
            Drop = 0,
            Key = v71.Key,
            Health = v71.Health,
            MaxHealth = v71.MaxHealth,
            Destroyed = v71.Destroyed
        });
    end));
    u10:Fire({
        Drop = 0,
        Key = u56.Key,
        Health = u56.Health,
        MaxHealth = u56.MaxHealth,
        Destroyed = u56.Destroyed
    });

    return function() -- Line: 509
        -- upvalues: u57 (copy)
        u57:Destroy();
    end;
end;

function u1.GetStates() -- Line: 518
    -- upvalues: u9 (copy)
    local v72 = {};

    for _, v in u9 do
        v72[v.Key] = {
            Drop = 0,
            Key = v.Key,
            Health = v.Health,
            MaxHealth = v.MaxHealth,
            Destroyed = v.Destroyed
        };
    end;

    return v72;
end;

function u1.Bind(p73: function) -- Line: 528
    -- upvalues: u10 (copy), u1 (copy)
    local u74 = u10:Connect(p73);

    for _, v in u1.GetStates() do
        task.spawn(p73, v);
    end;

    return function() -- Line: 533
        -- upvalues: u74 (copy)
        u74:Disconnect();
    end;
end;

function u1.Start() -- Line: 541
    -- upvalues: u12 (ref), Sound (copy), GameState (copy), u13 (ref), Observers (copy), GeneratorProtocol (copy), observeGenerator (copy), Workspace (copy)
    u12 = Sound.new("Survival");
    GameState.ListenToState(function(p75, p76) -- Line: 544
        -- upvalues: u13 (ref)
        u13 = p76 == "Game Ending";
    end);
    Observers.observeTag(GeneratorProtocol.TAG, observeGenerator, { Workspace });
end;

return u1;