-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Observers = require(ReplicatedStorage.Packages.Observers);
local Janitor = require(ReplicatedStorage.Shared.Janitor);
local Sound = require(ReplicatedStorage.Classes.Sound);
local Animation = Instance.new("Animation", nil);
Animation.AnimationId = "rbxassetid://130065050998927";
Animation.Name = "HOSTAGE_IDLE";
local Animation2 = Instance.new("Animation", nil);
Animation2.AnimationId = "rbxassetid://84183418979817";
Animation2.Name = "HOSTAGE_CARRYING";

local function updateAnimation(p1: userdata) -- Line: 26
    -- upvalues: Animation2 (copy), Animation (copy)
    local v2 = p1:FindFirstChildOfClass("Humanoid");

    if not v2 then
        return nil;
    end;

    local Animator = v2:WaitForChild("Animator");
    local v3 = p1:GetAttribute("State") == "Carrying" and Animator:LoadAnimation(Animation2) or (p1:GetAttribute("State") == "Idle" and Animator:LoadAnimation(Animation) or nil);

    if v3 then
        v3:Play();
    end;

    return v3;
end;

return Observers.observeTag("Hostage", function(u4) -- Line: 44
    -- upvalues: Janitor (copy), Sound (copy), updateAnimation (copy)
    local HumanoidRootPart = u4:WaitForChild("HumanoidRootPart", 10);
    local v5 = u4:FindFirstChildOfClass("Humanoid");

    if not v5 then
        local v6 = tick();

        repeat
            task.wait(0.1);
            v5 = u4:FindFirstChildOfClass("Humanoid");
        until v5 or tick() - v6 > 10;
    end;

    local v7 = u4:WaitForChild("Head", 10) or (v5 or HumanoidRootPart);

    if v7 and u4:IsDescendantOf(workspace) then
        local u8 = Janitor.new();
        local Hostage = Sound.new("Hostage");
        local u9 = nil;
        Hostage:playOneTime({
            Name = "Hostage Idle",
            Parent = v7
        });
        u8:Add(u4:GetAttributeChangedSignal("State"):Connect(function() -- Line: 69
            -- upvalues: u9 (ref), updateAnimation (ref), u4 (copy)
            if u9 then
                u9:Stop();
                u9 = nil;
            end;

            u9 = updateAnimation(u4);
        end));
        u9 = updateAnimation(u4);
        u8:Add(function() -- Line: 77
            -- upvalues: Hostage (copy)
            Hostage:destroy();
        end);

        return function() -- Line: 80
            -- upvalues: u8 (copy)
            u8:Destroy();
        end;
    end;
end);