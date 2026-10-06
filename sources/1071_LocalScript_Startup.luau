-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local RunService = game:GetService("RunService");
game:GetService("StarterGui"):SetCoreGuiEnabled(Enum.CoreGuiType.Backpack, false);
local Profiler = require(ReplicatedStorage.Shared.Profiler);
local u1 = {};
local u2 = 1;
local u3 = 0;
local u4 = false;

local function getTraceback(p5) -- Line: 24
    return debug.traceback(tostring(p5), 2);
end;

local function runPhase(p6: string, p7: string?, p8: function, ...) -- Line: 28
    -- upvalues: Profiler (copy), getTraceback (copy)
    Profiler.mark((`Startup.Phase.{p6}`));
    local table_pack_ret = table.pack(xpcall(p8, getTraceback, ...));

    if table_pack_ret[1] then
        return true, table.unpack(table_pack_ret, 2, table_pack_ret.n);
    end;

    if p7 then
        p6 = `{p6}.{p7}`;
    end;

    warn((`[Startup] {p6} failed:\n{table_pack_ret[2]}`));

    return false;
end;

local function runStartupThread(p9: string, p10: string?, p11: string, p12: function) -- Line: 42
    -- upvalues: u3 (ref), u1 (copy), u4 (ref), u2 (ref), Profiler (copy), getTraceback (copy), RunService (copy)
    u3 = u3 + 1;
    local v13 = {};

    if p10 then
        p9 = `{p9}.{p10}`;
    end;

    v13.label = p9;
    v13.profileLabel = p11;
    v13.callback = p12;
    u1[u3] = v13;

    if u4 then
        return;
    end;

    u4 = true;
    task.spawn(function() -- Line: 55
        -- upvalues: u2 (ref), u3 (ref), u1 (ref), Profiler (ref), getTraceback (ref), RunService (ref), u4 (ref)
        local os_clock_ret = os.clock();
        local v14 = 0;

        while u2 <= u3 do
            local u15 = u1[u2];
            u1[u2] = nil;
            u2 = u2 + 1;
            v14 = v14 + 1;
            task.spawn(function() -- Line: 65
                -- upvalues: u15 (copy), Profiler (ref), getTraceback (ref)
                debug.setmemorycategory((`Startup.{u15.label}`));
                Profiler.mark(u15.profileLabel);
                local v16, v17 = xpcall(u15.callback, getTraceback);

                if not v16 then
                    warn((`[Startup] {u15.label} failed:\n{v17}`));
                end;
            end);

            if u2 <= u3 and (v14 >= 1 or os.clock() - os_clock_ret >= 0.0015) then
                RunService.Heartbeat:Wait();
                os_clock_ret = os.clock();
                v14 = 0;
            end;
        end;

        table.clear(u1);
        u2 = 1;
        u3 = 0;
        u4 = false;
    end);
end;

local function initialize(p18: string, p19: any) -- Line: 91
    -- upvalues: runPhase (copy)
    if typeof(p19) ~= "table" then
        return false;
    end;

    local Initialize = p19.Initialize;

    return not Initialize and true or runPhase("Initialize", p18, Initialize);
end;

local function start(u20: string, p21: string, p22: any) -- Line: 103
    -- upvalues: runStartupThread (copy), runPhase (copy)
    if typeof(p22) ~= "table" then
        return;
    end;

    local Start = p22.Start;

    if Start then
        runStartupThread("Start", u20, p21, function() -- Line: 111
            -- upvalues: runPhase (ref), u20 (copy), Start (copy)
            runPhase("Start", u20, Start);
        end);
    end;
end;

local function loadController(u23: userdata) -- Line: 117
    -- upvalues: Profiler (copy), ReplicatedStorage (copy), runStartupThread (copy), runPhase (copy)
    local InstancePath = Profiler.getInstancePath(u23, ReplicatedStorage);
    local u24 = `Startup.Module.{InstancePath}`;
    runStartupThread("Controller", InstancePath, u24, function() -- Line: 122
        -- upvalues: runPhase (ref), InstancePath (copy), u23 (copy), u24 (copy), runStartupThread (ref)
        local v25, v26 = runPhase("Require", InstancePath, require, u23);

        if not v25 then
            return;
        end;

        local v27 = InstancePath;
        local v28;

        if typeof(v26) == "table" then
            local Initialize = v26.Initialize;
            v28 = not Initialize and true or runPhase("Initialize", v27, Initialize);
        else
            v28 = false;
        end;

        if v28 then
            local u29 = InstancePath;
            local v30 = u24;

            if typeof(v26) ~= "table" then
                return;
            end;

            local Start = v26.Start;

            if Start then
                runStartupThread("Start", u29, v30, function() -- Line: 111
                    -- upvalues: runPhase (ref), u29 (copy), Start (copy)
                    runPhase("Start", u29, Start);
                end);
            end;
        end;
    end);
end;

local function loadObserver(u31: userdata) -- Line: 134
    -- upvalues: Profiler (copy), ReplicatedStorage (copy), runStartupThread (copy), runPhase (copy)
    local InstancePath = Profiler.getInstancePath(u31, ReplicatedStorage);
    runStartupThread("Observer", InstancePath, `Startup.Module.{InstancePath}`, function() -- Line: 138
        -- upvalues: InstancePath (copy), runPhase (ref), u31 (copy)
        debug.setmemorycategory((`Startup.Observer.{InstancePath}`));
        runPhase("Require", InstancePath, require, u31);
    end);
end;

local function loadInterface(u32: userdata) -- Line: 144
    -- upvalues: runStartupThread (copy), runPhase (copy)
    runStartupThread("Interface", nil, "Startup.Module.Interface", function() -- Line: 145
        -- upvalues: runPhase (ref), u32 (copy)
        local v33, v34 = runPhase("Require", "Interface", require, u32);

        if not v33 then
            return;
        end;

        if typeof(v34) ~= "table" then
            return;
        end;

        if v34.Initialize and not runPhase("Initialize", "Interface", v34.Initialize) then
            return;
        end;

        if v34.Start then
            runPhase("Start", "Interface", v34.Start);
        end;
    end);
end;

for _, child in ipairs(ReplicatedStorage.Controllers:GetChildren()) do
    if child:IsA("ModuleScript") then
        local InstancePath = Profiler.getInstancePath(child, ReplicatedStorage);
        local u35 = `Startup.Module.{InstancePath}`;
        runStartupThread("Controller", InstancePath, u35, function() -- Line: 122
            -- upvalues: runPhase (copy), InstancePath (copy), child (copy), u35 (copy), runStartupThread (copy)
            local v36, v37 = runPhase("Require", InstancePath, require, child);

            if not v36 then
                return;
            end;

            local v38 = InstancePath;
            local v39;

            if typeof(v37) == "table" then
                local Initialize = v37.Initialize;
                v39 = not Initialize and true or runPhase("Initialize", v38, Initialize);
            else
                v39 = false;
            end;

            if v39 then
                local u40 = InstancePath;
                local v41 = u35;

                if typeof(v37) ~= "table" then
                    return;
                end;

                local Start = v37.Start;

                if Start then
                    runStartupThread("Start", u40, v41, function() -- Line: 111
                        -- upvalues: runPhase (ref), u40 (copy), Start (copy)
                        runPhase("Start", u40, Start);
                    end);
                end;
            end;
        end);
    end;
end;

for _, child in ipairs(ReplicatedStorage.Controllers.Observers:GetChildren()) do
    if child:IsA("ModuleScript") then
        local InstancePath = Profiler.getInstancePath(child, ReplicatedStorage);
        runStartupThread("Observer", InstancePath, `Startup.Module.{InstancePath}`, function() -- Line: 138
            -- upvalues: InstancePath (copy), runPhase (copy), child (copy)
            debug.setmemorycategory((`Startup.Observer.{InstancePath}`));
            runPhase("Require", InstancePath, require, child);
        end);
    elseif child:IsA("Folder") then
        for _, child2 in ipairs(child:GetChildren()) do
            if child2:IsA("ModuleScript") then
                local InstancePath = Profiler.getInstancePath(child2, ReplicatedStorage);
                runStartupThread("Observer", InstancePath, `Startup.Module.{InstancePath}`, function() -- Line: 138
                    -- upvalues: InstancePath (copy), runPhase (copy), child2 (copy)
                    debug.setmemorycategory((`Startup.Observer.{InstancePath}`));
                    runPhase("Require", InstancePath, require, child2);
                end);
            end;
        end;
    end;
end;

local Interface = ReplicatedStorage:WaitForChild("Interface");
runStartupThread("Interface", nil, "Startup.Module.Interface", function() -- Line: 145
    -- upvalues: runPhase (copy), Interface (copy)
    local v42, v43 = runPhase("Require", "Interface", require, Interface);

    if not v42 then
        return;
    end;

    if typeof(v43) ~= "table" then
        return;
    end;

    if v43.Initialize and not runPhase("Initialize", "Interface", v43.Initialize) then
        return;
    end;

    if v43.Start then
        runPhase("Start", "Interface", v43.Start);
    end;
end);