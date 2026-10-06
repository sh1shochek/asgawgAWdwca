-- Decompiled with Potassium's decompiler.

local u1 = {};
local CollectionService = game:GetService("CollectionService");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Players = game:GetService("Players");
local Workspace = game:GetService("Workspace");
local RunServiceController = require(ReplicatedStorage.Controllers.RunServiceController);
local CharacterResolver = require(ReplicatedStorage.Components.Common.CharacterResolver);
local LocalPlayer = Players.LocalPlayer;
local RaycastParams_new_ret = RaycastParams.new();
RaycastParams_new_ret.FilterType = Enum.RaycastFilterType.Exclude;
RaycastParams_new_ret.IgnoreWater = true;
local u2 = 0;
local u3 = -1;
local u4 = nil;
local u5 = nil;
local u6 = nil;
local u7 = 0;
local u8 = nil;
RunServiceController.BindToHeartbeat("Components.CenterScreenRaycast.InvalidateCache", function() -- Line: 36
    -- upvalues: u2 (ref)
    u2 = u2 + 1;
end);

local function ClearCache() -- Line: 40
    -- upvalues: u3 (ref), u4 (ref), u5 (ref), u6 (ref), u7 (ref), u8 (ref)
    u3 = -1;
    u4 = nil;
    u5 = nil;
    u6 = nil;
    u7 = 0;
    u8 = nil;
end;

local function ResolveRaycast(p9: number) -- Line: 49
    -- upvalues: Workspace (copy), CharacterResolver (copy), u3 (ref), u4 (ref), u5 (ref), u6 (ref), u7 (ref), u8 (ref), u2 (ref), RaycastParams_new_ret (copy)
    local CurrentCamera = Workspace.CurrentCamera;
    local LocalCharacter = CharacterResolver.getLocalCharacter();

    if not (CurrentCamera and LocalCharacter) then
        u3 = -1;
        u4 = nil;
        u5 = nil;
        u6 = nil;
        u7 = 0;
        u8 = nil;

        return nil;
    end;

    local CFrame = CurrentCamera.CFrame;
    local v10;

    if u3 == u2 and (u4 == CurrentCamera and (u6 == LocalCharacter and u5 == CFrame)) then
        v10 = p9 <= u7;
    else
        v10 = false;
    end;

    if v10 then
        return u8;
    end;

    local Map = Workspace:FindFirstChild("Map");
    local v11;

    if Map then
        v11 = Map:FindFirstChild("Barriers");
    else
        v11 = nil;
    end;

    RaycastParams_new_ret.FilterDescendantsInstances = v11 and { LocalCharacter, CurrentCamera, v11 } or { LocalCharacter, CurrentCamera };
    u8 = Workspace:Raycast(CFrame.Position, CFrame.LookVector * p9, RaycastParams_new_ret);
    u3 = u2;
    u4 = CurrentCamera;
    u5 = CFrame;
    u6 = LocalCharacter;
    u7 = p9;

    return u8;
end;

function u1.GetResult(p12: number?) -- Line: 82
    -- upvalues: ResolveRaycast (copy)
    local v13 = p12 or 10;
    local v14 = ResolveRaycast(v13);

    if v14 and v13 >= v14.Distance then
        return v14;
    end;

    return nil;
end;

function u1.GetInstance(p15: number?) -- Line: 91
    -- upvalues: u1 (copy)
    local Result = u1.GetResult(p15);

    if Result then
        return Result.Instance;
    end;

    return nil;
end;

function u1.FindTaggedAncestor(p16: string, p17: number?) -- Line: 96
    -- upvalues: u1 (copy), CollectionService (copy)
    local Instance = u1.GetInstance(p17);

    while Instance do
        if CollectionService:HasTag(Instance, p16) then
            return Instance;
        end;

        Instance = Instance.Parent;
    end;

    return nil;
end;

local function RayEntersBox(p18, p19: vector, p20: vector, p21: vector, p22: number) -- Line: 108
    local v23 = p18:PointToObjectSpace(p20);
    local v24 = p18:VectorToObjectSpace(p21);
    local v25 = p19 / 2;
    local v26 = 0;

    for _, v in { "X", "Y", "Z" } do
        local v27 = v23[v];
        local v28 = v24[v];
        local v29 = v25[v];

        if math.abs(v28) < 1e-6 then
            if v29 < math.abs(v27) then
                return nil;
            end;
        else
            local v30 = (-v29 - v27) / v28;
            local v31 = (v29 - v27) / v28;

            if v31 >= v30 then
                local v32 = v30;
                v30 = v31;
                v31 = v32;
            end;

            v26 = math.max(v26, v31);
            p22 = math.min(p22, v30);

            if p22 < v26 then
                return nil;
            end;
        end;
    end;

    return v26;
end;

function u1.FindTaggedModelInSight(p33: string, p34: number?) -- Line: 138
    -- upvalues: u1 (copy), Workspace (copy), CharacterResolver (copy), CollectionService (copy), RayEntersBox (copy)
    local v35 = p34 or 10;
    local v36 = u1.FindTaggedAncestor(p33, v35);

    if v36 and v36:IsA("Model") then
        return v36;
    end;

    local CurrentCamera = Workspace.CurrentCamera;

    if not (CurrentCamera and CharacterResolver.getLocalCharacter()) then
        return nil;
    end;

    local Position = CurrentCamera.CFrame.Position;
    local LookVector = CurrentCamera.CFrame.LookVector;
    local Result = u1.GetResult(v35);
    local v37 = (1 / 0);
    local v38 = nil;

    for _, v in CollectionService:GetTagged(p33) do
        if v:IsA("Model") and v:GetAttribute("Destroyed") ~= true then
            local BoundingBox, v39 = v:GetBoundingBox();

            if (BoundingBox.Position - Position).Magnitude <= v35 + v39.Magnitude / 2 then
                local v40 = RayEntersBox(BoundingBox, v39, Position, LookVector, v35);

                if v40 ~= nil and (v37 > v40 and not (Result and (Result.Distance < v40 - 0.25 and not Result.Instance:IsDescendantOf(v)))) then
                    v38 = v;
                    v37 = v40;
                end;
            end;
        end;
    end;

    return v38;
end;

function u1.GetHoveredHostage(p41: number?) -- Line: 175
    -- upvalues: LocalPlayer (copy), u1 (copy)
    if LocalPlayer:GetAttribute("Team") ~= "Counter-Terrorists" then
        return nil;
    end;

    local v42 = u1.FindTaggedAncestor("Hostage", p41 or 5);

    if not (v42 and v42:IsA("Model")) then
        return nil;
    end;

    if v42:GetAttribute("CanRescue") ~= true then
        return nil;
    end;

    local Attribute = v42:GetAttribute("RescuingPlayer");

    if Attribute and Attribute ~= LocalPlayer.Name then
        return nil;
    end;

    if v42:GetAttribute("CarryingPlayer") then
        return nil;
    end;

    return v42;
end;

return u1;