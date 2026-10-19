-- AmmoCrate (ModuleScript)
-- full path: ReplicatedStorage.Controllers.EntityController.Entities.AmmoCrate

-- Decompiled with Potassium's decompiler.

local u1 = {};
u1.__index = u1;
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Players = game:GetService("Players");
local SurvivalVoiceController = require(ReplicatedStorage.Controllers.SurvivalVoiceController);
local Remotes = require(ReplicatedStorage.Database.Security.Remotes);
local Router = require(ReplicatedStorage.Database.Security.Router);
local AmmoCrate = ReplicatedStorage:WaitForChild("Assets"):WaitForChild("ItemDrops"):WaitForChild("AmmoCrate");
local u2 = { 3, 12 };

local function AttemptEntityPickup(p3: any, p4: vector?) -- Line: 49
    -- upvalues: Remotes (copy)
    if not p4 or (p4 - p3.Position).Magnitude > 6 then
        return;
    end;

    local os_clock_ret = os.clock();

    if os_clock_ret - p3.LastRequest < 0.5 then
        return;
    end;

    p3.LastRequest = os_clock_ret;
    Remotes.Entity.InteractWithEntity.Send({
        Action = "Pickup",
        EntityId = p3.EntityId
    });
end;

local function UpdateBlink(p5: any, p6: number) -- Line: 67
    -- upvalues: u2 (copy)
    local Lifetime = p5.Lifetime;

    if not Lifetime then
        return;
    end;

    local v7 = Lifetime - 5;
    local v8;

    if v7 <= p6 then
        local math_clamp_ret = math.clamp((p6 - v7) / 5, 0, 1);
        v8 = (p6 - v7) * (u2[1] + (u2[2] - u2[1]) * math_clamp_ret) % 1 >= 0.5;
    else
        v8 = false;
    end;

    if v8 == p5.IsFaded then
        return;
    end;

    p5.IsFaded = v8;

    for i, v in p5.BlinkParts do
        local v9;

        if v8 then
            v9 = 1 - (1 - v) * 0.25;
        else
            v9 = v;
        end;

        i.Transparency = v9;
    end;
end;

function u1.new(p10: string, p11: string, p12: vector, p13: number?) -- Line: 93
    -- upvalues: AmmoCrate (copy), u1 (copy)
    local v14 = {
        LastRequest = 0,
        IsFaded = false,
        EntityId = p10,
        Position = p12,
        Model = AmmoCrate:Clone(),
        Lifetime = p13,
        BlinkParts = {}
    };

    return setmetatable(v14, u1);
end;

function u1.TrackPart(p15: any, p16: userdata) -- Line: 110
    if p16.Transparency < 1 then
        p15.BlinkParts[p16] = p16.Transparency;
    end;
end;

function u1.Step(p17: any, p18: number, p19: vector?) -- Line: 117
    -- upvalues: UpdateBlink (copy), AttemptEntityPickup (copy)
    UpdateBlink(p17, p18);
    AttemptEntityPickup(p17, p19);
end;

function u1.Destroy(p20: any, p21: number?) -- Line: 125
    -- upvalues: Players (copy), SurvivalVoiceController (copy), Router (copy)
    p20.Model:Destroy();

    if p21 == Players.LocalPlayer.UserId then
        SurvivalVoiceController.OnAmmoCrate();
        Router.broadcastRouter("RunInterfaceSound", "Successful Buy Menu Purchase");
    end;
end;

return u1;