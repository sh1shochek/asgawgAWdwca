-- Decompiled with Potassium's decompiler.

local u1 = {};
u1.__index = u1;
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Players = game:GetService("Players");
require(script:WaitForChild("Types"));
local LocalPlayer = Players.LocalPlayer;
local Sound = require(ReplicatedStorage.Classes.Sound);
local Materials = require(ReplicatedStorage.Components.Common.VFXLibary.CreateImpact.Components.Materials);
local GetRayIgnore = require(ReplicatedStorage.Components.Common.GetRayIgnore);
local FlashEffect = require(ReplicatedStorage.Components.Common.VFXLibary.FlashEffect);
local CharacterResolver = require(ReplicatedStorage.Components.Common.CharacterResolver);
local RuntimeKinematics = require(ReplicatedStorage.MovementV2.RuntimeKinematics);
local u2 = { Vector3.new(0, 0, 0), Vector3.new(0.8, 0, 0), Vector3.new(-0.8, 0, 0), Vector3.new(0, 0, 0.8), Vector3.new(0, 0, -0.8) };
local u3 = {
    Concrete = "LandingConcrete",
    Brick = "LandingConcrete",
    Cobblestone = "LandingConcrete",
    Basalt = "LandingConcrete",
    Limestone = "LandingConcrete",
    Pavement = "LandingConcrete",
    Asphalt = "LandingConcrete",
    Rock = "LandingConcrete",
    Slate = "LandingConcrete",
    Granite = "LandingConcrete",
    Marble = "LandingConcrete",
    Pebble = "LandingConcrete",
    CeramicTiles = "LandingConcrete",
    Ground = "LandingDirt",
    Mud = "LandingDirt",
    Glass = "LandingGlass",
    Gravel = "LandingGravel",
    Rubber = "LandingRubber",
    Plastic = "LandingRubber",
    Sand = "LandingSand",
    Snow = "LandingSand",
    Grass = "LandingGrass",
    LeafyGrass = "LandingGrass",
    Metal = "LandingMetal",
    DiamondPlate = "LandingMetal",
    CorrodedMetal = "LandingMetal",
    ["Corroded Metal"] = "LandingMetal",
    Wood = "Wood",
    WoodPlanks = "WoodPlanks",
    Fabric = "LandingDirt",
    Carpet = "LandingDirt",
    Cardboard = "LandingDirt"
};
local u4 = nil;
local RaycastParams_new_ret = RaycastParams.new();
RaycastParams_new_ret.FilterType = Enum.RaycastFilterType.Exclude;
RaycastParams_new_ret.IgnoreWater = true;

local function GetFloorMaterial(p5: userdata, p6: vector, p7: number?) -- Line: 116
    -- upvalues: GetRayIgnore (copy), RaycastParams_new_ret (copy), u2 (copy)
    local v8 = GetRayIgnore();

    if not table.find(v8, p5) then
        table.insert(v8, p5);
    end;

    RaycastParams_new_ret.FilterDescendantsInstances = v8;
    local Vector3_new_ret = Vector3.new(0, -(p7 or 3.1), 0);

    for _, v in ipairs(u2) do
        local v9 = workspace:Raycast(p6 + v, Vector3_new_ret, RaycastParams_new_ret);

        if v9 and v9.Normal.Y > 0.7 then
            return v9.Material.Name;
        end;
    end;

    return "Air";
end;

local function ResolveFloorMaterial(p10: any, p11: string, p12: boolean, p13: boolean) -- Line: 140
    if p11 ~= "Air" then
        return p11;
    end;

    if not p12 then
        return "Air";
    end;

    if p13 then
        local CurrentFloorMaterial = p10.CurrentFloorMaterial;

        if CurrentFloorMaterial and (CurrentFloorMaterial ~= "" and CurrentFloorMaterial ~= "Air") then
            return CurrentFloorMaterial;
        end;
    end;

    return "Concrete";
end;

local function GetVolumeMultiplier(p14: any, p15: boolean?) -- Line: 167
    -- upvalues: FlashEffect (copy)
    return (p15 and 0.4 or 1) * (p14.IsLocalPlayer and FlashEffect.GetAudioFadeMultiplier() or 1);
end;

local function PlayFootstepSound(p16: userdata, p17: string, p18: number) -- Line: 175
    -- upvalues: u4 (ref), Materials (copy)
    if not (u4 and (p17 ~= "" and p17 ~= "Air")) then
        return nil;
    end;

    local v19 = u4.Sounds and not u4.Sounds:FindFirstChild(p17) and (Materials[p17] or "Ground") or p17;

    if not u4.Sounds or u4.Sounds:FindFirstChild(v19) then
        return u4:play({
            Parent = p16,
            Name = v19
        }, p18);
    end;

    warn(string.format("[FloorSound] Missing sound for category: \'%s\' (material: %s)", v19, p17));

    return nil;
end;

local function StopFootstepSound(p20: userdata?) -- Line: 200
    if p20 and p20.Playing then
        p20:Stop();
    end;
end;

local function ResetAirborneTracking(p21) -- Line: 208
    p21.IsAirborne = false;
    p21.AirborneStartTime = 0;
    p21.PeakAirborneVelocityY = 0;
end;

local function BeginAirborneTracking(p22: any, p23: number, p24: number) -- Line: 216
    if p22.IsAirborne then
        p22.PeakAirborneVelocityY = math.min(p22.PeakAirborneVelocityY, p24);

        return;
    end;

    p22.IsAirborne = true;
    p22.AirborneStartTime = p23;
    p22.PeakAirborneVelocityY = p24;
end;

local function ConsumeLandingWindow(p25: any, p26: number) -- Line: 229
    local v27 = not p25.IsAirborne and 0 or p26 - p25.AirborneStartTime;
    local PeakAirborneVelocityY = p25.PeakAirborneVelocityY;
    p25.IsAirborne = false;
    p25.AirborneStartTime = 0;
    p25.PeakAirborneVelocityY = 0;

    return v27, PeakAirborneVelocityY;
end;

local function PlayLandingSound(p28: any, p29: userdata, p30: userdata, p31: string?) -- Line: 238
    -- upvalues: GetFloorMaterial (copy), FlashEffect (copy), PlayFootstepSound (copy), u3 (copy)
    local v32 = tick();

    if v32 - p28.LastFloorSoundTime < 0.1 then
        return;
    end;

    p28.LastFloorSoundTime = v32;
    local Attribute = p28.Player:GetAttribute("IsCrouching");
    local v33 = p31 or GetFloorMaterial(p30, p29.Position);
    local v34 = p28.IsLocalPlayer and FlashEffect.GetAudioFadeMultiplier() or 1;
    PlayFootstepSound(p29, u3[v33] or "LandingConcrete", (Attribute and 0.4 or 1) * v34);
end;

local function PlayJumpSound(p35: any, p36: userdata, p37: string) -- Line: 260
    -- upvalues: FlashEffect (copy), PlayFootstepSound (copy)
    local v38 = tick();

    if v38 - p35.LastFloorSoundTime < 0.1 then
        return;
    end;

    local CurrentFootstepSound = p35.CurrentFootstepSound;

    if CurrentFootstepSound and CurrentFootstepSound.Playing then
        CurrentFootstepSound:Stop();
    end;

    p35.CurrentFootstepSound = nil;
    p35.LastFloorSoundTime = v38;
    local v39 = (p35.Player:GetAttribute("IsCrouching") and 0.4 or 1) * (p35.IsLocalPlayer and FlashEffect.GetAudioFadeMultiplier() or 1);
    PlayFootstepSound(p36, "Jump", v39);
    PlayFootstepSound(p36, p37, v39);
end;

function u1.SetCharacter(p40: any, p41: userdata?) -- Line: 278
    -- upvalues: CharacterResolver (copy), RuntimeKinematics (copy)
    if p41 then
        local RootPart = CharacterResolver.getRootPart(p41);

        if not (RootPart and p41.Parent) then
            return;
        end;

        p40.PrimaryPart = RootPart;
        p40.Character = p41;
        p40.TimePassed = 0.25;
        local _, _, _, v42, v43 = RuntimeKinematics.resolve(p41, RootPart);
        p40.IsAirborne = not v43;
        p40.AirborneStartTime = not p40.IsAirborne and 0 or tick();
        p40.PeakAirborneVelocityY = not p40.IsAirborne and 0 or v42;

        return;
    end;

    local CurrentFootstepSound = p40.CurrentFootstepSound;

    if CurrentFootstepSound and CurrentFootstepSound.Playing then
        CurrentFootstepSound:Stop();
    end;

    p40.CurrentFootstepSound = nil;
    p40.CurrentFloorMaterial = nil;
    p40.PrimaryPart = nil;
    p40.TimePassed = 0.25;
    p40.Character = nil;
    p40.IsAirborne = false;
    p40.AirborneStartTime = 0;
    p40.PeakAirborneVelocityY = 0;
end;

function u1.Update(p44: any, p45: number, p46: vector?) -- Line: 308
    -- upvalues: CharacterResolver (copy), RuntimeKinematics (copy), GetFloorMaterial (copy), PlayJumpSound (copy), PlayLandingSound (copy), PlayFootstepSound (copy), FlashEffect (copy)
    local PrimaryPart = p44.PrimaryPart;
    local Character = p44.Character;
    local Player = p44.Player;

    if not (PrimaryPart and (Character and (Character.Parent and CharacterResolver.isAliveCharacter(Character)))) then
        return;
    end;

    local v47 = tick();
    local v48, _, v49, _, v50 = RuntimeKinematics.resolve(Character, PrimaryPart);

    if v50 then
        if p44.IsAirborne then
            local Position, v51 = RuntimeKinematics.getPosition(Character, PrimaryPart);
            local v52 = GetFloorMaterial(Character, Position, v51 and 3.1 or 6.2);
            local v53 = v52 == "Air" and "Concrete" or v52;
            p44.CurrentFloorMaterial = v53;
            local v54 = not p44.IsAirborne and 0 or v47 - p44.AirborneStartTime;
            local PeakAirborneVelocityY = p44.PeakAirborneVelocityY;
            p44.IsAirborne = false;
            p44.AirborneStartTime = 0;
            p44.PeakAirborneVelocityY = 0;

            if v54 >= 0.08 and PeakAirborneVelocityY <= -2.5 then
                PlayLandingSound(p44, PrimaryPart, Character, v53);
            end;
        end;
    else
        if not p44.IsAirborne and v48.Y > 2 then
            local v55 = GetFloorMaterial(Character, PrimaryPart.Position, 6.2);
            PlayJumpSound(p44, PrimaryPart, v55 == "Air" and (p44.CurrentFloorMaterial or "Concrete") or v55);
        end;

        local Y = v48.Y;

        if p44.IsAirborne then
            p44.PeakAirborneVelocityY = math.min(p44.PeakAirborneVelocityY, Y);
        else
            p44.IsAirborne = true;
            p44.AirborneStartTime = v47;
            p44.PeakAirborneVelocityY = Y;
        end;
    end;

    local Attribute = Player:GetAttribute("IsCrouching");

    if Player:GetAttribute("IsWalking") or Attribute then
        return;
    end;

    if Player:GetAttribute("IsSniperScoped") == true then
        return;
    end;

    local v56 = Attribute and 3.5 or 7.5;
    local v57 = Attribute and 0.55 or 0.3;
    p44.TimePassed = p44.TimePassed + p45;

    if v57 <= p44.TimePassed then
        p44.TimePassed = p44.TimePassed - v57;

        if v47 - p44.LastFloorSoundTime < 0.1 then
            return;
        end;

        if v56 <= v49 then
            local v58 = GetFloorMaterial(Character, PrimaryPart.Position, 3.1);

            if v58 == "Air" then
                if v50 then
                    local CurrentFloorMaterial = p44.CurrentFloorMaterial;
                    v58 = not (CurrentFloorMaterial and (CurrentFloorMaterial ~= "" and CurrentFloorMaterial ~= "Air")) and "Concrete" or CurrentFloorMaterial;
                else
                    v58 = "Air";
                end;
            end;

            if v50 then
                p44.CurrentFloorMaterial = v58;
            end;

            p44.LastFloorSoundTime = v47;
            p44.CurrentFootstepSound = PlayFootstepSound(PrimaryPart, v58, (Attribute and 0.4 or 1) * (p44.IsLocalPlayer and FlashEffect.GetAudioFadeMultiplier() or 1));
        end;
    end;
end;

function u1.new(p59: userdata) -- Line: 392
    -- upvalues: u1 (copy), LocalPlayer (copy), u4 (ref), Sound (copy)
    local v60 = setmetatable({}, u1);
    v60.IsLocalPlayer = p59 == LocalPlayer;
    v60.Player = p59;
    v60.PrimaryPart = nil;
    v60.Character = nil;
    v60.TimePassed = 0.25;
    v60.CurrentFootstepSound = nil;
    v60.CurrentFloorMaterial = nil;
    v60.LastFloorSoundTime = 0;
    v60.IsAirborne = false;
    v60.AirborneStartTime = 0;
    v60.PeakAirborneVelocityY = 0;

    if not u4 then
        u4 = Sound.new("FloorSounds");
    end;

    return v60;
end;

return u1;