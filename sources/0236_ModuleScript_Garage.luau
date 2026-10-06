-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local RunService = game:GetService("RunService");
local MoverTrajectory = require(ReplicatedStorage.MovementV2.MoverTrajectory);
local Observers = require(ReplicatedStorage.Packages.Observers);
local Sound = require(ReplicatedStorage.Classes.Sound);

local function playGarageSound(p1: userdata, p2: boolean) -- Line: 10
    -- upvalues: Sound (copy)
    Sound.new("Miscellaneous"):playOneTime({
        Parent = p1,
        Name = p2 and "Open Garage" or "Close Garage"
    });
end;

return Observers.observeTag("Garage", function(u3: userdata) -- Line: 18
    -- upvalues: MoverTrajectory (copy), RunService (copy), Sound (copy)
    if not u3:IsDescendantOf(workspace) then
        return nil;
    end;

    local Handle = u3:FindFirstChild("Handle");

    if Handle == nil or not Handle:IsA("BasePart") then
        return nil;
    end;

    local u4 = nil;
    local u5 = nil;
    local u6 = true;

    local function disconnectRender() -- Line: 31
        -- upvalues: u5 (ref)
        if u5 ~= nil then
            u5:Disconnect();
            u5 = nil;
        end;
    end;

    local function applyPose() -- Line: 38
        -- upvalues: u4 (ref), Handle (copy), u5 (ref), MoverTrajectory (ref)
        if u4 == nil or Handle.Parent == nil then
            if u5 ~= nil then
                u5:Disconnect();
                u5 = nil;
            end;

            return;
        end;

        local ServerTimeNow = workspace:GetServerTimeNow();
        Handle.CFrame = MoverTrajectory.EvaluateTime(u4, ServerTimeNow);

        if (not u4.Moving or MoverTrajectory.TimeAlpha(u4, ServerTimeNow) >= 1) and u5 ~= nil then
            u5:Disconnect();
            u5 = nil;
        end;
    end;

    local function refreshTrajectory() -- Line: 50
        -- upvalues: MoverTrajectory (ref), Handle (copy), u4 (ref), u5 (ref), RunService (ref), applyPose (copy)
        local v7 = MoverTrajectory.Read(Handle);

        if v7 == nil then
            return;
        end;

        u4 = v7;

        if u5 ~= nil then
            u5:Disconnect();
            u5 = nil;
        end;

        if v7.Moving then
            u5 = RunService.RenderStepped:Connect(applyPose);
        end;

        applyPose();
    end;

    local u8 = Handle:GetAttributeChangedSignal(MoverTrajectory.Attributes.Revision):Connect(refreshTrajectory);
    local u9 = Handle:GetAttributeChangedSignal(MoverTrajectory.Attributes.Id):Connect(refreshTrajectory);
    local u12 = MoverTrajectory.ClientDescriptorChanged:Connect(function(p10) -- Line: 66
        -- upvalues: Handle (copy), MoverTrajectory (ref), u4 (ref), u5 (ref), RunService (ref), applyPose (copy)
        if Handle:GetAttribute(MoverTrajectory.Attributes.Id) == p10 then
            local v11 = MoverTrajectory.Read(Handle);

            if v11 == nil then
                return;
            end;

            u4 = v11;

            if u5 ~= nil then
                u5:Disconnect();
                u5 = nil;
            end;

            if v11.Moving then
                u5 = RunService.RenderStepped:Connect(applyPose);
            end;

            applyPose();
        end;
    end);
    local u14 = u3:GetAttributeChangedSignal("CurrentState"):Connect(function() -- Line: 71
        -- upvalues: u6 (ref), Handle (copy), u3 (copy), Sound (ref)
        if not u6 then
            local v13 = u3:GetAttribute("CurrentState") == true;
            Sound.new("Miscellaneous"):playOneTime({
                Parent = Handle,
                Name = v13 and "Open Garage" or "Close Garage"
            });
        end;

        u6 = false;
    end);
    local v15 = MoverTrajectory.Read(Handle);

    if v15 ~= nil then
        u4 = v15;

        if u5 ~= nil then
            u5:Disconnect();
            u5 = nil;
        end;

        if v15.Moving then
            u5 = RunService.RenderStepped:Connect(applyPose);
        end;

        applyPose();
    end;

    u6 = false;

    return function() -- Line: 80
        -- upvalues: u5 (ref), u8 (copy), u9 (copy), u12 (copy), u14 (copy)
        if u5 ~= nil then
            u5:Disconnect();
            u5 = nil;
        end;

        u8:Disconnect();
        u9:Disconnect();
        u12:Disconnect();
        u14:Disconnect();
    end;
end);