-- Decompiled with Potassium's decompiler.

local u1 = {};
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Players = game:GetService("Players");
require(script:WaitForChild("Types"));
local LocalPlayer = Players.LocalPlayer;
local CharacterController = require(ReplicatedStorage.Controllers.CharacterController);
local InventoryController = require(ReplicatedStorage.Controllers.InventoryController);
local SpectateController = require(ReplicatedStorage.Controllers.SpectateController);
local CharacterResolver = require(ReplicatedStorage.Components.Common.CharacterResolver);
local RuntimeKinematics = require(ReplicatedStorage.MovementV2.RuntimeKinematics);
local RunServiceController = require(ReplicatedStorage.Controllers.RunServiceController);
local Spring = require(ReplicatedStorage.Shared.Spring);
local u2 = Spring.new(1, 2.5, 1);
local u3 = Spring.new(0.85, 0.5, Vector2.zero);
local u4 = false;
local u5 = 0;
local u6 = nil;
local u7 = nil;
local u8 = nil;

local function getMovementSpeed(p9: userdata) -- Line: 50
    -- upvalues: RuntimeKinematics (copy)
    local Velocity = RuntimeKinematics.getVelocity(p9, p9.PrimaryPart);

    return Vector3.new(Velocity.X, 0, Velocity.Z).Magnitude;
end;

local function isCharacterMoving(p10: userdata) -- Line: 55
    -- upvalues: RuntimeKinematics (copy)
    local Velocity = RuntimeKinematics.getVelocity(p10, p10.PrimaryPart);

    return Vector3.new(Velocity.X, 0, Velocity.Z).Magnitude > 0.1;
end;

local function isCharacterJumping(p11: userdata) -- Line: 59
    -- upvalues: RuntimeKinematics (copy)
    return not RuntimeKinematics.isOnGround(p11);
end;

function u1.toggle(p12: boolean) -- Line: 66
    -- upvalues: u6 (ref), u7 (ref), u8 (ref), u2 (copy), u5 (ref)
    u6.Visible = p12;
    u6.Blur.Visible = true;
    local v13 = p12 and 3 or 1;
    local v14 = p12 and 4 or 2;

    if u7 and u7.Parent then
        u7.ZIndex = v13;
    end;

    if u8 and u8.Parent then
        u8.ZIndex = v14;
    end;

    if not p12 then
        u5 = 0;

        return;
    end;

    u2:setPosition(1);
    u2:setGoal(0);
    u5 = tick();
end;

function u1.updateMovementSharpness(p15: userdata, p16: boolean) -- Line: 84
    -- upvalues: RuntimeKinematics (copy), InventoryController (copy), u2 (copy), u5 (ref)
    local Velocity = RuntimeKinematics.getVelocity(p15, p15.PrimaryPart);
    local Magnitude = Vector3.new(Velocity.X, 0, Velocity.Z).Magnitude;
    local v17 = math.min(Magnitude, 3) / 3;
    local CurrentEquipped = InventoryController.getCurrentEquipped();
    local v18 = CurrentEquipped and CurrentEquipped.Properties;

    if v18 then
        if CurrentEquipped.Properties.AimingOptions == "SniperScope" and (CurrentEquipped.Properties.MuzzleType == "Sniper" and (CurrentEquipped.Properties.Spread.Range.Min == 0 and CurrentEquipped.Properties.Spread.PerShot == 0)) then
            v18 = CurrentEquipped.Properties.Spread.MovementMultiplier == 2;
        else
            v18 = false;
        end;
    end;

    local v19;

    if v18 and not RuntimeKinematics.isOnGround(p15) then
        local Y = RuntimeKinematics.getVelocity(p15, p15.PrimaryPart).Y;
        v19 = math.abs(Y) <= 3;
    else
        v19 = false;
    end;

    if p16 then
        u2:setPosition(1);
        u2:setGoal(0);
        u5 = tick();

        return;
    end;

    if RuntimeKinematics.isOnGround(p15) then
        if v17 > 0.1 then
            u2:setPosition(v17);

            return;
        end;

        if tick() - u5 > 1.2 then
            u2:reset(0);
        end;

        return;
    end;

    if not (v18 and v19) then
        u2:setPosition(1);

        return;
    end;

    u2:setPosition(0);
    u2:setGoal(0);
end;

function u1.updateScope(p20: userdata, p21: number) -- Line: 127
    -- upvalues: CharacterResolver (copy), RuntimeKinematics (copy), u4 (ref), u1 (copy), CharacterController (copy), u3 (copy), u6 (ref), u2 (copy)
    if not CharacterResolver.isAliveCharacter(p20) then
        return;
    end;

    local v22 = not RuntimeKinematics.isOnGround(p20);
    u1.updateMovementSharpness(p20, u4 and not v22);
    u4 = v22;
    local Velocity = RuntimeKinematics.getVelocity(p20, p20.PrimaryPart);

    if Vector3.new(Velocity.X, 0, Velocity.Z).Magnitude > 0.1 then
        local Velocity2 = RuntimeKinematics.getVelocity(p20, p20.PrimaryPart);
        local Magnitude = Vector3.new(Velocity2.X, 0, Velocity2.Z).Magnitude;
        local math_min_ret = math.min(Magnitude, 3);
        local v23 = CharacterController.GetCrouchState() and 0.5 or (CharacterController.GetWalkState() and 0.75 or 1);
        local Vector2_new = Vector2.new;
        local v24 = tick() * 3.141592653589793 * 1.75 * v23;
        local math_sin_ret = math.sin(v24);
        local v25 = tick() * 3.141592653589793 * 2.75 * v23;
        u3:setPosition(Vector2_new(math_sin_ret, (math.sin(v25))) * math_min_ret * 1.5);
        local Position = u3:getPosition();
        u6.Position = UDim2.new(0.5, Position.X, 0.5, Position.Y);
    else
        u3:reset(Vector2.zero);
        u6.Position = UDim2.fromScale(0.5, 0.5);
    end;

    u6.Blur.ImageTransparency = 1 - u2:getPosition();
    u6.Sharp.ImageTransparency = u2:getPosition();
end;

function u1.Initialize(p26, p27) -- Line: 166
    -- upvalues: u6 (ref), u7 (ref), u8 (ref), RunServiceController (copy), LocalPlayer (copy), CharacterResolver (copy), InventoryController (copy), SpectateController (copy), u2 (copy), u3 (copy), u1 (copy)
    u6 = p27;
    local v28 = p27.Parent and p27.Parent.Parent;

    if v28 then
        u7 = v28:FindFirstChild("Bottom");
        u8 = v28:FindFirstChild("Top");

        if u7 then
            u7.ZIndex = 1;
        end;

        if u8 then
            u8.ZIndex = 2;
        end;
    end;

    RunServiceController.BindToRenderStep("UI.SniperScope.Update", function(p29: number) -- Line: 177
        -- upvalues: LocalPlayer (ref), CharacterResolver (ref), InventoryController (ref), SpectateController (ref), u2 (ref), u3 (ref), u1 (ref), u6 (ref), u7 (ref), u8 (ref)
        local v30 = LocalPlayer:GetAttribute("IsSpectating") == true;
        local Character = LocalPlayer.Character;

        if v30 or CharacterResolver.isAliveCharacter(Character) then
            local CurrentEquipped = InventoryController.getCurrentEquipped();
            local CurrentSpectateInstance = SpectateController.GetCurrentSpectateInstance();
            local v31 = false;

            if v30 and CurrentSpectateInstance then
                if CurrentSpectateInstance.CurrentEquipped then
                    local Name = CurrentSpectateInstance.CurrentEquipped.Name;

                    if (Name == "AWP" and true or Name == "SSG 08") and CurrentSpectateInstance.PerspectiveState == "First-Person" then
                        v31 = (CurrentSpectateInstance.Player:GetAttribute("ScopeIncrement") or 0) > 0;
                        Character = CurrentSpectateInstance.Character;
                    end;
                end;
            else
                v31 = CurrentEquipped and CurrentEquipped.IsAiming and CurrentEquipped.Properties.AimingOptions == "SniperScope";
            end;

            u2:update(p29);
            u3:update(p29);

            if v31 and Character then
                u1.updateScope(Character, p29);

                if not u6.Visible then
                    u1.toggle(true);
                end;
            elseif u6.Visible then
                u1.toggle(false);
            end;
        elseif u6.Visible then
            u1.toggle(false);
        end;

        if not u6.Visible then
            if u7 and u7.Parent then
                u7.ZIndex = 1;
            end;

            if u8 and u8.Parent then
                u8.ZIndex = 2;
            end;
        end;
    end);
end;

return u1;