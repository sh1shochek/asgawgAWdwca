-- ReplicatedStorage.Shared.Simulation
-- Script path: ReplicatedStorage.Shared.Simulation
-- Decompile time: 18.89 ms

-- Decompiled with Potassium's decompiler.

local v1 = {};
local RunService = game:GetService("RunService");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local u2 = RunService:IsServer();
local TemplateOverrides = require(ReplicatedStorage.Shared.TemplateOverrides);
local GameStats = ReplicatedStorage:WaitForChild("GameStats");
local u3 = 0;
local u4 = 0;
local u5 = {};
local u6 = nil;
local u7 = nil;
local u8 = nil;
local u9 = nil;
local u10 = nil;
local u11 = nil;
local u12 = nil;
local u13 = nil;
local u14 = nil;
local u15 = nil;
local u16 = nil;
local u17 = nil;

local function ParseCommandInputs(p18, p19) -- Line: 56
    -- upvalues: u2 (copy), u4 (ref), u9 (ref), u3 (ref)
    local Inputs = p19.Inputs;
    local AdditionalInputs = p19.AdditionalInputs;
    p18.DuckHeld = AdditionalInputs.Duck or (p18.Ducking or p18.Ducked);
    p18.WannaJumpButton = AdditionalInputs.Jump;
    p18.CurrentMoveX = (Inputs.Right and 1 or 0) + (Inputs.Left and -1 or 0);
    p18.CurrentMoveZ = (Inputs.Forward and -1 or 0) + (Inputs.Backward and 1 or 0);
    local v20 = p18.CommandCount + 1 + (p19.SkippedTicks or 0);
    local v21;

    if u2 then
        v21 = p18.PreparationEndCommand;
    else
        v21 = u4;
    end;

    local v22;

    if p18.PreparationStartCommand < v20 then
        if v20 < v21 then
            v22 = true;
        else
            v22 = u2 and u9.GetTick() < u3 - u9.TimeToTick(0.25);
        end;
    else
        v22 = false;
    end;

    p18.Preparation = v22;

    if v22 or (p18.Planting or (p18.Defusing or p18.Frozen)) then
        p18.CurrentMoveX = 0;
        p18.CurrentMoveZ = 0;
        p18.WannaJumpButton = false;

        if p18.Planting then
            p18.DuckHeld = false;
        end;

        if p18.Noclip then
            p18.Velocity = Vector3.new(0, 0, 0);
        else
            p18.Velocity = Vector3.new(0, 1, 0) * p18.Velocity.Y;
        end;

        if p18.OnGround and p18.Velocity.Y == 0 then
            p18.SkipMovementPhysics = true;
        end;
    end;

    p18.Yaw = -3.141592653589793 + p19.Yaw * 6.283185307179586 / 65535;
    p18.Pitch = -1.55334 + p19.Pitch * 3.10668 / 65535;
    p18.Walk = AdditionalInputs.Walk;
    p18.WannaDuck = AdditionalInputs.Duck;
    p18.PressE = AdditionalInputs.PressE;
end;

local function UpdateGroundState(p23: any, p24: boolean?) -- Line: 130
    -- upvalues: u11 (ref), u13 (ref), u6 (ref)
    p23.AirFrictionReduced = false;

    if p23.Noclip then
        p23.OnGround = false;
        p23.StandingPart = nil;

        return;
    end;

    local Y = p23.Velocity.Y;

    if Y > 9.716000000000001 or p23.Climbing and Y > 0 then
        p23.OnGround = false;
        p23.StandingPart = nil;

        return;
    end;

    if p23.ResolvedStandingPart and not p24 then
        p23.OnGround = true;
        p23.StandingPart = p23.ResolvedStandingPart;

        return;
    end;

    local v25 = true;

    if u11.CFG.GroundFrameSkip and not p24 then
        if p23.OnGround then
            v25 = p23.CurrentFrame % u11.CFG.GroundFrameSkipAmount == 0;
        elseif p23.Velocity.Y >= p23.Constants.JumpImpulse or p23.Velocity.Y < 0 and p23.Velocity.Y > -p23.Constants.Gravity * 0.5 then
            v25 = p23.CurrentFrame % u11.CFG.NoGroundFrameSkipAmount == 0;
        end;
    end;

    if v25 then
        local v26 = p23.OnGround and not p23.Climbing;
        local v27, v28, v29, v30, v31, v32 = u13.DoGroundCheck(p23.Position, p23.Constants.MaxGroundSlope, p23.Ducked, v26 and (p23.Constants.StepSize.Y or 0) or 0);
        p23.OnGround = v27;
        p23.StandingPart = v27 and v28 and v28 or nil;
        p23.AirFrictionReduced = not v27 and Y > 0;

        if v27 and (v26 and not (v32 or (v31 <= 0 or v31 >= 1))) then
            p23.Position = v30;
        end;

        if v29 then
            p23.LastStuckPosition = p23.Position;
            p23.LastStuckDucked = p23.Ducked;
            p23.LastStuckGeneration = u6.Generation;
        end;
    end;
end;

local function ProcessGroundState(p33) -- Line: 197
    p33.WasGround = p33.OnGround;

    if p33.Velocity.Y > 17.35 then
        p33.OnGround = false;
        p33.StandingPart = nil;
    end;
end;

local function ProcessJumpAndBhop(p34) -- Line: 209
    -- upvalues: u11 (ref)
    local v35 = (p34.OnGround or p34.Climbing) and p34.WannaJumpButton;

    if not u11.CFG.AutoBunnyHop and p34.WannaJump then
        v35 = false;
    end;

    p34.DoJump = v35;
    p34.WannaJump = p34.WannaJumpButton;

    if v35 then
        p34.HasWalkMovedSinceLastJump = false;
    end;
end;

local function CheckParameters(p36) -- Line: 232
    -- upvalues: u14 (ref)
    local Constants = p36.Constants;
    local math_min_ret = math.min(Constants.Speed, Constants.MaxSpeed);
    local v37 = p36.WannaDuck and u14.DuckingEnabled(p36) or p36.Planting or (p36.Ducking or u14.HasDuckFlag(p36));
    local v38 = 1;

    if p36.Walk and not v37 then
        if vector.magnitude(p36.Velocity) < math_min_ret * Constants.WalkModifier + 1.735 then
            v38 = Constants.WalkModifier;
            p36.IsWalking = true;
        end;
    else
        p36.IsWalking = false;
    end;

    local math_clamp_ret = math.clamp(1 - p36.Stamina * 0.01, 0, 1);
    local v39 = p36.OnGround and (p36.VelocityModifier or 1) or 1;
    p36.MaxSpeedBase = math_min_ret * v39;
    p36.CroppedMaxSpeed = math_min_ret * v38 * v39 * (math_clamp_ret * math_clamp_ret);
end;

local function ProcessLocomotion(p40, p41) -- Line: 267
    -- upvalues: u14 (ref), u6 (ref), u11 (ref)
    if p40.Noclip then
        u14.FullNoClipMove(p40, p41);

        return;
    end;

    if p40.DuckHeld then
        p40.CroppedMaxSpeed = p40.CroppedMaxSpeed * u14.GetDuckSpeedModifier(p40);
    end;

    local v42 = nil;

    if not p40.Climbing then
        u14.StartGravity(p40, p41);

        if p40.DoJump then
            u14.CheckJumpButton(p40, p41);
        end;

        if p40.OnGround then
            p40.Velocity = Vector3.new(1, 0, 1) * p40.Velocity;
            p40.FallingVelocity = 0;
        end;

        local MaxSpeedBase = p40.MaxSpeedBase;
        local v43 = nil;

        if p40.CurrentMoveX ~= 0 or p40.CurrentMoveZ ~= 0 then
            local math_sin_ret = math.sin(p40.Yaw);
            local math_cos_ret = math.cos(p40.Yaw);
            v42 = vector.create(p40.CurrentMoveX * math_cos_ret + p40.CurrentMoveZ * math_sin_ret, 0, -p40.CurrentMoveX * math_sin_ret + p40.CurrentMoveZ * math_cos_ret);
            local vector_magnitude_ret = vector.magnitude(v42);

            if vector_magnitude_ret ~= 0 then
                v43 = math.min(MaxSpeedBase * vector_magnitude_ret, p40.CroppedMaxSpeed);
                v42 = v42 / vector_magnitude_ret;
            end;
        end;

        p40.LastWishSpeed = v43 or 0;

        if p40.OnGround then
            u14.WalkMove(p40, v42, v43, p41);
        else
            u14.AirMove(p40, v42, v43, p41);
        end;
    end;

    local v44 = nil;

    if p40.Climbing then
        v44 = -p40.LadderNormal;
    elseif p40.CurrentMoveX ~= 0 or p40.CurrentMoveZ ~= 0 then
        local CFrame_fromEulerAnglesYXZ_ret = CFrame.fromEulerAnglesYXZ(-p40.Pitch, p40.Yaw, 0);
        local v45 = CFrame_fromEulerAnglesYXZ_ret.LookVector * -p40.CurrentMoveZ + CFrame_fromEulerAnglesYXZ_ret.RightVector * p40.CurrentMoveX;

        if vector.dot(v45, v45) > 0 then
            v44 = vector.normalize(v45);
        end;
    end;

    if v44 and u6.HasLadders() then
        local v46 = true;

        if u11.CFG.LadderSkipIfGroundedAndStationary and (p40.OnGround and not (p40.Climbing or (p40.CurrentMoveX ~= 0 or p40.CurrentMoveZ ~= 0))) then
            v46 = false;
        elseif u11.CFG.SkipLadderFrameCheck then
            v46 = p40.Climbing and p40.WannaJumpButton or p40.CurrentFrame % u11.CFG.SkipLadderFrameCheckAmount == 0;
        end;

        if v46 then
            u14.LadderMove(p40, v44, p40.CurrentMoveX, p40.CurrentMoveZ, p40.DuckPressed, p40.Walk);
        end;
    end;
end;

local function UpdateStamina(p47, p48) -- Line: 362
    if p47.Stamina > 0 then
        p47.Stamina = math.max(0, p47.Stamina - p47.Constants.StaminaRecoveryRate * p48);
    end;
end;

local function ApplyPhysicsSteps(p49, p50) -- Line: 372
    -- upvalues: u11 (ref), u13 (ref), u6 (ref), u12 (ref)
    p49.ResolvedStandingPart = nil;

    if u11.CFG.SleepStateSkip then
        local v51;

        if p49.CurrentMoveX == 0 and p49.CurrentMoveZ == 0 then
            v51 = not p49.DoJump and (p49.OnGround or p49.Climbing);

            if v51 then
                if vector.dot(p49.Velocity, p49.Velocity) == 0 then
                    v51 = not (p49.Planting or p49.Defusing);
                else
                    v51 = false;
                end;
            end;
        else
            v51 = false;
        end;

        p49.SkipMovementPhysics = v51;
    end;

    if p49.Noclip then
        p49.Position = p49.Position + p49.Velocity * p50;

        return;
    end;

    if not p49.SkipMovementPhysics then
        local Y = p49.Velocity.Y;
        local v52, v53, v54, v55 = u13.ProjectVelocity(p49.Position, p49.Velocity, p50, p49.Ducked, nil, not p49.OnGround);

        if v55 then
            p49.LastStuckPosition = v52;
            p49.LastStuckDucked = p49.Ducked;
            p49.LastStuckGeneration = u6.Generation;
        end;

        if p49.OnGround and not p49.Climbing then
            local v56, v57, v58;

            if v54 and not p49.DoJump then
                v56, v57, v58 = u13.DoStepUp(p49.Position, p49.Velocity, p49.Constants.StepSize, p49.Constants.MaxGroundSlope, p50, p49.Ducked);
            else
                v56 = nil;
                v58 = nil;
                v57 = nil;
            end;

            if v56 then
                local v59 = (v52 - p49.Position) * Vector3.new(1, 0, 1);
                local v60 = (v56 - p49.Position) * Vector3.new(1, 0, 1);

                if vector.dot(v59, v59) > vector.dot(v60, v60) then
                    v56 = nil;
                end;
            end;

            local _ = p49.Position;
            local _ = p49.Velocity;

            if v56 then
                u12.AddStepUp(p49, v58);
                p49.Position = v56;
                p49.Velocity = v57;
            else
                p49.Position = v52;
                p49.Velocity = v53;
            end;

            if Y <= 0 then
                local v61 = true;

                if v61 and u11.CFG.StepDownFrameSkip then
                    v61 = p49.CurrentFrame % u11.CFG.StepDownFrameAmount == 0 and true or p49.StepDownFrameSkip;
                end;

                if v61 and (v56 and u11.CFG.StepDownSkipIfStepUpResult) then
                    v61 = false;
                end;

                if v61 then
                    local v62, v63, v64 = u13.DoStepDown(p49.Position, p49.Constants.StepSize, p49.Constants.MaxGroundSlope, p49.Ducked);
                    p49.ResolvedStandingPart = v64;

                    if not v62 then
                        p49.StepDownFrameSkip = false;

                        return;
                    end;

                    p49.Position = v62;
                    u12.AddStepUp(p49, v63);
                    p49.StepDownFrameSkip = true;
                end;
            end;
        else
            p49.Position = v52;
            p49.Velocity = v53;
        end;
    end;
end;

local function RunModifications(p65) -- Line: 453
    local Modifications = p65.Modifications;

    if next(Modifications) then
        for _, v in Modifications do
            v.Function(p65, table.unpack(v.Arguments));
        end;
    end;
end;

local function UpdateTagging(p66, p67) -- Line: 462
    -- upvalues: u7 (ref)
    local Constants = p66.Constants;

    if p66.FlinchStack == Constants.FlinchStackMax and (not p66.OnGround or p66.VelocityModifier >= Constants.VelocityModifierMax) then
        return;
    end;

    if p66.FlinchStack < p66.Constants.FlinchStackMax then
        p66.FlinchStack = u7.Approach(p66.Constants.FlinchStackMax, p66.FlinchStack, p67 * p66.Constants.FlinchStackRecoveryRate);
    end;

    p66.FlinchStack = math.clamp(p66.FlinchStack, p66.Constants.FlinchStackMin, p66.Constants.FlinchStackMax);

    if p66.OnGround and p66.VelocityModifier < p66.Constants.VelocityModifierMax then
        p66.VelocityModifier = math.clamp(p66.VelocityModifier + p67 * p66.Constants.VelocityModifierRecoveryRate, p66.Constants.VelocityModifierMin, p66.Constants.VelocityModifierMax);
    end;
end;

local function ProcessCommand(p68, p69, p70, p71) -- Line: 487
    -- upvalues: u12 (ref), ParseCommandInputs (copy), CheckParameters (copy), u13 (ref), u15 (ref), u14 (ref), u11 (ref), ProcessLocomotion (copy), ApplyPhysicsSteps (copy), UpdateGroundState (copy), UpdateTagging (copy), RunModifications (copy)
    p68.CurrentFrame = p69.ClientTick % 256;
    p68.Resimulating = p71 or false;

    if p68.PendingVelocityModifierTicks > 0 then
        p68.PendingVelocityModifierTicks = p68.PendingVelocityModifierTicks - 1;

        if p68.PendingVelocityModifierTicks <= 0 then
            p68.VelocityModifier = math.min(p68.VelocityModifier, p68.PendingVelocityModifier);
            p68.PendingVelocityModifierTicks = 0;
        end;
    end;

    for i = 1, p69.SkippedTicks or 0 do
        u12.UpdatePunchAngles(p68, p70);
        local _ = i;
    end;

    u12.UpdatePunchAngles(p68, p70);
    ParseCommandInputs(p68, p69);
    CheckParameters(p68);

    if p68.Stamina > 0 then
        p68.Stamina = math.max(0, p68.Stamina - p68.Constants.StaminaRecoveryRate * p70);
    end;

    u13.UpdatePlayerHulls(p68, p69.RenderTime);

    if not p68.Noclip then
        u13.CheckStuck(p68);
    end;

    p68.WasGround = p68.OnGround;

    if p68.Velocity.Y > 17.35 then
        p68.OnGround = false;
        p68.StandingPart = nil;
    end;

    if p68.Noclip then
        p68.OnGround = false;
        p68.StandingPart = nil;
    end;

    u15.PressE(p68, p68.PressE, p69.RenderTime, p70);
    u14.Duck(p68, p68.WannaDuck, p70);
    local v72 = (p68.OnGround or p68.Climbing) and p68.WannaJumpButton;

    if not u11.CFG.AutoBunnyHop and p68.WannaJump then
        v72 = false;
    end;

    p68.DoJump = v72;
    p68.WannaJump = p68.WannaJumpButton;

    if v72 then
        p68.HasWalkMovedSinceLastJump = false;
    end;

    ProcessLocomotion(p68, p70);
    u14.ClampVelocity(p68);
    ApplyPhysicsSteps(p68, p70);
    UpdateGroundState(p68);

    if not (p68.Climbing or p68.Noclip) then
        u14.FinishGravity(p68, p70);
    end;

    if p68.OnGround then
        p68.Velocity = Vector3.new(1, 0, 1) * p68.Velocity;
    end;

    if p68.Climbing or p68.Noclip then
        p68.FallingVelocity = 0;
    elseif not p68.OnGround then
        p68.FallingVelocity = -p68.Velocity.Y;
    end;

    u14.CheckFalling(p68);
    UpdateTagging(p68, p70);
    u12.DecayStepUp(p68, p70);
    RunModifications(p68);
    u14.ClampVelocity(p68);
end;

local function GetStandingPart(p73) -- Line: 597
    return p73.StandingPart;
end;

local function AddModification(p74, p75, p76, ...) -- Line: 601
    local Step = p76.Step;

    if not Step then
        return warn("Not found step function");
    end;

    p74.Modifications[p75] = {
        Function = Step,
        Arguments = { ... }
    };
end;

local function RemoveModification(p77, p78) -- Line: 612
    p77.Modifications[p78] = nil;
end;

local function SetTeam(p79: any, p80: string) -- Line: 616
    p79.Team = p80;
end;

local function SetIdentifier(p81: any, p82: number) -- Line: 620
    p81.Identifier = p82;
end;

local function SetArmorValue(p83: any, p84: userdata, p85: number) -- Line: 624
    if p85 <= 0 then
        p83.ArmorValue = 0;
        p83.HasHelmet = false;
    else
        p83.ArmorValue = p85;
    end;

    if p84 then
        p84:SetAttribute("ArmorValue", p83.ArmorValue);
        p84:SetAttribute("HasHelmet", p83.HasHelmet);
    end;
end;

local function SetHasHelmet(p86: any, p87: userdata, p88: boolean) -- Line: 638
    p86.HasHelmet = p88;

    if p87 then
        p87:SetAttribute("HasHelmet", p86.HasHelmet);
    end;
end;

local function SetVelocityModifier(p89: any, p90: number, p91: number?) -- Line: 659
    -- upvalues: u11 (ref), u9 (ref)
    local math_min_ret = math.min(1, p90);
    local v92 = u11.CFG.PredictableDamageTagTicks or 0;

    if v92 > 0 and p91 then
        local v93 = u9.TimeToTick(p91);
        local v94 = v92 + math.ceil(v93);
        v92 = math.min(255, v94);
    end;

    if v92 <= 0 or p89.VelocityModifier <= math_min_ret then
        p89.VelocityModifier = math.min(p89.VelocityModifier, math_min_ret);
        p89.PendingVelocityModifierTicks = 0;

        return;
    end;

    if p89.PendingVelocityModifierTicks > 0 then
        p89.PendingVelocityModifier = math.min(p89.PendingVelocityModifier, math_min_ret);

        return;
    end;

    p89.PendingVelocityModifier = math_min_ret;
    p89.PendingVelocityModifierTicks = v92;
end;

local function SetFlinchStack(p95: any, p96: number) -- Line: 685
    p95.FlinchStack = p96;
end;

local function SetDefuseKit(p97, p98, p99) -- Line: 689
    p97.HasDefuseKit = p99;

    if p98 then
        p98:SetAttribute("DefuseKit", p97.HasDefuseKit);
    end;
end;

local function Destroy(p100) -- Line: 697
    table.clear(p100);
end;

function v1.new(p101: vector) -- Line: 702
    -- upvalues: u11 (ref), TemplateOverrides (copy), u10 (ref), ProcessCommand (copy), UpdateGroundState (copy), GetStandingPart (copy), u14 (ref), u12 (ref), AddModification (copy), RemoveModification (copy), SetTeam (copy), SetIdentifier (copy), SetArmorValue (copy), SetHasHelmet (copy), SetDefuseKit (copy), SetVelocityModifier (copy), SetFlinchStack (copy), u16 (ref), Destroy (copy), u2 (copy)
    local v102 = {
        PerfectBhopChain = 0,
        CommandCount = 0,
        PreparationEndCommand = 0,
        PreparationStartCommand = -1,
        Preparation = false,
        HasDefuseKit = false,
        HasHelmet = false,
        ArmorValue = 0,
        FlinchStack = 1,
        VelocityModifier = 1,
        PendingVelocityModifier = 1,
        PendingVelocityModifierTicks = 0,
        Constants = table.clone(u11.ConstantsTemplate)
    };
    TemplateOverrides.ApplySimulation(v102.Constants);
    v102.LastDuck = false;
    v102.Ducked = false;
    v102.Ducking = false;
    v102.DuckFlag = false;
    v102.DuckSpeed = 8;
    v102.DuckAmount = 0;
    v102.DuckCooldown = 0;
    v102.DuckPressed = false;
    v102.LastFullCrouchPosition = (p101 or Vector3.new(0, 0, 0)) * Vector3.new(1, 0, 1);
    v102.CroppedMaxSpeed = 0;
    v102.MaxSpeedBase = 0;
    v102.IsWalking = false;
    v102.Walk = false;
    v102.CameraOffset = 2;
    v102.Height = 0;
    v102.ViewPunchAngle = Vector3.new(0, 0, 0);
    v102.AimPunchAngle = Vector3.new(0, 0, 0);
    v102.AimPunchAngleVel = Vector3.new(0, 0, 0);
    v102.SeenAimPunch = nil;
    v102.Position = p101 or Vector3.new(0, 0, 0);
    v102.Velocity = Vector3.new(0, 0, 0);
    v102.FallingVelocity = 0;
    v102.Yaw = 0;
    v102.Pitch = 0;
    v102.OnGround = false;
    v102.WasGround = false;
    v102.AirFrictionReduced = false;
    v102.StandingPart = nil;
    v102.ResolvedStandingPart = nil;
    v102.CurrentWeapon = nil;
    v102.Planting = false;
    v102.Defusing = false;
    v102.DefuseFinished = false;
    v102.DefuseTimer = 0;
    v102.DefuseAdvertised = false;
    v102.PressEDown = false;
    v102.DefuseUpdate = u10.new();
    v102.Frozen = false;
    v102.Noclip = false;
    v102.DoJump = false;
    v102.WannaJump = false;
    v102.Climbing = false;
    v102.LadderNormal = Vector3.new(0, 0, 0);
    v102.IgnoreLadderJumpTime = 0;
    v102.HasWalkMovedSinceLastJump = false;
    v102.Stamina = 0;
    v102.Resimulating = false;
    v102.StepUp = 0;
    v102.CurrentFrame = 0;
    v102.StepDownFrameSkip = false;
    v102.SkipMovementPhysics = false;
    v102.LastStuckPosition = Vector3.new(0, 0, 0);
    v102.LastStuckDucked = false;
    v102.LastStuckGeneration = -1;
    v102.Modifications = {};
    v102.ProcessCommand = ProcessCommand;
    v102.CategorizePosition = UpdateGroundState;
    v102.GetStandingPart = GetStandingPart;
    v102.HasDuckFlag = u14.HasDuckFlag;
    v102.KickBack = u12.KickBack;
    v102.BuildCameraCFrame = u12.BuildCameraCFrame;
    v102.BuildShotCFrame = u12.BuildShotCFrame;
    v102.AddModification = AddModification;
    v102.RemoveModification = RemoveModification;
    v102.SetTeam = SetTeam;
    v102.SetIdentifier = SetIdentifier;
    v102.SetArmorValue = SetArmorValue;
    v102.SetHasHelmet = SetHasHelmet;
    v102.SetDefuseKit = SetDefuseKit;
    v102.SetVelocityModifier = SetVelocityModifier;
    v102.SetFlinchStack = SetFlinchStack;
    v102.WriteState = u16.WriteState;
    v102.ReadState = u16.ReadState;
    v102.Destroy = Destroy;
    v102.Health = u10.new();

    if u2 then
        v102.OnPickup = u10.new();
    end;

    return v102;
end;

function v1.Init(p103) -- Line: 860
    -- upvalues: u6 (ref), u7 (ref), u8 (ref), u9 (ref), u10 (ref), u17 (ref), u11 (ref), u12 (ref), u13 (ref), u14 (ref), u15 (ref), u16 (ref), u5 (copy), GameStats (copy), u3 (ref), u2 (copy), u4 (ref)
    u6 = p103:GetModule("CollisionModule");
    u7 = p103:GetModule("Math");
    u8 = p103:GetModule("GameConfiguration");
    u9 = p103:GetModule("Tick");
    u10 = p103:GetModule("Signal");
    u17 = p103:GetModule("Entities");
    u11 = require(script.Config);
    u12 = require(script.Camera);
    u13 = require(script.Collision);
    u14 = require(script.Movement);
    u15 = require(script.Interaction);
    u16 = require(script.State);

    for _, child in ipairs(script.Modifications:GetChildren()) do
        u5[child.Name] = require(child);
    end;

    GameStats:GetAttributeChangedSignal("PreparationEndTick"):Connect(function() -- Line: 879
        -- upvalues: u3 (ref), GameStats (ref)
        u3 = GameStats:GetAttribute("PreparationEndTick") or 0;
    end);
    u3 = GameStats:GetAttribute("PreparationEndTick") or 0;

    if not u2 then
        local LocalPlayer = game:GetService("Players").LocalPlayer;
        LocalPlayer:GetAttributeChangedSignal("PreparationEndCommand"):Connect(function() -- Line: 888
            -- upvalues: u4 (ref), LocalPlayer (copy)
            u4 = LocalPlayer:GetAttribute("PreparationEndCommand") or 0;
        end);
        u4 = LocalPlayer:GetAttribute("PreparationEndCommand") or 0;
    end;
end;

v1.ProcessCommand = ProcessCommand;
v1.CategorizePosition = UpdateGroundState;

function v1.Start(p104) -- Line: 900
    -- upvalues: u16 (ref)
    u16.Scheme = p104:GetModule("BufferScheme").GetScheme("CharacterState");
end;

return v1;