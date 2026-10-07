-- ReplicatedStorage.Components.Common.VFXLibary.CreateMuzzleFlash.GetMuzzleFlash
-- Script path: ReplicatedStorage.Components.Common.VFXLibary.CreateMuzzleFlash.GetMuzzleFlash
-- Decompile time: 0.22 ms

return function(a1, a2, a3, a4) -- Line: 3 -- types: a1: userdata, a2: userdata, a3: string, a4: string
    debug.profilebegin("VFX.MuzzleFlash.CloneAsset")
    local v1 = a2:FindFirstChild(a3):Clone()
    v1.Name = a3
    v1.CollisionGroup = "Debris"
    v1.CanCollide = false
    v1.CanQuery = false
    v1.CanTouch = false
    v1.Anchored = false
    v1.Massless = true
    v1.CFrame = a1.CFrame
    v1.Parent = a1
    local v2 = Instance.new(a4)
    v2.Part0 = a1
    v2.Part1 = v1
    v2.Parent = v1
    debug.profileend()
    return v1
end