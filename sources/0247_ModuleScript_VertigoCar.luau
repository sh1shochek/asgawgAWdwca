-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local TweenService = game:GetService("TweenService");
local Observers = require(ReplicatedStorage.Packages.Observers);
local GraphicsQualityController = require(ReplicatedStorage.Controllers.GraphicsQualityController);
local Janitor = require(ReplicatedStorage.Shared.Janitor);

local function CreateTween(p1: any, p2: userdata) -- Line: 16
    -- upvalues: TweenService (copy)
    if not p2:IsDescendantOf(workspace) then
        return;
    end;

    local PointA = p2:WaitForChild("PointA", 5);
    local PointB = p2:WaitForChild("PointB", 5);

    if not (PointA and PointB) then
        warn((`[VertigoCar] Model "{p2.Name}" is missing PointA or PointB attachments`));

        return;
    end;

    if not p2:IsDescendantOf(workspace) then
        return;
    end;

    local WorldPosition = PointA.WorldPosition;
    local WorldPosition2 = PointB.WorldPosition;
    local Magnitude = (WorldPosition2 - WorldPosition).Magnitude;

    if Magnitude <= 0 then
        return;
    end;

    local v3 = TweenService:Create(p2, TweenInfo.new(Magnitude / 42, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {
        Position = WorldPosition2
    });
    p1:Add(v3, "Cancel");

    while p2:IsDescendantOf(workspace) do
        p2.Position = WorldPosition;
        v3:Play();
        v3.Completed:Wait();
    end;
end;

return Observers.observeTag("VertigoCar", function(u4: userdata) -- Line: 58
    -- upvalues: GraphicsQualityController (copy), Janitor (copy), CreateTween (copy)
    u4.Anchored = true;

    if not u4:IsDescendantOf(workspace) then
        return nil;
    end;

    local v6 = GraphicsQualityController.RunAnimatedProp(function() -- Line: 67
        -- upvalues: Janitor (ref), u4 (copy), CreateTween (ref)
        local u5 = Janitor.new();
        u5:Add(u4);
        u5:Add(task.spawn(function() -- Line: 70
            -- upvalues: CreateTween (ref), u5 (copy), u4 (ref)
            CreateTween(u5, u4);
        end));

        return function() -- Line: 73
            -- upvalues: u5 (copy)
            u5:Destroy();
        end;
    end);

    if not v6 then
        u4:Destroy();
    end;

    return v6;
end);