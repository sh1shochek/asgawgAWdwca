-- ReplicatedStorage.GameClient.InteractionController
-- Script path: ReplicatedStorage.GameClient.InteractionController
-- Decompile time: 14.52 ms

-- Decompiled with Potassium's decompiler.

local v1 = {};
local RunService = game:GetService("RunService");
local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Interaction = require(ReplicatedStorage.Shared.Simulation.Interaction);
local LocalPlayer = Players.LocalPlayer;
local u2 = nil;
local u3 = nil;
local u4 = nil;
local u5 = nil;
local u6 = nil;
local u7 = nil;
local u8 = nil;
local u9 = {};

local function RefreshConfig() -- Line: 31
    -- upvalues: u9 (copy), u3 (ref)
    u9.PickupRange = u3.Get("Interaction", "PickupRange");
end;

local RaycastParams_new_ret = RaycastParams.new();
RaycastParams_new_ret.FilterType = Enum.RaycastFilterType.Include;
RaycastParams_new_ret.IgnoreWater = true;
local u10 = { nil, nil };
local u11 = nil;
local DroppedWeapons = workspace:WaitForChild("Debris"):WaitForChild("DroppedWeapons");
local u12 = 0;

local function ClearPrompt() -- Line: 55
    -- upvalues: u11 (ref), u7 (ref)
    if not u11 then
        u7.SetPickUpVisibility(false);

        return;
    end;

    u7.SetPickUpVisibility(false);
    u11 = nil;
end;

local function Step() -- Line: 64
    -- upvalues: u8 (ref), u11 (ref), u7 (ref), u2 (ref), u10 (copy), DroppedWeapons (copy), RaycastParams_new_ret (copy), u9 (copy), Interaction (copy), LocalPlayer (copy)
    if u8.HasFramePriority() then
        if not u11 then
            u7.SetPickUpVisibility(false);

            return;
        end;

        u7.SetPickUpVisibility(false);
        u11 = nil;

        return;
    end;

    local CFrame = u2.GetCFrame();
    local Map = workspace:FindFirstChild("Map");

    if Map then
        Map = Map:FindFirstChild("Geometry");
    end;

    if u10[1] ~= DroppedWeapons or u10[2] ~= Map then
        u10[1] = DroppedWeapons;
        u10[2] = Map;
        RaycastParams_new_ret.FilterDescendantsInstances = u10;
    end;

    local v13 = workspace:Raycast(CFrame.Position, CFrame.LookVector * u9.PickupRange, RaycastParams_new_ret);
    local v14;

    if v13 then
        v14 = v13.Instance;
    else
        v14 = v13;
    end;

    local v15 = v14 and (v14:IsDescendantOf(DroppedWeapons) and v14.Parent) or nil;

    if not v15 then
        v15 = Interaction.AimedWeapon(CFrame, v13 and v13.Distance or u9.PickupRange);

        if v15 then
            v15 = DroppedWeapons:FindFirstChild((tostring(v15)));
        end;
    end;

    if not v15 then
        if not u11 then
            u7.SetPickUpVisibility(false);

            return;
        end;

        u7.SetPickUpVisibility(false);
        u11 = nil;

        return;
    end;

    local Attribute = v15:GetAttribute("BlockedTeam");

    if not Attribute or LocalPlayer:GetAttribute("Team") ~= Attribute then
        if u11 ~= v15 then
            u7.SetPickUpVisibility(true, v15:GetAttribute("WeaponName"));
            u11 = v15;
        end;

        return;
    end;

    if not u11 then
        u7.SetPickUpVisibility(false);

        return;
    end;

    u7.SetPickUpVisibility(false);
    u11 = nil;
end;

local function OnCharacterSpawn(u16) -- Line: 120
    -- upvalues: u12 (ref), RunService (copy), Step (copy), u11 (ref), u7 (ref), DroppedWeapons (copy)
    local u17 = 0;
    local u18 = false;

    local function RefreshConnection() -- Line: 133
        -- upvalues: u12 (ref), u18 (ref), u16 (copy), RunService (ref), u17 (ref), Step (ref)
        local v19 = u12 > 0;

        if v19 == u18 then
            return;
        end;

        u18 = v19;

        if v19 then
            u16.Maid:Add("Character_ProcessInteraction", RunService.PostSimulation:Connect(function() -- Line: 147
                -- upvalues: u17 (ref), Step (ref)
                local os_clock_ret = os.clock();

                if u17 <= os_clock_ret then
                    u17 = os_clock_ret + 0.1;
                    Step();
                end;
            end));

            return;
        end;

        u16.Maid:Remove("Character_ProcessInteraction");
    end;

    local function Track(p20: string, p21: userdata?) -- Line: 157
        -- upvalues: u16 (copy), u12 (ref), RefreshConnection (copy), u11 (ref), u7 (ref)
        if not p21 then
            return;
        end;

        u16.Maid:Add(`Character_Add{p20}`, p21.ChildAdded:Connect(function() -- Line: 162
            -- upvalues: u12 (ref), RefreshConnection (ref)
            u12 = u12 + 1;
            RefreshConnection();
        end));
        u16.Maid:Add(`Character_Remove{p20}`, p21.ChildRemoved:Connect(function() -- Line: 167
            -- upvalues: u12 (ref), u11 (ref), u7 (ref), RefreshConnection (ref)
            u12 = u12 - 1;

            if u12 <= 0 then
                if u11 then
                    u7.SetPickUpVisibility(false);
                    u11 = nil;
                else
                    u7.SetPickUpVisibility(false);
                end;
            end;

            RefreshConnection();
        end));
        u12 = u12 + #p21:GetChildren();
    end;

    u12 = 0;
    Track("DroppedWeapon", DroppedWeapons);
    RefreshConnection();
end;

function v1.GetTarget() -- Line: 190
    -- upvalues: u11 (ref)
    return u11;
end;

function v1.Init(p22) -- Line: 196
    -- upvalues: u2 (ref), u4 (ref), u5 (ref), u3 (ref), u6 (ref), u8 (ref), u9 (copy), RefreshConfig (copy)
    u2 = p22:GetModule("CameraController");
    u4 = p22:GetModule("CharacterController");
    u5 = p22:GetModule("Gui");
    u3 = p22:GetModule("GameConfiguration");
    u6 = p22:GetModule("NewMapAdded");
    u8 = p22:GetModule("BindsController");
    u9.PickupRange = u3.Get("Interaction", "PickupRange");
    u3.Updated:Connect(RefreshConfig);
end;

function v1.Start(p23) -- Line: 208
    -- upvalues: u7 (ref), u5 (ref), u4 (ref), OnCharacterSpawn (copy), ClearPrompt (copy)
    u7 = u5.GetComponent("Notification");
    u4.OnCharacterSpawn:Connect(OnCharacterSpawn);
    u4.OnCharacterDestroy:Connect(ClearPrompt);
end;

return v1;