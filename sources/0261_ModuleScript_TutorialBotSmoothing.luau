-- Decompiled with Potassium's decompiler.

local v1 = {};
local RunService = game:GetService("RunService");
local Workspace = game:GetService("Workspace");
local u2 = {
    TutorialEscorts = true,
    TutorialRetakers = true,
    TutorialCTSquad = true,
    TutorialBAttackers = true
};
local u3 = {};
local u4 = {};
local u5 = nil;
local u6 = {};
local u7 = {};
local u8 = 0;

local function isSamePose(p9, p10) -- Line: 81
    local v11;

    if (p9.Position - p10.Position).Magnitude <= 0.001 and p9.LookVector:Dot(p10.LookVector) >= 0.999998 then
        v11 = p9.UpVector:Dot(p10.UpVector) >= 0.999998;
    else
        v11 = false;
    end;

    return v11;
end;

local function untrack(p12: userdata) -- Line: 87
    -- upvalues: u3 (copy), u5 (ref)
    local v13 = u3[p12];

    if not v13 then
        return;
    end;

    u3[p12] = nil;

    for _, v in v13.Connections do
        v:Disconnect();
    end;

    local Written = v13.Written;

    if Written and v13.Root.Parent then
        local CFrame2 = v13.Root.CFrame;
        local v14;

        if (CFrame2.Position - Written.Position).Magnitude <= 0.001 and CFrame2.LookVector:Dot(Written.LookVector) >= 0.999998 then
            v14 = CFrame2.UpVector:Dot(Written.UpVector) >= 0.999998;
        else
            v14 = false;
        end;

        if v14 then
            v13.Root.CFrame = v13.Target;
        end;
    end;

    if next(u3) == nil and u5 then
        u5:Disconnect();
        u5 = nil;
    end;
end;

local function receive(p15: table, p16, p17: number) -- Line: 107
    -- upvalues: u8 (ref)
    p15.Target = p16;
    local Position = p16.Position;
    local Path = p15.Path;
    local v18;

    if #Path > 0 then
        v18 = Path[#Path];
    else
        v18 = p15.Visual.Position;
    end;

    local Magnitude = (Position - v18).Magnitude;

    if Magnitude <= 8 then
        if Magnitude > 0.001 then
            table.insert(Path, Position);
            p15.Queued = p15.Queued + Magnitude;
            local MovedAt = p15.MovedAt;

            if MovedAt and p17 - MovedAt < 0.6 then
                u8 = math.max(u8, p17 - MovedAt);
            end;

            p15.MovedAt = p17;
        end;

        table.insert(p15.Arrivals, {
            Time = p17,
            Distance = p15.Queued
        });

        return;
    end;

    table.clear(Path);
    table.clear(p15.Arrivals);
    p15.Visual = p16;
    p15.Speed = 0;
    p15.Cruise = 0;
end;

local function measureSpeed(p19: table, p20: number) -- Line: 134
    local Arrivals = p19.Arrivals;

    while #Arrivals > 1 and p20 - Arrivals[1].Time > 0.5 do
        table.remove(Arrivals, 1);
    end;

    if #Arrivals < 2 then
        return 0;
    end;

    local v21 = Arrivals[1];

    return (p19.Queued - v21.Distance) / math.max(p20 - v21.Time, 0.25);
end;

local function pathLength(p22: vector, p23: table) -- Line: 146
    local v24 = 0;

    for _, v in p23 do
        v24 = v24 + (v - p22).Magnitude;
        p22 = v;
    end;

    return v24;
end;

local function advance(p25: vector, p26: table, p27: number) -- Line: 157
    while #p26 > 0 do
        local v28 = p26[1];
        local Magnitude = (v28 - p25).Magnitude;

        if p27 < Magnitude then
            return p25 + (v28 - p25) * (p27 / Magnitude);
        end;

        p27 = p27 - Magnitude;
        table.remove(p26, 1);
        p25 = v28;
    end;

    return p25;
end;

local function step(p29: number) -- Line: 172
    -- upvalues: u8 (ref), u6 (copy), u7 (copy), u3 (copy), untrack (copy), receive (copy), measureSpeed (copy), advance (copy), Workspace (copy)
    local math_min_ret = math.min(p29, 0.1);
    local os_clock_ret = os.clock();
    local v30 = 1 - math.exp(math_min_ret * -10);
    local v31 = 1 - math.exp(math_min_ret * -14);
    u8 = u8 * math.exp(-math_min_ret / 3);
    local math_clamp_ret = math.clamp(u8 * 1.25, 0.1, 0.4);
    local math_exp_ret = math.exp(-math_min_ret / 1);
    table.clear(u6);
    table.clear(u7);

    for i, v in u3 do
        local Root = v.Root;

        if i.Parent == v.Folder and (Root.Parent ~= nil and i:GetAttribute("Dead") ~= true) then
            local CFrame2 = Root.CFrame;
            local Written = v.Written;

            if Written then
                local v32;

                if (CFrame2.Position - Written.Position).Magnitude <= 0.001 and CFrame2.LookVector:Dot(Written.LookVector) >= 0.999998 then
                    v32 = CFrame2.UpVector:Dot(Written.UpVector) >= 0.999998;
                else
                    v32 = false;
                end;

                if not v32 then
                    receive(v, CFrame2, os_clock_ret);
                end;
            else
                receive(v, CFrame2, os_clock_ret);
            end;

            local Target = v.Target;
            local Visual = v.Visual;
            v.Speed = v.Speed + (measureSpeed(v, os_clock_ret) - v.Speed) * v30;
            v.Cruise = math.max(v.Speed, v.Cruise * math_exp_ret);
            local Path = v.Path;
            local Position = Visual.Position;
            local v33 = v;
            local v34 = 0;

            for _, v2 in Path do
                v34 = v34 + (v2 - Position).Magnitude;
                Position = v2;
            end;

            local v35;

            if v34 <= 0.01 then
                table.clear(Path);
                v35 = Target.Position;
            else
                local v36 = v33.Speed + (v34 - v33.Speed * math_clamp_ret) * 3;
                local MovedAt = v33.MovedAt;

                if not MovedAt or math_clamp_ret < os_clock_ret - MovedAt then
                    v36 = math.max(v36, v33.Cruise);
                end;

                local math_max_ret = math.max(v33.Cruise * 1.5, 4);
                local v37 = math.clamp(v36, 0, math_max_ret) * math_min_ret;
                local math_max_ret2 = math.max(v37, v34 - 7);

                if v34 - 0.01 <= math_max_ret2 then
                    v35 = advance(Visual.Position, Path, (1 / 0));
                else
                    v35 = advance(Visual.Position, Path, math_max_ret2);
                end;
            end;

            local v38;

            if Visual.LookVector:Dot(Target.LookVector) >= 0.9999904807207345 then
                v38 = Visual.UpVector:Dot(Target.UpVector) >= 0.9999904807207345;
            else
                v38 = false;
            end;

            local v39;

            if v38 then
                v39 = Target.Rotation;
            else
                v39 = Visual.Rotation:Lerp(Target.Rotation, v31);
            end;

            local v40 = CFrame.new(v35) * v39;

            if #Path == 0 then
                if v38 then
                    v40 = Target;
                end;
            end;

            v33.Visual = v40;

            if v40 == Target then
                local v41;

                if (CFrame2.Position - Target.Position).Magnitude <= 0.001 and CFrame2.LookVector:Dot(Target.LookVector) >= 0.999998 then
                    v41 = CFrame2.UpVector:Dot(Target.UpVector) >= 0.999998;
                else
                    v41 = false;
                end;

                if v41 then
                    v33.Written = CFrame2;
                else
                    v33.Written = v40;
                    u6[#u6 + 1] = Root;
                    u7[#u7 + 1] = v40;
                end;
            else
                v33.Written = v40;
                u6[#u6 + 1] = Root;
                u7[#u7 + 1] = v40;
            end;
        else
            untrack(i);
        end;
    end;

    if #u6 == 1 then
        u6[1].CFrame = u7[1];

        return;
    end;

    if #u6 > 1 then
        Workspace:BulkMoveTo(u6, u7, Enum.BulkMoveMode.FireCFrameChanged);
    end;
end;

local function track(u42: userdata, u43: userdata) -- Line: 249
    -- upvalues: u3 (copy), track (copy), untrack (copy), u5 (ref), RunService (copy), step (copy)
    if not u42:IsA("Model") or u3[u42] then
        return;
    end;

    if u42:GetAttribute("TutorialDummy") ~= true or u42:GetAttribute("TutorialCutout") == true then
        return;
    end;

    if u42:GetAttribute("Dead") == true then
        return;
    end;

    local HumanoidRootPart = u42:FindFirstChild("HumanoidRootPart");

    if not (HumanoidRootPart and HumanoidRootPart:IsA("BasePart")) then
        local u44 = nil;
        u44 = u42.ChildAdded:Connect(function(p45) -- Line: 263
            -- upvalues: u44 (ref), track (ref), u42 (copy), u43 (copy)
            if p45.Name == "HumanoidRootPart" then
                u44:Disconnect();
                track(u42, u43);
            end;
        end);
        task.delay(10, function() -- Line: 269
            -- upvalues: u44 (ref)
            u44:Disconnect();
        end);

        return;
    end;

    if not HumanoidRootPart.Anchored then
        return;
    end;

    local CFrame2 = HumanoidRootPart.CFrame;
    local v46 = {
        Written = nil,
        Queued = 0,
        Speed = 0,
        Cruise = 0,
        MovedAt = nil,
        Model = u42,
        Folder = u43,
        Root = HumanoidRootPart,
        Target = CFrame2,
        Visual = CFrame2,
        Path = {},
        Arrivals = {},
        Connections = {}
    };
    u3[u42] = v46;
    local Connections = v46.Connections;
    local AttributeChangedSignal = u42:GetAttributeChangedSignal("Dead");
    table.insert(Connections, AttributeChangedSignal:Connect(function() -- Line: 299
        -- upvalues: u42 (copy), untrack (ref)
        if u42:GetAttribute("Dead") == true then
            untrack(u42);
        end;
    end));
    table.insert(v46.Connections, u42.AncestryChanged:Connect(function() -- Line: 307
        -- upvalues: u42 (copy), u43 (copy), untrack (ref)
        if u42.Parent ~= u43 then
            untrack(u42);
        end;
    end));

    if not u5 then
        u5 = RunService.RenderStepped:Connect(step);
    end;
end;

local function watchFolder(u47: userdata) -- Line: 318
    -- upvalues: u2 (copy), u4 (copy), track (copy), untrack (copy)
    if not u2[u47.Name] or u4[u47] then
        return;
    end;

    u4[u47] = { u47.ChildAdded:Connect(function(p48) -- Line: 323
            -- upvalues: track (ref), u47 (copy)
            track(p48, u47);
        end), u47.ChildRemoved:Connect(function(p49) -- Line: 326
            -- upvalues: untrack (ref)
            if p49:IsA("Model") then
                untrack(p49);
            end;
        end) };

    for _, child in u47:GetChildren() do
        track(child, u47);
    end;
end;

local function unwatchFolder(p50: userdata) -- Line: 337
    -- upvalues: u4 (copy), u3 (copy), untrack (copy)
    local v51 = u4[p50];

    if not v51 then
        return;
    end;

    u4[p50] = nil;

    for _, v in v51 do
        v:Disconnect();
    end;

    for i, v in u3 do
        if v.Folder == p50 then
            untrack(i);
        end;
    end;
end;

function v1.Start() -- Line: 356
    -- upvalues: Workspace (copy), watchFolder (copy), unwatchFolder (copy)
    Workspace.ChildAdded:Connect(watchFolder);
    Workspace.ChildRemoved:Connect(unwatchFolder);

    for _, child in Workspace:GetChildren() do
        watchFolder(child);
    end;
end;

return v1;