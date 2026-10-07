-- ReplicatedStorage.Components.Common.VFXLibary.BreakGlass
-- Script path: ReplicatedStorage.Components.Common.VFXLibary.BreakGlass
-- Decompile time: 6.17 ms

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local Debris = workspace:WaitForChild("Debris")
local DataController = require(ReplicatedStorage.Controllers.DataController)
local LocalPlayer = Players.LocalPlayer
local Janitor = require(ReplicatedStorage.Shared.Janitor)
local Sound = require(ReplicatedStorage.Classes.Sound)
local u36 = Instance.new("WedgePart", script)
u36.BottomSurface = Enum.SurfaceType.Smooth
u36.TopSurface = Enum.SurfaceType.Smooth
u36.Anchored = true

local function draw3dTriangle(a1, a2, a3, a4) -- Line: 30
    -- upvalues: u36 (val)
    local v1, v2, v3
    debug.profilebegin("VFX.BreakGlass.DrawTriangle")
    local v4 = a2 - a1
    local v5 = a3 - a1
    local v6 = a3 - a2
    local v7 = v4:Dot(v4)
    local v8 = v5:Dot(v5)
    local v9 = v6:Dot(v6)
    if not (v8 < v7) then
        if not (v9 < v8) or not (v7 < v8) then
            v1, v3 = a1, a3
        else
            v2 = a2
            a2 = a1
            v1 = v2
            v3 = a3
        end
    elseif v9 < v7 then
        v1 = a3
        v3 = a1
    elseif not (v9 < v8) or not (v7 < v8) then
        v1, v3 = a1, a3
    else
        v2 = a2
        a2 = a1
        v1 = v2
        v3 = a3
    end
    v4 = a2 - v1
    v5 = v3 - v1
    v6 = v3 - a2
    local Unit = v5:Cross(v4).Unit
    local Unit_2 = v6:Cross(Unit).Unit
    local Unit_3 = v6.Unit
    local v10 = math.abs((v4:Dot(Unit_2)))
    local v11 = u36:Clone()
    v11.Size = Vector3.new(0, v10, (math.abs((v4:Dot(Unit_3)))))
    v11.CFrame = CFrame.fromMatrix((v1 + a2) / 2, Unit, Unit_2, Unit_3)
    v11.Parent = a4
    local v12 = u36:Clone()
    v12.Size = Vector3.new(0, v10, (math.abs((v5:Dot(Unit_3)))))
    v12.CFrame = CFrame.fromMatrix((v1 + v3) / 2, -Unit, Unit_2, -Unit_3)
    v12.Parent = a4
    debug.profileend()
    return v11, v12
end

local function retireSourcePart(a1, a2) -- Line: 76 -- types: a1: userdata
    a1.CollisionGroup = "Debris"
    a1.Transparency = 1
    a1.CanCollide = false
    a1.CastShadow = false
    a1.CanQuery = false
    a1.CanTouch = false
    a1.Anchored = true
    a2:Add(a1)
    local Parent = a1.Parent
    if Parent and Parent:IsA("Model") and Parent:HasTag("BreakableGlass") then
        a2:Add(Parent)
        for i, v in ipairs(Parent:GetDescendants()) do
            if v:IsA("Decal") then
                v:Destroy()
            end
        end
    end
end

local u42 = {{1, 1}, {0, 1}, {-1, 1}, {-1, 0}, {-1, -1}, {0, -1}, {1, -1}, {1, 0}}
local u71 = TweenInfo.new(0.25, Enum.EasingStyle.Linear, Enum.EasingDirection.In)
return function(a1, a2, a3) -- Line: 104
    -- upvalues: DataController (val), LocalPlayer (val), Janitor (val), Sound (val), retireSourcePart (val), u42 (val)
    -- upvalues: draw3dTriangle (val), Debris (val), TweenService (val), u71 (val)
    local CFrame_2, v1, v2, v3, v4
    debug.profilebegin("VFX.BreakGlass")
    if not a1 then
        debug.profileend()
        return
    end
    debug.profilebegin("VFX.BreakGlass.GetSetting")
    local v5 = DataController.Get(LocalPlayer, "Settings.Video.Presets.Glass Shatter") ~= false
    debug.profileend()
    local u235 = Janitor.new()
    if not v5 then
        debug.profilebegin("VFX.BreakGlass.NoShatter.Sound")
        ;(Sound.new("Bullet")):PlaySoundAtPosition({Class = "Bullet", Name = "Glass Shattered", Position = a2})
        debug.profileend()
        debug.profilebegin("VFX.BreakGlass.NoShatter.CleanupSource")
        retireSourcePart(a1, u235)
        debug.profileend()
        task.delay(0.1, function() -- Line: 131 -- upvalues: u235 (val)
            debug.profilebegin("VFX.BreakGlass.NoShatter.DelayedCleanup")
            u235:Destroy()
            debug.profileend()
        end)
        debug.profileend()
        return
    end
    debug.profilebegin("VFX.BreakGlass.BuildCornerPoints")
    local Size = a1.Size
    local Z_2 = if not (Size.X < Size.Z) then Size.X else Size.Z
    local v6 = Z_2 * 0.5
    local v7 = Size.Y * 0.5
    local v8 = {}
    local v9, v10, v11 = a1, a2, a3
    for i, v in ipairs(u42) do
        v1 = v[1] * v6
        v2 = v[2] * v7
        CFrame_2 = v9.CFrame
        v3 = if not v4 then CFrame.new(v1, v2, 0) else CFrame.new(0, v2, v1)
        v8[i] = CFrame_2 * v3
    end
    debug.profileend()
    debug.profilebegin("VFX.BreakGlass.CreateFragments")
    for i2, i3 in ipairs(v8) do
        v1 = v8[i2 + 1] or v8[1]
        u142, u143 = draw3dTriangle(i3.Position, v1.Position, v10, Debris)
        for i4, j in ipairs({u142, u143}) do
            j.Transparency = math.min(v9.Transparency, 0.6)
            j.AssemblyLinearVelocity = v11 * 15
            j.CollisionGroup = "Debris"
            j.Color = v9.Color
            j.Anchored = false
        end
        u235:Add(u142)
        u235:Add(u143)
        task.delay(4.75, function() -- Line: 170 -- upvalues: u235 (val), TweenService (upval), u142 (val), u71 (upval), u143 (val)
            debug.profilebegin("VFX.BreakGlass.FragmentFadeTween")
            u235:Add((TweenService:Create(u142, u71, {Transparency = 1}))):Play()
            u235:Add((TweenService:Create(u143, u71, {Transparency = 1}))):Play()
            debug.profileend()
        end)
    end
    debug.profileend()
    debug.profilebegin("VFX.BreakGlass.CleanupSource")
    ;(Sound.new("Bullet")):playOneTime({Name = "Glass Shattered", Parent = v9})
    retireSourcePart(v9, u235)
    debug.profileend()
    task.delay(5, function() -- Line: 187 -- upvalues: u235 (val)
        debug.profilebegin("VFX.BreakGlass.DelayedCleanup")
        u235:Destroy()
        debug.profileend()
    end)
    debug.profileend()
end