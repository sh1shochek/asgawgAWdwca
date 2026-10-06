-- Decompiled with Potassium's decompiler.

local CollectionService = game:GetService("CollectionService");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Workspace = game:GetService("Workspace");
local Players = game:GetService("Players");
require(script.Parent.Parent.Types);
local CharacterResolver = require(ReplicatedStorage.Components.Common.CharacterResolver);
local Remotes = require(ReplicatedStorage.Database.Security.Remotes);
local DataController = require(ReplicatedStorage.Controllers.DataController);
local LocalPlayer = Players.LocalPlayer;
local CurrentCamera = Workspace.CurrentCamera;
local u1 = 0;
local RaycastParams_new_ret = RaycastParams.new();
RaycastParams_new_ret.FilterType = Enum.RaycastFilterType.Exclude;
RaycastParams_new_ret.IgnoreWater = false;

local function GetWeaponDataFromInstance(p2: userdata?) -- Line: 42
    -- upvalues: CollectionService (copy)
    while p2 do
        if CollectionService:HasTag(p2, "WeaponDropped") then
            local Attribute = p2:GetAttribute("Weapon");
            local Attribute2 = p2:GetAttribute("Skin");

            if Attribute and Attribute2 then
                return Attribute, Attribute2, p2.Name;
            end;

            break;
        end;

        p2 = p2.Parent;
    end;

    return nil, nil, nil;
end;

local function GetRaycastResult(...) -- Line: 60
    -- upvalues: CurrentCamera (copy), RaycastParams_new_ret (copy)
    local v3 = { CurrentCamera, ... };
    RaycastParams_new_ret.FilterDescendantsInstances = v3;
    local v4 = workspace:Raycast(CurrentCamera.CFrame.Position, CurrentCamera.CFrame.LookVector * 1000, RaycastParams_new_ret);

    while v4 and v4.Instance do
        local Instance = v4.Instance;

        if not Instance:IsA("BasePart") or Instance.Transparency <= 0.98 then
            break;
        end;

        table.insert(v3, Instance);
        RaycastParams_new_ret.FilterDescendantsInstances = v3;
        v4 = workspace:Raycast(v4.Position, CurrentCamera.CFrame.LookVector.Unit * (1000 - v4.Distance), RaycastParams_new_ret);
    end;

    return v4;
end;

return table.freeze({
    Name = "Ping",
    Group = "Gameplay",
    Category = "UI Keys",

    Callback = function(p5) -- Line: 88, Name: onInput
        -- upvalues: DataController (copy), LocalPlayer (copy), CharacterResolver (copy), GetRaycastResult (copy), GetWeaponDataFromInstance (copy), Remotes (copy), u1 (ref)
        if workspace:GetAttribute("Gamemode") == "Deathmatch" then
            return;
        end;

        if DataController.Get(LocalPlayer, "Settings.Game.HUD.Player Pings") == "Disabled" then
            return;
        end;

        if not CharacterResolver.isAliveCharacter(CharacterResolver.getPlayerCharacter(LocalPlayer)) or p5 ~= Enum.UserInputState.Begin then
            return;
        end;

        local v6 = GetRaycastResult(CharacterResolver.getLocalCharacter());

        if not v6 then
            return;
        end;

        local v7, v8, v9 = GetWeaponDataFromInstance(v6.Instance);

        if v7 and (v8 and v9) then
            Remotes.Ping.CreatePlayerPositionPing.Send({
                IsDanger = false,
                Position = v6.Position,
                WeaponIdentity = v9,
                WeaponName = v7,
                WeaponSkin = v8
            });
        else
            Remotes.Ping.CreatePlayerPositionPing.Send({
                IsDanger = tick() - u1 < 0.5,
                Position = v6.Position
            });
        end;

        u1 = tick();
    end
});