-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Debris = game:GetService("Debris");
local Schema = require(ReplicatedStorage.MovementV2.Collision.Schema);
local Debris2 = workspace:WaitForChild("Debris");
local Observers = require(ReplicatedStorage.Packages.Observers);

local function createDuplicateSnowman(p1: userdata) -- Line: 17
    -- upvalues: Schema (copy), Debris2 (copy)
    local Pivot = p1:GetPivot();
    local v2 = p1:Clone();
    v2:SetAttribute("Broken", false);
    v2:RemoveTag("Snowman");
    v2:RemoveTag("Interactable");

    for _, descendant in v2:GetDescendants() do
        descendant:RemoveTag(Schema.Tags.Destructible);
    end;

    v2:PivotTo(Pivot);

    for _, child in ipairs(v2:GetChildren()) do
        if child.Name == "Head" then
            child.CanCollide = true;
            child.Transparency = 0;
        end;
    end;

    v2.Parent = Debris2;

    return v2;
end;

local function createBreakPoints(p3: userdata) -- Line: 40
    -- upvalues: Debris (copy)
    local Attribute = p3:GetAttribute("Direction");

    for _, child in ipairs(p3:GetChildren()) do
        if child.Name == "Head" then
            child.CollisionGroup = "Debris";
            child.Anchored = false;
            child.Massless = true;

            if Attribute then
                child:ApplyImpulse(math.random(30, 40) * Attribute);
            end;
        end;
    end;

    Debris:AddItem(p3, 10);
end;

return Observers.observeTag("Snowman", function(u4: userdata) -- Line: 58
    -- upvalues: Observers (copy), createDuplicateSnowman (copy), createBreakPoints (copy)
    if u4:IsDescendantOf(workspace) then
        return Observers.observeAttribute(u4, "Broken", function(p5) -- Line: 62
            -- upvalues: createDuplicateSnowman (ref), u4 (copy), createBreakPoints (ref)
            if p5 then
                createBreakPoints((createDuplicateSnowman(u4)));
            end;
        end);
    end;
end);