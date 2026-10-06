-- Decompiled with Potassium's decompiler.

local u1 = {};
u1.__index = u1;
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Players = game:GetService("Players");
local CharacterResolver = require(ReplicatedStorage.Components.Common.CharacterResolver);
local RunServiceController = require(ReplicatedStorage.Controllers.RunServiceController);
local Remotes = require(ReplicatedStorage.Database.Security.Remotes);
local Router = require(ReplicatedStorage.Database.Security.Router);
local Health = ReplicatedStorage:WaitForChild("Assets"):WaitForChild("Deathmatch"):WaitForChild("Health");
local Debris = workspace:WaitForChild("Debris");

local function AttemptEntityPickup(p2) -- Line: 45
    -- upvalues: Players (copy), CharacterResolver (copy), Remotes (copy)
    local os_clock_ret = os.clock();

    if os_clock_ret - p2.LastRequest < 0.5 then
        return;
    end;

    if Players.LocalPlayer:GetAttribute("BuyMenu") then
        return;
    end;

    local LocalCharacter = CharacterResolver.getLocalCharacter();

    if not CharacterResolver.isAliveCharacter(LocalCharacter) then
        return;
    end;

    local RootPart = CharacterResolver.getRootPart(LocalCharacter);

    if not RootPart or (RootPart.Position - p2.Position).Magnitude > 6 then
        return;
    end;

    p2.LastRequest = os_clock_ret;
    Remotes.Entity.InteractWithEntity.Send({
        Action = "Pickup",
        EntityId = p2.EntityId
    });
end;

function u1.new(p3: string, p4: string, p5: vector) -- Line: 76
    -- upvalues: Health (copy), RunServiceController (copy), u1 (copy), Debris (copy), AttemptEntityPickup (copy)
    local v6 = {
        LastRequest = 0,
        Elapsed = 0,
        EntityId = p3,
        Position = p5,
        Model = Health:Clone(),
        BindingName = RunServiceController.CreateBindingName("DeathmatchHealthKit")
    };
    local u7 = setmetatable(v6, u1);

    for _, descendant in u7.Model:GetDescendants() do
        if descendant:IsA("BasePart") then
            descendant.CanCollide = false;
            descendant.CanQuery = false;
            descendant.CanTouch = false;
            descendant.Anchored = true;
        end;
    end;

    u7.Model:PivotTo(CFrame.new(p5));
    u7.Model.Parent = Debris;
    RunServiceController.BindToHeartbeat(u7.BindingName, function(p8: number) -- Line: 99
        -- upvalues: u7 (copy), AttemptEntityPickup (ref)
        local v9 = u7;
        v9.Elapsed = v9.Elapsed + p8;
        local v10 = math.sin(u7.Elapsed * 0.5 * 2 * 3.141592653589793) * 0.15 + 0.2;
        u7.Model:PivotTo(CFrame.new(u7.Position + Vector3.new(0, v10, 0)) * CFrame.Angles(0, u7.Elapsed * 1.5707963267948966, 0));
        AttemptEntityPickup(u7);
    end);

    return u7;
end;

function u1.Destroy(p11: any, p12: number?) -- Line: 114
    -- upvalues: RunServiceController (copy), Players (copy), Router (copy)
    RunServiceController.Unbind("Heartbeat", p11.BindingName);
    p11.Model:Destroy();

    if p12 == Players.LocalPlayer.UserId then
        Router.broadcastRouter("DeathmatchHealthClaimed");
    end;
end;

return u1;