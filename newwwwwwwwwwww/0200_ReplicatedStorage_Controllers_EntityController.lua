-- EntityController (ModuleScript)
-- full path: ReplicatedStorage.Controllers.EntityController

-- Decompiled with Potassium's decompiler.

local v1 = {};
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Players = game:GetService("Players");
local Entities = script:WaitForChild("Entities");
local CharacterResolver = require(ReplicatedStorage.Components.Common.CharacterResolver);
local SurvivalDowned = require(ReplicatedStorage.Components.Common.SurvivalDowned);
local FarThrottle = require(ReplicatedStorage.Components.Common.FarThrottle);
local RunServiceController = require(ReplicatedStorage.Controllers.RunServiceController);
local Remotes = require(ReplicatedStorage.Database.Security.Remotes);
local Debris = workspace:WaitForChild("Debris");
local u2 = {};
local u3 = {};
local u4 = {};
local u5 = {};
local u6 = nil;
local u7 = FarThrottle.new();

local function getPickupPosition() -- Line: 76
    -- upvalues: CharacterResolver (copy), SurvivalDowned (copy), Players (copy)
    local LocalCharacter = CharacterResolver.getLocalCharacter();

    if not CharacterResolver.isAliveCharacter(LocalCharacter) or SurvivalDowned.IsDowned(Players.LocalPlayer) then
        return nil;
    end;

    local RootPart = CharacterResolver.getRootPart(LocalCharacter);

    if RootPart then
        return RootPart.Position;
    end;

    return nil;
end;

local function track(p8: table) -- Line: 87
    -- upvalues: Debris (copy)
    local Model = p8.Model;
    Model:PivotTo(CFrame.new(p8.Position));
    local Pivot = Model:GetPivot();
    local TrackPart = p8.TrackPart;
    local v9 = {
        Elapsed = 0,
        Entity = p8,
        Parts = {},
        Offsets = {}
    };

    for _, descendant in Model:GetDescendants() do
        if descendant:IsA("BasePart") then
            descendant.CanCollide = false;
            descendant.CanQuery = false;
            descendant.CanTouch = false;
            descendant.Anchored = true;
            table.insert(v9.Parts, descendant);
            table.insert(v9.Offsets, Pivot:ToObjectSpace(descendant.CFrame));

            if TrackPart then
                TrackPart(p8, descendant);
            end;
        end;
    end;

    Model.Parent = Debris;

    return v9;
end;

local function step(p10: number) -- Line: 111
    -- upvalues: u4 (copy), u5 (copy), CharacterResolver (copy), SurvivalDowned (copy), Players (copy), u7 (copy), u2 (copy)
    table.clear(u4);
    table.clear(u5);
    local LocalCharacter = CharacterResolver.getLocalCharacter();
    local v11;

    if CharacterResolver.isAliveCharacter(LocalCharacter) and not SurvivalDowned.IsDowned(Players.LocalPlayer) then
        local RootPart = CharacterResolver.getRootPart(LocalCharacter);

        if RootPart then
            v11 = RootPart.Position;
        else
            v11 = nil;
        end;
    else
        v11 = nil;
    end;

    u7:Begin();
    local v12 = 0;

    for _, v in u2 do
        v12 = v12 + 1;
        local Entity = v.Entity;
        v.Elapsed = v.Elapsed + p10;
        local Elapsed = v.Elapsed;
        Entity:Step(Elapsed, v11);

        if not u7:Skips(Entity.Position, v12) then
            local v13 = math.sin(Elapsed * 0.5 * 2 * 3.141592653589793) * 0.15 + 0.2;
            local v14 = CFrame.new(Entity.Position + Vector3.new(0, v13, 0)) * CFrame.Angles(0, Elapsed * 1.5707963267948966, 0);
            local v15 = v;

            for i, v2 in v.Parts do
                table.insert(u4, v2);
                table.insert(u5, v14 * v15.Offsets[i]);
            end;
        end;
    end;

    if #u4 > 0 then
        workspace:BulkMoveTo(u4, u5, Enum.BulkMoveMode.FireCFrameChanged);
    end;
end;

function v1.Initialize() -- Line: 142
    -- upvalues: Entities (copy), u3 (copy), Remotes (copy), u2 (copy), track (copy), u6 (ref), RunServiceController (copy), step (copy)
    for _, child in Entities:GetChildren() do
        if child:IsA("ModuleScript") then
            u3[child.Name] = require(child);
        end;
    end;

    Remotes.Entity.CreateEntity.Listen(function(p16) -- Line: 150
        -- upvalues: u3 (ref), u2 (ref), track (ref), u6 (ref), RunServiceController (ref), step (ref)
        local v17 = u3[p16.EntityName];

        if not v17 then
            return;
        end;

        u2[p16.EntityId] = track(v17.new(p16.EntityId, p16.EntityName, p16.EntityPosition, p16.Lifetime));

        if not u6 then
            u6 = RunServiceController.BindToHeartbeat("EntityController.Step", step);
        end;
    end);
    Remotes.Entity.DestroyEntity.Listen(function(p18) -- Line: 163
        -- upvalues: u2 (ref), u6 (ref)
        local v19 = u2[p18.EntityId];

        if not v19 then
            return;
        end;

        u2[p18.EntityId] = nil;
        v19.Entity:Destroy(p18.ClaimedBy);

        if next(u2) == nil and u6 then
            u6:Disconnect();
            u6 = nil;
        end;
    end);
end;

return v1;