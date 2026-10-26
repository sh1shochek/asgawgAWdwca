-- ReplicatedStorage.Controllers.HordeController
-- class: ModuleScript

-- Decompiled with Potassium's decompiler.

local v1 = {};
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Workspace = game:GetService("Workspace");
local Players = game:GetService("Players");
local RunServiceController = require(ReplicatedStorage.Controllers.RunServiceController);
local HordeProtocol = require(ReplicatedStorage.Components.Common.HordeProtocol);
local IsSurvivalMode = require(ReplicatedStorage.Components.Common.IsSurvivalMode);
local Signal = require(ReplicatedStorage.Packages.Signal);
local script_DamageNumbers = require(script.DamageNumbers);
local script_HealthBars = require(script.HealthBars);
local script_RigShell = require(script.RigShell);
local Remotes = require(ReplicatedStorage.Database.Security.Remotes);
local BYTES_PER_ZOMBIE = HordeProtocol.BYTES_PER_ZOMBIE;
local HEADER_BYTES = HordeProtocol.HEADER_BYTES;
local STATE_DEAD = HordeProtocol.STATE_DEAD;
local STATE_AIRBORNE = HordeProtocol.STATE_AIRBORNE;
local HEALTH_STEPS = HordeProtocol.HEALTH_STEPS;
local LINK_GRAVITY = HordeProtocol.LINK_GRAVITY;
local u2 = Signal.new();
v1.HitConfirmed = u2;
local LocalPlayer = Players.LocalPlayer;
local u3 = {};
local u4 = {};
local u5 = {};
local u6 = 0;
local u7 = nil;
local u8 = nil;
local u9 = {};
local u10 = {};
local u11 = nil;
local u12 = {};
local u13 = {};

local function getContainer() -- Line: 176
    -- upvalues: u8 (ref), Workspace (copy), HordeProtocol (copy)
    local v14 = u8;

    if v14 and v14.Parent then
        return v14;
    end;

    local v15 = Workspace:FindFirstChild(HordeProtocol.SHELL_FOLDER);

    if v15 then
        u8 = v15;

        return v15;
    end;

    local Folder = Instance.new("Folder");
    Folder.Name = HordeProtocol.SHELL_FOLDER;
    Folder.Parent = Workspace;
    u8 = Folder;

    return Folder;
end;

local function profiled(u16: string, u17: function) -- Line: 194
    return function(...) -- Line: 195
        -- upvalues: u16 (copy), u17 (copy)
        debug.profilebegin(u16);
        u17(...);
        debug.profileend();
    end;
end;

local function tombstone(p18: number, p19: number) -- Line: 202
    -- upvalues: u5 (copy), u6 (ref)
    if not u5[p18] then
        u6 = u6 + 1;

        if u6 > 120 then
            table.clear(u5);
            u6 = 1;
        end;
    end;

    u5[p18] = p19;
end;

local u20 = nil;

local function ensureRender() -- Line: 215
    -- upvalues: u11 (ref), RunServiceController (copy), u20 (ref)
    if not u11 then
        u11 = RunServiceController.BindToRenderSteppedEvent("HordeController.Render", u20);
    end;
end;

local function createEntry(p21: number, p22: number, p23: vector, p24: number) -- Line: 221
    -- upvalues: u5 (copy), u6 (ref), script_RigShell (copy), u8 (ref), Workspace (copy), HordeProtocol (copy), HEALTH_STEPS (copy), u3 (copy), u11 (ref), RunServiceController (copy), u20 (ref)
    if u5[p21] then
        u5[p21] = nil;
        u6 = u6 - 1;
    end;

    local v25 = {
        DiedAt = nil,
        Hidden = false,
        StepDistance = 0,
        LastRenderPosition = nil,
        LastFootstepAt = (-1 / 0),
        WasAirborne = false,
        LastRootFrame = nil,
        NextMoveAt = 0,
        Paced = false,
        DisplayYaw = nil,
        YawEasedAt = 0,
        YawKnown = false
    };
    local Acquire = script_RigShell.Acquire;
    local v26 = u8;

    if not (v26 and v26.Parent) then
        v26 = Workspace:FindFirstChild(HordeProtocol.SHELL_FOLDER);

        if v26 then
            u8 = v26;
        else
            v26 = Instance.new("Folder");
            v26.Name = HordeProtocol.SHELL_FOLDER;
            v26.Parent = Workspace;
            u8 = v26;
        end;
    end;

    v25.Shell = Acquire(p21, p22, p23, v26);
    v25.HealthSteps = HEALTH_STEPS;
    v25.Samples = {
        {
            Yaw = 0,
            Airborne = false,
            Time = p24,
            Position = p23
        }
    };
    u3[p21] = v25;

    if not u11 then
        u11 = RunServiceController.BindToRenderSteppedEvent("HordeController.Render", u20);
    end;

    return v25;
end;

local function dropEntry(p27: number, p28: table, p29: boolean?) -- Line: 249
    -- upvalues: u3 (copy), script_HealthBars (copy), script_RigShell (copy)
    u3[p27] = nil;
    script_HealthBars.Remove(p27);

    if p29 then
        script_RigShell.Destroy(p28.Shell);

        return;
    end;

    script_RigShell.Recycle(p28.Shell);
end;

local function retireCorpse(p30: number, p31: table, p32: number) -- Line: 260
    -- upvalues: u3 (copy), script_HealthBars (copy), script_RigShell (copy), u4 (copy)
    u3[p30] = nil;
    script_HealthBars.Remove(p30);
    script_RigShell.Retire(p31.Shell);
    u4[#u4 + 1] = {
        SinkStartedAt = nil,
        NextSinkMoveAt = 0,
        Shell = p31.Shell,
        SinkAt = p32 + 3
    };
    local v33 = 0;

    for i = #u4, 1, -1 do
        local v34 = u4[i];
        local v35;

        if v34.SinkStartedAt then
            v35 = i;
        else
            v33 = v33 + 1;

            if v33 > 12 then
                v34.SinkAt = p32;
                v35 = i;
            else
                v35 = i;
            end;
        end;
    end;
end;

local function updateCorpses(p36: number) -- Line: 279
    -- upvalues: u13 (copy), script_RigShell (copy), u4 (copy), u9 (copy), u10 (copy)
    local v37 = 1;
    local table_remove_ret = table.remove(u13);

    if table_remove_ret then
        v37 = v37 - 1;
        debug.profilebegin("Horde.Recycle");
        script_RigShell.Recycle(table_remove_ret);
        debug.profileend();
    end;

    for i = #u4, 1, -1 do
        local v38 = u4[i];
        local Shell = v38.Shell;
        local SinkStartedAt = v38.SinkStartedAt;
        local v39;

        if Shell.Model.Parent then
            if SinkStartedAt then
                local v40 = (p36 - SinkStartedAt) / 2.5;

                if v40 >= 1 then
                    if script_RigShell.Bury(Shell, p36) then
                        table.remove(u4, i);
                        v39 = i;
                    elseif v37 > 0 then
                        v37 = v37 - 1;
                        table.remove(u4, i);
                        debug.profilebegin("Horde.Recycle");
                        script_RigShell.Recycle(Shell);
                        debug.profileend();
                        v39 = i;
                    else
                        v39 = i;
                    end;
                elseif v38.NextSinkMoveAt <= p36 then
                    v38.NextSinkMoveAt = p36 + 0.06666666666666667;
                    script_RigShell.AppendSink(Shell, 4 * v40 * v40 * (3 - 2 * v40), u9, u10);
                    v39 = i;
                else
                    v39 = i;
                end;
            elseif v38.SinkAt <= p36 then
                v38.SinkStartedAt = p36;
                debug.profilebegin("Horde.BeginSink");
                script_RigShell.BeginSink(Shell);
                debug.profileend();
                v39 = i;
            else
                v39 = i;
            end;
        else
            table.remove(u4, i);
            script_RigShell.Recycle(Shell);
            v39 = i;
        end;
    end;

    if v37 > 0 then
        debug.profilebegin("Horde.EvictBuried");
        script_RigShell.EvictBuried(p36);
        debug.profileend();
    end;
end;

local function pushSample(p41: table, p42: number, p43: vector, p44: number, p45: boolean) -- Line: 327
    local v46 = p41[#p41];

    if v46 and p42 <= v46.Time then
        return;
    end;

    if #p41 < 6 then
        p41[#p41 + 1] = {
            Time = p42,
            Position = p43,
            Yaw = p44,
            Airborne = p45
        };

        return;
    end;

    local table_remove_ret = table.remove(p41, 1);
    table_remove_ret.Time = p42;
    table_remove_ret.Position = p43;
    table_remove_ret.Yaw = p44;
    table_remove_ret.Airborne = p45;
    p41[#p41 + 1] = table_remove_ret;
end;

local function shiftSamples(p47: number) -- Line: 343
    -- upvalues: u3 (copy)
    for _, v in u3 do
        for _, v2 in v.Samples do
            v2.Time = v2.Time + p47;
        end;
    end;
end;

local function onStream(p48: buffer) -- Line: 351
    -- upvalues: HEADER_BYTES (copy), HordeProtocol (copy), BYTES_PER_ZOMBIE (copy), u7 (ref), shiftSamples (copy), u3 (copy), u5 (copy), STATE_DEAD (copy), createEntry (copy), pushSample (copy), STATE_AIRBORNE (copy), script_HealthBars (copy), HEALTH_STEPS (copy)
    if typeof(p48) ~= "buffer" then
        return;
    end;

    local buffer_len_ret = buffer.len(p48);

    if buffer_len_ret < HEADER_BYTES then
        return;
    end;

    local v49, v50 = HordeProtocol.readHeader(p48);

    if buffer_len_ret < HEADER_BYTES + v49 * BYTES_PER_ZOMBIE then
        return;
    end;

    local os_clock_ret = os.clock();
    local v51 = os_clock_ret - v50;
    local v52 = u7;

    if v52 and (v51 >= v52 and v51 - v52 <= 0.5) then
        v51 = v52 + (v51 - v52) * 0.05;
    elseif v52 then
        shiftSamples(v51 - v52);
    end;

    u7 = v51;
    local v53 = v50 + v51;
    local v54 = HEADER_BYTES;

    for i = 1, v49 do
        local v55, v56, v57, v58, v59, v60, v61;
        local v62 = 0;

        while true do
            if v62 == 0 then
                v62 = -1;
                local v63, v64, v65;
                v56, v63, v64, v65, v60, v58, v61 = HordeProtocol.readRecord(p48, v54);
                v54 = v54 + BYTES_PER_ZOMBIE;
                v55 = Vector3.new(v63, v64, v65);
                v57 = u3[v56];

                if v57 then
                    v62 = 1;
                    continue;
                end;

                local v66 = u5[v56];

                if v58 ~= STATE_DEAD and (not v66 or os_clock_ret - v66 >= 1) then
                    v57 = createEntry(v56, HordeProtocol.ARCHETYPE_NORMAL, v55, v53);
                    v62 = 1;
                    continue;
                end;

                v59 = i;
                v62 = 2;
                continue;
            elseif v62 == 1 then
                v62 = -1;
                local Samples = v57.Samples;
                local v67 = Samples[#Samples];

                if v67 and (v67.Position - v55).Magnitude > 20 then
                    table.clear(Samples);
                    v57.DisplayYaw = nil;
                    v59 = i;
                elseif v57.YawKnown then
                    v59 = i;
                else
                    v59 = i;

                    for _, v in Samples do
                        v.Yaw = v60;
                    end;

                    v57.DisplayYaw = nil;
                end;

                v57.YawKnown = true;
                pushSample(Samples, v53, v55, v60, v58 == STATE_AIRBORNE);
                local Shell = v57.Shell;

                if not Shell.Dead then
                    Shell.State = v58;
                end;

                if v61 ~= v57.HealthSteps then
                    v57.HealthSteps = v61;
                    script_HealthBars.SetHealth(v56, v61 / HEALTH_STEPS);
                end;

                v62 = 2;
                continue;
            elseif v62 == 2 then
                v62 = -1;
                break;
            else
                break;
            end;
        end;
    end;
end;

local function onSpawn(p68: table) -- Line: 418
    -- upvalues: u3 (copy), script_HealthBars (copy), script_RigShell (copy), createEntry (copy)
    local Id = p68.Id;
    local v69 = u3[Id];

    if v69 then
        u3[Id] = nil;
        script_HealthBars.Remove(Id);
        script_RigShell.Recycle(v69.Shell);
    end;

    createEntry(Id, p68.Archetype, p68.Feet, os.clock());
end;

local function onDeath(p70: table) -- Line: 427
    -- upvalues: u3 (copy), script_HealthBars (copy), STATE_DEAD (copy), u12 (copy)
    local v71 = u3[p70.Id];
    script_HealthBars.Remove(p70.Id);

    if v71 then
        local Shell = v71.Shell;
        Shell.Dead = true;
        Shell.State = STATE_DEAD;
        v71.DiedAt = os.clock();
        u12[#u12 + 1] = {
            Entry = v71,
            Data = p70
        };
    end;
end;

local function stepDeaths() -- Line: 440
    -- upvalues: u12 (copy), u3 (copy), script_RigShell (copy)
    for i = 1, math.min(#u12, 1) do
        local table_remove_ret = table.remove(u12, 1);
        local Entry = table_remove_ret.Entry;
        local Data = table_remove_ret.Data;
        local Shell = Entry.Shell;
        local v72;

        if u3[Data.Id] == Entry and not Shell.Ragdolled then
            debug.profilebegin("Horde.DeathCry");
            script_RigShell.DeathCry(Shell);
            debug.profileend();
            debug.profilebegin("Horde.Burst");
            script_RigShell.Burst(Shell);
            debug.profileend();
            debug.profilebegin("Horde.Ragdoll");
            local v73 = script_RigShell.Ragdoll(Shell, Data.Headshot, Data.Direction, Data.Position, Data.Part);
            debug.profileend();

            if v73 or not Shell.Animator then
                v72 = i;
            else
                Shell.Animator:stopAnimations(0.1);
                v72 = i;
            end;
        else
            v72 = i;
        end;
    end;
end;

local function onRemove(p74: number) -- Line: 464
    -- upvalues: u5 (copy), u6 (ref), u3 (copy), retireCorpse (copy), script_HealthBars (copy), script_RigShell (copy)
    local os_clock_ret = os.clock();

    if not u5[p74] then
        u6 = u6 + 1;

        if u6 > 120 then
            table.clear(u5);
            u6 = 1;
        end;
    end;

    u5[p74] = os_clock_ret;
    local v75 = u3[p74];

    if v75 then
        if v75.Shell.Ragdolled then
            retireCorpse(p74, v75, os_clock_ret);

            return;
        end;

        u3[p74] = nil;
        script_HealthBars.Remove(p74);
        script_RigShell.Recycle(v75.Shell);
    end;
end;

local function clearAll(p76: boolean?) -- Line: 478
    -- upvalues: u12 (copy), u9 (copy), u10 (copy), u3 (copy), u5 (copy), u6 (ref), retireCorpse (copy), script_HealthBars (copy), script_RigShell (copy), u13 (copy), Workspace (copy), u11 (ref), RunServiceController (copy), u20 (ref), u4 (copy), script_DamageNumbers (copy)
    local os_clock_ret = os.clock();
    table.clear(u12);

    if not p76 then
        table.clear(u9);
        table.clear(u10);

        for i, v in u3 do
            if not u5[i] then
                u6 = u6 + 1;

                if u6 > 120 then
                    table.clear(u5);
                    u6 = 1;
                end;
            end;

            u5[i] = os_clock_ret;
            local Shell = v.Shell;

            if Shell.Ragdolled then
                retireCorpse(i, v, os_clock_ret);
            else
                u3[i] = nil;
                script_HealthBars.Remove(i);
                script_RigShell.Retire(Shell);

                if Shell.Model.Parent then
                    local v77 = #u9 + 1;
                    local v78 = Shell.Root.CFrame - Vector3.new(0, 300, 0);
                    u9[v77] = Shell.Root;
                    u10[v77] = v78;
                end;

                u13[#u13 + 1] = Shell;
            end;
        end;

        if #u9 > 0 then
            Workspace:BulkMoveTo(u9, u10, Enum.BulkMoveMode.FireCFrameChanged);
            table.clear(u9);
            table.clear(u10);
        end;

        if not u11 then
            u11 = RunServiceController.BindToRenderSteppedEvent("HordeController.Render", u20);
        end;

        return;
    end;

    for i, v in u3 do
        if not u5[i] then
            u6 = u6 + 1;

            if u6 > 120 then
                table.clear(u5);
                u6 = 1;
            end;
        end;

        u5[i] = os_clock_ret;
        u3[i] = nil;
        script_HealthBars.Remove(i);

        if p76 then
            script_RigShell.Destroy(v.Shell);
        else
            script_RigShell.Recycle(v.Shell);
        end;
    end;

    for _, v in u4 do
        script_RigShell.Destroy(v.Shell);
    end;

    table.clear(u4);

    for _, v in u13 do
        script_RigShell.Destroy(v);
    end;

    table.clear(u13);
    script_RigShell.ClearPool();
    script_HealthBars.Clear();
    script_DamageNumbers.Clear();
end;

local function onHit(p79: table) -- Line: 529
    -- upvalues: u3 (copy), script_RigShell (copy), LocalPlayer (copy), u2 (copy), script_DamageNumbers (copy), script_HealthBars (copy), HEALTH_STEPS (copy)
    local Id = p79.Id;
    local Headshot = p79.Headshot;
    local Died = p79.Died;
    local v80 = p79.Part == "Burn";
    local v81 = u3[Id];

    if v81 and not (v81.Shell.Dead or v80) then
        script_RigShell.Flinch(v81.Shell, Headshot, p79.Direction);

        if not Died then
            script_RigShell.Pain(v81.Shell);
        end;
    end;

    if LocalPlayer and p79.AttackerUserId == LocalPlayer.UserId then
        if not v80 or Died then
            u2:Fire(Headshot, Died);
        end;

        if p79.Damage > 0 then
            script_DamageNumbers.Show(Id, p79.Position, p79.Damage, Headshot, Died, v80);

            if v81 and not (Died or v81.Shell.Dead) then
                script_HealthBars.Show(Id, v81.Shell.Model, v81.HealthSteps / HEALTH_STEPS);
            end;
        end;
    end;
end;

local function easeYaw(p82: table, p83: number, p84: number) -- Line: 554
    local DisplayYaw = p82.DisplayYaw;
    local v85 = p84 - p82.YawEasedAt;
    p82.YawEasedAt = p84;

    if DisplayYaw == nil then
        p82.DisplayYaw = p83;

        return p83;
    end;

    local v86 = (p83 - DisplayYaw + 3.141592653589793) % 6.283185307179586 - 3.141592653589793;

    if math.abs(v86) <= 0.002 then
        p82.DisplayYaw = p83;

        return p83;
    end;

    local v87 = DisplayYaw + v86 * (1 - math.exp(v85 * -14));
    p82.DisplayYaw = v87;

    return v87;
end;

local function sampleMotion(p88: table, p89: number) -- Line: 574
    -- upvalues: LINK_GRAVITY (copy), script_RigShell (copy)
    local Samples = p88.Samples;
    local v90 = #Samples;
    local v91 = Samples[v90];
    local _ = v91.Position;
    local Yaw = v91.Yaw;
    local Airborne = v91.Airborne;
    local Airborne2 = v91.Airborne;
    local v92 = Vector3.new(0, 0, 0);
    local v93 = nil;

    for i = v90 - 1, 1, -1 do
        local v94 = Samples[i];
        Airborne2 = Airborne2 or v94.Airborne;
        local v95 = v91.Time - v94.Time;

        if v95 >= 0.05 then
            v92 = (v91.Position - v94.Position) / v95;

            if Airborne2 then
                if v91.Airborne and v94.Airborne then
                    v93 = v92.Y - 0.5 * LINK_GRAVITY * v95;
                end;

                v92 = v92 * Vector3.new(1, 0, 1);
            end;

            local Magnitude = v92.Magnitude;

            if Magnitude > 30 then
                v92 = v92 * (30 / Magnitude);
            end;

            break;
        end;

        local _ = i;
    end;

    local v96 = p89 - v91.Time;
    local v97;

    if v96 >= 0 then
        local math_min_ret = math.min(v96, 0.1);
        v97 = v91.Position + v92 * math_min_ret;

        if v93 then
            local v98 = v97.Y + (v93 - 0.5 * LINK_GRAVITY * math_min_ret) * math_min_ret;

            if v98 < v97.Y then
                local v99 = script_RigShell.FloorHeight(v97, v97.Y - v98);

                if v99 then
                    v98 = math.max(v98, v99);
                end;
            end;

            v97 = Vector3.new(v97.X, v98, v97.Z);
        end;

        if v96 > 0.30000000000000004 then
            v92 = Vector3.new(0, 0, 0);
        end;
    else
        local v100 = Samples[1];
        local v101 = 1;

        for i = v90, 2, -1 do
            if Samples[i - 1].Time <= p89 then
                v100 = Samples[i - 1];
                v91 = Samples[i];
                v101 = i - 1;
                break;
            end;

            local _ = i;
        end;

        local v102 = v91.Time - v100.Time;
        local v103 = v102 <= 0 and 1 or math.clamp((p89 - v100.Time) / v102, 0, 1);
        v97 = v100.Position:Lerp(v91.Position, v103);

        if v100.Airborne then
            local v104 = v103 * v102;
            local v105 = v97.Y + 0.5 * LINK_GRAVITY * v104 * (v102 - v104);
            local v106 = Samples[v101 - 1];

            if not v91.Airborne and (v106 and v106.Airborne) then
                local v107 = v100.Time - v106.Time;
                local math_max_ret = math.max(v100.Position.Y + ((v100.Position.Y - v106.Position.Y) / v107 - 0.5 * LINK_GRAVITY * v107 - 0.5 * LINK_GRAVITY * v104) * v104, v91.Position.Y);
                v105 = math.min(v105, math_max_ret);
            end;

            v97 = Vector3.new(v97.X, v105, v97.Z);
        end;

        Yaw = v100.Yaw + ((v91.Yaw - v100.Yaw + 3.141592653589793) % 6.283185307179586 - 3.141592653589793) * v103;
        Airborne = v100.Airborne or v91.Airborne;
    end;

    return v97, Yaw, v92, Airborne;
end;

u20 = function() -- Line: 666, Name: render
    -- upvalues: Workspace (copy), u9 (copy), u10 (copy), u3 (copy), script_RigShell (copy), sampleMotion (copy), u8 (ref), HordeProtocol (copy), updateCorpses (copy), stepDeaths (copy), u4 (copy), u13 (copy), u11 (ref)
    local os_clock_ret = os.clock();
    local v108 = os_clock_ret - 0.12;
    local CurrentCamera = Workspace.CurrentCamera;
    local v109 = not CurrentCamera and Vector3.new(0, 0, 0) or CurrentCamera.CFrame.Position;
    table.clear(u9);
    table.clear(u10);
    local v110 = 1;

    for _, v in u3 do
        if #v.Samples ~= 0 then
            local Shell = v.Shell;

            if v.Paced and (os_clock_ret < v.NextMoveAt and not (Shell.Dead or Shell.Ragdolled)) then
                script_RigShell.Animate(Shell, os_clock_ret, Shell.LastVelocity, v.WasAirborne);
            else
                local v111, v112, v113, v114 = sampleMotion(v, v108);
                local Magnitude = (v111 - v109).Magnitude;
                local v115 = Magnitude > 260;

                if v115 ~= v.Hidden then
                    v.Hidden = v115;
                    debug.profilebegin("Horde.HideDistance");
                    local Model = Shell.Model;
                    local v116;

                    if v115 then
                        v116 = nil;
                    else
                        v116 = u8;

                        if not (v116 and v116.Parent) then
                            v116 = Workspace:FindFirstChild(HordeProtocol.SHELL_FOLDER);

                            if v116 then
                                u8 = v116;
                            else
                                v116 = Instance.new("Folder");
                                v116.Name = HordeProtocol.SHELL_FOLDER;
                                v116.Parent = Workspace;
                                u8 = v116;
                            end;
                        end;
                    end;

                    Model.Parent = v116;
                    debug.profileend();
                end;

                if not v115 then
                    local v117 = Magnitude > 150;

                    if v117 ~= Shell.Frozen then
                        script_RigShell.SetFrozen(Shell, v117);
                    end;

                    if not Shell.Ragdolled then
                        local v118, v119;

                        if Shell.Dead and v.DiedAt then
                            local v120 = os_clock_ret - v.DiedAt;
                            v118 = math.clamp(v120 / 1, 0, 1);
                            v119 = math.clamp((v120 - 1) / 1.2, 0, 1) * 4;
                        else
                            v118 = 0;
                            v119 = 0;
                        end;

                        Shell.LastVelocity = v113;
                        local v121 = v.WasAirborne and not v114;
                        v.WasAirborne = v114;

                        if not (Shell.Dead or (v117 or v114)) then
                            local LastRenderPosition = v.LastRenderPosition;

                            if LastRenderPosition and not v121 then
                                v.StepDistance = v.StepDistance + ((v111 - LastRenderPosition) * Vector3.new(1, 0, 1)).Magnitude;
                            end;

                            if v.StepDistance >= 2.6 or v121 then
                                v.StepDistance = 0;

                                if v110 > 0 and (Magnitude <= 70 and os_clock_ret - v.LastFootstepAt >= 0.25) then
                                    v110 = v110 - 1;
                                    v.LastFootstepAt = os_clock_ret;
                                    script_RigShell.Footstep(Shell, v111, os_clock_ret);
                                end;
                            end;
                        end;

                        v.LastRenderPosition = v111;
                        local RootFrame = script_RigShell.RootFrame;
                        local DisplayYaw = v.DisplayYaw;
                        local v122 = os_clock_ret - v.YawEasedAt;
                        v.YawEasedAt = os_clock_ret;

                        if DisplayYaw == nil then
                            v.DisplayYaw = v112;
                        else
                            local v123 = (v112 - DisplayYaw + 3.141592653589793) % 6.283185307179586 - 3.141592653589793;

                            if math.abs(v123) <= 0.002 then
                                v.DisplayYaw = v112;
                            else
                                v112 = DisplayYaw + v123 * (1 - math.exp(v122 * -14));
                                v.DisplayYaw = v112;
                            end;
                        end;

                        local v124 = RootFrame(v111, v112, v118, v119);
                        local v125 = v117 or Magnitude > 60;
                        v.Paced = v125;

                        if v124 ~= v.LastRootFrame and (not v125 or v.NextMoveAt <= os_clock_ret) then
                            v.LastRootFrame = v124;
                            v.NextMoveAt = os_clock_ret + (v117 and 0.05 or 0.025);
                            local v126 = #u9;
                            u9[v126 + 1] = Shell.Root;
                            u10[v126 + 1] = v124;
                        end;

                        script_RigShell.Animate(Shell, os_clock_ret, v113, v114);
                    end;
                end;
            end;
        end;
    end;

    updateCorpses(os_clock_ret);
    stepDeaths();
    script_RigShell.StepEffects();

    if #u9 > 0 then
        Workspace:BulkMoveTo(u9, u10, Enum.BulkMoveMode.FireCFrameChanged);
    end;

    if next(u3) == nil and (#u4 == 0 and (#u13 == 0 and (not script_RigShell.HasBuried() and u11))) then
        u11:Disconnect();
        u11 = nil;
    end;
end;

function v1.GetBodyPosition(p127: number) -- Line: 763
    -- upvalues: u3 (copy)
    local v128 = u3[p127];

    if not v128 then
        return nil;
    end;

    local UpperTorso = v128.Shell.Model:FindFirstChild("UpperTorso");

    if UpperTorso and UpperTorso:IsA("BasePart") then
        return UpperTorso.Position;
    end;

    return v128.Shell.Root.Position;
end;

function v1.GetLiveShells() -- Line: 777
    -- upvalues: u3 (copy)
    local v129 = {};

    for _, v in u3 do
        local Shell = v.Shell;

        if not (v.DiedAt or (Shell.Dead or v.Hidden)) then
            v129[#v129 + 1] = Shell.Model;
        end;
    end;

    return v129;
end;

function v1.GetLiveShell(p130: userdata) -- Line: 789
    -- upvalues: HordeProtocol (copy), u3 (copy)
    local v131 = p130:FindFirstAncestorOfClass("Model");

    while v131 and v131:GetAttribute(HordeProtocol.ID_ATTRIBUTE) == nil do
        v131 = v131:FindFirstAncestorOfClass("Model");
    end;

    if not v131 then
        return nil;
    end;

    local Attribute = v131:GetAttribute(HordeProtocol.ID_ATTRIBUTE);
    local v132;

    if typeof(Attribute) == "number" then
        v132 = u3[Attribute];
    else
        v132 = nil;
    end;

    if v132 and (v132.Shell.Model == v131 and not (v132.DiedAt or (v132.Shell.Dead or v132.Hidden))) then
        return v131;
    end;

    return nil;
end;

function v1.CountNear(p133: vector, p134: number, p135: number) -- Line: 807
    -- upvalues: u3 (copy)
    local v136 = 0;

    for _, v in u3 do
        if not (v.DiedAt or v.Shell.Dead) then
            local v137 = v.Samples[#v.Samples];

            if v137 then
                local v138 = v137.Position - p133;

                if math.abs(v138.Y) <= p135 and Vector2.new(v138.X, v138.Z).Magnitude <= p134 then
                    v136 = v136 + 1;
                end;
            end;
        end;
    end;

    return v136;
end;

function v1.Start() -- Line: 828
    -- upvalues: Remotes (copy), onSpawn (copy), onDeath (copy), onRemove (copy), clearAll (copy), onHit (copy), IsSurvivalMode (copy), script_RigShell (copy), Workspace (copy), ReplicatedStorage (copy), HordeProtocol (copy), onStream (copy)
    local u139 = onSpawn;
    local u140 = "Horde.Spawn";
    Remotes.Horde.Spawn.Listen(function(...) -- Line: 195
        -- upvalues: u140 (copy), u139 (copy)
        debug.profilebegin(u140);
        u139(...);
        debug.profileend();
    end);
    local u141 = onDeath;
    local u142 = "Horde.Death";
    Remotes.Horde.Death.Listen(function(...) -- Line: 195
        -- upvalues: u142 (copy), u141 (copy)
        debug.profilebegin(u142);
        u141(...);
        debug.profileend();
    end);
    local u143 = onRemove;
    local u144 = "Horde.Remove";
    Remotes.Horde.Remove.Listen(function(...) -- Line: 195
        -- upvalues: u144 (copy), u143 (copy)
        debug.profilebegin(u144);
        u143(...);
        debug.profileend();
    end);
    Remotes.Horde.Clear.Listen(function() -- Line: 832
        -- upvalues: clearAll (ref)
        clearAll();
    end);
    local u145 = onHit;
    local u146 = "Horde.Hit";
    Remotes.Horde.Hit.Listen(function(...) -- Line: 195
        -- upvalues: u146 (copy), u145 (copy)
        debug.profilebegin(u146);
        u145(...);
        debug.profileend();
    end);

    if IsSurvivalMode() then
        script_RigShell.Refill();
    end;

    Workspace:GetAttributeChangedSignal("Gamemode"):Connect(function() -- Line: 840
        -- upvalues: IsSurvivalMode (ref), script_RigShell (ref), clearAll (ref)
        if IsSurvivalMode() then
            script_RigShell.Refill();

            return;
        end;

        clearAll(true);
    end);
    task.spawn(function() -- Line: 847
        -- upvalues: ReplicatedStorage (ref), HordeProtocol (ref), onStream (ref), IsSurvivalMode (ref), Remotes (ref)
        local v147 = ReplicatedStorage:WaitForChild(HordeProtocol.STREAM_REMOTE, 60);

        if not v147 then
            return;
        end;

        local u148 = onStream;
        local u149 = "Horde.Stream";
        v147.OnClientEvent:Connect(function(...) -- Line: 195
            -- upvalues: u149 (copy), u148 (copy)
            debug.profilebegin(u149);
            u148(...);
            debug.profileend();
        end);

        if IsSurvivalMode() then
            Remotes.Horde.Sync.Send();
        end;
    end);
end;

return v1;