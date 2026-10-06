-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Debris = game:GetService("Debris");
local Schema = require(ReplicatedStorage.MovementV2.Collision.Schema);
local Debris2 = workspace:WaitForChild("Debris");
local Observers = require(ReplicatedStorage.Packages.Observers);
local Sound = require(ReplicatedStorage.Classes.Sound);

local function createDuplicateWindow(p1: userdata) -- Line: 20
    -- upvalues: Schema (copy), Debris2 (copy)
    local Pivot = p1:GetPivot();
    local v2 = p1:Clone();
    v2:SetAttribute("Broken", false);
    v2:RemoveTag("Market Window");
    v2:RemoveTag("Interactable");

    for _, descendant in v2:GetDescendants() do
        descendant:RemoveTag(Schema.Tags.Destructible);
    end;

    v2:PivotTo(Pivot);

    for _, child in ipairs(v2:GetChildren()) do
        if child:IsA("BasePart") then
            child.CanCollide = true;
            child.Transparency = 0;
        end;
    end;

    v2.Parent = Debris2;

    return v2;
end;

local function createBreakPoints(p3: userdata) -- Line: 43
    -- upvalues: Debris (copy), Sound (copy)
    local Attribute = p3:GetAttribute("Direction");

    for _, child in ipairs(p3:GetChildren()) do
        if child:IsA("BasePart") then
            child.CollisionGroup = "Debris";
            child.Anchored = false;
            local v4 = Attribute.X * math.random(7, 12);
            local v5 = Attribute.Y * math.random(7, 12);
            local v6 = Attribute.Z * math.random(7, 12);
            child:ApplyImpulse((Vector3.new(v4, v5, v6)));
        end;
    end;

    Debris:AddItem(p3, 5);
    Sound.new("Bullet"):playOneTime({
        Name = "Break Market Window",
        Parent = p3.PrimaryPart
    });
end;

return Observers.observeTag("Market Window", function(u7: userdata) -- Line: 68
    -- upvalues: Observers (copy), createDuplicateWindow (copy), createBreakPoints (copy)
    if u7:IsDescendantOf(workspace) then
        return Observers.observeAttribute(u7, "Broken", function(p8) -- Line: 72
            -- upvalues: createDuplicateWindow (ref), u7 (copy), createBreakPoints (ref)
            if p8 then
                createBreakPoints((createDuplicateWindow(u7)));
            end;
        end);
    end;
end);