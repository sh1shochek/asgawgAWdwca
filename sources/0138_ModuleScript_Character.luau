-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Players = game:GetService("Players");
local DebugFlags = require(ReplicatedStorage.Shared.DebugFlags);
local GetWeaponProperties = require(ReplicatedStorage.Components.Common.GetWeaponProperties);
local CreateZeusBeam = require(ReplicatedStorage.Components.Common.VFXLibary.CreateZeusBeam);
local CharacterGeneration = require(ReplicatedStorage.Components.Common.CharacterGeneration);
local ClientCharacterPresentation = require(ReplicatedStorage.Components.Common.ClientCharacterPresentation);
local IsTutorialMode = require(ReplicatedStorage.Components.Common.IsTutorialMode);
local EmitParticles = require(script.Parent.EmitParticles);

local function executeMuzzleFlash(p1: userdata, p2: string) -- Line: 19
    -- upvalues: EmitParticles (copy)
    debug.profilebegin("VFX.MuzzleFlash.Character.Execute");
    local v3 = p1:FindFirstChild(p2);

    if not v3 then
        debug.profileend();

        return nil;
    end;

    debug.profilebegin("VFX.MuzzleFlash.Character.EmitParticles");
    EmitParticles(v3);
    debug.profileend();
    debug.profileend();

    return p1.Position;
end;

local function dlog(p4: string, ...) -- Line: 34
    -- upvalues: DebugFlags (copy)
    if not DebugFlags.IsEnabled("WeaponFX") then
        return;
    end;

    warn(("[WeaponFX][MuzzleFlash.Character] " .. p4):format(...));
end;

local function findTutorialDummy(p5: number) -- Line: 42
    -- upvalues: IsTutorialMode (copy)
    if not IsTutorialMode() then
        return nil;
    end;

    for _, child in workspace:GetChildren() do
        if child:IsA("Folder") and string.sub(child.Name, 1, 8) == "Tutorial" then
            for _, child2 in child:GetChildren() do
                if child2:IsA("Model") and (child2:GetAttribute("TutorialDummy") == true and child2:GetAttribute("DummyUserId") == p5) then
                    return child2;
                end;
            end;
        end;
    end;

    return nil;
end;

local function findDummyWeaponModel(p6: userdata, p7: string) -- Line: 59
    local v8 = p6:FindFirstChild(p7);

    if v8 and v8:IsA("Model") then
        return v8;
    end;

    for _, child in p6:GetChildren() do
        if child:IsA("Model") and child:FindFirstChild("Interactables") then
            return child;
        end;
    end;

    return nil;
end;

return function(p9: number, p10: number, p11: string, p12: string, p13: string?, p14: boolean?) -- Line: 72, Name: tryCreate
    -- upvalues: Players (copy), findTutorialDummy (copy), dlog (copy), GetWeaponProperties (copy), ClientCharacterPresentation (copy), CharacterGeneration (copy), findDummyWeaponModel (copy), CreateZeusBeam (copy), executeMuzzleFlash (copy)
    debug.profilebegin("VFX.MuzzleFlash.Character.TryCreate");
    local PlayerByUserId = Players:GetPlayerByUserId(p9);
    local v15;

    if PlayerByUserId then
        v15 = nil;
    else
        v15 = findTutorialDummy(p9);
    end;

    if not (PlayerByUserId or v15) then
        dlog("player not found userId=%s weapon=%s", tostring(p9), (tostring(p11)));
        debug.profileend();

        return;
    end;

    local v16;

    if PlayerByUserId then
        v16 = PlayerByUserId.Name;
    else
        v16 = v15.Name;
    end;

    debug.profilebegin("VFX.MuzzleFlash.Character.TryCreate.GetWeaponProperties");
    local v17 = GetWeaponProperties(p11);
    debug.profileend();

    if not v17 then
        dlog("weapon properties missing player=%s weapon=%s", v16, (tostring(p11)));
        debug.profileend();

        return;
    end;

    debug.profilebegin("VFX.MuzzleFlash.Character.TryCreate.FindWeaponModel");
    local v18;

    if PlayerByUserId then
        local v19 = ClientCharacterPresentation.Create(PlayerByUserId, p10);

        if not (v19 and CharacterGeneration.Matches(v19, p10)) then
            dlog("presentation missing player=%s generation=%s weapon=%s", v16, tostring(p10), (tostring(p11)));
            debug.profileend();
            debug.profileend();

            return;
        end;

        v18 = v19:FindFirstChild("WeaponModel");

        if v18 then
            v18 = v18:FindFirstChild("Equipped");
        end;

        if not (v18 and v18:IsA("Model")) then
            v18 = nil;
        end;
    else
        v18 = findDummyWeaponModel(v15, p11);
    end;

    debug.profileend();

    if not v18 then
        dlog("missing equipped presentation player=%s weapon=%s", v16, (tostring(p11)));
        debug.profileend();

        return;
    end;

    debug.profilebegin("VFX.MuzzleFlash.Character.TryCreate.FindMuzzlePart");
    local Interactables = v18:FindFirstChild("Interactables");

    if not Interactables then
        dlog("missing Interactables player=%s weapon=%s", v16, (tostring(p11)));
        debug.profileend();
        debug.profileend();

        return;
    end;

    local MuzzlePart = Interactables:FindFirstChild("MuzzlePart");

    if v17.ShootingOptions == "Dual" then
        MuzzlePart = Interactables:FindFirstChild("MuzzlePart" .. (p12 == "Left" and "L" or "R"));
    end;

    if not MuzzlePart then
        dlog("missing muzzle part player=%s weapon=%s shootingHand=%s", v16, tostring(p11), (tostring(p12)));
        debug.profileend();
        debug.profileend();

        return;
    end;

    debug.profileend();

    if v17.MuzzleType == "Zeus x27" then
        debug.profilebegin("VFX.MuzzleFlash.Character.CreateZeusBeam");
        CreateZeusBeam(MuzzlePart);
        debug.profileend();
    end;

    if p14 then
        debug.profileend();

        return;
    end;

    local v20 = p13 or v17.MuzzleType;

    if not v20 then
        debug.profileend();

        return;
    end;

    if not executeMuzzleFlash(MuzzlePart, v20) then
        dlog("executeMuzzleFlash failed player=%s weapon=%s override=%s", v16, tostring(p11), (tostring(p13)));
    end;

    debug.profileend();
end;