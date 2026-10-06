-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local TweenService = game:GetService("TweenService");
local Players = game:GetService("Players");
local Debris = workspace:WaitForChild("Debris");
local DataController = require(ReplicatedStorage.Controllers.DataController);
local LocalPlayer = Players.LocalPlayer;
local Janitor = require(ReplicatedStorage.Shared.Janitor);
local Sound = require(ReplicatedStorage.Classes.Sound);
local WedgePart = Instance.new("WedgePart", script);
WedgePart.BottomSurface = Enum.SurfaceType.Smooth;
WedgePart.TopSurface = Enum.SurfaceType.Smooth;
WedgePart.Anchored = true;

local function draw3dTriangle(p1: vector, p2: vector, p3: vector, p4: userdata) -- Line: 30
    -- upvalues: WedgePart (copy)
    debug.profilebegin("VFX.BreakGlass.DrawTriangle");
    local v5 = p2 - p1;
    local v6 = p3 - p1;
    local v7 = p3 - p2;
    local v8 = v5:Dot(v5);
    local v9 = v6:Dot(v6);
    local v10 = v7:Dot(v7);

    if v9 < v8 and v10 < v8 then
        local v11 = p3;
        p3 = p1;
        p1 = p2;
        p2 = v11;
    elseif v10 < v9 then
        if v8 >= v9 then
            local v12 = p2;
            p2 = p1;
            p1 = v12;
        end;
    else
        local v13 = p2;
        p2 = p1;
        p1 = v13;
    end;

    local v14 = p1 - p2;
    local v15 = p3 - p2;
    local v16 = p3 - p1;
    local Unit = v15:Cross(v14).Unit;
    local Unit2 = v16:Cross(Unit).Unit;
    local Unit3 = v16.Unit;
    local v17 = v14:Dot(Unit2);
    local math_abs_ret = math.abs(v17);
    local v18 = WedgePart:Clone();
    local v19 = v14:Dot(Unit3);
    local math_abs_ret2 = math.abs(v19);
    v18.Size = Vector3.new(0, math_abs_ret, math_abs_ret2);
    v18.CFrame = CFrame.fromMatrix((p2 + p1) / 2, Unit, Unit2, Unit3);
    v18.Parent = p4;
    local v20 = WedgePart:Clone();
    local v21 = v15:Dot(Unit3);
    local math_abs_ret3 = math.abs(v21);
    v20.Size = Vector3.new(0, math_abs_ret, math_abs_ret3);
    v20.CFrame = CFrame.fromMatrix((p2 + p3) / 2, -Unit, Unit2, -Unit3);
    v20.Parent = p4;
    debug.profileend();

    return v18, v20;
end;

local function retireSourcePart(p22: userdata, p23: any) -- Line: 76
    p22.CollisionGroup = "Debris";
    p22.Transparency = 1;
    p22.CanCollide = false;
    p22.CastShadow = false;
    p22.CanQuery = false;
    p22.CanTouch = false;
    p22.Anchored = true;
    p23:Add(p22);
    local Parent = p22.Parent;

    if Parent and (Parent:IsA("Model") and Parent:HasTag("BreakableGlass")) then
        p23:Add(Parent);

        for _, descendant in ipairs(Parent:GetDescendants()) do
            if descendant:IsA("Decal") then
                descendant:Destroy();
            end;
        end;
    end;
end;

local u24 = { { 1, 1 }, { 0, 1 }, { -1, 1 }, { -1, 0 }, { -1, -1 }, { 0, -1 }, { 1, -1 }, { 1, 0 } };
local TweenInfo_new_ret = TweenInfo.new(0.25, Enum.EasingStyle.Linear, Enum.EasingDirection.In);

return function(p25: userdata?, p26: vector, p27: vector) -- Line: 104
    -- upvalues: DataController (copy), LocalPlayer (copy), Janitor (copy), Sound (copy), retireSourcePart (copy), u24 (copy), draw3dTriangle (copy), Debris (copy), TweenService (copy), TweenInfo_new_ret (copy)
    debug.profilebegin("VFX.BreakGlass");

    if not p25 then
        debug.profileend();

        return;
    end;

    debug.profilebegin("VFX.BreakGlass.GetSetting");
    local v28 = DataController.Get(LocalPlayer, "Settings.Video.Presets.Glass Shatter") ~= false;
    debug.profileend();
    local u29 = Janitor.new();

    if not v28 then
        debug.profilebegin("VFX.BreakGlass.NoShatter.Sound");
        Sound.new("Bullet"):PlaySoundAtPosition({
            Class = "Bullet",
            Name = "Glass Shattered",
            Position = p26
        });
        debug.profileend();
        debug.profilebegin("VFX.BreakGlass.NoShatter.CleanupSource");
        retireSourcePart(p25, u29);
        debug.profileend();
        task.delay(0.1, function() -- Line: 131
            -- upvalues: u29 (copy)
            debug.profilebegin("VFX.BreakGlass.NoShatter.DelayedCleanup");
            u29:Destroy();
            debug.profileend();
        end);
        debug.profileend();

        return;
    end;

    debug.profilebegin("VFX.BreakGlass.BuildCornerPoints");
    local Size = p25.Size;
    local v30 = Size.Z > Size.X;
    local v31;

    if v30 then
        v31 = Size.Z;
    else
        v31 = Size.X;
    end;

    local v32 = v31 * 0.5;
    local v33 = Size.Y * 0.5;
    local v34 = {};

    for i, v in ipairs(u24) do
        local v35 = v[1] * v32;
        local v36 = v[2] * v33;
        local CFrame2 = p25.CFrame;
        local v37;

        if v30 then
            v37 = CFrame.new(0, v36, v35);
        else
            v37 = CFrame.new(v35, v36, 0);
        end;

        v34[i] = CFrame2 * v37;
    end;

    debug.profileend();
    debug.profilebegin("VFX.BreakGlass.CreateFragments");

    for i, v in ipairs(v34) do
        local u38, u39 = draw3dTriangle(v.Position, (v34[i + 1] or v34[1]).Position, p26, Debris);

        for _, v2 in ipairs({ u38, u39 }) do
            v2.Transparency = math.min(p25.Transparency, 0.6);
            v2.AssemblyLinearVelocity = p27 * 15;
            v2.CollisionGroup = "Debris";
            v2.Color = p25.Color;
            v2.Anchored = false;
        end;

        u29:Add(u38);
        u29:Add(u39);
        task.delay(4.75, function() -- Line: 170
            -- upvalues: u29 (copy), TweenService (ref), u38 (copy), TweenInfo_new_ret (ref), u39 (copy)
            debug.profilebegin("VFX.BreakGlass.FragmentFadeTween");
            u29:Add(TweenService:Create(u38, TweenInfo_new_ret, {
                Transparency = 1
            })):Play();
            u29:Add(TweenService:Create(u39, TweenInfo_new_ret, {
                Transparency = 1
            })):Play();
            debug.profileend();
        end);
    end;

    debug.profileend();
    debug.profilebegin("VFX.BreakGlass.CleanupSource");
    Sound.new("Bullet"):playOneTime({
        Name = "Glass Shattered",
        Parent = p25
    });
    retireSourcePart(p25, u29);
    debug.profileend();
    task.delay(5, function() -- Line: 187
        -- upvalues: u29 (copy)
        debug.profilebegin("VFX.BreakGlass.DelayedCleanup");
        u29:Destroy();
        debug.profileend();
    end);
    debug.profileend();
end;