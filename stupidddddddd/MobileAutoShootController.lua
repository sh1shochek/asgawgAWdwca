-- ReplicatedStorage.Controllers.MobileAutoShootController
-- Script path: ReplicatedStorage.Controllers.MobileAutoShootController
-- Decompile time: 11.14 ms

local v1 = {}
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local InventoryController = require(ReplicatedStorage.Controllers.InventoryController)
local DataController = require(ReplicatedStorage.Controllers.DataController)
local RunServiceController = require(ReplicatedStorage.Controllers.RunServiceController)
local FlashEffect = require(ReplicatedStorage.Components.Common.VFXLibary.FlashEffect)
local CharacterResolver = require(ReplicatedStorage.Components.Common.CharacterResolver)
local CharacterPresentationDescriptor = require(ReplicatedStorage.Components.Common.CharacterPresentationDescriptor)
local GetUserPlatform = require(ReplicatedStorage.Components.Common.GetUserPlatform)
local LocalPlayer = Players.LocalPlayer
local v2 = GetUserPlatform()
local u60 = false
if table.find(v2, "Mobile") ~= nil then
    u60 = #v2 <= 1
end
local u61 = {["Counter-Terrorists"] = true, Terrorists = true}
local u64 = {}
local identity = CFrame.identity
local v3 = CFrame.Angles(0.017453292519943295, 0, 0)
local v4 = CFrame.Angles(-0.017453292519943295, 0, 0)
local v5 = CFrame.Angles(0, 0.017453292519943295, 0)
local v6 = CFrame.Angles(0, -0.017453292519943295, 0)
local v7 = CFrame.Angles(0.012217304763960306, 0.012217304763960306, 0)
local v8 = CFrame.Angles(0.012217304763960306, -0.012217304763960306, 0)
local v9 = CFrame.Angles(-0.012217304763960306, 0.012217304763960306, 0)
u64[1] = identity
u64[2] = v3
u64[3] = v4
u64[4] = v5
u64[5] = v6
u64[6] = v7
u64[7] = v8
u64[8] = v9
u64[9] = CFrame.Angles(-0.012217304763960306, -0.012217304763960306, 0)
local u106 = {UserInputType = Enum.UserInputType.Touch}
local u109 = RaycastParams.new()
u109.FilterType = Enum.RaycastFilterType.Exclude
u109.IgnoreWater = true
local u112 = nil
local u113 = nil
local u115 = Random.new()
local u116 = 0
local u117 = false
local u118 = nil
local u119 = 0
local u120 = 0
local u121 = nil
local u122 = 0
local u123 = 0
local u124 = 0
local u125 = nil
local u126 = 0

local function refreshRaycastFilter(a1) -- Line: 107 -- upvalues: Workspace (val), u109 (val) -- types: a1: userdata?
    local v1 = {}
    if a1 then
        table.insert(v1, a1)
    end
    if Workspace.CurrentCamera then
        table.insert(v1, Workspace.CurrentCamera)
    end
    u109.FilterDescendantsInstances = v1
end

local function isEnemyTeam(a1) -- Line: 121 -- upvalues: LocalPlayer (val), u61 (val), Workspace (val)
    local Attribute = LocalPlayer:GetAttribute("Team")
    if u61[Attribute] and u61[a1] then
        local v1 = true
        if Workspace:GetAttribute("Gamemode") ~= "Deathmatch" then
            v1 = a1 ~= Attribute
        end
        return v1
    end
    return false
end

local function getBotShell(a1) -- Line: 133 -- types: a1: userdata
    local Parent = a1
    while Parent do
        if not Parent:IsA("Model") then
            break
        end
        if Parent:GetAttribute("Bot") == true then
            return Parent
        end
        Parent = Parent.Parent
    end
    return nil
end

local function getEnemyCharacter(a1) -- Line: 147
    -- upvalues: getBotShell (val), CharacterPresentationDescriptor (val), CharacterResolver (val), LocalPlayer (val)
    -- upvalues: u61 (val), Workspace (val)
    local v1
    local v2 = a1:FindFirstAncestorOfClass("Model")
    if not v2 then
        return nil
    end
    local v3 = getBotShell(v2)
    if v3 then
        if v3:GetAttribute(CharacterPresentationDescriptor.VisibleAttribute) == false then
            return nil
        end
        if CharacterResolver.isAliveCharacter(v3) then
            local Attribute = v3:GetAttribute("Team")
            local Attribute_2 = LocalPlayer:GetAttribute("Team")
            if not u61[Attribute_2] then
                v1 = false
            elseif u61[Attribute] then
                v1 = true
                if Workspace:GetAttribute("Gamemode") ~= "Deathmatch" then
                    v1 = Attribute ~= Attribute_2
                end
            else
                v1 = false
            end
            if v1 then
                return v3
            end
        end
        return nil
    end
    if not CharacterResolver.isAliveCharacter(v2) then
        return nil
    end
    v1 = CharacterResolver.getPlayerFromCharacter(v2)
    if v1 then
        local v4
        local Attribute_3 = v1:GetAttribute("Team")
        local Attribute_4 = LocalPlayer:GetAttribute("Team")
        if not u61[Attribute_4] then
            v4 = false
        elseif u61[Attribute_3] then
            v4 = true
            if Workspace:GetAttribute("Gamemode") ~= "Deathmatch" then
                v4 = Attribute_3 ~= Attribute_4
            end
        else
            v4 = false
        end
        if v4 then
            return v2
        end
    end
    return nil
end

local function clipSlab(a1, a2, a3, a4, a5, a6) -- Line: 178
    -- upvalues: 
    if (math.abs(a2)) < 0.0001 then
        if not (a1 < a3) and not (a4 < a1) then
            return a5, a6
        end
        return 1, 0
    end
    local v1 = (a3 - a1) / a2
    local v2 = (a4 - a1) / a2
    if v2 < v1 then
        local v3 = v2
        v2 = v1
        v1 = v3
    end
    return (math.max(a5, v1)), (math.min(a6, v2))
end

local function doesRayHitBox(a1, a2, a3, a4, a5) -- Line: 197
    -- upvalues: 
    local v1, v2, v3, v4, v5, v6
    local X = a1.X
    local X_2 = a2.X
    local X_3 = a3.X
    local X_4 = a4.X
    local v7 = math.abs(X_2)
    if not (v7 < 0.0001) then
        v7 = (X_3 - X) / X_2
        local v8 = (X_4 - X) / X_2
        if v8 < v7 then
            local v9 = v8
            v8 = v7
            v7 = v9
        end
        v3 = math.max(0, v7)
        v4 = math.min(a5, v8)
    elseif X < X_3 then
        v3 = 1
        v4 = 0
    elseif not (X_4 < X) then
        v3 = 0
        v4 = a5
    else
        v3 = 1
        v4 = 0
    end
    if v4 < v3 then
        return false
    end
    local Y = a1.Y
    local Y_2 = a2.Y
    local Y_3 = a3.Y
    local Y_4 = a4.Y
    local v10 = math.abs(Y_2)
    if not (v10 < 0.0001) then
        v10 = (Y_3 - Y) / Y_2
        v1 = (Y_4 - Y) / Y_2
        if v1 < v10 then
            v2 = v1
            v1 = v10
            v10 = v2
        end
        v5 = math.max(v3, v10)
        v6 = math.min(v4, v1)
    elseif Y < Y_3 then
        v5 = 1
        v6 = 0
    elseif not (Y_4 < Y) then
        v5 = v3
        v6 = v4
    else
        v5 = 1
        v6 = 0
    end
    v3 = v5
    v4 = v6
    if v4 < v3 then
        return false
    end
    local Z = a1.Z
    local Z_2 = a2.Z
    local Z_3 = a3.Z
    local Z_4 = a4.Z
    v10 = math.abs(Z_2)
    if not (v10 < 0.0001) then
        v10 = (Z_3 - Z) / Z_2
        v1 = (Z_4 - Z) / Z_2
        if v1 < v10 then
            v2 = v1
            v1 = v10
            v10 = v2
        end
        v5 = math.max(v3, v10)
        v6 = math.min(v4, v1)
    elseif Z < Z_3 then
        v5 = 1
        v6 = 0
    elseif not (Z_4 < Z) then
        v5 = v3
        v6 = v4
    else
        v5 = 1
        v6 = 0
    end
    v5 = v5 <= v6
    return v5
end

local function isRayBlockedBySmoke(a1, a2, a3) -- Line: 213
    -- upvalues: Workspace (val), doesRayHitBox (val)
    local Position, v1
    local Debris = Workspace:FindFirstChild("Debris")
    if not Debris then
        return false
    end
    local v2, v3, v4 = a1, a2, a3
    for i, j in Debris:GetChildren() do
        if j:IsA("Folder") and string.sub(j.Name, 1, 11) == "VoxelSmoke_" then
            for k, n in j:GetChildren() do
                if n.Name == "SmokeVoxel" and n:IsA("BasePart") then
                    v1 = n.Size / 2
                    Position = n.Position
                    if doesRayHitBox(v2, v3, Position - v1, Position + v1, v4) then
                        return true
                    end
                end
            end
        end
    end
    return false
end

local function getHoveredEnemy(a1) -- Line: 238
    -- upvalues: Workspace (val), CharacterResolver (val), u64 (val), u109 (val), getEnemyCharacter (val)
    -- upvalues: isRayBlockedBySmoke (val)
    local CurrentCamera = Workspace.CurrentCamera
    if CurrentCamera and CharacterResolver.getLocalCharacter() then
        local LookVector, v1, v2
        local CFrame = CurrentCamera.CFrame
        local Position = CFrame.Position
        local v3 = nil
        local v4 = nil
        for i, j in u64, v3, v4 do
            LookVector = (CFrame * j).LookVector
            v1 = Workspace:Raycast(Position, LookVector * a1, u109)
            v2 = v1 and getEnemyCharacter(v1.Instance)
            if v2 and not isRayBlockedBySmoke(Position, LookVector, v1.Distance) then
                return v2, v1.Distance
            end
        end
        return nil, 0
    end
    return nil, 0
end

local function pressFire(a1) -- Line: 261 -- upvalues: u112 (ref), u121 (ref), u122 (ref), u123 (ref), u106 (val)
    if not u112 then
        return
    end
    u121 = a1
    u122 = os.clock()
    u123 = a1.Rounds
    u112(Enum.UserInputState.Begin, u106)
end

local function releaseFire() -- Line: 273 -- upvalues: u121 (ref), u112 (ref), u106 (val)
    if not u121 then
        return
    end
    u121 = nil
    if u112 then
        u112(Enum.UserInputState.End, u106)
    end
end

local function clearTargetState() -- Line: 285 -- upvalues: u118 (ref), u124 (ref), u125 (ref), u126 (ref), u116 (ref)
    u118 = nil
    u124 = 0
    u125 = nil
    u126 = 0
    u116 = 0
end

local function resetState() -- Line: 295
    -- upvalues: u121 (ref), u112 (ref), u106 (val), u118 (ref), u124 (ref), u125 (ref), u126 (ref), u116 (ref)
    if u121 then
        u121 = nil
        if u112 then
            u112(Enum.UserInputState.End, u106)
        end
    end
    u118 = nil
    u124 = 0
    u125 = nil
    u126 = 0
    u116 = 0
end

local function getBurstSize(a1, a2) -- Line: 304 -- types: a2: number
    if not a1.Properties.Automatic then
        return 1
    end
    if a2 <= 30 then
        return (1 / 0)
    end
    if a2 <= 80 then
        return 4
    end
    return 2
end

local function isWeaponRecovered(a1, a2) -- Line: 317 -- upvalues: u125 (ref) -- types: a2: number
    if u125 and not (0.9 <= a2 - u125) then
        local Recoil = a1.Recoil
        if Recoil then
            local Time = Recoil.Time
            if Recoil.ActiveFireRate * 0.25 < Time then
                return false
            end
        end
        local Spread = a1.Properties.Spread
        if not Spread then
            return true
        end
        local Range = Spread.Range
        return (a1:getBaseSpread()) <= Range.Min + (Range.Max - Range.Min) * 0.3
    end
    return true
end

local function updatePendingPress(a1, a2) -- Line: 338
    -- upvalues: u121 (ref), u123 (ref), u112 (ref), u106 (val), u124 (ref), u125 (ref), u122 (ref)
    if not u121 then
        return
    end
    if a1 and a1 == u121 and a1.Rounds < u123 then
        if u121 then
            u121 = nil
            if u112 then
                u112(Enum.UserInputState.End, u106)
            end
        end
        u124 = u124 + 1
        u125 = a2
        return
    end
    if a1 == u121 and not (0.5 < a2 - u122) then
        return
    end
    if not u121 then
        return
    end
    u121 = nil
    if u112 then
        u112(Enum.UserInputState.End, u106)
    end
end

local function step() -- Line: 354
    -- upvalues: u117 (ref), InventoryController (val), u121 (ref), u123 (ref), u112 (ref), u106 (val), u124 (ref)
    -- upvalues: u125 (ref), u122 (ref), FlashEffect (val), u118 (ref), u126 (ref), u116 (ref), getHoveredEnemy (val)
    -- upvalues: u119 (ref), u120 (ref), u115 (val)
    if u117 then
        return
    end
    local v1 = os.clock()
    local v2 = InventoryController.getCurrentEquipped()
    local v3 = if not v2 then nil else if v2.Properties.Class ~= "Weapon" then nil else v2
    if u121 then
        if not v3 or v3 ~= u121 then
            if v3 ~= u121 then
                if u121 then
                    u121 = nil
                    if u112 then
                        u112(Enum.UserInputState.End, u106)
                    end
                end
            elseif 0.5 < v1 - u122 and u121 then
                u121 = nil
                if u112 then
                    u112(Enum.UserInputState.End, u106)
                end
            end
        elseif v3.Rounds < u123 then
            if u121 then
                u121 = nil
                if u112 then
                    u112(Enum.UserInputState.End, u106)
                end
            end
            u124 = u124 + 1
            u125 = v1
        elseif v3 ~= u121 then
            if u121 then
                u121 = nil
                if u112 then
                    u112(Enum.UserInputState.End, u106)
                end
            end
        elseif 0.5 < v1 - u122 and u121 then
            u121 = nil
            if u112 then
                u112(Enum.UserInputState.End, u106)
            end
        end
    end
    if v3 and not (v3.Rounds <= 0) and not FlashEffect.IsFlashed() then
        if not u118 and v1 < u116 then
            return
        end
        u116 = v1 + 0.03333333333333333
        debug.profilebegin("MobileAutoShootController.Scan")
        local v4, v5 = getHoveredEnemy(v3.IsAiming and v3.Properties.Range or 180)
        debug.profileend()
        if not v4 then
            if u118 and 0.12 < v1 - u119 then
                if u121 then
                    u121 = nil
                    if u112 then
                        u112(Enum.UserInputState.End, u106)
                    end
                end
                u118 = nil
                u124 = 0
                u125 = nil
                u126 = 0
                u116 = 0
            end
            return
        end
        u119 = v1
        if not u118 then
            u118 = v1
            u120 = u115:NextNumber(0.12, 0.2)
        end
        if not u121 and not v3.IsShooting then
            local v6 = v1 - u118
            if not (v6 < u120) then
                v6 = u124
                if (if v3.Properties.Automatic then if not (v5 <= 30) then if not (v5 <= 80) then 2 else 4 else (1 / 0) else 1) <= v6 then
                    if not u125 then
                        v6 = true
                    elseif not (0.9 <= v1 - u125) then
                        local Range, Spread
                        local Recoil = v3.Recoil
                        if not Recoil then
                            Spread = v3.Properties.Spread
                            if not Spread then
                                v6 = true
                            else
                                Range = Spread.Range
                                v6 = (v3:getBaseSpread()) <= Range.Min + (Range.Max - Range.Min) * 0.3
                            end
                        else
                            local Time = Recoil.Time
                            if not (Recoil.ActiveFireRate * 0.25 < Time) then
                                Spread = v3.Properties.Spread
                                if not Spread then
                                    v6 = true
                                else
                                    Range = Spread.Range
                                    v6 = (v3:getBaseSpread()) <= Range.Min + (Range.Max - Range.Min) * 0.3
                                end
                            else
                                v6 = false
                            end
                        end
                    else
                        v6 = true
                    end
                    if not v6 then
                        return
                    end
                    u124 = 0
                    u126 = v1 + u115:NextNumber(0, 0.04)
                end
                if u126 <= v1 then
                    if not u112 then
                        return
                    end
                    u121 = v3
                    u122 = os.clock()
                    u123 = v3.Rounds
                    u112(Enum.UserInputState.Begin, u106)
                end
                return
            end
        end
        return
    end
    if u118 then
        if u121 then
            u121 = nil
            if u112 then
                u112(Enum.UserInputState.End, u106)
            end
        end
        u118 = nil
        u124 = 0
        u125 = nil
        u126 = 0
        u116 = 0
    end
end

local function setEnabled(a1) -- Line: 423
    -- upvalues: u113 (ref), RunServiceController (val), step (val), u121 (ref), u112 (ref), u106 (val), u118 (ref)
    -- upvalues: u124 (ref), u125 (ref), u126 (ref), u116 (ref)
    if a1 and not u113 then
        u113 = RunServiceController.BindToRenderStep("MobileAutoShootController.Step", step)
        return
    end
    if not a1 and u113 then
        u113:Disconnect()
        u113 = nil
        if u121 then
            u121 = nil
            if u112 then
                u112(Enum.UserInputState.End, u106)
            end
        end
        u118 = nil
        u124 = 0
        u125 = nil
        u126 = 0
        u116 = 0
    end
end

function v1.SetManualFireHeld(a1) -- Line: 438
    -- upvalues: u117 (ref), u121 (ref), u118 (ref), u124 (ref), u125 (ref), u126 (ref), u116 (ref)
    u117 = a1
    if a1 then
        u121 = nil
        u118 = nil
        u124 = 0
        u125 = nil
        u126 = 0
        u116 = 0
    end
end

function v1.Start() -- Line: 450
    -- upvalues: u60 (val), ReplicatedStorage (val), u112 (ref), Workspace (val), CharacterResolver (val), u109 (val)
    -- upvalues: LocalPlayer (val), u121 (ref), u106 (val), u118 (ref), u124 (ref), u125 (ref), u126 (ref), u116 (ref)
    -- upvalues: u113 (ref), RunServiceController (val), step (val), DataController (val)
    if not u60 then
        return
    end
    u112 = require(ReplicatedStorage.Controllers.InputController.Actions.Fire).Callback
    ;(Workspace:GetPropertyChangedSignal("CurrentCamera")):Connect(function() -- Line: 459 -- upvalues: CharacterResolver (upval), Workspace (upval), u109 (upval)
        local v1 = CharacterResolver.getLocalCharacter()
        local v2 = {}
        if v1 then
            table.insert(v2, v1)
        end
        if Workspace.CurrentCamera then
            table.insert(v2, Workspace.CurrentCamera)
        end
        u109.FilterDescendantsInstances = v2
    end)
    CharacterResolver.observeCharacter(LocalPlayer, function(a1) -- Line: 463
        -- upvalues: Workspace (upval), u109 (upval), u121 (upval), u112 (upval), u106 (upval), u118 (upval)
        -- upvalues: u124 (upval), u125 (upval), u126 (upval), u116 (upval)
        local v1 = {}
        if a1 then
            table.insert(v1, a1)
        end
        if Workspace.CurrentCamera then
            table.insert(v1, Workspace.CurrentCamera)
        end
        u109.FilterDescendantsInstances = v1
        if u121 then
            u121 = nil
            if u112 then
                u112(Enum.UserInputState.End, u106)
            end
        end
        u118 = nil
        u124 = 0
        u125 = nil
        u126 = 0
        u116 = 0
        return function() end
    end)
    if not u113 then
        u113 = RunServiceController.BindToRenderStep("MobileAutoShootController.Step", step)
    end
    DataController.CreateListener(LocalPlayer, "Settings.Game.Other.Mobile Auto Shoot", function(a1) -- Line: 471
        -- upvalues: u113 (upval), RunServiceController (upval), step (upval), u121 (upval), u112 (upval), u106 (upval)
        -- upvalues: u118 (upval), u124 (upval), u125 (upval), u126 (upval), u116 (upval)
        local v1 = a1 ~= false
        if not v1 then
            if not v1 and u113 then
                u113:Disconnect()
                u113 = nil
                if u121 then
                    u121 = nil
                    if u112 then
                        u112(Enum.UserInputState.End, u106)
                    end
                end
                u118 = nil
                u124 = 0
                u125 = nil
                u126 = 0
                u116 = 0
            end
        elseif not u113 then
            u113 = RunServiceController.BindToRenderStep("MobileAutoShootController.Step", step)
        elseif not v1 and u113 then
            u113:Disconnect()
            u113 = nil
            if u121 then
                u121 = nil
                if u112 then
                    u112(Enum.UserInputState.End, u106)
                end
            end
            u118 = nil
            u124 = 0
            u125 = nil
            u126 = 0
            u116 = 0
        end
        return nil
    end)
end

return v1