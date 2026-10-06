-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local RunServiceController = require(ReplicatedStorage.Controllers.RunServiceController);
local ObjectPool = require(ReplicatedStorage.Shared.ObjectPool);
local Tracers = ReplicatedStorage:WaitForChild("Assets"):WaitForChild("Tracers");
local Debris = workspace:WaitForChild("Debris");
local Default = Tracers:WaitForChild("Default");
local u2 = ObjectPool.new(Default, {
    InitialSize = 8,
    MaxRetained = 48,

    Reset = function(p1: userdata) -- Line: 54, Name: resetTracer
        p1.TopAttachment.Position = Vector3.new(0, 0, 0);
        p1.BottomAttachment.Position = Vector3.new(0, 0, 0);
        p1.LeftAttachment.Position = Vector3.new(0, 0, 0);
        p1.RightAttachment.Position = Vector3.new(0, 0, 0);
    end
});
local u3 = {};
local u4 = nil;
local u5 = {};
local u6 = {};

local function retireTracer(p7: number, p8: table) -- Line: 82
    -- upvalues: u2 (copy), u3 (copy)
    u2:Release(p8.Part, p8.Lease);
    u3[p7] = u3[#u3];
    u3[#u3] = nil;
end;

local function updateTracers(p9: number) -- Line: 88
    -- upvalues: u3 (copy), u2 (copy), u5 (copy), u6 (copy), u4 (ref)
    debug.profilebegin("VFX.TracerUpdate");

    for i = #u3, 1, -1 do
        local v10 = u3[i];
        v10.Elapsed = v10.Elapsed + p9;
        local Part = v10.Part;
        local v11;

        if v10.Elapsed >= 1 or Part.Parent == nil then
            u2:Release(v10.Part, v10.Lease);
            u3[i] = u3[#u3];
            u3[#u3] = nil;
            v11 = i;
        else
            local v12 = 5 + 995 * (v10.Elapsed / 1);

            if v10.MaxDistance == nil or v10.MaxDistance > v12 then
                u5[#u5 + 1] = Part;
                u6[#u6 + 1] = CFrame.new(v10.Origin + v10.Direction * v12);
                local v13 = 0.1 * math.min(v12 / 50, 1);

                if v10.HalfWidth == v13 then
                    v11 = i;
                else
                    v10.HalfWidth = v13;
                    Part.TopAttachment.Position = Vector3.new(0, v13, 0);
                    Part.BottomAttachment.Position = Vector3.new(0, -v13, 0);
                    Part.LeftAttachment.Position = Vector3.new(-v13, 0, 0);
                    Part.RightAttachment.Position = Vector3.new(v13, 0, 0);
                    v11 = i;
                end;
            else
                u2:Release(v10.Part, v10.Lease);
                u3[i] = u3[#u3];
                u3[#u3] = nil;
                v11 = i;
            end;
        end;
    end;

    if #u5 > 0 then
        workspace:BulkMoveTo(u5, u6, Enum.BulkMoveMode.FireCFrameChanged);
        table.clear(u5);
        table.clear(u6);
    end;

    if #u3 == 0 and u4 then
        u4:Disconnect();
        u4 = nil;
    end;

    debug.profileend();
end;

local function ensureUpdaterBound() -- Line: 137
    -- upvalues: u4 (ref), RunServiceController (copy), updateTracers (copy)
    if not u4 then
        u4 = RunServiceController.BindToHeartbeat("VFX.TracerUpdater", updateTracers);
    end;
end;

return function(p14: number, p15: vector, p16: vector, p17: boolean?) -- Line: 146
    -- upvalues: u2 (copy), Debris (copy), u3 (copy), u4 (ref), RunServiceController (copy), updateTracers (copy)
    debug.profilebegin("VFX.Tracer");

    if not (p15 and (p17 ~= true or p14 > 5)) then
        debug.profileend();

        return;
    end;

    debug.profilebegin("VFX.Tracer.Acquire");
    local v18, v19 = u2:Acquire();
    v18.CollisionGroup = "Debris";
    v18.CanCollide = false;
    v18.CanQuery = false;
    v18.CanTouch = false;
    v18.Anchored = true;
    debug.profileend();
    debug.profilebegin("VFX.Tracer.Parent");
    v18.TopAttachment.Position = Vector3.new(0, 0, 0);
    v18.BottomAttachment.Position = Vector3.new(0, 0, 0);
    v18.LeftAttachment.Position = Vector3.new(0, 0, 0);
    v18.RightAttachment.Position = Vector3.new(0, 0, 0);
    v18.CFrame = CFrame.new(p15 + p16 * 5);
    v18.Parent = Debris;
    debug.profileend();
    local v20 = {
        Elapsed = 0,
        Part = v18,
        Lease = v19,
        Origin = p15,
        Direction = p16
    };
    local v21;

    if p17 == true then
        v21 = math.max(p14, 0);
    else
        v21 = nil;
    end;

    v20.MaxDistance = v21;
    table.insert(u3, v20);

    if not u4 then
        u4 = RunServiceController.BindToHeartbeat("VFX.TracerUpdater", updateTracers);
    end;

    debug.profileend();
end;