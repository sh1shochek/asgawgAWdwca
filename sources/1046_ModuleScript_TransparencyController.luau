-- Decompiled with Potassium's decompiler.

local VRService = game:GetService("VRService");
local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local u1 = { "BasePart", "Decal", "Beam", "ParticleEmitter", "Trail", "Fire", "Smoke", "Sparkles", "Explosion" };
local u2 = {
    [Enum.AccessoryType.Hat] = true,
    [Enum.AccessoryType.Hair] = true,
    [Enum.AccessoryType.Face] = true,
    [Enum.AccessoryType.Eyebrow] = true,
    [Enum.AccessoryType.Eyelash] = true
};
local CameraUtils = require(script.Parent:WaitForChild("CameraUtils"));
local CharacterResolver = require(ReplicatedStorage.Components.Common.CharacterResolver);
local success, result = pcall(function() -- Line: 38
    return UserSettings():IsUserFeatureEnabled("UserHideCharacterParticlesInFirstPerson");
end);
local u3 = success and result;
local u4 = {};
u4.__index = u4;

local function resolveSubjectCharacter(p5: userdata?) -- Line: 49
    if not p5 then
        return nil;
    end;

    if p5:IsA("Humanoid") then
        local Parent = p5.Parent;

        if Parent and Parent:IsA("Model") then
            return Parent;
        end;
    elseif p5:IsA("VehicleSeat") and p5.Occupant then
        local Parent = p5.Occupant.Parent;

        if Parent and Parent:IsA("Model") then
            return Parent;
        end;
    else
        if p5:IsA("BasePart") then
            return p5:FindFirstAncestorOfClass("Model");
        end;

        if p5:IsA("Model") then
            return p5;
        end;
    end;

    return nil;
end;

function u4.new() -- Line: 73
    -- upvalues: u4 (copy)
    local v6 = setmetatable({}, u4);
    v6.transparencyDirty = false;
    v6.enabled = false;
    v6.lastTransparency = nil;
    v6.descendantAddedConn = nil;
    v6.descendantRemovingConn = nil;
    v6.toolDescendantAddedConns = {};
    v6.toolDescendantRemovingConns = {};
    v6.cachedParts = {};
    v6.character = nil;

    return v6;
end;

function u4.HasToolAncestor(p7: table, p8: userdata) -- Line: 89
    if p8.Parent == nil then
        return false;
    end;

    assert(p8.Parent, "");

    return p8.Parent:IsA("Tool") or p7:HasToolAncestor(p8.Parent);
end;

function u4.IsValidPartToModify(p9: table, p10: userdata) -- Line: 97
    -- upvalues: u3 (ref), u1 (copy)
    if u3 then
        for _, v in u1 do
            if p10:IsA(v) then
                return not p9:HasToolAncestor(p10);
            end;
        end;
    elseif p10:IsA("BasePart") or p10:IsA("Decal") then
        return not p9:HasToolAncestor(p10);
    end;

    return false;
end;

function u4.CachePartsRecursive(p11, p12) -- Line: 112
    if p12 then
        if p11:IsValidPartToModify(p12) then
            p11.cachedParts[p12] = true;
            p11.transparencyDirty = true;
        end;

        for _, child in pairs(p12:GetChildren()) do
            p11:CachePartsRecursive(child);
        end;
    end;
end;

function u4.TeardownTransparency(p13) -- Line: 124
    -- upvalues: Players (copy)
    local character = p13.character;

    if character then
        if p13.character:GetAttribute("Dead") == true then
            character = true;
        else
            character = Players.LocalPlayer;

            if character then
                if Players.LocalPlayer.Character == p13.character then
                    character = Players.LocalPlayer:GetAttribute("IsSpectating") == true;
                else
                    character = false;
                end;
            end;
        end;
    end;

    for i, _ in pairs(p13.cachedParts) do
        i.LocalTransparencyModifier = character and 1 or 0;
    end;

    p13.cachedParts = {};
    p13.character = nil;
    p13.transparencyDirty = true;
    p13.lastTransparency = nil;

    if p13.descendantAddedConn then
        p13.descendantAddedConn:disconnect();
        p13.descendantAddedConn = nil;
    end;

    if p13.descendantRemovingConn then
        p13.descendantRemovingConn:disconnect();
        p13.descendantRemovingConn = nil;
    end;

    for i, v in pairs(p13.toolDescendantAddedConns) do
        v:Disconnect();
        p13.toolDescendantAddedConns[i] = nil;
    end;

    for i, v in pairs(p13.toolDescendantRemovingConns) do
        v:Disconnect();
        p13.toolDescendantRemovingConns[i] = nil;
    end;
end;

function u4.SetupTransparency(u14, u15) -- Line: 164
    u14:TeardownTransparency();
    u14.character = u15;

    if u14.descendantAddedConn then
        u14.descendantAddedConn:disconnect();
    end;

    u14.descendantAddedConn = u15.DescendantAdded:Connect(function(p16) -- Line: 171
        -- upvalues: u14 (copy), u15 (copy)
        if not u14:IsValidPartToModify(p16) then
            if p16:IsA("Tool") then
                if u14.toolDescendantAddedConns[p16] then
                    u14.toolDescendantAddedConns[p16]:Disconnect();
                end;

                u14.toolDescendantAddedConns[p16] = p16.DescendantAdded:Connect(function(p17) -- Line: 181
                    -- upvalues: u14 (ref)
                    u14.cachedParts[p17] = nil;

                    if p17:IsA("BasePart") or p17:IsA("Decal") then
                        p17.LocalTransparencyModifier = 0;
                    end;
                end);

                if u14.toolDescendantRemovingConns[p16] then
                    u14.toolDescendantRemovingConns[p16]:disconnect();
                end;

                u14.toolDescendantRemovingConns[p16] = p16.DescendantRemoving:Connect(function(p18) -- Line: 191
                    -- upvalues: u15 (ref), u14 (ref)
                    wait();

                    if u15 and (p18 and (p18:IsDescendantOf(u15) and u14:IsValidPartToModify(p18))) then
                        u14.cachedParts[p18] = true;
                        u14.transparencyDirty = true;
                    end;
                end);
            end;

            return;
        end;

        u14.cachedParts[p16] = true;
        u14.transparencyDirty = true;
    end);

    if u14.descendantRemovingConn then
        u14.descendantRemovingConn:disconnect();
    end;

    u14.descendantRemovingConn = u15.DescendantRemoving:connect(function(p19) -- Line: 205
        -- upvalues: u14 (copy)
        if u14.cachedParts[p19] then
            u14.cachedParts[p19] = nil;
            p19.LocalTransparencyModifier = 0;
        end;
    end);
    u14:CachePartsRecursive(u15);
end;

function u4.Enable(p20: table, p21: boolean) -- Line: 215
    if p20.enabled ~= p21 then
        p20.enabled = p21;
    end;
end;

function u4.SetSubject(p22, p23) -- Line: 221
    -- upvalues: resolveSubjectCharacter (copy), CharacterResolver (copy)
    local v24 = resolveSubjectCharacter(p23);

    if v24 and not CharacterResolver.getPlayerFromCharacter(v24) then
        v24 = nil;
    end;

    if v24 then
        p22:SetupTransparency(v24);

        return;
    end;

    p22:TeardownTransparency();
end;

function u4.Update(p25, p26) -- Line: 233
    -- upvalues: resolveSubjectCharacter (copy), CharacterResolver (copy), Players (copy), CameraUtils (copy), VRService (copy), u2 (copy)
    local workspace_CurrentCamera = workspace.CurrentCamera;

    if workspace_CurrentCamera and p25.enabled then
        local v27 = resolveSubjectCharacter(workspace_CurrentCamera.CameraSubject);
        local LocalCharacter = CharacterResolver.getLocalCharacter();
        local v28;

        if v27 == nil or LocalCharacter ~= v27 then
            v28 = false;
        else
            v28 = Players.LocalPlayer.CameraMode == Enum.CameraMode.LockFirstPerson;
        end;

        local magnitude = (workspace_CurrentCamera.Focus.p - workspace_CurrentCamera.CoordinateFrame.p).magnitude;
        local v29 = v28 and 1 or (magnitude < 2 and 1 - (magnitude - 0.5) / 1.5 or 0);
        local v30 = v29 < 0.5 and 0 or v29;

        if p25.lastTransparency and (v30 < 1 and p25.lastTransparency < 0.95) then
            local v31 = 2.8 * p26;
            local math_clamp_ret = math.clamp(v30 - p25.lastTransparency, -v31, v31);
            v30 = p25.lastTransparency + math_clamp_ret;
        end;

        local v32 = CameraUtils.Round(v30, 2);
        local math_clamp_ret = math.clamp(v32, 0, 1);

        if p25.transparencyDirty or p25.lastTransparency ~= math_clamp_ret then
            local v33 = VRService.VREnabled and VRService.AvatarGestures;

            for i, _ in pairs(p25.cachedParts) do
                if v33 then
                    local Parent = i.Parent;

                    if Parent and (Parent:IsA("Accessory") and u2[Parent.AccessoryType]) or i.Name == "Head" then
                        i.LocalTransparencyModifier = math_clamp_ret;
                    else
                        i.LocalTransparencyModifier = 0;
                    end;
                else
                    i.LocalTransparencyModifier = math_clamp_ret;
                end;
            end;

            p25.transparencyDirty = false;
            p25.lastTransparency = math_clamp_ret;
        end;
    end;
end;

return u4;