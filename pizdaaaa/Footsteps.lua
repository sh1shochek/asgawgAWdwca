-- ReplicatedStorage.GameClient.Footsteps
-- Script path: ReplicatedStorage.GameClient.Footsteps
-- Decompile time: 4.51 ms

-- Decompiled with Potassium's decompiler.

local v1 = {};
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local SoundManager = require(ReplicatedStorage.Shared.Managers.SoundManager);
local StepTiming = require(ReplicatedStorage.Shared.StepTiming);
local Characters = workspace:WaitForChild("Characters");
local u2 = nil;
local RaycastParams_new_ret = RaycastParams.new();
RaycastParams_new_ret.FilterType = Enum.RaycastFilterType.Exclude;
RaycastParams_new_ret.FilterDescendantsInstances = { Characters };
RaycastParams_new_ret.RespectCanCollide = false;

local function GroundSurface(p3: vector) -- Line: 69
    -- upvalues: RaycastParams_new_ret (copy)
    local v4 = workspace:Blockcast(CFrame.new(p3), Vector3.new(1, 0.1, 1), Vector3.new(0, -4, 0), RaycastParams_new_ret);

    if v4 then
        return v4.Material, v4.Position;
    end;

    return Enum.Material.Plastic, p3;
end;

local function Play(p5: vector, p6: boolean, p7: boolean, p8: boolean, p9: any) -- Line: 83
    -- upvalues: SoundManager (copy), RaycastParams_new_ret (copy)
    if p8 then
        return SoundManager.PlayLadderStep(p6, p9);
    end;

    local v10 = workspace:Blockcast(CFrame.new(p5), Vector3.new(1, 0.1, 1), Vector3.new(0, -4, 0), RaycastParams_new_ret);
    local v11;

    if v10 then
        v11 = v10.Material;
        p5 = v10.Position;
    else
        v11 = Enum.Material.Plastic;
    end;

    if p9.Position then
        p9.Position = p5;
    end;

    if not p7 then
        return SoundManager.PlayFootstep(v11, p6, p9);
    end;

    SoundManager.Play("Misc.Land", p9);

    return SoundManager.PlayLanding(v11, p9);
end;

local function PlayLocal(p12: vector, p13: boolean, p14: boolean, p15: number, p16: boolean?) -- Line: 109
    -- upvalues: Play (copy)
    Play(p12, p13, p14, p16 or false, {
        LocalReplicated = true,
        Volume = p15,
        Parent = workspace.CurrentCamera
    });
end;

function v1.PlayLocalFallDamage() -- Line: 121
    -- upvalues: SoundManager (copy)
    SoundManager.Play("Player.FallDamage", {
        LocalReplicated = true,
        Parent = workspace.CurrentCamera
    });
end;

function v1.UpdateLocal(p17: any, p18: any, p19: number) -- Line: 129
    -- upvalues: StepTiming (copy), PlayLocal (copy)
    if p18.Noclip then
        p17.FallSpeed = 0;

        return;
    end;

    StepTiming.Update(p17, p18.Position, p18.Velocity, p18.OnGround, p18.Ducked, p18.Climbing, p18.Walk, p19, PlayLocal);
end;

function v1.Init(p20) -- Line: 148
    -- upvalues: u2 (ref)
    u2 = p20:GetModule("Network");
end;

function v1.Start(p21) -- Line: 152
    -- upvalues: u2 (ref), Play (copy), StepTiming (copy)
    u2.PlayFootstepSoundOnPosition.On(function(p22: number, p23: vector, p24: number, p25: number) -- Line: 153
        -- upvalues: Play (ref), StepTiming (ref)
        local workspace_CurrentCamera = workspace.CurrentCamera;

        if not workspace_CurrentCamera then
            return;
        end;

        local v26 = workspace_CurrentCamera.CFrame.Position - p23;

        if vector.dot(v26, v26) > 7525.5625 then
            return;
        end;

        Play(p23, bit32.btest(p24, StepTiming.FLAG_RIGHT_FOOT), bit32.btest(p24, StepTiming.FLAG_LANDING), bit32.btest(p24, StepTiming.FLAG_LADDER), {
            Position = p23,
            FootstepPosition = p23,
            Volume = p25 / 255
        });
    end);
end;

return v1;