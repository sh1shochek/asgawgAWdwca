-- Decompiled with Potassium's decompiler.

local v1 = {};
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Players = game:GetService("Players");
local Workspace = game:GetService("Workspace");
local InventoryController = require(ReplicatedStorage.Controllers.InventoryController);
local DataController = require(ReplicatedStorage.Controllers.DataController);
local RunServiceController = require(ReplicatedStorage.Controllers.RunServiceController);
local FlashEffect = require(ReplicatedStorage.Components.Common.VFXLibary.FlashEffect);
local CharacterResolver = require(ReplicatedStorage.Components.Common.CharacterResolver);
local CharacterPresentationDescriptor = require(ReplicatedStorage.Components.Common.CharacterPresentationDescriptor);
local GetUserPlatform = require(ReplicatedStorage.Components.Common.GetUserPlatform);
local LocalPlayer = Players.LocalPlayer;
local v2 = GetUserPlatform();
local u3;

if table.find(v2, "Mobile") == nil then
    u3 = false;
else
    u3 = #v2 <= 1;
end;

local u4 = {
    ["Counter-Terrorists"] = true,
    Terrorists = true
};
local u5 = {
    CFrame.identity,
    CFrame.Angles(0.017453292519943295, 0, 0),
    CFrame.Angles(-0.017453292519943295, 0, 0),
    CFrame.Angles(0, 0.017453292519943295, 0),
    CFrame.Angles(0, -0.017453292519943295, 0),
    CFrame.Angles(0.012217304763960306, 0.012217304763960306, 0),
    CFrame.Angles(0.012217304763960306, -0.012217304763960306, 0),
    CFrame.Angles(-0.012217304763960306, 0.012217304763960306, 0),
    CFrame.Angles(-0.012217304763960306, -0.012217304763960306, 0)
};
local u6 = {
    UserInputType = Enum.UserInputType.Touch
};
local RaycastParams_new_ret = RaycastParams.new();
RaycastParams_new_ret.FilterType = Enum.RaycastFilterType.Exclude;
RaycastParams_new_ret.IgnoreWater = true;
local u7 = nil;
local u8 = nil;
local Random_new_ret = Random.new();
local u9 = 0;
local u10 = false;
local u11 = nil;
local u12 = 0;
local u13 = 0;
local u14 = nil;
local u15 = 0;
local u16 = 0;
local u17 = 0;
local u18 = nil;
local u19 = 0;

local function refreshRaycastFilter(p20: userdata?) -- Line: 107
    -- upvalues: Workspace (copy), RaycastParams_new_ret (copy)
    local v21 = {};

    if p20 then
        table.insert(v21, p20);
    end;

    if Workspace.CurrentCamera then
        table.insert(v21, Workspace.CurrentCamera);
    end;

    RaycastParams_new_ret.FilterDescendantsInstances = v21;
end;

local function isEnemyTeam(p22) -- Line: 121
    -- upvalues: LocalPlayer (copy), u4 (copy), Workspace (copy)
    local Attribute = LocalPlayer:GetAttribute("Team");

    if u4[Attribute] and u4[p22] then
        return Workspace:GetAttribute("Gamemode") == "Deathmatch" and true or p22 ~= Attribute;
    end;

    return false;
end;

local function getBotShell(p23: userdata) -- Line: 133
    while p23 and p23:IsA("Model") do
        if p23:GetAttribute("Bot") == true then
            return p23;
        end;

        p23 = p23.Parent;
    end;

    return nil;
end;

local function getEnemyCharacter(p24: userdata) -- Line: 147
    -- upvalues: getBotShell (copy), CharacterPresentationDescriptor (copy), CharacterResolver (copy), LocalPlayer (copy), u4 (copy), Workspace (copy)
    local v25 = p24:FindFirstAncestorOfClass("Model");

    if not v25 then
        return nil;
    end;

    local v26 = getBotShell(v25);

    if v26 then
        if v26:GetAttribute(CharacterPresentationDescriptor.VisibleAttribute) == false then
            return nil;
        end;

        if CharacterResolver.isAliveCharacter(v26) then
            local Attribute = v26:GetAttribute("Team");
            local Attribute2 = LocalPlayer:GetAttribute("Team");
            local v27;

            if u4[Attribute2] and u4[Attribute] then
                v27 = Workspace:GetAttribute("Gamemode") == "Deathmatch" and true or Attribute ~= Attribute2;
            else
                v27 = false;
            end;

            if v27 then
                return v26;
            end;
        end;

        return nil;
    end;

    if not CharacterResolver.isAliveCharacter(v25) then
        return nil;
    end;

    local PlayerFromCharacter = CharacterResolver.getPlayerFromCharacter(v25);

    if PlayerFromCharacter then
        local Attribute = PlayerFromCharacter:GetAttribute("Team");
        local Attribute2 = LocalPlayer:GetAttribute("Team");
        local v28;

        if u4[Attribute2] and u4[Attribute] then
            v28 = Workspace:GetAttribute("Gamemode") == "Deathmatch" and true or Attribute ~= Attribute2;
        else
            v28 = false;
        end;

        if v28 then
            return v25;
        end;
    end;

    return nil;
end;

local function clipSlab(p29: number, p30: number, p31: number, p32: number, p33: number, p34: number) -- Line: 178
    if math.abs(p30) < 0.0001 then
        if p29 < p31 or p32 < p29 then
            return 1, 0;
        end;

        return p33, p34;
    end;

    local v35 = (p31 - p29) / p30;
    local v36 = (p32 - p29) / p30;

    if v36 >= v35 then
        local v37 = v35;
        v35 = v36;
        v36 = v37;
    end;

    return math.max(p33, v36), math.min(p34, v35);
end;

local function doesRayHitBox(p38: vector, p39: vector, p40: vector, p41: vector, p42: number) -- Line: 197
    local X = p38.X;
    local X2 = p39.X;
    local X3 = p40.X;
    local X4 = p41.X;
    local v43;

    if math.abs(X2) < 0.0001 then
        if X < X3 or X4 < X then
            p42 = 0;
            v43 = 1;
        else
            v43 = 0;
        end;
    else
        local v44 = (X3 - X) / X2;
        local v45 = (X4 - X) / X2;

        if v45 >= v44 then
            local v46 = v44;
            v44 = v45;
            v45 = v46;
        end;

        v43 = math.max(0, v45);
        p42 = math.min(p42, v44);
    end;

    if p42 < v43 then
        return false;
    end;

    local Y = p38.Y;
    local Y2 = p39.Y;
    local Y3 = p40.Y;
    local Y4 = p41.Y;

    if math.abs(Y2) < 0.0001 then
        if Y < Y3 or Y4 < Y then
            v43 = 1;
            p42 = 0;
        end;
    else
        local v47 = (Y3 - Y) / Y2;
        local v48 = (Y4 - Y) / Y2;

        if v48 >= v47 then
            local v49 = v47;
            v47 = v48;
            v48 = v49;
        end;

        v43 = math.max(v43, v48);
        p42 = math.min(p42, v47);
    end;

    if p42 < v43 then
        return false;
    end;

    local Z = p38.Z;
    local Z2 = p39.Z;
    local Z3 = p40.Z;
    local Z4 = p41.Z;

    if math.abs(Z2) < 0.0001 then
        if Z < Z3 or Z4 < Z then
            v43 = 1;
            p42 = 0;
        end;
    else
        local v50 = (Z3 - Z) / Z2;
        local v51 = (Z4 - Z) / Z2;

        if v51 >= v50 then
            local v52 = v50;
            v50 = v51;
            v51 = v52;
        end;

        v43 = math.max(v43, v51);
        p42 = math.min(p42, v50);
    end;

    return v43 <= p42;
end;

local function isRayBlockedBySmoke(p53: vector, p54: vector, p55: number) -- Line: 213
    -- upvalues: Workspace (copy), doesRayHitBox (copy)
    local Debris = Workspace:FindFirstChild("Debris");

    if not Debris then
        return false;
    end;

    for _, child in Debris:GetChildren() do
        if child:IsA("Folder") and string.sub(child.Name, 1, 11) == "VoxelSmoke_" then
            for _, child2 in child:GetChildren() do
                if child2.Name == "SmokeVoxel" and child2:IsA("BasePart") then
                    local v56 = child2.Size / 2;
                    local Position = child2.Position;

                    if doesRayHitBox(p53, p54, Position - v56, Position + v56, p55) then
                        return true;
                    end;
                end;
            end;
        end;
    end;

    return false;
end;

local function getHoveredEnemy(p57: number) -- Line: 238
    -- upvalues: Workspace (copy), CharacterResolver (copy), u5 (copy), RaycastParams_new_ret (copy), getEnemyCharacter (copy), isRayBlockedBySmoke (copy)
    local CurrentCamera = Workspace.CurrentCamera;

    if not (CurrentCamera and CharacterResolver.getLocalCharacter()) then
        return nil, 0;
    end;

    local CFrame2 = CurrentCamera.CFrame;
    local Position = CFrame2.Position;

    for _, v in u5 do
        local LookVector = (CFrame2 * v).LookVector;
        local v58 = Workspace:Raycast(Position, LookVector * p57, RaycastParams_new_ret);
        local v59;

        if v58 then
            v59 = getEnemyCharacter(v58.Instance);
        else
            v59 = v58;
        end;

        if v59 and not isRayBlockedBySmoke(Position, LookVector, v58.Distance) then
            return v59, v58.Distance;
        end;
    end;

    return nil, 0;
end;

local function pressFire(p60) -- Line: 261
    -- upvalues: u7 (ref), u14 (ref), u15 (ref), u16 (ref), u6 (copy)
    if not u7 then
        return;
    end;

    u14 = p60;
    u15 = os.clock();
    u16 = p60.Rounds;
    u7(Enum.UserInputState.Begin, u6);
end;

local function releaseFire() -- Line: 273
    -- upvalues: u14 (ref), u7 (ref), u6 (copy)
    if not u14 then
        return;
    end;

    u14 = nil;

    if u7 then
        u7(Enum.UserInputState.End, u6);
    end;
end;

local function clearTargetState() -- Line: 285
    -- upvalues: u11 (ref), u17 (ref), u18 (ref), u19 (ref), u9 (ref)
    u11 = nil;
    u17 = 0;
    u18 = nil;
    u19 = 0;
    u9 = 0;
end;

local function resetState() -- Line: 295
    -- upvalues: u14 (ref), u7 (ref), u6 (copy), u11 (ref), u17 (ref), u18 (ref), u19 (ref), u9 (ref)
    if u14 then
        u14 = nil;

        if u7 then
            u7(Enum.UserInputState.End, u6);
        end;
    end;

    u11 = nil;
    u17 = 0;
    u18 = nil;
    u19 = 0;
    u9 = 0;
end;

local function getBurstSize(p61: any, p62: number) -- Line: 304
    return p61.Properties.Automatic and (p62 <= 30 and (1 / 0) or (p62 <= 80 and 4 or 2)) or 1;
end;

local function isWeaponRecovered(p63: any, p64: number) -- Line: 317
    -- upvalues: u18 (ref)
    if not u18 or p64 - u18 >= 0.9 then
        return true;
    end;

    local Recoil = p63.Recoil;

    if Recoil and Recoil.Time > Recoil.ActiveFireRate * 0.25 then
        return false;
    end;

    local Spread = p63.Properties.Spread;

    if not Spread then
        return true;
    end;

    local Range = Spread.Range;

    return p63:getBaseSpread() <= Range.Min + (Range.Max - Range.Min) * 0.3;
end;

local function updatePendingPress(p65: any, p66: number) -- Line: 338
    -- upvalues: u14 (ref), u16 (ref), u7 (ref), u6 (copy), u17 (ref), u18 (ref), u15 (ref)
    if not u14 then
        return;
    end;

    if not (p65 and (p65 == u14 and p65.Rounds < u16)) then
        if p65 ~= u14 or p66 - u15 > 0.5 then
            if not u14 then
                return;
            end;

            u14 = nil;

            if u7 then
                u7(Enum.UserInputState.End, u6);
            end;
        end;

        return;
    end;

    if u14 then
        u14 = nil;

        if u7 then
            u7(Enum.UserInputState.End, u6);
        end;
    end;

    u17 = u17 + 1;
    u18 = p66;
end;

local function step() -- Line: 354
    -- upvalues: u10 (ref), InventoryController (copy), u14 (ref), u16 (ref), u7 (ref), u6 (copy), u17 (ref), u18 (ref), u15 (ref), FlashEffect (copy), u11 (ref), u19 (ref), u9 (ref), getHoveredEnemy (copy), u12 (ref), u13 (ref), Random_new_ret (copy)
    if u10 then
        return;
    end;

    local os_clock_ret = os.clock();
    local CurrentEquipped = InventoryController.getCurrentEquipped();

    if not CurrentEquipped or CurrentEquipped.Properties.Class ~= "Weapon" then
        CurrentEquipped = nil;
    end;

    if u14 then
        if CurrentEquipped and (CurrentEquipped == u14 and CurrentEquipped.Rounds < u16) then
            if u14 then
                u14 = nil;

                if u7 then
                    u7(Enum.UserInputState.End, u6);
                end;
            end;

            u17 = u17 + 1;
            u18 = os_clock_ret;
        elseif (CurrentEquipped ~= u14 or os_clock_ret - u15 > 0.5) and u14 then
            u14 = nil;

            if u7 then
                u7(Enum.UserInputState.End, u6);
            end;
        end;
    end;

    if not (CurrentEquipped and (CurrentEquipped.Rounds > 0 and not FlashEffect.IsFlashed())) then
        if u11 then
            if u14 then
                u14 = nil;

                if u7 then
                    u7(Enum.UserInputState.End, u6);
                end;
            end;

            u11 = nil;
            u17 = 0;
            u18 = nil;
            u19 = 0;
            u9 = 0;
        end;

        return;
    end;

    if not u11 and os_clock_ret < u9 then
        return;
    end;

    u9 = os_clock_ret + 0.03333333333333333;
    debug.profilebegin("MobileAutoShootController.Scan");
    local v67, v68 = getHoveredEnemy(CurrentEquipped.IsAiming and (CurrentEquipped.Properties.Range or 180) or 180);
    debug.profileend();

    if not v67 then
        if u11 and os_clock_ret - u12 > 0.12 then
            if u14 then
                u14 = nil;

                if u7 then
                    u7(Enum.UserInputState.End, u6);
                end;
            end;

            u11 = nil;
            u17 = 0;
            u18 = nil;
            u19 = 0;
            u9 = 0;
        end;

        return;
    end;

    u12 = os_clock_ret;

    if not u11 then
        u11 = os_clock_ret;
        u13 = Random_new_ret:NextNumber(0.12, 0.2);
    end;

    if u14 or (CurrentEquipped.IsShooting or os_clock_ret - u11 < u13) then
        return;
    end;

    if u17 >= (CurrentEquipped.Properties.Automatic and (v68 <= 30 and (1 / 0) or (v68 <= 80 and 4 or 2)) or 1) then
        local v69;

        if u18 and os_clock_ret - u18 < 0.9 then
            local Recoil = CurrentEquipped.Recoil;

            if Recoil and Recoil.Time > Recoil.ActiveFireRate * 0.25 then
                v69 = false;
            else
                local Spread = CurrentEquipped.Properties.Spread;

                if Spread then
                    local Range = Spread.Range;
                    v69 = CurrentEquipped:getBaseSpread() <= Range.Min + (Range.Max - Range.Min) * 0.3;
                else
                    v69 = true;
                end;
            end;
        else
            v69 = true;
        end;

        if not v69 then
            return;
        end;

        u17 = 0;
        u19 = os_clock_ret + Random_new_ret:NextNumber(0, 0.04);
    end;

    if u19 <= os_clock_ret then
        if not u7 then
            return;
        end;

        u14 = CurrentEquipped;
        u15 = os.clock();
        u16 = CurrentEquipped.Rounds;
        u7(Enum.UserInputState.Begin, u6);
    end;
end;

local function setEnabled(p70: boolean) -- Line: 423
    -- upvalues: u8 (ref), RunServiceController (copy), step (copy), u14 (ref), u7 (ref), u6 (copy), u11 (ref), u17 (ref), u18 (ref), u19 (ref), u9 (ref)
    if p70 and not u8 then
        u8 = RunServiceController.BindToRenderStep("MobileAutoShootController.Step", step);

        return;
    end;

    if not p70 and u8 then
        u8:Disconnect();
        u8 = nil;

        if u14 then
            u14 = nil;

            if u7 then
                u7(Enum.UserInputState.End, u6);
            end;
        end;

        u11 = nil;
        u17 = 0;
        u18 = nil;
        u19 = 0;
        u9 = 0;
    end;
end;

function v1.SetManualFireHeld(p71: boolean) -- Line: 438
    -- upvalues: u10 (ref), u14 (ref), u11 (ref), u17 (ref), u18 (ref), u19 (ref), u9 (ref)
    u10 = p71;

    if p71 then
        u14 = nil;
        u11 = nil;
        u17 = 0;
        u18 = nil;
        u19 = 0;
        u9 = 0;
    end;
end;

function v1.Start() -- Line: 450
    -- upvalues: u3 (copy), ReplicatedStorage (copy), u7 (ref), Workspace (copy), CharacterResolver (copy), RaycastParams_new_ret (copy), LocalPlayer (copy), u14 (ref), u6 (copy), u11 (ref), u17 (ref), u18 (ref), u19 (ref), u9 (ref), u8 (ref), RunServiceController (copy), step (copy), DataController (copy)
    if not u3 then
        return;
    end;

    u7 = require(ReplicatedStorage.Controllers.InputController.Actions.Fire).Callback;
    Workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function() -- Line: 459
        -- upvalues: CharacterResolver (ref), Workspace (ref), RaycastParams_new_ret (ref)
        local LocalCharacter = CharacterResolver.getLocalCharacter();
        local v72 = {};

        if LocalCharacter then
            table.insert(v72, LocalCharacter);
        end;

        if Workspace.CurrentCamera then
            table.insert(v72, Workspace.CurrentCamera);
        end;

        RaycastParams_new_ret.FilterDescendantsInstances = v72;
    end);
    CharacterResolver.observeCharacter(LocalPlayer, function(p73: userdata?) -- Line: 463
        -- upvalues: Workspace (ref), RaycastParams_new_ret (ref), u14 (ref), u7 (ref), u6 (ref), u11 (ref), u17 (ref), u18 (ref), u19 (ref), u9 (ref)
        local v74 = {};

        if p73 then
            table.insert(v74, p73);
        end;

        if Workspace.CurrentCamera then
            table.insert(v74, Workspace.CurrentCamera);
        end;

        RaycastParams_new_ret.FilterDescendantsInstances = v74;

        if u14 then
            u14 = nil;

            if u7 then
                u7(Enum.UserInputState.End, u6);
            end;
        end;

        u11 = nil;
        u17 = 0;
        u18 = nil;
        u19 = 0;
        u9 = 0;

        return function() -- Line: 466
        end;
    end);

    if not u8 then
        u8 = RunServiceController.BindToRenderStep("MobileAutoShootController.Step", step);
    end;

    DataController.CreateListener(LocalPlayer, "Settings.Game.Other.Mobile Auto Shoot", function(p75: boolean?) -- Line: 471
        -- upvalues: u8 (ref), RunServiceController (ref), step (ref), u14 (ref), u7 (ref), u6 (ref), u11 (ref), u17 (ref), u18 (ref), u19 (ref), u9 (ref)
        local v76 = p75 ~= false;

        if v76 and not u8 then
            u8 = RunServiceController.BindToRenderStep("MobileAutoShootController.Step", step);
        elseif not v76 and u8 then
            u8:Disconnect();
            u8 = nil;

            if u14 then
                u14 = nil;

                if u7 then
                    u7(Enum.UserInputState.End, u6);
                end;
            end;

            u11 = nil;
            u17 = 0;
            u18 = nil;
            u19 = 0;
            u9 = 0;
        end;

        return nil;
    end);
end;

return v1;