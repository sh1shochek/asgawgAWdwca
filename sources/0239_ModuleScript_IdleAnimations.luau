-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Observers = require(ReplicatedStorage.Packages.Observers);
local GraphicsQualityController = require(ReplicatedStorage.Controllers.GraphicsQualityController);
local u1 = {};

for _, v in {
    {
        Tag = "Ceiling Fan",
        AnimationId = "rbxassetid://82806563298602",
        RequireWorkspace = true,
        AnimatorPath = { "AnimationController", "Animator" }
    },
    {
        Tag = "Flag",
        AnimationId = "rbxassetid://103823379066850",
        AnimationName = "FLAG_IDLE",
        AnimatorPath = { "csFlag", "AnimationController", "Animator" },
        Ancestors = { workspace }
    },
    {
        Tag = "VertigoCrane",
        AnimationId = "rbxassetid://75914758947993",
        AnimationName = "CRANE_IDLE",
        RequireWorkspace = true,
        AnimatorPath = { "AnimationController", "Animator" }
    },
    {
        Tag = "VertigoGenerator",
        AnimationId = "rbxassetid://106431666932790",
        AnimationName = "GENERATOR_IDLE",
        RequireWorkspace = true,
        AnimatorPath = { "AnimationController", "Animator" }
    }
} do
    local Animation = Instance.new("Animation");
    Animation.AnimationId = v.AnimationId;

    if v.AnimationName then
        Animation.Name = v.AnimationName;
    end;

    table.insert(u1, Observers.observeTag(v.Tag, function(u2: userdata) -- Line: 69
        -- upvalues: v (copy), GraphicsQualityController (copy), Animation (copy)
        local v3 = u2;

        for _, v2 in v.AnimatorPath do
            u2 = u2:WaitForChild(v2);
        end;

        if v.RequireWorkspace and not v3:IsDescendantOf(workspace) then
            return nil;
        end;

        return GraphicsQualityController.RunAnimatedProp(function() -- Line: 79
            -- upvalues: u2 (ref), Animation (ref)
            local u4 = u2:LoadAnimation(Animation);
            u4:Play();

            return function() -- Line: 82
                -- upvalues: u4 (copy)
                u4:Destroy();
            end;
        end);
    end, v.Ancestors));
end;

return function() -- Line: 90
    -- upvalues: u1 (copy)
    for _, v in u1 do
        v();
    end;
end;