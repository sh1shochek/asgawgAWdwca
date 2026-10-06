-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Debris = game:GetService("Debris");
local Other = ReplicatedStorage:WaitForChild("Assets"):WaitForChild("Other");
local Debris2 = workspace:WaitForChild("Debris");

local function getNumberAttribute(p1: userdata, p2: string, p3: number) -- Line: 13
    local Attribute = p1:GetAttribute(p2);

    if typeof(Attribute) == "number" then
        return Attribute;
    end;

    return p3;
end;

local function getBeamUpVector(p4: vector, p5: vector) -- Line: 18
    local v6 = p5 - p4 * p5:Dot(p4);

    if v6.Magnitude <= 0.001 then
        v6 = Vector3.new(0, 1, 0) - p4 * (Vector3.new(0, 1, 0)):Dot(p4);
    end;

    if v6.Magnitude <= 0.001 then
        v6 = Vector3.new(0, 0, 1) - p4 * (Vector3.new(0, 0, 1)):Dot(p4);
    end;

    return v6.Unit;
end;

local function getBeamCleanupTime(p7: userdata) -- Line: 31
    local v8 = 5;

    for _, descendant in ipairs(p7:GetDescendants()) do
        if descendant:IsA("ParticleEmitter") then
            local Attribute = descendant:GetAttribute("EmitDelay");
            local v9 = (typeof(Attribute) ~= "number" and 0 or Attribute) + math.max(descendant.Lifetime.Max, 1) + 1;
            v8 = math.max(v8, v9);
        end;
    end;

    return v8;
end;

return function(p10: userdata) -- Line: 44
    -- upvalues: Other (copy), getBeamUpVector (copy), Debris2 (copy), Debris (copy), getBeamCleanupTime (copy)
    local ZeusBeam = Other:FindFirstChild("ZeusBeam");

    if not (ZeusBeam and ZeusBeam:IsA("BasePart")) then
        return nil;
    end;

    local LookVector = p10.CFrame.LookVector;

    if LookVector.Magnitude <= 0.001 then
        return nil;
    end;

    local Unit = LookVector.Unit;
    local v11 = ZeusBeam:Clone();
    v11.CollisionGroup = "Debris";
    v11.CanCollide = false;
    v11.CanQuery = false;
    v11.CanTouch = false;
    v11.Anchored = true;
    local v12 = p10.Position + Unit * (v11.Size.X * 0.5);
    local v13 = getBeamUpVector(Unit, p10.CFrame.UpVector);
    v11.CFrame = CFrame.fromMatrix(v12, Unit, v13);
    v11.Parent = Debris2;

    for _, descendant in ipairs(v11:GetDescendants()) do
        if descendant:IsA("ParticleEmitter") then
            local Attribute = descendant:GetAttribute("EmitDelay");
            local v14 = typeof(Attribute) ~= "number" and 0 or Attribute;
            task.delay(v14, function() -- Line: 72
                -- upvalues: descendant (copy)
                if not descendant.Parent then
                    return;
                end;

                local Attribute2 = descendant:GetAttribute("EmitCount");
                local v15 = typeof(Attribute2) ~= "number" and 0 or Attribute2;

                if v15 > 0 then
                    descendant:Emit(v15);

                    return;
                end;

                descendant.Enabled = true;
                task.delay(0.15, function() -- Line: 82
                    -- upvalues: descendant (ref)
                    if descendant.Parent then
                        descendant.Enabled = false;
                    end;
                end);
            end);
        end;
    end;

    Debris:AddItem(v11, (getBeamCleanupTime(v11)));

    return v11;
end;