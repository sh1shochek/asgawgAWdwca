-- ReplicatedStorage.GameClient.Entities.DroppedWeapon
-- Script path: ReplicatedStorage.GameClient.Entities.DroppedWeapon
-- Decompile time: 11.44 ms

-- Decompiled with Potassium's decompiler.

local v1 = {};
local SnapshotInterp = require(game:GetService("ReplicatedStorage").Shared.Utility.SnapshotInterp);
local u2 = nil;
local u3 = nil;
local u4 = nil;
local u5 = nil;
local u6 = nil;
local u7 = nil;
local u8 = nil;
local u9 = nil;
local u10 = true;
local DroppedWeapons = workspace:WaitForChild("Debris"):WaitForChild("DroppedWeapons");

local function ApplyDroppedWeaponShadow(p11: userdata) -- Line: 23
    -- upvalues: u10 (ref)
    if p11:IsA("BasePart") then
        p11.CastShadow = u10;
    end;
end;

local function ModelCreation(p12: number, p13: string) -- Line: 29
    -- upvalues: u4 (ref), u5 (ref), DroppedWeapons (copy)
    local v14 = u4.Get(p13);
    local v15 = (v14.Assets.DropModel or v14.Assets.CharacterModel):Clone();
    v15.Name = tostring(p12);
    v15:SetAttribute("WeaponName", p13);

    if p13 == "Bomb" then
        u5.SetBombDisplay(v15, 0);
    end;

    v15.Parent = DroppedWeapons;

    return v15;
end;

local function Interpolate(p16: any, p17: any, p18: any, p19: any, p20: number?, p21: number?) -- Line: 51
    -- upvalues: u7 (ref), u8 (ref), SnapshotInterp (copy), u9 (ref)
    u7.InterpolateState(p16, p17, p18, p19);
    p16.InBuyZone = u8.Teams[SnapshotInterp.Snap(p19, p17.InBuyZone, p18.InBuyZone)];

    if p16.InBuyZone ~= p16.PreviousInBuyZone then
        p16.Model:SetAttribute("InBuyZone", p16.InBuyZone);
        p16.PreviousInBuyZone = p16.InBuyZone;
    end;

    p16.InFrustum = u9:VisiblePoint(p16.Position, 3.5);
    p16.CFrame = u7.GetCFrame(p16);
end;

local function Destroy(p22) -- Line: 74
    p22.Model:Destroy();
    table.clear(p22);
end;

function v1.new(p23: number, p24: any) -- Line: 83
    -- upvalues: u3 (ref), u8 (ref), u4 (ref), ModelCreation (copy), Interpolate (copy), Destroy (copy), u5 (ref), u7 (ref), u9 (ref)
    local v25 = p24.State and (u3:UnpackScheme(p24.State) or {}) or {};
    local WeaponName = p24.WeaponName;
    local v26 = {
        Name = u8.Weapons[WeaponName],
        Identifier = p23,
        Movable = true
    };
    local v27 = u4.Get(v26.Name);
    v26.Position = v25.Position;
    v26.Yaw = v25.Yaw;
    v26.Pitch = v25.Pitch;
    v26.Roll = v25.Roll;
    v26.Normal = v25.Normal;
    v26.Mode = v25.Mode;
    v26.InBuyZone = "Spectator";
    v26.PreviousInBuyZone = "Spectator";
    v26.OnGround = v25.OnGround == 1;
    v26.Model = ModelCreation(p23, v26.Name);
    v26.PrimaryPart = v26.Model.PrimaryPart;
    v26.Interpolate = Interpolate;
    v26.Destroy = Destroy;
    u5.ApplyWeaponSkin(v26.Model, v26.Name, u8.SkinsNum[WeaponName][p24.WeaponSkin], nil, true);
    local AltFunction = v27.Data.AltFunction;

    if AltFunction and AltFunction.Name == "Silencer" then
        v26.AltFunctionInfo = AltFunction.Name;
        local Silencer = v26.Model:FindFirstChild("Silencer");

        if Silencer then
            Silencer.Transparency = v26.Mode == 2 and 1 or 0;
        end;
    end;

    u7.SetModelBounds(v26);
    v26.CFrame = u7.GetCFrame(v26);
    v26.Model:PivotTo(v26.CFrame);
    v26.OldCFrame = v26.CFrame;
    v26.InFrustum = u9:VisiblePoint(v26.Position, 3.5);

    if v25.BlockedTeam then
        v26.BlockedTeam = u8.Teams[v25.BlockedTeam];
        v26.Model:SetAttribute("BlockedTeam", v26.BlockedTeam);
    end;

    return v26;
end;

function v1.Init(p28) -- Line: 164
    -- upvalues: u8 (ref), u4 (ref), u7 (ref), u5 (ref), u6 (ref), u9 (ref), u2 (ref)
    u8 = p28:GetModule("Enums");
    u4 = p28:GetModule("WeaponManager");
    u7 = p28:GetModule("DroppedPhysics");
    u5 = p28:GetModule("CharacterModel");
    u6 = p28:GetModule("Gui");
    u9 = p28:GetModule("FrustumCuller").Shared();
    u2 = p28:GetModule("BufferScheme");
end;

function v1.Start(p29) -- Line: 175
    -- upvalues: u3 (ref), u2 (ref), u6 (ref), u10 (ref), DroppedWeapons (copy), ApplyDroppedWeaponShadow (copy)
    u3 = u2.GetScheme("EntityDroppedWeapon");
    local Component = u6.GetComponent("Settings");

    local function SetDroppedWeaponShadows(p30) -- Line: 179
        -- upvalues: u10 (ref), DroppedWeapons (ref)
        u10 = p30 ~= false;

        for _, descendant in DroppedWeapons:GetDescendants() do
            if descendant:IsA("BasePart") then
                descendant.CastShadow = u10;
            end;
        end;
    end;

    local PlayerSettings = Component:GetPlayerSettings();
    u10 = (PlayerSettings and (PlayerSettings.Game and PlayerSettings.Game["Graphics & Visuals"]) and PlayerSettings.Game["Graphics & Visuals"]["Dropped Weapon Shadows"]) ~= false;

    for _, descendant in DroppedWeapons:GetDescendants() do
        if descendant:IsA("BasePart") then
            descendant.CastShadow = u10;
        end;
    end;

    Component:AddConnection("Game", "Graphics & Visuals", "Dropped Weapon Shadows", SetDroppedWeaponShadows);
    DroppedWeapons.DescendantAdded:Connect(ApplyDroppedWeaponShadow);
end;

return v1;