-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local RunServiceController = require(ReplicatedStorage.Controllers.RunServiceController);
local Observers = require(ReplicatedStorage.Packages.Observers);
local GraphicsQualityController = require(ReplicatedStorage.Controllers.GraphicsQualityController);
local Janitor = require(ReplicatedStorage.Shared.Janitor);

local function UpdateBoat(p1: any, p2: number, p3: table, p4: table) -- Line: 20
    p3[1] = p3[1] + p2;
    local Handle = p1.Handle;

    if not (Handle and Handle:IsDescendantOf(workspace)) then
        return;
    end;

    if not p4[1] then
        p4[1] = Handle.CFrame;
    end;

    local v5 = p4[1];
    local v6 = p3[1];
    local v7 = math.sin(v6 * 0.8) * 0.05235987755982989;
    local v8 = math.cos(v6 * 0.8 * 0.7) * 0.05235987755982989 * 0.8;
    local v9 = math.sin(v6 * 0.5) * 0.15;
    local v10 = math.sin(v6 * 1.2) * 0.1;
    local v11 = v5.LookVector * v9 + Vector3.new(0, v10, 0);
    local v12 = v5.Position + v11;
    local CFrame_Angles_ret = CFrame.Angles(v7, 0, 0);
    local CFrame_Angles_ret2 = CFrame.Angles(0, 0, v8);
    local v13 = v5 * CFrame_Angles_ret * CFrame_Angles_ret2;
    Handle.CFrame = v13 + (v12 - v13.Position);
end;

return Observers.observeTag("TugBoat", function(u14) -- Line: 56
    -- upvalues: GraphicsQualityController (copy), Janitor (copy), RunServiceController (copy), UpdateBoat (copy)
    if u14:IsDescendantOf(workspace) then
        return GraphicsQualityController.RunAnimatedProp(function() -- Line: 62
            -- upvalues: Janitor (ref), RunServiceController (ref), UpdateBoat (ref), u14 (copy)
            local u15 = Janitor.new();
            local u16 = { nil };
            local u17 = { 0 };
            local v18 = RunServiceController.CreateBindingName("Observers.Game.TugBoat.Update");
            u15:Add(RunServiceController.BindToHeartbeat(v18, function(p19: number) -- Line: 67
                -- upvalues: UpdateBoat (ref), u14 (ref), u17 (copy), u16 (copy)
                UpdateBoat(u14, p19, u17, u16);
            end));

            return function() -- Line: 70
                -- upvalues: u15 (copy)
                u15:Destroy();
            end;
        end);
    end;
end);