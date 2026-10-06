-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local HttpService = game:GetService("HttpService");
local Players = game:GetService("Players");
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
local u1 = {};
local u2 = {};

local function hasParticleEmitter(p3: userdata) -- Line: 46
    for _, descendant in ipairs(p3:GetDescendants()) do
        if descendant:IsA("ParticleEmitter") then
            return true;
        end;
    end;

    return false;
end;

local function getImpactTemplates(p4) -- Line: 55
    -- upvalues: u1 (copy), hasParticleEmitter (copy)
    local v5 = u1[p4];

    if v5 then
        return v5;
    end;

    local v6 = {};

    for _, child in ipairs(p4:GetChildren()) do
        if child:IsA("BasePart") and hasParticleEmitter(child) then
            v6[#v6 + 1] = child;
        end;
    end;

    u1[p4] = v6;

    return v6;
end;

local function resetImpactMarker(p7: userdata) -- Line: 71
    for _, descendant in ipairs(p7:GetDescendants()) do
        if descendant:IsA("ParticleEmitter") then
            descendant:Clear();
        end;
    end;
end;

local function getImpactPool(p8: userdata) -- Line: 79
    -- upvalues: u2 (copy), ObjectPool (copy), resetImpactMarker (copy)
    local v9 = u2[p8];

    if v9 then
        return v9;
    end;

    local v10 = ObjectPool.new(p8, {
        InitialSize = 2,
        MaxRetained = 60,
        Reset = resetImpactMarker
    });
    u2[p8] = v10;

    return v10;
end;

local function createImpactMarker(p11) -- Line: 94
    -- upvalues: getImpactTemplates (copy), u2 (copy), ObjectPool (copy), resetImpactMarker (copy)
    debug.profilebegin("VFX.Impact.CreateImpactMarker");
    local v12 = getImpactTemplates(p11);

    if #v12 == 0 then
        debug.profileend();

        return nil, nil, nil;
    end;

    local v13 = v12[math.random(1, #v12)];
    local v14 = u2[v13];

    if not v14 then
        v14 = ObjectPool.new(v13, {
            InitialSize = 2,
            MaxRetained = 60,
            Reset = resetImpactMarker
        });
        u2[v13] = v14;
    end;

    local v15, v16 = v14:Acquire();
    v15.CollisionGroup = "Debris";
    v15.CanCollide = false;
    v15.CanQuery = false;
    v15.CanTouch = false;
    v15.Anchored = true;
    debug.profileend();

    return v15, v14, v16;
end;

local function IsHeadPart(p17: userdata?) -- Line: 117
    if p17 and p17:IsA("BasePart") then
        return string.find(string.lower(p17.Name), "head", 1, true) ~= nil;
    end;

    return false;
end;

local function IsHeadImpact(p18: userdata?, p19: string) -- Line: 126
    local v20;

    if p19 == "Blood Splatter" then
        if not (p18 and p18:IsA("BasePart")) then
            return false;
        end;

        v20 = string.find(string.lower(p18.Name), "head", 1, true) ~= nil;
    else
        v20 = false;
    end;

    return v20;
end;

local function decodeArmor(p21) -- Line: 130
    -- upvalues: HttpService (copy)
    if typeof(p21) ~= "string" or p21 == "" then
        return nil;
    end;

    local success, result = pcall(HttpService.JSONDecode, HttpService, p21);

    if success and typeof(result) == "table" then
        return result;
    end;

    return nil;
end;

return function(p22: userdata?, p23: string, p24: vector, p25: vector, p26: boolean, p27: boolean, p28: boolean?, p29: string?, p30: boolean?, p31: boolean?, p32: boolean?, p33: boolean?) -- Line: 140
    -- upvalues: Players (copy), Impacts (copy), Materials (copy), Participants (copy), HttpService (copy), CharacterResolver (copy), FlashEffect (copy), DebugFlags (copy), Sound (copy), createImpactMarker (copy), Debris (copy)
    debug.profilebegin("VFX.Impact");
    local v34 = p23 == "Blood Splatter" and Players.LocalPlayer:GetAttribute("SK") and "Blood Splatter_SK" or p23;
    local v35 = Impacts:FindFirstChild(Materials[v34] or v34);

    if v35 then
        local v36;

        if v34 == "Blood Splatter" and (p22 and p22:IsA("BasePart")) then
            v36 = string.find(string.lower(p22.Name), "head", 1, true) ~= nil;
        else
            v36 = false;
        end;

        local v37 = v36 or p31 ~= nil;
        local v38 = p31 == true;
        debug.profilebegin("VFX.Impact.ResolveSound");
        local Name = v35.Name;

        if v37 then
            Name = "Headshot";

            if p22 and (not p27 and p31 == nil) then
                local v39 = p22:FindFirstAncestorOfClass("Model");
                local v40;

                if v39 and v39:GetAttribute("Bot") == true then
                    v40 = v39:GetAttribute("CombatantId");
                else
                    v40 = nil;
                end;

                if typeof(v40) == "number" then
                    local v41 = Participants.FromKey(Participants.BotKey(v40));
                    local v42;

                    if v41 then
                        local Attribute = v41:GetAttribute("Armor");

                        if typeof(Attribute) == "string" and Attribute ~= "" then
                            local v43;
                            v43, v42 = pcall(HttpService.JSONDecode, HttpService, Attribute);

                            if not v43 or typeof(v42) ~= "table" then
                                v42 = nil;
                            end;
                        else
                            v42 = nil;
                        end;
                    else
                        v42 = nil;
                    end;

                    if v42 == nil then
                        v38 = false;
                    else
                        v38 = v42.Type == "Kevlar + Helmet";
                    end;
                elseif CharacterResolver.isPlayerCharacter(v39) and v39:IsDescendantOf(workspace) then
                    local PlayerFromCharacter = CharacterResolver.getPlayerFromCharacter(v39);

                    if PlayerFromCharacter and PlayerFromCharacter:IsDescendantOf(Players) then
                        local Attribute = PlayerFromCharacter:GetAttribute("Armor");
                        local v44;

                        if typeof(Attribute) == "string" and Attribute ~= "" then
                            local v45;
                            v45, v44 = pcall(HttpService.JSONDecode, HttpService, Attribute);

                            if not v45 or typeof(v44) ~= "table" then
                                v44 = nil;
                            end;
                        else
                            v44 = nil;
                        end;

                        if v44 == nil then
                            v38 = false;
                        else
                            v38 = v44.Type == "Kevlar + Helmet";
                        end;
                    end;
                end;
            end;

            if v38 then
                Name = "Helmet Headshot";
            end;
        end;

        local CutoutBoard = CharacterResolver.getCutoutBoard(p22);
        local v46 = CutoutBoard and (CharacterResolver.isCutoutHeadshot(CutoutBoard, p24) and "Helmet Headshot" or "Blood Splatter") or Name;
        debug.profileend();

        if p26 or p33 == true then
            if DebugFlags.IsEnabled("WeaponFX") then
                warn(("[WeaponFX][Client][ImpactSound] skipped material=%s pos=%s exit=%s suppressed=%s"):format(tostring(v34), tostring(p24), tostring(p26), (tostring(p33 == true))));
            end;
        else
            debug.profilebegin("VFX.Impact.PlaySound");
            local v47 = FlashEffect.IsFlashed();
            local v48 = v47 and 0 or 1;

            if DebugFlags.IsEnabled("WeaponFX") then
                warn(("[WeaponFX][Client][ImpactSound] play material=%s sound=%s pos=%s flashed=%s exit=%s melee=%s volumeMult=%s"):format(tostring(v34), tostring(v46), tostring(p24), tostring(v47), tostring(p26), tostring(p27), (tostring(v48))));
            end;

            Sound.new("Bullet"):PlaySoundAtPosition({
                Class = "Bullet",
                Position = p24,
                Name = v46
            }, nil, v48, p28 == true, p30 == true);
            debug.profileend();
        end;

        if v34 == "Blood Splatter" and v38 then
            v35 = Impacts:FindFirstChild("Helmet Headshot") or v35;
        end;

        if (v34 == "Blood Splatter" or not p27) and p32 ~= true then
            local u49, u50, u51 = createImpactMarker(v35);

            if not (u49 and (u50 and u51)) then
                debug.profileend();

                return;
            end;

            debug.profilebegin("VFX.Impact.ParentMarker");

            if v37 and (v34 == "Blood Splatter" and (p22 and p22:IsA("BasePart"))) then
                u49.CFrame = CFrame.new(p22.Position, p22.Position + Vector3.new(0, 1, 0));
            else
                u49.CFrame = CFrame.new(p24, p24 + p25) + p25 * 0.1;
            end;

            u49.Parent = Debris;
            u49.Transparency = 1;
            debug.profileend();
            debug.profilebegin("VFX.Impact.EmitParticles");

            for _, descendant in ipairs(u49:GetDescendants()) do
                if descendant:IsA("ParticleEmitter") then
                    local v52 = descendant:GetAttribute("EmitDelay") or 0;
                    local u53 = descendant:GetAttribute("EmitCount") or 1;

                    if v52 <= 0 then
                        descendant:Emit(u53);
                    else
                        task.delay(v52, function() -- Line: 271
                            -- upvalues: u49 (copy), descendant (copy), u50 (copy), u51 (copy), u53 (copy)
                            if u49.Parent and (descendant.Parent and u50:IsAcquired(u49, u51)) then
                                descendant:Emit(u53);
                            end;
                        end);
                    end;
                end;
            end;

            debug.profileend();
            task.delay(5, function() -- Line: 285
                -- upvalues: u50 (copy), u49 (copy), u51 (copy)
                u50:Release(u49, u51);
            end);
        end;
    end;

    debug.profileend();
end;