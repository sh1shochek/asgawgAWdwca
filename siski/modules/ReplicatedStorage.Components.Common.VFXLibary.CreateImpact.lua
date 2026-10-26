-- ReplicatedStorage.Components.Common.VFXLibary.CreateImpact
-- class: ModuleScript

-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local HttpService = game:GetService("HttpService");
local Players = game:GetService("Players");
local RunService = game:GetService("RunService");
require(ReplicatedStorage.Database.Custom.Types);
local Sound = require(ReplicatedStorage.Classes.Sound);
local ObjectPool = require(ReplicatedStorage.Shared.ObjectPool);
local DebugFlags = require(ReplicatedStorage.Shared.DebugFlags);
local FlashEffect = require(ReplicatedStorage.Components.Common.VFXLibary.FlashEffect);
local CharacterResolver = require(ReplicatedStorage.Components.Common.CharacterResolver);
local Participants = require(ReplicatedStorage.Components.Common.Participants);
local Materials = require(script.Components.Materials);
local Impacts = ReplicatedStorage:WaitForChild("Assets"):WaitForChild("Impacts");
local Debris = workspace:WaitForChild("Debris");
local CFrame_new_ret = CFrame.new(0, -10000, 0);
local u1 = {};
local u2 = {};
local u3 = {};
local u4 = setmetatable({}, {
    __mode = "k"
});

local function hasParticleEmitter(p5: userdata) -- Line: 58
    for _, descendant in ipairs(p5:GetDescendants()) do
        if descendant:IsA("ParticleEmitter") then
            return true;
        end;
    end;

    return false;
end;

local function getImpactTemplates(p6) -- Line: 67
    -- upvalues: u1 (copy), hasParticleEmitter (copy)
    local v7 = u1[p6];

    if v7 then
        return v7;
    end;

    local v8 = {};

    for _, child in ipairs(p6:GetChildren()) do
        if child:IsA("BasePart") and hasParticleEmitter(child) then
            v8[#v8 + 1] = child;
        end;
    end;

    u1[p6] = v8;

    return v8;
end;

local u9 = {};

local function resetImpactMarker(p10: userdata) -- Line: 86
    -- upvalues: u4 (copy), u9 (copy), CFrame_new_ret (copy)
    for _, v in u4[p10] or u9 do
        v.Emitter:Clear();
    end;

    p10.CFrame = CFrame_new_ret;
end;

local function prepareImpactMarker(p11: userdata) -- Line: 94
    -- upvalues: CFrame_new_ret (copy), u4 (copy)
    p11.CFrame = CFrame_new_ret;
    p11.CollisionGroup = "Debris";
    p11.CanCollide = false;
    p11.CanQuery = false;
    p11.CanTouch = false;
    p11.Anchored = true;
    p11.Transparency = 1;
    local v12 = {};

    for _, descendant in p11:GetDescendants() do
        if descendant:IsA("ParticleEmitter") then
            v12[#v12 + 1] = {
                Emitter = descendant,
                Delay = descendant:GetAttribute("EmitDelay") or 0,
                Count = descendant:GetAttribute("EmitCount") or 1
            };
        end;
    end;

    u4[p11] = v12;
end;

local function getImpactHold(p13: userdata) -- Line: 115
    local v14 = 0;

    for _, descendant in p13:GetDescendants() do
        if descendant:IsA("ParticleEmitter") then
            local v15 = (descendant:GetAttribute("EmitDelay") or 0) + descendant.Lifetime.Max;
            v14 = math.max(v14, v15);
        end;
    end;

    return math.min(v14 + 0.25, 5);
end;

local function getImpactPool(p16: userdata) -- Line: 126
    -- upvalues: u2 (copy), ObjectPool (copy), resetImpactMarker (copy), prepareImpactMarker (copy), Debris (copy), u3 (copy), getImpactHold (copy)
    local v17 = u2[p16];

    if v17 then
        return v17;
    end;

    local v18 = ObjectPool.new(p16, {
        InitialSize = 4,
        MaxRetained = 60,
        InPlace = true,
        StorageName = "ImpactMarkers",
        Reset = resetImpactMarker,
        Prepare = prepareImpactMarker,
        StorageParent = Debris
    });
    u2[p16] = v18;
    u3[p16] = getImpactHold(p16);

    return v18;
end;

local function createImpactMarker(p19) -- Line: 146
    -- upvalues: getImpactTemplates (copy), getImpactPool (copy), u3 (copy)
    debug.profilebegin("VFX.Impact.CreateImpactMarker");
    local v20 = getImpactTemplates(p19);

    if #v20 == 0 then
        debug.profileend();

        return nil, nil, nil, nil;
    end;

    local v21 = v20[math.random(1, #v20)];
    local v22 = getImpactPool(v21);
    local v23, v24 = v22:Acquire();
    debug.profileend();

    return v23, v22, v24, u3[v21];
end;

if RunService:IsClient() then
    task.defer(function() -- Line: 165
        -- upvalues: Impacts (copy), getImpactTemplates (copy), getImpactPool (copy)
        for _, child in Impacts:GetChildren() do
            for _, v in getImpactTemplates(child) do
                getImpactPool(v);
                task.wait();
            end;
        end;
    end);
end;

local function IsHeadPart(p25: userdata?) -- Line: 178
    if p25 and p25:IsA("BasePart") then
        return string.find(string.lower(p25.Name), "head", 1, true) ~= nil;
    end;

    return false;
end;

local function IsHeadImpact(p26: userdata?, p27: string) -- Line: 187
    local v28;

    if p27 == "Blood Splatter" then
        if not (p26 and p26:IsA("BasePart")) then
            return false;
        end;

        v28 = string.find(string.lower(p26.Name), "head", 1, true) ~= nil;
    else
        v28 = false;
    end;

    return v28;
end;

local function decodeArmor(p29) -- Line: 191
    -- upvalues: HttpService (copy)
    if typeof(p29) ~= "string" or p29 == "" then
        return nil;
    end;

    local success, result = pcall(HttpService.JSONDecode, HttpService, p29);

    if success and typeof(result) == "table" then
        return result;
    end;

    return nil;
end;

return function(p30: userdata?, p31: string, p32: vector, p33: vector, p34: boolean, p35: boolean, p36: boolean?, p37: string?, p38: boolean?, p39: boolean?, p40: boolean?, p41: boolean?) -- Line: 201
    -- upvalues: Players (copy), Impacts (copy), Materials (copy), Participants (copy), HttpService (copy), CharacterResolver (copy), FlashEffect (copy), DebugFlags (copy), Sound (copy), createImpactMarker (copy), u4 (copy), u9 (copy)
    debug.profilebegin("VFX.Impact");
    local v42 = p31 == "Blood Splatter" and Players.LocalPlayer:GetAttribute("SK") and "Blood Splatter_SK" or p31;
    local v43 = Impacts:FindFirstChild(Materials[v42] or v42);

    if v43 then
        local v44;

        if v42 == "Blood Splatter" and (p30 and p30:IsA("BasePart")) then
            v44 = string.find(string.lower(p30.Name), "head", 1, true) ~= nil;
        else
            v44 = false;
        end;

        local v45 = v44 or p39 ~= nil;
        local v46 = p39 == true;
        debug.profilebegin("VFX.Impact.ResolveSound");
        local Name = v43.Name;

        if v45 then
            Name = "Headshot";

            if p30 and (not p35 and p39 == nil) then
                local v47 = p30:FindFirstAncestorOfClass("Model");
                local v48;

                if v47 and v47:GetAttribute("Bot") == true then
                    v48 = v47:GetAttribute("CombatantId");
                else
                    v48 = nil;
                end;

                if typeof(v48) == "number" then
                    local v49 = Participants.FromKey(Participants.BotKey(v48));
                    local v50;

                    if v49 then
                        local Attribute = v49:GetAttribute("Armor");

                        if typeof(Attribute) == "string" and Attribute ~= "" then
                            local v51;
                            v51, v50 = pcall(HttpService.JSONDecode, HttpService, Attribute);

                            if not v51 or typeof(v50) ~= "table" then
                                v50 = nil;
                            end;
                        else
                            v50 = nil;
                        end;
                    else
                        v50 = nil;
                    end;

                    if v50 == nil then
                        v46 = false;
                    else
                        v46 = v50.Type == "Kevlar + Helmet";
                    end;
                elseif CharacterResolver.isPlayerCharacter(v47) and v47:IsDescendantOf(workspace) then
                    local PlayerFromCharacter = CharacterResolver.getPlayerFromCharacter(v47);

                    if PlayerFromCharacter and PlayerFromCharacter:IsDescendantOf(Players) then
                        local Attribute = PlayerFromCharacter:GetAttribute("Armor");
                        local v52;

                        if typeof(Attribute) == "string" and Attribute ~= "" then
                            local v53;
                            v53, v52 = pcall(HttpService.JSONDecode, HttpService, Attribute);

                            if not v53 or typeof(v52) ~= "table" then
                                v52 = nil;
                            end;
                        else
                            v52 = nil;
                        end;

                        if v52 == nil then
                            v46 = false;
                        else
                            v46 = v52.Type == "Kevlar + Helmet";
                        end;
                    end;
                end;
            end;

            if v46 then
                Name = "Helmet Headshot";
            end;
        end;

        local CutoutBoard = CharacterResolver.getCutoutBoard(p30);
        local v54 = CutoutBoard and (CharacterResolver.isCutoutHeadshot(CutoutBoard, p32) and "Helmet Headshot" or "Blood Splatter") or Name;
        debug.profileend();

        if p34 or p41 == true then
            if DebugFlags.IsEnabled("WeaponFX") then
                warn(("[WeaponFX][Client][ImpactSound] skipped material=%s pos=%s exit=%s suppressed=%s"):format(tostring(v42), tostring(p32), tostring(p34), (tostring(p41 == true))));
            end;
        else
            debug.profilebegin("VFX.Impact.PlaySound");
            local v55 = FlashEffect.IsFlashed();
            local v56 = v55 and 0 or 1;

            if DebugFlags.IsEnabled("WeaponFX") then
                warn(("[WeaponFX][Client][ImpactSound] play material=%s sound=%s pos=%s flashed=%s exit=%s melee=%s volumeMult=%s"):format(tostring(v42), tostring(v54), tostring(p32), tostring(v55), tostring(p34), tostring(p35), (tostring(v56))));
            end;

            Sound.new("Bullet"):PlaySoundAtPosition({
                Class = "Bullet",
                Position = p32,
                Name = v54
            }, nil, v56, p36 == true, p38 == true);
            debug.profileend();
        end;

        if v42 == "Blood Splatter" and v46 then
            v43 = Impacts:FindFirstChild("Helmet Headshot") or v43;
        end;

        if (v42 == "Blood Splatter" or not p35) and p40 ~= true then
            local u57, u58, u59, v60 = createImpactMarker(v43);

            if not (u57 and (u58 and u59)) then
                debug.profileend();

                return;
            end;

            debug.profilebegin("VFX.Impact.ParentMarker");

            if v45 and (v42 == "Blood Splatter" and (p30 and p30:IsA("BasePart"))) then
                u57.CFrame = CFrame.new(p30.Position, p30.Position + Vector3.new(0, 1, 0));
            else
                u57.CFrame = CFrame.new(p32, p32 + p33) + p33 * 0.1;
            end;

            debug.profileend();
            debug.profilebegin("VFX.Impact.EmitParticles");

            for _, v in u4[u57] or u9 do
                local Emitter = v.Emitter;
                local Count = v.Count;

                if v.Delay <= 0 then
                    Emitter:Emit(Count);
                else
                    task.delay(v.Delay, function() -- Line: 329
                        -- upvalues: u57 (copy), u58 (copy), u59 (copy), Emitter (copy), Count (copy)
                        if u57.Parent and u58:IsAcquired(u57, u59) then
                            Emitter:Emit(Count);
                        end;
                    end);
                end;
            end;

            debug.profileend();
            task.delay(v60 or 5, function() -- Line: 338
                -- upvalues: u58 (copy), u57 (copy), u59 (copy)
                u58:Release(u57, u59);
            end);
        end;
    end;

    debug.profileend();
end;