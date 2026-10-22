-- ReplicatedStorage.GameClient.Entities.Bomb
-- Script path: ReplicatedStorage.GameClient.Entities.Bomb
-- Decompile time: 8.63 ms

-- Decompiled with Potassium's decompiler.

local v1 = {};
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local TweenService = game:GetService("TweenService");
local Debris = game:GetService("Debris");
local SnapshotInterp = require(ReplicatedStorage.Shared.Utility.SnapshotInterp);
local SoundManager = require(ReplicatedStorage.Shared.Managers.SoundManager);
local Bomb = workspace:WaitForChild("Debris"):WaitForChild("Bomb");
local u2 = nil;
local u3 = nil;
local u4 = nil;
local u5 = nil;
local u6 = nil;
local u7 = nil;
local u8 = nil;
local u9 = nil;
local u10 = nil;
local u11 = nil;
local u12 = 40;

local function Emit(p13, p14, p15) -- Line: 37
    local v16 = p13:FindFirstChild(p14);

    if v16 and v16:IsA("ParticleEmitter") then
        v16:Emit(p15);
    end;
end;

local function PlayExplosion(p17) -- Line: 45
    -- upvalues: u3 (ref), u7 (ref), Bomb (copy), Debris (copy), u11 (ref), SoundManager (copy), TweenService (copy)
    local u18 = u3:Clone();
    local BlastLight = u18:FindFirstChild("BlastLight");
    local BlastSound = u18:FindFirstChild("BlastSound");
    local Magnitude = (u7.GetCFrame().Position - p17).Magnitude;
    u18.CFrame = CFrame.new(p17);
    u18.Parent = Bomb;
    Debris:AddItem(u18, 15);

    if Magnitude < 208.20000000000002 then
        u7.StartShake(16 * (1 - Magnitude / 208.20000000000002), 150, 1);
    end;

    u11.Play("Explosion", (math.clamp(1 - Magnitude / 624.6, 0.15, 1)));

    if BlastSound and BlastSound:IsA("Sound") then
        BlastSound.SoundGroup = SoundManager.GetGroup("SFX");
        BlastSound.TimePosition = 0;
        BlastSound:Play();
    end;

    if BlastLight and BlastLight:IsA("PointLight") then
        BlastLight.Brightness = 22;
        BlastLight.Range = 50;
        TweenService:Create(BlastLight, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Brightness = 0,
            Range = 11
        }):Play();
    end;

    local Sparks_Streamers = u18:FindFirstChild("Sparks_Streamers");

    if Sparks_Streamers and Sparks_Streamers:IsA("ParticleEmitter") then
        Sparks_Streamers:Emit(6);
    end;

    local Glow = u18:FindFirstChild("Glow");

    if Glow and Glow:IsA("ParticleEmitter") then
        Glow:Emit(5);
    end;

    local Shockwave = u18:FindFirstChild("Shockwave");

    if Shockwave and Shockwave:IsA("ParticleEmitter") then
        Shockwave:Emit(3);
    end;

    local Explosion = u18:FindFirstChild("Explosion");

    if Explosion and Explosion:IsA("ParticleEmitter") then
        Explosion:Emit(8);
    end;

    task.delay(0.04, function() -- Line: 83
        -- upvalues: u18 (copy)
        local Fire_BurstJets = u18:FindFirstChild("Fire_BurstJets");

        if Fire_BurstJets and Fire_BurstJets:IsA("ParticleEmitter") then
            Fire_BurstJets:Emit(32);
        end;

        local OneDirt = u18:FindFirstChild("OneDirt");

        if OneDirt and OneDirt:IsA("ParticleEmitter") then
            OneDirt:Emit(25);
        end;
    end);
    task.delay(0.12, function() -- Line: 88
        -- upvalues: u18 (copy)
        local Fire_RollingPlume = u18:FindFirstChild("Fire_RollingPlume");

        if Fire_RollingPlume and Fire_RollingPlume:IsA("ParticleEmitter") then
            Fire_RollingPlume:Emit(24);
        end;

        local Smoke_TurbulentDark = u18:FindFirstChild("Smoke_TurbulentDark");

        if Smoke_TurbulentDark and Smoke_TurbulentDark:IsA("ParticleEmitter") then
            Smoke_TurbulentDark:Emit(26);
        end;
    end);
    task.delay(0.22, function() -- Line: 93
        -- upvalues: u18 (copy)
        local Smoke_HeavyAsh = u18:FindFirstChild("Smoke_HeavyAsh");

        if Smoke_HeavyAsh and Smoke_HeavyAsh:IsA("ParticleEmitter") then
            Smoke_HeavyAsh:Emit(22);
        end;

        local Smoke_AmbientLingering = u18:FindFirstChild("Smoke_AmbientLingering");

        if Smoke_AmbientLingering and Smoke_AmbientLingering:IsA("ParticleEmitter") then
            Smoke_AmbientLingering:Emit(18);
        end;
    end);
    task.delay(0.35, function() -- Line: 98
        -- upvalues: u18 (copy)
        local Smoke_RadialCloud = u18:FindFirstChild("Smoke_RadialCloud");

        if Smoke_RadialCloud and Smoke_RadialCloud:IsA("ParticleEmitter") then
            Smoke_RadialCloud:Emit(14);
        end;

        local Smoke_HeavyAsh = u18:FindFirstChild("Smoke_HeavyAsh");

        if Smoke_HeavyAsh and Smoke_HeavyAsh:IsA("ParticleEmitter") then
            Smoke_HeavyAsh:Emit(12);
        end;
    end);
end;

local function ApplyDefuser(p19) -- Line: 115
    -- upvalues: SoundManager (copy), u8 (ref), u6 (ref)
    local v20 = p19.Defused and 0 or (p19.Defusing or 0);

    if p19.CurrentDefuser == v20 then
        return;
    end;

    if v20 == 0 then
        if p19.Defused then
            SoundManager.Play("Bomb.c4_disarmfinish", {
                Position = p19.Model:GetPivot().Position
            });
        end;
    else
        SoundManager.Play("Bomb.c4_disarmstart", {
            Position = p19.Model:GetPivot().Position
        });
        p19.DefuseLength = p19.DefuseTimer;
    end;

    local v21 = p19.CurrentDefuser and u8.GetEntity("Character", p19.CurrentDefuser);

    if v21 and v21.Model then
        u6.SetDefusing(v21, false);
    end;

    p19.CurrentDefuser = v20;
    local v22;

    if v20 == 0 then
        v22 = false;
    else
        v22 = u8.GetEntity("Character", v20);
    end;

    if v22 and v22.Model then
        u6.SetDefusing(v22, true, p19.Model);
    end;
end;

local function StepBeep(p23) -- Line: 168
    -- upvalues: SoundManager (copy), u12 (ref), TweenService (copy)
    local BlowTimer = p23.BlowTimer;

    if p23.Exploded or (p23.Defused or not BlowTimer) then
        return;
    end;

    if BlowTimer < 1 and not p23.TriggerTripped then
        p23.TriggerTripped = true;
        SoundManager.Play("Bomb.c4-trigger-trip");
    end;

    if BlowTimer <= 0 and not p23.ExplodeWarned then
        p23.ExplodeWarned = true;
        SoundManager.Play("Bomb.c4-explode-warning");
    end;

    if BlowTimer <= 1 then
        return;
    end;

    local os_clock_ret = os.clock();

    if os_clock_ret < (p23.NextBeep or 0) then
        return;
    end;

    local math_clamp_ret = math.clamp(BlowTimer / u12, 0, 1);
    p23.NextBeep = os_clock_ret + math.max(math_clamp_ret * 0.9 + 0.1, 0.15);
    SoundManager.Play("Bomb.c4_beep", {
        Position = p23.Model:GetPivot().Position,
        Volume = 1.3 - math.min(math_clamp_ret * 0.6 + 0.3, 1)
    });
    p23.Attachment.Red.Brightness = 15;
    p23.Attachment.Red.Enabled = true;
    p23.Attachment.Light.Brightness = 25;
    p23.Attachment.Light.Enabled = true;
    TweenService:Create(p23.Attachment.Red, TweenInfo.new(0.5, Enum.EasingStyle.Exponential), {
        Brightness = 0
    }):Play();
    TweenService:Create(p23.Attachment.Light, TweenInfo.new(0.5, Enum.EasingStyle.Exponential), {
        Brightness = 0
    }):Play();
    p23.Attachment.Particle:Emit(1);
end;

local function StepDefuseDisplay(p24) -- Line: 231
    -- upvalues: u6 (ref)
    local DefuseLength = p24.DefuseLength;
    local v25 = 0;

    if p24.Defused then
        v25 = u6.BombCodeLength;
    elseif p24.CurrentDefuser ~= 0 and (DefuseLength and DefuseLength > 0) then
        v25 = math.ceil((1 - p24.DefuseTimer / DefuseLength) * u6.BombCodeLength);
    end;

    if p24.DisplayDigits ~= v25 then
        p24.DisplayDigits = v25;
        u6.SetBombDisplay(p24.Model, v25);
    end;
end;

local function Interpolate(p26, p27, p28, p29, p30) -- Line: 252
    -- upvalues: SnapshotInterp (copy), SoundManager (copy), PlayExplosion (copy), ApplyDefuser (copy), u6 (ref), StepBeep (copy)
    p26.BlowTimer = math.lerp(p27.BlowTimer, p28.BlowTimer, p29);
    local Exploded = p26.Exploded;
    p26.Exploded = SnapshotInterp.Snap(p29, p27.Exploded, p28.Exploded);

    if p26.Exploded and not Exploded then
        local Position = p26.Model:GetPivot().Position;
        SoundManager.Play("Bomb.c4-explode", {
            Position = Position
        });
        SoundManager.Play("Bomb.c4-exp-deb", {
            Position = Position
        });
        PlayExplosion(Position);
    end;

    p26.Defusing = SnapshotInterp.Snap(p29, p27.Defusing, p28.Defusing);
    p26.Defused = p26.Defused or SnapshotInterp.Snap(p29, p27.Defused, p28.Defused);
    p26.NextDefuse = math.lerp(p27.NextDefuse, p28.NextDefuse, p29);
    p26.DefuseTimer = math.lerp(p27.DefuseTimer, p28.DefuseTimer, p29);
    ApplyDefuser(p26);
    local DefuseLength = p26.DefuseLength;
    local v31 = 0;

    if p26.Defused then
        v31 = u6.BombCodeLength;
    elseif p26.CurrentDefuser ~= 0 and (DefuseLength and DefuseLength > 0) then
        v31 = math.ceil((1 - p26.DefuseTimer / DefuseLength) * u6.BombCodeLength);
    end;

    if p26.DisplayDigits ~= v31 then
        p26.DisplayDigits = v31;
        u6.SetBombDisplay(p26.Model, v31);
    end;

    StepBeep(p26);
end;

local function ReadState(p32, p33) -- Line: 288
    -- upvalues: ReadState (copy)
    for i, v in p33 do
        local v34;

        if typeof(v) == "table" then
            v34 = ReadState(p32, v) or v;
        else
            v34 = v;
        end;

        p32[i] = v34;
    end;
end;

local function Destroy(p35) -- Line: 294
    p35.Model:Destroy();
    table.clear(p35);
end;

function v1.new(p36, p37) -- Line: 302
    -- upvalues: u2 (ref), Bomb (copy), u6 (ref), u5 (ref), u12 (ref), SoundManager (copy), Interpolate (copy), ReadState (copy), Destroy (copy)
    local v38 = {
        Identifier = p36,
        CurrentDefuser = 0,
        NextBeep = os.clock() + 1,
        Model = u2:Clone()
    };
    v38.Model.Name = tostring(p36);
    v38.Model:PivotTo(CFrame.new(p37.Position) * CFrame.fromEulerAnglesYXZ(p37.Roll, p37.Yaw, 0) * v38.Model.PrimaryPart.PivotOffset);
    v38.Model.Parent = Bomb;
    v38.Attachment = v38.Model.Attachment;
    u6.ApplyWeaponSkin(v38.Model, "Bomb", "Stock", nil, true);
    u6.SetBombDisplay(v38.Model, 0);
    local v39 = p37.State and u5:UnpackScheme(p37.State);

    if v39 then
        v38.BlowTimer = v39.BlowTimer;
        v38.Exploded = v39.Exploded;
        v38.Defusing = v39.Defusing;
        v38.Defused = v39.Defused;
        v38.NextDefuse = v39.NextDefuse;
        v38.DefuseTimer = v39.DefuseTimer;
    end;

    if (v38.BlowTimer or u12) >= u12 - 1 then
        SoundManager.Play("Bomb.c4-plant-quiet", {
            Position = v38.Model:GetPivot().Position
        });
    end;

    v38.Interpolate = Interpolate;
    v38.ReadState = ReadState;
    v38.Destroy = Destroy;

    return v38;
end;

function v1.Init(p40) -- Line: 363
    -- upvalues: u2 (ref), u3 (ref), ReplicatedStorage (copy), u4 (ref), u7 (ref), u6 (ref), u8 (ref), u9 (ref), u10 (ref)
    u2 = p40:GetModule("WeaponManager").Get("Bomb").Assets.CharacterModel;
    u3 = ReplicatedStorage.Assets:WaitForChild("BombExplosion");
    u4 = p40:GetModule("BufferScheme");
    u7 = p40:GetModule("CameraController");
    u6 = p40:GetModule("CharacterModel");
    u8 = p40:GetModule("Entities");
    u9 = p40:GetModule("GameConfiguration");
    u10 = p40:GetModule("Gui");
end;

function v1.Start(p41) -- Line: 377
    -- upvalues: u5 (ref), u4 (ref), u11 (ref), u10 (ref), u12 (ref), u9 (ref)
    u5 = u4.GetScheme("EntityBomb");
    u11 = u10.GetComponent("Haptics");

    local function RefreshConfig() -- Line: 381
        -- upvalues: u12 (ref), u9 (ref)
        u12 = u9.Get("Bomb", "BlowTimer");
    end;

    u12 = u9.Get("Bomb", "BlowTimer");
    u9.Updated:Connect(RefreshConfig);
end;

return v1;