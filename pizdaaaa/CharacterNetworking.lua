-- ReplicatedStorage.GameClient.CharacterController.CharacterNetworking
-- Script path: ReplicatedStorage.GameClient.CharacterController.CharacterNetworking
-- Decompile time: 12.72 ms

-- Decompiled with Potassium's decompiler.

local v1 = {};
local u2 = nil;
local u3 = nil;
local u4 = nil;
local u5 = nil;
local u6 = {};

local function RefreshConfig() -- Line: 15
    -- upvalues: u6 (copy), u5 (ref)
    u6.TickRate = u5.Get("Game", "TickRate");
    local v7 = u5.Get("Network", "CommandBackup") or 0;
    u6.CommandBackup = math.max(v7, 0);
    local v8 = u5.Get("Network", "CommandResend") or 0;
    u6.CommandResend = math.max(v8, u6.CommandBackup);
    u6.IdleCommand = u5.Get("Network", "IdleCommand");
    u6.IdleCommandWaitMultiplier = u5.Get("Network", "IdleCommandWaitMultiplier") or 1;
    local v9 = u5.Get("Network", "IdleCommandSendRate") or 10;
    local math_max_ret = math.max(v9, 1);
    local math_round_ret = math.round(u6.TickRate / math_max_ret);
    u6.IdleCommandSendInterval = math.max(math_round_ret, 1);
end;

local u10 = {};

local function IsIdleCommand(p11, p12) -- Line: 39
    if not p12 then
        return false;
    end;

    local Inputs = p11.Inputs;
    local AdditionalInputs = p11.AdditionalInputs;
    local WishBooleans = p11.WishBooleans;
    local v13 = not (Inputs.Forward or Inputs.Backward or (Inputs.Left or Inputs.Right) or (AdditionalInputs.Duck or (AdditionalInputs.Walk or AdditionalInputs.Jump or (AdditionalInputs.PressE or AdditionalInputs.Ping)) or (WishBooleans.WishInspect or (WishBooleans.WishFire or WishBooleans.WishFire2 or (WishBooleans.WishReload or WishBooleans.WishDrop)))));

    if v13 then
        if p11.Yaw == p12.Yaw and p11.Pitch == p12.Pitch then
            v13 = p11.WishEquip == p12.WishEquip;
        else
            v13 = false;
        end;
    end;

    return v13;
end;

local function RingStateChanged(p14: any, p15: number) -- Line: 57
    -- upvalues: u3 (ref)
    local ByTick = p14:GetByTick(p15);
    local ByTick2 = p14:GetByTick(p15 - 1);

    if not (ByTick and (ByTick.Snapshot and (ByTick2 and ByTick2.Snapshot))) then
        return true;
    end;

    local _, v16 = u3.Delta(ByTick2.Snapshot, ByTick.Snapshot);

    return v16 == true;
end;

local function IsIdleStateStable(p17: any, p18: number) -- Line: 72
    -- upvalues: u3 (ref)
    local SimulationCache = p17.SimulationCache;
    local ByTick = SimulationCache:GetByTick(p18);
    local ByTick2 = SimulationCache:GetByTick(p18 - 1);
    local v19;

    if ByTick and (ByTick.Snapshot and (ByTick2 and ByTick2.Snapshot)) then
        local _, v20 = u3.Delta(ByTick2.Snapshot, ByTick.Snapshot);
        v19 = v20 == true;
    else
        v19 = true;
    end;

    if v19 then
        return false;
    end;

    local WeaponSimulationCache = p17.WeaponSimulationCache;
    local ByTick3 = WeaponSimulationCache:GetByTick(p18);
    local ByTick4 = WeaponSimulationCache:GetByTick(p18 - 1);

    if ByTick3 or ByTick4 then
        if not (ByTick3 and ByTick4) then
            return false;
        end;

        local _, v21 = u3.Delta(ByTick4.Snapshot, ByTick3.Snapshot);

        if v21 then
            return false;
        end;
    end;

    return true;
end;

local function SendIdle(p22) -- Line: 95
    -- upvalues: u2 (ref)
    u2.Character.CommandIdle.Fire({
        ClientTick = p22.ClientTick,
        ServerTick = p22.ServerTick
    });
end;

local function ShouldSendStableIdle(p23: number, p24: number) -- Line: 102
    return p23 % p24 == 0;
end;

local function Flush(p25) -- Line: 136
    -- upvalues: u6 (copy), u10 (copy), u2 (ref)
    local Commands = p25.Commands;
    local v26 = #Commands;

    if v26 == 0 then
        return;
    end;

    local CommandBackup = u6.CommandBackup;

    if os.clock() - (p25.LastStateArrival or 0) > CommandBackup / u6.TickRate then
        CommandBackup = u6.CommandResend;
    end;

    local PredictedCommands = p25.PredictedCommands;
    local v27 = #PredictedCommands;

    while v27 > 0 and Commands[1].ClientTick <= PredictedCommands[v27].ClientTick do
        v27 = v27 - 1;
    end;

    table.clear(u10);
    local math_max_ret = math.max(30 - v26, 0);
    local v28 = 0;
    local v29 = 0;

    for i = 1, v27 do
        local v30 = PredictedCommands[i];
        local v31;

        if v30.Shot and (v30.Sends or 0) < 16 then
            v28 = v28 + 1;
            v31 = i;
        else
            v31 = i;
        end;
    end;

    local v32 = math_max_ret - math.min(v28, math_max_ret);
    local v33 = v27 - math.min(CommandBackup, v32) + 1;
    local math_max_ret2 = math.max(v33, 1);
    local v34 = math_max_ret - (v27 - math_max_ret2 + 1);

    for i = 1, math_max_ret2 - 1 do
        local v35 = PredictedCommands[i];
        local v36;

        if v34 > 0 and (v35.Shot and (v35.Sends or 0) < 16) then
            v35.Sends = (v35.Sends or 0) + 1;
            v34 = v34 - 1;
            v29 = v29 + 1;
            u10[v29] = v35;
            v36 = i;
        else
            v36 = i;
        end;
    end;

    for i = math_max_ret2, v27 do
        v29 = v29 + 1;
        u10[v29] = PredictedCommands[i];
        local _ = i;
    end;

    for i = 1, v26 do
        v29 = v29 + 1;
        u10[v29] = Commands[i];
        local _ = i;
    end;

    u2.Character.CommandArray.Fire(u10);
    table.clear(Commands);
end;

local function ResetInputStates(p37) -- Line: 220
    -- upvalues: u4 (ref)
    if u4.GetKeyState("WishDrop") then
        u4.UpdateKeyState("WishDrop", false);
    end;
end;

function v1.ProcessPacket(p38) -- Line: 228
    -- upvalues: u3 (ref), u6 (copy), IsIdleCommand (copy), Flush (copy), IsIdleStateStable (copy), u2 (ref), u4 (ref)
    local v39 = u3.PackTables(p38.CurrentCommand, p38.CurrentWeaponCommand);
    local v40 = p38.PredictedCommands[#p38.PredictedCommands];
    p38.TotalCommandCount = p38.TotalCommandCount + 1;
    table.insert(p38.PredictedCommands, v39);

    if #p38.PredictedCommands > u6.TickRate * 2 then
        table.remove(p38.PredictedCommands, 1);
    end;

    local v41 = u6.IdleCommand and IsIdleCommand(v39, v40);

    if v41 then
        p38.IdleTicks = (p38.IdleTicks or 0) + 1;
    else
        p38.IdleTicks = 0;
    end;

    if v41 and p38.IdleTicks >= u6.IdleCommandWaitMultiplier then
        p38.IdleCommandCount = p38.IdleCommandCount + 1;
        Flush(p38);

        if IsIdleStateStable(p38, v39.ClientTick) then
            p38.IdleStateTicks = (p38.IdleStateTicks or 0) + 1;
            p38.PendingIdleCommand = v39;

            if p38.IdleStateTicks % u6.IdleCommandSendInterval == 0 then
                u2.Character.CommandIdle.Fire({
                    ClientTick = v39.ClientTick,
                    ServerTick = v39.ServerTick
                });
                p38.PendingIdleCommand = nil;
            end;
        else
            p38.IdleStateTicks = 0;

            if p38.PendingIdleCommand then
                local PendingIdleCommand = p38.PendingIdleCommand;
                u2.Character.CommandIdle.Fire({
                    ClientTick = PendingIdleCommand.ClientTick,
                    ServerTick = PendingIdleCommand.ServerTick
                });
                p38.PendingIdleCommand = nil;
            end;

            u2.Character.CommandIdle.Fire({
                ClientTick = v39.ClientTick,
                ServerTick = v39.ServerTick
            });
        end;
    else
        if p38.PendingIdleCommand then
            local PendingIdleCommand = p38.PendingIdleCommand;
            u2.Character.CommandIdle.Fire({
                ClientTick = PendingIdleCommand.ClientTick,
                ServerTick = PendingIdleCommand.ServerTick
            });
            p38.PendingIdleCommand = nil;
        end;

        p38.IdleStateTicks = 0;
        table.insert(p38.Commands, v39);
    end;

    if u4.GetKeyState("WishDrop") then
        u4.UpdateKeyState("WishDrop", false);
    end;
end;

function v1.FlushPacket(p42) -- Line: 299
    -- upvalues: Flush (copy)
    Flush(p42);
end;

function v1.Init(p43) -- Line: 305
    -- upvalues: u2 (ref), u3 (ref), u4 (ref), u5 (ref), RefreshConfig (copy)
    u2 = p43:GetModule("Network");
    u3 = p43:GetModule("Table");
    u4 = p43:GetModule("WeaponController");
    u5 = p43:GetModule("GameConfiguration");
    RefreshConfig();
    u5.Updated:Connect(RefreshConfig);
end;

return v1;