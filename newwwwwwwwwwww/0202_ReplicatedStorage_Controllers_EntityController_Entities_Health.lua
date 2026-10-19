-- Health (ModuleScript)
-- full path: ReplicatedStorage.Controllers.EntityController.Entities.Health

-- Decompiled with Potassium's decompiler.

local u1 = {};
u1.__index = u1;
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Players = game:GetService("Players");
local SurvivalVoiceController = require(ReplicatedStorage.Controllers.SurvivalVoiceController);
local Remotes = require(ReplicatedStorage.Database.Security.Remotes);
local Router = require(ReplicatedStorage.Database.Security.Router);
local Health = ReplicatedStorage:WaitForChild("Assets"):WaitForChild("ItemDrops"):WaitForChild("Health");

local function AttemptEntityPickup(p2: any, p3: vector?) -- Line: 38
    -- upvalues: Players (copy), Remotes (copy)
    if not p3 or (p3 - p2.Position).Magnitude > 6 then
        return;
    end;

    local os_clock_ret = os.clock();

    if os_clock_ret - p2.LastRequest < 0.5 then
        return;
    end;

    if Players.LocalPlayer:GetAttribute("BuyMenu") then
        return;
    end;

    p2.LastRequest = os_clock_ret;
    Remotes.Entity.InteractWithEntity.Send({
        Action = "Pickup",
        EntityId = p2.EntityId
    });
end;

function u1.new(p4: string, p5: string, p6: vector) -- Line: 63
    -- upvalues: Health (copy), u1 (copy)
    local v7 = {
        LastRequest = 0,
        EntityId = p4,
        Position = p6,
        Model = Health:Clone()
    };

    return setmetatable(v7, u1);
end;

function u1.Step(p8: any, p9: number, p10: vector?) -- Line: 76
    -- upvalues: AttemptEntityPickup (copy)
    AttemptEntityPickup(p8, p10);
end;

function u1.Destroy(p11: any, p12: number?) -- Line: 83
    -- upvalues: Players (copy), SurvivalVoiceController (copy), Router (copy)
    p11.Model:Destroy();

    if p12 == Players.LocalPlayer.UserId then
        SurvivalVoiceController.OnHealthKit();
        Router.broadcastRouter("DeathmatchHealthClaimed");
    end;
end;

return u1;