-- Decompiled with Potassium's decompiler.

return function(p1: userdata, p2: userdata, p3: string, p4: string) -- Line: 3
    debug.profilebegin("VFX.MuzzleFlash.CloneAsset");
    local v5 = p2:FindFirstChild(p3):Clone();
    v5.Name = p3;
    v5.CollisionGroup = "Debris";
    v5.CanCollide = false;
    v5.CanQuery = false;
    v5.CanTouch = false;
    v5.Anchored = false;
    v5.Massless = true;
    v5.CFrame = p1.CFrame;
    v5.Parent = p1;
    local Instance_new_ret = Instance.new(p4);
    Instance_new_ret.Part0 = p1;
    Instance_new_ret.Part1 = v5;
    Instance_new_ret.Parent = v5;
    debug.profileend();

    return v5;
end;