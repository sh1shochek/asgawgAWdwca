-- Decompiled with Potassium's decompiler.

local u1 = {};
u1.__index = u1;
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local ReplicatedFirst = game:GetService("ReplicatedFirst");
local ContentProvider = game:GetService("ContentProvider");
local Players = game:GetService("Players");
require(script:WaitForChild("Types"));
local RunServiceController = require(ReplicatedStorage.Controllers.RunServiceController);
local LocalPlayer = Players.LocalPlayer;
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui");
local GetWeaponProperties = require(ReplicatedStorage.Components.Common.GetWeaponProperties);
local FlashEffect = require(ReplicatedStorage.Components.Common.VFXLibary.FlashEffect);
local Janitor = require(ReplicatedStorage.Shared.Janitor);
local Remotes = require(ReplicatedStorage.Database.Security.Remotes);
local u2 = { "7", "73", "735", "7355", "73556", "735560", "7355608" };
local u3 = {};

local function preloadClips(p4: string) -- Line: 56
    -- upvalues: u3 (copy), GetWeaponProperties (copy), ContentProvider (copy)
    if u3[p4] then
        return;
    end;

    u3[p4] = true;
    local v5 = GetWeaponProperties(p4);

    if v5 then
        v5 = v5.CameraAnimations;
    end;

    if typeof(v5) ~= "Instance" then
        return;
    end;

    local v6 = {};

    for _, child in v5:GetChildren() do
        if child:IsA("Animation") then
            table.insert(v6, child);
        end;
    end;

    task.spawn(ContentProvider.PreloadAsync, ContentProvider, v6);
end;

local function isInspectVariantName(p7: string) -- Line: 78
    return p7 == "Inspect" and true or string.match(p7, "^Inspect%d+$") ~= nil;
end;

local function getVariantBaseName(p8: string) -- Line: 83
    local string_gsub_ret = string.gsub(p8, "%d+$", "");

    if string_gsub_ret == "" then
        return p8;
    end;

    return string_gsub_ret;
end;

local function shouldSkipDuplicateSoundEvent(p9: userdata, p10: string) -- Line: 91
    local v11 = tick();
    local Attribute = p9:GetAttribute("LastSoundEventName");
    local Attribute2 = p9:GetAttribute("LastSoundEventTick");

    if Attribute == p10 and type(Attribute2) == "number" then
        local v12 = v11 - Attribute2;

        if v12 >= 0 and v12 <= 0.02 then
            return true;
        end;
    end;

    p9:SetAttribute("LastSoundEventName", p10);
    p9:SetAttribute("LastSoundEventTick", v11);

    return false;
end;

local function handleAnimationSoundEvent(u13: any, p14: userdata, p15: string, p16: string, p17: any, p18: userdata?, p19: userdata) -- Line: 108
    -- upvalues: shouldSkipDuplicateSoundEvent (copy), LocalPlayer (copy), FlashEffect (copy), PlayerGui (copy), Remotes (copy)
    if u13.IsDestroyed then
        return;
    end;

    if p18 then
        p18 = p18:FindFirstChild(p16);
    end;

    if not (p18 and (#p18:GetChildren() > 0 and not shouldSkipDuplicateSoundEvent(p14, p16))) then
        return;
    end;

    local v20 = p15 == "Inspect" and true or string.match(p15, "^Inspect%d+$") ~= nil;

    if not v20 then
        local string_gsub_ret = string.gsub(p15, "%d+$", "");

        if string_gsub_ret == "" then
            string_gsub_ret = p15;
        end;

        v20 = string_gsub_ret == "Equip";
    end;

    local u21 = (p19 == LocalPlayer or v20) and p17:play({
        Parent = PlayerGui,
        Name = p16
    }, (FlashEffect.GetAudioFadeMultiplier()));

    if u21 then
        u13.ActiveSounds[u21] = p15;
        u21.Ended:Once(function() -- Line: 140
            -- upvalues: u13 (copy), u21 (copy)
            if not u13.IsDestroyed then
                u13.ActiveSounds[u21] = nil;
            end;
        end);
    end;

    if v20 or (LocalPlayer ~= p19 or p16 == "Prepare" and p17.SoundGroupName == "R8 Revolver") then
        return;
    end;

    Remotes.Sound.ReplicateSound.Send({
        Class = p17.SoundGroupName,
        Name = p16
    });
end;

local function connectTrackSoundEvents(p22: any, u23: userdata, u24: string) -- Line: 166
    -- upvalues: handleAnimationSoundEvent (copy)
    local Sound = p22.Sound;
    local Sounds = Sound.Sounds;
    local Player = p22.Player;
    local u25 = {};
    local u26 = setmetatable({}, {
        __mode = "v"
    });
    u26.instance = p22;
    table.insert(u25, u23.KeyframeReached:Connect(function(p27: string) -- Line: 179, Name: onSoundEvent
        -- upvalues: u26 (copy), handleAnimationSoundEvent (ref), u23 (copy), u24 (copy), Sound (copy), Sounds (copy), Player (copy)
        local instance = u26.instance;

        if not instance then
            return;
        end;

        handleAnimationSoundEvent(instance, u23, u24, p27, Sound, Sounds, Player);
    end));

    if Sounds then
        for _, child in ipairs(Sounds:GetChildren()) do
            if child:IsA("Folder") then
                local Name = child.Name;
                local MarkerReachedSignal = u23:GetMarkerReachedSignal(Name);
                table.insert(u25, MarkerReachedSignal:Connect(function() -- Line: 202
                    -- upvalues: Name (copy), u26 (copy), handleAnimationSoundEvent (ref), u23 (copy), u24 (copy), Sound (copy), Sounds (copy), Player (copy)
                    local instance = u26.instance;

                    if not instance then
                        return;
                    end;

                    handleAnimationSoundEvent(instance, u23, u24, Name, Sound, Sounds, Player);
                end));
            end;
        end;
    end;

    return function() -- Line: 209
        -- upvalues: u25 (copy)
        for _, v in ipairs(u25) do
            v:Disconnect();
        end;

        table.clear(u25);
    end;
end;

function u1.getAnimation(p28: any, p29: string) -- Line: 219
    p28:ensureLoaded();

    return p28.Animations[p29];
end;

function u1.hasInspectAnimation(p30) -- Line: 227
    p30:ensureLoaded();
    local Inspect = p30.VariantGroups.Inspect;

    return Inspect and #Inspect > 0 and true or p30.Animations.Inspect ~= nil;
end;

local function computeVariantProbabilities(p31: table) -- Line: 239
    local v32 = #p31;
    local v33 = 0;
    local v34 = 0;
    local v35 = {};

    for _, v in ipairs(p31) do
        if v.weight == nil then
            v34 = v34 + 1;
        else
            v33 = v33 + math.max(v.weight, 0);
        end;
    end;

    local math_max_ret = math.max(0, 1 - v34 / v32);
    local v36 = v32 - v34;

    for i, v in ipairs(p31) do
        if v.weight == nil then
            v35[i] = 1 / v32;
        elseif v33 > 0 then
            v35[i] = math_max_ret * (math.max(v.weight, 0) / v33);
        else
            v35[i] = math_max_ret / v36;
        end;
    end;

    return v35;
end;

local function rollVariant(p37: table?, p38: string) -- Line: 271
    -- upvalues: computeVariantProbabilities (copy)
    if not p37 or #p37 == 0 then
        return p38;
    end;

    if #p37 == 1 then
        return p37[1].name;
    end;

    local v39 = computeVariantProbabilities(p37);
    local math_random_ret = math.random();
    local v40 = 0;

    for i, v in ipairs(p37) do
        v40 = v40 + v39[i];

        if math_random_ret < v40 then
            return v.name;
        end;
    end;

    return p37[#p37].name;
end;

function u1.pickVariant(p41: any, p42: string) -- Line: 297
    -- upvalues: rollVariant (copy)
    p41:ensureLoaded();

    return rollVariant(p41.VariantGroups[p42], p42);
end;

function u1.pickInspectVariant(p43) -- Line: 307
    -- upvalues: rollVariant (copy)
    p43:ensureLoaded();
    local os_clock_ret = os.clock();

    if p43.LastInspectVariant and (p43.LastInspectCancelTime and (os_clock_ret - p43.LastInspectCancelTime <= 1 and p43.Animations[p43.LastInspectVariant])) then
        return p43.LastInspectVariant;
    end;

    local v44 = rollVariant(p43.VariantGroups.Inspect, "Inspect");
    p43.LastInspectVariant = v44;

    return v44;
end;

function u1.markInspectCancel(p45) -- Line: 328
    p45.LastInspectCancelTime = os.clock();
end;

function u1.adjustAnimationSpeed(p46: any, p47: string, p48: number) -- Line: 334
    local Animation = p46:getAnimation(p47);

    if Animation then
        Animation:AdjustSpeed(Animation.Length / p48);
    end;
end;

function u1.play(p49: any, p50: string, ...) -- Line: 343
    local Animation = p49:getAnimation(p50);

    if Animation then
        Animation:Play(...);
    end;

    return Animation;
end;

function u1.stop(p51: any, p52: string, p53: number?) -- Line: 353
    local v54 = p51.Animations[p52];

    if v54 and v54.IsPlaying then
        v54:Stop(p53 or 0);
    end;
end;

local function hermiteEaseOut(p55: number) -- Line: 363
    return p55 * 3 * p55 - p55 * 2 * p55 * p55;
end;

function u1.cancelCrossfade(p56) -- Line: 369
    if p56.CrossfadeConnection then
        p56.CrossfadeConnection:Disconnect();
        p56.CrossfadeConnection = nil;
    end;

    if p56.CrossfadeTempTrack then
        p56.CrossfadeTempTrack:Stop(0);
        p56.CrossfadeTempTrack:Destroy();
        p56.CrossfadeTempTrack = nil;
    end;
end;

function u1.crossfadeRestart(u57: any, p58: string, p59: number?) -- Line: 383
    -- upvalues: connectTrackSoundEvents (copy), RunServiceController (copy)
    local u60 = p59 or 0.25;
    u57:cancelCrossfade();
    local VariantGroups = u57.VariantGroups;
    local string_gsub_ret = string.gsub(p58, "%d+$", "");

    if string_gsub_ret == "" then
        string_gsub_ret = p58;
    end;

    local v61 = VariantGroups[string_gsub_ret];

    if v61 then
        for _, v in ipairs(v61) do
            if v.name ~= p58 then
                local v62 = u57.Animations[v.name];

                if v62 and v62.IsPlaying then
                    v62:Stop(0);
                end;
            end;
        end;
    end;

    local Animation = u57:getAnimation(p58);

    if not Animation then
        return nil;
    end;

    if not Animation.IsPlaying then
        Animation:Play(0, 1, 1);

        return Animation;
    end;

    local math_max_ret = math.max(Animation.WeightCurrent, 0.5);
    local Animation2 = Animation.Animation;
    local v63, u64;

    if Animation2 then
        v63, u64 = pcall(function() -- Line: 418
            -- upvalues: u57 (copy), Animation2 (copy)
            return u57.Animator:LoadAnimation(Animation2);
        end);
    else
        v63 = false;
        u64 = nil;
    end;

    if not (v63 and u64) then
        Animation:Stop(0);
        Animation:Play(0, 1, 1);

        return Animation;
    end;

    local u65 = connectTrackSoundEvents(u57, u64, p58);
    u64:Play(0, 0.01, 1);
    u64.TimePosition = 0;
    u57.CrossfadeTempTrack = u64;
    local u66 = tick();
    local v67 = RunServiceController.CreateBindingName("Classes.Viewmodel.Animation.Crossfade");
    u57.CrossfadeConnection = RunServiceController.BindToRenderStep(v67, function() -- Line: 437
        -- upvalues: u57 (copy), u65 (copy), u66 (copy), u60 (copy), Animation (copy), math_max_ret (copy), u64 (ref)
        if u57.IsDestroyed then
            u65();
            u57:cancelCrossfade();

            return;
        end;

        local v68 = (tick() - u66) / u60;
        local math_clamp_ret = math.clamp(v68, 0, 1);
        local v69 = math_clamp_ret * 3 * math_clamp_ret - math_clamp_ret * 2 * math_clamp_ret * math_clamp_ret;
        Animation:AdjustWeight(math_max_ret * (1 - v69), 0);
        u64:AdjustWeight(math.max(v69, 0.01), 0);

        if math_clamp_ret >= 1 then
            u65();
            local TimePosition = u64.TimePosition;
            Animation:Stop(0);
            Animation:Play(0, 1, 1);
            Animation.TimePosition = TimePosition;
            Animation:AdjustWeight(1, 0);
            u57:cancelCrossfade();
        end;
    end);

    return Animation;
end;

function u1.crossfadeTo(u70: any, p71: string, p72: number?) -- Line: 470
    -- upvalues: RunServiceController (copy)
    u70:cancelCrossfade();
    local u73 = {};
    local u74 = p72 or 0.25;

    for i, v in pairs(u70.Animations) do
        if v.IsPlaying and (i ~= "Idle" and i ~= p71) then
            table.insert(u73, {
                track = v,
                startWeight = v.WeightCurrent
            });
        end;
    end;

    local Animation = u70:getAnimation(p71);
    local u75 = p71 == "Idle";

    if not (Animation or u75) then
        return nil;
    end;

    if not u75 then
        Animation:Play(0, 0, 1);
    end;

    local u76 = tick();
    local v77 = RunServiceController.CreateBindingName("Classes.Viewmodel.Animation.Crossfade");
    u70.CrossfadeConnection = RunServiceController.BindToRenderStep(v77, function() -- Line: 500
        -- upvalues: u70 (copy), u76 (copy), u74 (copy), u73 (copy), u75 (copy), Animation (copy)
        if u70.IsDestroyed then
            u70:cancelCrossfade();

            return;
        end;

        local v78 = (tick() - u76) / u74;
        local math_clamp_ret = math.clamp(v78, 0, 1);
        local v79 = 1 - math_clamp_ret;
        local v80 = v79 * 3 * v79 - v79 * 2 * v79 * v79;

        for _, v in ipairs(u73) do
            v.track:AdjustWeight(v.startWeight * v80, 0);
        end;

        if not u75 then
            Animation:AdjustWeight(1 - v80, 0);
        end;

        if math_clamp_ret >= 1 then
            for _, v in ipairs(u73) do
                if v.track.IsPlaying then
                    v.track:Stop(0);
                end;
            end;

            if u75 and Animation then
                Animation:Play(0, 1, 1);
            elseif Animation then
                Animation:AdjustWeight(1, 0);
            end;

            u70:cancelCrossfade();
        end;
    end);

    return Animation;
end;

function u1.stopAnimations(p81: any, p82: number?) -- Line: 537
    p81:cancelCrossfade();

    for _, v in pairs(p81.Animations) do
        if v.IsPlaying then
            v:Stop(p82 or 0);
        end;
    end;

    p81:stopSounds();
end;

function u1.stopSounds(p83) -- Line: 550
    for i, v in pairs(p83.ActiveSounds) do
        local v84;

        if v then
            v84 = string.find(v, "Shoot") ~= nil;
        else
            v84 = v;
        end;

        if not v84 then
            p83.ActiveSounds[i] = nil;

            if i and i.Parent then
                i:Destroy();
            end;
        end;
    end;
end;

function u1.unregister(p85: any, p86: string) -- Line: 565
    local v87 = p85.Animations[p86];

    if not v87 then
        return;
    end;

    p85.Janitor:Remove("AnimationSoundConnections_" .. p86);
    p85.Janitor:RemoveNoClean("AnimationCleanup_" .. p86);
    p85.Animations[p86] = nil;

    if v87.IsPlaying then
        v87:Stop();
    end;

    v87:Destroy();
end;

function u1.register(u88: any, u89: string, u90: userdata) -- Line: 583
    -- upvalues: connectTrackSoundEvents (copy)
    u88:unregister(u89);
    local success, result = pcall(function() -- Line: 585
        -- upvalues: u88 (copy), u90 (copy)
        return u88.Animator:LoadAnimation(u90);
    end);

    if success then
        u88.Animations[u89] = result;
        local u91 = setmetatable({}, {
            __mode = "v"
        });
        u91.instance = u88;
        u88.Janitor:Add(function() -- Line: 593
            -- upvalues: u91 (copy), u89 (copy)
            local instance = u91.instance;

            if instance and not instance.IsDestroyed then
                instance:unregister(u89);
            end;
        end, true, "AnimationCleanup_" .. u89);
        u88.Janitor:Add(connectTrackSoundEvents(u88, result, u89), true, "AnimationSoundConnections_" .. u89);
    end;
end;

function u1.construct(p92) -- Line: 605
    -- upvalues: GetWeaponProperties (copy)
    local v93 = GetWeaponProperties(p92.Animation);

    if not v93 then
        return;
    end;

    local CameraAnimations = v93.CameraAnimations;

    if typeof(CameraAnimations) ~= "Instance" or not CameraAnimations:IsA("Folder") then
        return;
    end;

    p92.VariantGroups = {};

    for _, child in ipairs(CameraAnimations:GetChildren()) do
        if child:IsA("Animation") then
            p92:register(child.Name, child);

            if p92.Animations[child.Name] then
                local Name = child.Name;
                local string_gsub_ret = string.gsub(Name, "%d+$", "");

                if string_gsub_ret == "" then
                    string_gsub_ret = Name;
                end;

                local v94 = child:FindFirstChildWhichIsA("IntValue") or child:FindFirstChildWhichIsA("NumberValue");
                local v95 = p92.VariantGroups[string_gsub_ret];

                if not v95 then
                    v95 = {};
                    p92.VariantGroups[string_gsub_ret] = v95;
                end;

                local v96 = {
                    name = child.Name
                };
                local v97;

                if v94 then
                    v97 = v94.Value;
                else
                    v97 = nil;
                end;

                v96.weight = v97;
                table.insert(v95, v96);
            end;
        end;
    end;
end;

function u1.setModel(p98: any, p99: userdata) -- Line: 645
    -- upvalues: preloadClips (copy)
    if not p99 then
        return;
    end;

    p98.Animation = p99.Name;
    p98.Model = p99;
    p98.Animator = p99:WaitForChild("AnimationController"):WaitForChild("Animator");
    p98:stopAnimations();

    for i in table.clone(p98.Animations) do
        p98:unregister(i);
    end;

    p98.VariantGroups = {};
    p98.Loaded = false;
    preloadClips(p99.Name);

    if p98.Animation == "C4" then
        local v100 = p99:FindFirstChild("Weapon") and p99.Weapon:FindFirstChild("Interactive");

        if v100 and v100:FindFirstChild("SurfaceGui") then
            v100.SurfaceGui.TextLabel.Text = "*******";
        end;
    end;
end;

function u1.ensureLoaded(u101) -- Line: 673
    -- upvalues: ReplicatedFirst (copy), u2 (copy), LocalPlayer (copy)
    local Model = u101.Model;

    if u101.Loaded or (u101.IsDestroyed or not (Model and u101.Animator)) then
        return;
    end;

    u101.Loaded = true;
    local v102 = not Model:IsDescendantOf(game);
    local Parent = Model.Parent;

    if v102 then
        Model.Parent = ReplicatedFirst;
    end;

    u101:construct();

    if v102 then
        Model.Parent = Parent;
    end;

    if u101.Animation == "C4" then
        local u103 = Model:FindFirstChild("Weapon") and Model.Weapon:FindFirstChild("Interactive");

        for _, v in pairs(u101.Animations) do
            u101.Janitor:Add(v.KeyframeReached:Connect(function(p104) -- Line: 695
                -- upvalues: u2 (ref), u103 (copy), u101 (copy), LocalPlayer (ref)
                if table.find(u2, p104) then
                    if u103 and u103:FindFirstChild("SurfaceGui") then
                        u103.SurfaceGui.TextLabel.Text = string.rep("*", 7 - #p104) .. p104;
                    end;

                    u101.Sound:play({
                        Parent = LocalPlayer.PlayerGui,
                        Name = p104
                    });
                end;
            end));
        end;
    end;
end;

function u1.new(p105: userdata, p106: any) -- Line: 712
    -- upvalues: u1 (copy), Janitor (copy)
    local v107 = setmetatable({}, u1);
    v107.Janitor = Janitor.new();
    v107.IsDestroyed = false;
    v107.Player = p105;
    v107.ActiveSounds = {};
    v107.Animations = {};
    v107.VariantGroups = {};
    v107.Sound = p106;

    return v107;
end;

function u1.destroy(p108) -- Line: 739
    if not p108.IsDestroyed then
        p108.IsDestroyed = true;
        p108:stopAnimations();

        for i in pairs(p108.Animations) do
            p108:unregister(i);
        end;

        p108:stopSounds();
        table.clear(p108.ActiveSounds);
        table.clear(p108.Animations);
        table.clear(p108.VariantGroups);
        p108.Animation = nil;
        p108.Animator = nil;
        p108.Player = nil;
        p108.Sound = nil;
        p108.Janitor:Destroy();
        p108.Janitor = nil;
    end;
end;

return u1;