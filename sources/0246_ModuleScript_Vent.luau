-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Debris = game:GetService("Debris");
local Debris2 = workspace:WaitForChild("Debris");
local Observers = require(ReplicatedStorage.Packages.Observers);
local Sound = require(ReplicatedStorage.Classes.Sound);

local function createDuplicateVent(p1: userdata) -- Line: 20
    -- upvalues: Debris2 (copy)
    local Pivot = p1:GetPivot();
    local v2 = p1:Clone();
    v2:SetAttribute("Broken", false);
    v2:RemoveTag("Interactable");
    v2:RemoveTag("Vent");
    v2:PivotTo(Pivot);

    for _, child in ipairs(v2:GetChildren()) do
        if child:IsA("BasePart") then
            if child.Name == "BreakPoint" then
                child.CanCollide = true;
                child.CanQuery = false;
                child.Transparency = 0;
            else
                child:Destroy();
            end;
        end;
    end;

    v2.Parent = Debris2;

    return v2;
end;

local function createBreakPoints(p3: userdata) -- Line: 47
    -- upvalues: Debris (copy), Sound (copy)
    local Position = p3:GetPivot().Position;
    local Attribute = p3:GetAttribute("Direction");

    for _, child in ipairs(p3:GetChildren()) do
        if child:IsA("BasePart") then
            child.CollisionGroup = "Debris";
            child.Anchored = false;
            local v4 = Attribute.X * math.random(15, 20);
            local v5 = Attribute.Y * math.random(15, 20);
            local v6 = Attribute.Z * math.random(15, 20);
            child:ApplyImpulse((Vector3.new(v4, v5, v6)));
        end;
    end;

    Debris:AddItem(p3, 5);
    Sound.new("Bullet"):PlaySoundAtPosition({
        Name = "Break Metal Vent",
        Class = "Bullet",
        Position = Position
    });
end;

return Observers.observeTag("Vent", function(u7: userdata) -- Line: 72
    -- upvalues: Observers (copy), createDuplicateVent (copy), createBreakPoints (copy)
    if u7:IsDescendantOf(workspace) then
        return Observers.observeAttribute(u7, "Broken", function(p8) -- Line: 76
            -- upvalues: createDuplicateVent (ref), u7 (copy), createBreakPoints (ref)
            if p8 then
                createBreakPoints((createDuplicateVent(u7)));
            end;
        end);
    end;
end);