-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Debris = game:GetService("Debris");
local Debris2 = workspace:WaitForChild("Debris");
local Observers = require(ReplicatedStorage.Packages.Observers);
local Sound = require(ReplicatedStorage.Classes.Sound);

local function createDuplicateFlowerPot(p1: userdata) -- Line: 19
    -- upvalues: Debris2 (copy)
    local Pivot = p1:GetPivot();
    p1:SetAttribute("Broken", false);
    p1:RemoveTag("Flower Pot");
    p1:RemoveTag("Interactable");
    local v2 = p1:Clone();
    v2:PivotTo(Pivot);
    v2.Parent = Debris2;

    for _, child in ipairs(v2:GetChildren()) do
        if child:IsA("BasePart") then
            child.CanCollide = child.Name ~= "Unbroken";
            child.Transparency = child.Name == "Unbroken" and 1 or 0;
        end;
    end;

    return v2;
end;

local function createBreakPoints(p3: userdata) -- Line: 40
    -- upvalues: Debris (copy), Sound (copy)
    local Attribute = p3:GetAttribute("Direction");

    for _, child in ipairs(p3:GetChildren()) do
        if child:IsA("BasePart") and child.Name ~= "Unbroken" then
            child.CollisionGroup = "Debris";
            child.Anchored = false;
            child.Massless = true;
        end;
    end;

    for _, child in ipairs(p3:GetChildren()) do
        if child:IsA("BasePart") then
            child:ApplyImpulse(Attribute * math.random(2, 3));
        end;
    end;

    Debris:AddItem(p3, 5);
    Sound.new("Bullet"):playOneTime({
        Name = "Break Flower Pot",
        Parent = p3.PrimaryPart
    });
end;

return Observers.observeTag("Flower Pot", function(u4: userdata) -- Line: 65
    -- upvalues: Observers (copy), createDuplicateFlowerPot (copy), createBreakPoints (copy)
    if u4:IsDescendantOf(workspace) then
        return Observers.observeAttribute(u4, "Broken", function(p5) -- Line: 69
            -- upvalues: createDuplicateFlowerPot (ref), u4 (copy), createBreakPoints (ref)
            if p5 then
                createBreakPoints((createDuplicateFlowerPot(u4)));
            end;
        end);
    end;
end);