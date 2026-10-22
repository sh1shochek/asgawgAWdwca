-- ReplicatedStorage.GameClient.CharacterController.CharacterReconciliation
-- Script path: ReplicatedStorage.GameClient.CharacterController.CharacterReconciliation
-- Decompile time: 13.19 ms

-- Decompiled with Potassium's decompiler.

local v1 = {};
local u2 = nil;
local u3 = nil;
local u4 = nil;
local u5 = nil;
local u6 = nil;
local u7 = nil;
local u8 = nil;
local u9 = {
    Position = 0.1,
    Velocity = 0.1,
    StepUp = 0.05,
    LastFullCrouchPosition = 0.1,
    AimPunchAngle = 0.001,
    DuckAmount = 0.00392156862745098,
    AccuracyPenalty = 0.001,
    RecoilIndex = 0.001
};
local u10 = {
    Height = 1000,
    CameraOffset = 100
};
local u11 = {
    AimPunchAngleVel = false,
    ViewPunchAngle = false,
    RandomSeed = false,
    HitPoints = false
};
local u12 = {
    Timer = true,
    RandomSeed = true
};
local u13 = {};
local u14 = nil;
local u15 = nil;

local function RefreshConfig() -- Line: 100
    -- upvalues: u13 (copy), u6 (ref)
    u13.TickRate = u6.Get("Game", "TickRate");
end;

v1.RefreshConfig = RefreshConfig;

function v1.GetMisPredictionOffset(p16) -- Line: 104
    local v17 = os.clock() - p16.MisPredictionTime;

    return v17 >= 0.1 and Vector3.new(0, 0, 0) or p16.MisPrediction * (1 - v17 / 0.1);
end;

local function ValidateTicks(p18, p19) -- Line: 121
    local LastClientTick = p19.LastClientTick;

    if p19.CurrentServerTick < p18.SpawnTick then
        return false;
    end;

    if p18.LastConfirmedServerState == 0 or LastClientTick > p18.LastConfirmedServerState then
        return true, LastClientTick, p19.LastServerTick, p19.CurrentServerTick;
    end;

    return false;
end;

local function RestoreCharacterState(p20, p21, p22, p23) -- Line: 139
    -- upvalues: u7 (ref), u2 (ref)
    local State = p21.State;

    if State then
        if buffer.len(p21.State) > 0 then
            State = u7:UnpackScheme(p21.State);
        else
            State = false;
        end;
    end;

    local ByTick = p20.StateHistory:GetByTick(p22);

    if State then
        local v24 = ByTick and u2.ApplyDelta(ByTick.Snapshot, State);

        if v24 then
            State = v24;
        elseif not State then
            if ByTick then
                State = ByTick.Snapshot;
            else
                State = ByTick;
            end;
        end;
    elseif ByTick then
        State = ByTick.Snapshot;
    else
        State = ByTick;
    end;

    if p22 == 0 or ByTick then
        return State;
    end;

    return nil;
end;

local function IsFullWeaponState(p25, p26) -- Line: 153
    if not (p25 and p26) then
        return true;
    end;

    local NameEnum = p26.NameEnum;

    if NameEnum and NameEnum ~= p25.NameEnum then
        return true;
    end;

    local Slot = p26.Slot;

    return Slot and Slot ~= p25.Slot and true or false;
end;

local function RestoreWeaponState(p27, p28, p29) -- Line: 178
    -- upvalues: u5 (ref), u8 (ref), u2 (ref)
    local ByTick = p27.WeaponStateHistory:GetByTick(p29);

    if ByTick then
        ByTick = ByTick.Snapshot;
    end;

    if not p28.WeaponState or buffer.len(p28.WeaponState) <= 0 then
        return ByTick;
    end;

    local v30, v31, v32 = u5.UnpackSlots(p28.WeaponState);
    local v33 = {
        HeldSlot = (v30 == 0 or not v30) and (ByTick and (ByTick.HeldSlot or 0) or 0) or v30,
        Slots = {}
    };

    for i = 0, 15 do
        local bit32_lshift_ret = bit32.lshift(1, i);
        local v34;

        if bit32.btest(v31, bit32_lshift_ret) then
            local v35;

            if ByTick then
                v35 = ByTick.Slots[i];
            else
                v35 = ByTick;
            end;

            local v36 = v32[i];

            if v36 then
                if buffer.len(v36) > 0 then
                    v36 = u8:UnpackScheme(v36);
                else
                    v36 = false;
                end;
            end;

            if v36 and next(v36) then
                local v37;

                if v35 and v36 then
                    local NameEnum = v36.NameEnum;

                    if NameEnum and NameEnum ~= v35.NameEnum then
                        v37 = true;
                    else
                        local Slot = v36.Slot;
                        v37 = Slot and Slot ~= v35.Slot and true or false;
                    end;
                else
                    v37 = true;
                end;

                v33.Slots[i] = v37 and v36 and v36 or u2.ApplyDelta(v35, v36);
                v34 = i;
            else
                v33.Slots[i] = v35;
                v34 = i;
            end;
        else
            v34 = i;
        end;
    end;

    return v33;
end;

local function WeaponAtTick(p38, p39) -- Line: 218
    while p38 and (p38.Predicted and p39 < p38.BuyTick) do
        p38 = p38.Replaced;
    end;

    return p38;
end;

local function ResolveWeapon(p40, p41) -- Line: 226
    -- upvalues: u3 (ref)
    local v42 = u3.GetWeaponInventory()[p40.Slot];

    while v42 and (v42.Predicted and p41 < v42.BuyTick) do
        v42 = v42.Replaced;
    end;

    return v42;
end;

local function IsWeaponStateReady(p43, p44) -- Line: 230
    -- upvalues: u3 (ref)
    if not p43 then
        return u3.GetCurrentWeapon() == nil;
    end;

    for _, v in u3.GetWeaponInventory() do
        local v45 = v;

        while v45 and v45.Predicted do
            if v45.BuyTick <= p44 then
                return false;
            end;

            v45 = v45.Replaced;
        end;
    end;

    local v46 = u3.GetWeaponInventory()[p43.Slot];

    while v46 and (v46.Predicted and p44 < v46.BuyTick) do
        v46 = v46.Replaced;
    end;

    local v47;

    if v46 == nil then
        v47 = false;
    else
        v47 = p43.NameEnum == nil and true or v46.NameEnum == p43.NameEnum;
    end;

    return v47;
end;

local function FilterPredictedCommands(p48, p49) -- Line: 273
    local PredictedCommands = p48.PredictedCommands;
    local v50 = 1;

    while PredictedCommands[v50] and PredictedCommands[v50].ClientTick <= p49 do
        v50 = v50 + 1;
    end;

    if v50 == 1 then
        return;
    end;

    local v51 = #PredictedCommands;
    table.move(PredictedCommands, v50, v51, 1);

    for i = v51 - v50 + 2, v51 do
        PredictedCommands[i] = nil;
        local _ = i;
    end;
end;

local function ReportMismatch(p52, p53, p54, p55) -- Line: 306
    local Slot = p55.Slot;

    if Slot then
        print("[Reconcile] weapon", p52, p53, p54, "slot", Slot, "enum", p55.NameEnum);
    else
        print("[Reconcile]", p52, p53, p54);
    end;

    return false;
end;

local function StatesMatch(p56, p57, p58) -- Line: 318
    -- upvalues: u9 (copy), u10 (copy)
    for i, v in p57 do
        if not (p58 and p58[i]) then
            local v59 = p56[i];

            if v59 ~= v and (v ~= false or v59 ~= nil) then
                local v60 = typeof(v);

                if v60 ~= typeof(v59) then
                    local Slot = p57.Slot;

                    if Slot then
                        print("[Reconcile] weapon", i, v59, v, "slot", Slot, "enum", p57.NameEnum);
                    else
                        print("[Reconcile]", i, v59, v);
                    end;

                    return false;
                end;

                local v61 = u9[i];
                local v62 = u10[i];

                if v62 then
                    local v63 = math.floor(v59 * v62) - v;

                    if math.abs(v63) >= 1.5 then
                        local v64 = v59 * v62;
                        local Slot = p57.Slot;

                        if Slot then
                            print("[Reconcile] weapon", i, v64, v, "slot", Slot, "enum", p57.NameEnum);
                        else
                            print("[Reconcile]", i, v64, v);
                        end;

                        return false;
                    end;
                elseif v60 == "number" then
                    if math.abs(v59 - v) >= (v61 or 0.001) then
                        local Slot = p57.Slot;

                        if Slot then
                            print("[Reconcile] weapon", i, v59, v, "slot", Slot, "enum", p57.NameEnum);
                        else
                            print("[Reconcile]", i, v59, v);
                        end;

                        return false;
                    end;
                else
                    if v60 ~= "Vector3" then
                        return false;
                    end;

                    if vector.magnitude(v59 - v) >= (v61 or 0.001) then
                        local Slot = p57.Slot;

                        if Slot then
                            print("[Reconcile] weapon", i, v59, v, "slot", Slot, "enum", p57.NameEnum);
                        else
                            print("[Reconcile]", i, v59, v);
                        end;

                        return false;
                    end;
                end;
            end;
        end;
    end;

    return true;
end;

local function HolsteredServerState(p65, p66, p67, p68) -- Line: 383
    while p66 and (p66.Predicted and p68 < p66.BuyTick) do
        p66 = p66.Replaced;
    end;

    if p66 then
        if p66 == p67 then
            p65 = false;
        elseif p65 then
            p65 = p65.Slots[p66.Slot];
        end;
    else
        p65 = p66;
    end;

    if p65 and p65.NameEnum == p66.NameEnum then
        return p66, p65;
    end;

    return p66, nil;
end;

local function CheckSimulationCache(p69, p70, p71, p72, p73) -- Line: 394
    -- upvalues: StatesMatch (copy), u11 (copy), u3 (ref), u12 (copy)
    local ByTick = p69.SimulationCache:GetByTick(p70);
    local v74;

    if ByTick == nil then
        v74 = false;
    else
        v74 = StatesMatch(ByTick.Snapshot, p71, u11);
    end;

    local ByTick2 = p69.WeaponSimulationCache:GetByTick(p70);

    if ByTick2 then
        ByTick2 = ByTick2.Snapshot;
    end;

    local v75;

    if ByTick2 == nil and p72 == nil then
        v75 = true;
    elseif ByTick2 and p72 then
        v75 = StatesMatch(ByTick2, p72) or false;
    else
        v75 = false;
    end;

    if not v75 then
        return v74, false;
    end;

    if p72 then
        p72 = u3.GetWeaponInventory()[p72.Slot];

        while p72 and (p72.Predicted and p70 < p72.BuyTick) do
            p72 = p72.Replaced;
        end;
    end;

    for _, v in u3.GetWeaponInventory() do
        local v76 = v;

        while v76 and (v76.Predicted and p70 < v76.BuyTick) do
            v76 = v76.Replaced;
        end;

        local v77;

        if v76 then
            if v76 == p72 then
                v77 = false;
            elseif p73 then
                v77 = p73.Slots[v76.Slot];
            else
                v77 = p73;
            end;
        else
            v77 = v76;
        end;

        if not v77 or v77.NameEnum ~= v76.NameEnum then
            v77 = nil;
        end;

        local v78 = v77 and v76.History and v76.History:GetByTick(p70);

        if v78 and not StatesMatch(v78.Snapshot, v77, u12) then
            return v74, false;
        end;
    end;

    return v74, true;
end;

local function ApplyStateToSimulation(p79, p80, p81, p82, p83) -- Line: 428
    -- upvalues: u3 (ref)
    local Position = p79.Simulation.Position;
    p79.Simulation:ReadState(p80);
    local WeaponInventory = u3.GetWeaponInventory();
    local CurrentWeapon = u3.GetCurrentWeapon();
    local v84;

    if p81 then
        v84 = u3.GetWeaponInventory()[p81.Slot];

        while v84 and (v84.Predicted and p83 < v84.BuyTick) do
            v84 = v84.Replaced;
        end;
    else
        v84 = p81;
    end;

    for _, v in WeaponInventory do
        local v85 = v;
        local v86 = p81 and p82;

        while v85 and (v85.Predicted and p83 < v85.BuyTick) do
            v85 = v85.Replaced;
        end;

        if v85 then
            if v85 == v84 then
                v86 = false;
            elseif v86 then
                v86 = v86.Slots[v85.Slot];
            end;
        else
            v86 = v85;
        end;

        if not v86 or v86.NameEnum ~= v85.NameEnum then
            v86 = nil;
        end;

        local v87 = not v86;

        if v87 then
            if v85 then
                if v85 == v84 then
                    v87 = false;
                else
                    v87 = v85.History and v85.History:GetByTick(p83);
                end;
            else
                v87 = v85;
            end;
        end;

        if v86 then
            v85:ReadState(v86);
            v85.Timer = p81.Timer;
            v85.RandomSeed = p81.RandomSeed;
        elseif v87 then
            v85:ReadState(v87.Snapshot);
        end;
    end;

    if v84 and v84 ~= CurrentWeapon then
        v84:Equip(p79, true);
    else
        v84 = CurrentWeapon;
    end;

    if v84 and p81 then
        v84:ReadState(p81);
    end;

    if p81 then
        p79.WeaponTimer = p81.Timer;
        local Simulation = p79.Simulation;
        Simulation.CommandCount = Simulation.CommandCount + ((p81.RandomSeed - Simulation.CommandCount + 32768) % 65536 - 32768);
    end;

    return Position, WeaponInventory;
end;

local function ResimulateCommands(p88, p89, p90) -- Line: 484
    -- upvalues: u2 (ref), u4 (ref), u3 (ref)
    local Simulation = p88.Simulation;
    local v91 = {};

    for i, v in p90 do
        if v.Predicted then
            v91[i] = v;
        end;
    end;

    for _, v in p88.PredictedCommands do
        local v92 = u2.Copy(v);
        local ClientTick = v92.ClientTick;

        for i, v2 in v91 do
            local v93 = v2;

            while v93 and (v93.Predicted and ClientTick < v93.BuyTick) do
                v93 = v93.Replaced;
            end;

            p90[i] = v93;
        end;

        Simulation:ProcessCommand(v92, p89, true);
        u4.ProcessCommand(p88, u3.GetCurrentWeapon(), p90, v92, true, p89);
        local CurrentWeapon = u3.GetCurrentWeapon();
        p88.SimulationCache:PushFilled(ClientTick, nil, Simulation.WriteState, Simulation);

        if CurrentWeapon then
            p88.WeaponSimulationCache:PushFilled(ClientTick, nil, CurrentWeapon.WriteState, CurrentWeapon);
        end;

        u3.PushWeaponHistory(p90, ClientTick);
    end;

    for i, v in v91 do
        p90[i] = v;
    end;

    local CurrentWeapon = u3.GetCurrentWeapon();

    if CurrentWeapon then
        CurrentWeapon.Resimulating = false;
    end;
end;

local function CalculateMisprediction(p94, p95) -- Line: 549
    local v96 = p95 - p94.Simulation.Position;
    local vector_magnitude_ret = vector.magnitude(v96);
    p94.ReconciliationCorrection = vector_magnitude_ret;

    if vector_magnitude_ret <= 0.1 or vector_magnitude_ret > 4.4416 then
        return;
    end;

    local v97 = os.clock() - p94.MisPredictionTime;
    local v98 = v96 + (v97 >= 0.1 and Vector3.new(0, 0, 0) or p94.MisPrediction * (1 - v97 / 0.1));
    local vector_magnitude_ret2 = vector.magnitude(v98);

    if vector_magnitude_ret2 > 4.4416 then
        v98 = v98 * (4.4416 / vector_magnitude_ret2) or v98;
    end;

    p94.MisPrediction = v98;
    p94.MisPredictionTime = os.clock();
end;

function v1.HandleNewState(p99) -- Line: 573
    -- upvalues: RestoreWeaponState (copy), IsWeaponStateReady (copy), RestoreCharacterState (copy), u15 (ref), u14 (ref), FilterPredictedCommands (copy), CheckSimulationCache (copy), u3 (ref), ApplyStateToSimulation (copy), u13 (copy), ResimulateCommands (copy), CalculateMisprediction (copy)
    local CurrentServerState = p99.CurrentServerState;
    local LastClientTick = CurrentServerState.LastClientTick;
    local v100, v101, v102;

    if CurrentServerState.CurrentServerTick < p99.SpawnTick or p99.LastConfirmedServerState ~= 0 and LastClientTick <= p99.LastConfirmedServerState then
        v100 = false;
        v101 = nil;
        LastClientTick = nil;
        v102 = nil;
    else
        v101 = CurrentServerState.LastServerTick;
        v102 = CurrentServerState.CurrentServerTick;
        v100 = true;
    end;

    if not v100 then
        p99.PreviousServerState = CurrentServerState;

        return;
    end;

    local v103 = RestoreWeaponState(p99, CurrentServerState, v101);
    local v104;

    if v103 then
        v104 = v103.Slots[v103.HeldSlot];
    else
        v104 = v103;
    end;

    if not IsWeaponStateReady(v104, LastClientTick) then
        return;
    end;

    local v105 = RestoreCharacterState(p99, CurrentServerState, v101, v102);

    if not v105 then
        p99.PreviousServerState = CurrentServerState;

        return;
    end;

    p99.PreviousServerState = CurrentServerState;
    p99.LastConfirmedServerState = LastClientTick;
    p99.StateHistory:Push(v102, nil, v105);
    u15.SetLocalHealth(v105.HitPoints);

    if v103 then
        p99.WeaponStateHistory:Push(v102, nil, v103);
    end;

    u14.SetCurrentServerFrame(v102);
    p99.ServerTick = v102;
    FilterPredictedCommands(p99, LastClientTick);
    local v106, v107 = CheckSimulationCache(p99, LastClientTick, v105, v104, v103);

    if v106 and v107 then
        p99.ReconciliationCorrection = 0;

        return;
    end;

    local _ = p99.PredictedCommands[#p99.PredictedCommands];
    local CurrentWeapon = u3.GetCurrentWeapon();
    local v108;

    if CurrentWeapon then
        v108 = CurrentWeapon.Data;
    else
        v108 = CurrentWeapon;
    end;

    local v109;

    if v108 then
        v109 = v108.Ammo;
    else
        v109 = v108;
    end;

    if v108 then
        v108 = v108.ReserveAmmo;
    end;

    local v110;

    if CurrentWeapon then
        v110 = CurrentWeapon.ZoomLevel;
    else
        v110 = CurrentWeapon;
    end;

    local v111;

    if CurrentWeapon then
        v111 = CurrentWeapon.Mode;
    else
        v111 = CurrentWeapon;
    end;

    local v112, v113 = ApplyStateToSimulation(p99, v105, v104, v103, LastClientTick);
    ResimulateCommands(p99, 1 / u13.TickRate, v113);
    local CurrentWeapon2 = u3.GetCurrentWeapon();
    local v114;

    if CurrentWeapon2 then
        v114 = CurrentWeapon2.Data;
    else
        v114 = CurrentWeapon2;
    end;

    if v114 and (CurrentWeapon2 ~= CurrentWeapon or (v114.Ammo ~= v109 or v114.ReserveAmmo ~= v108)) then
        u3.OnAmmoCorrected:Fire(CurrentWeapon2);
    end;

    if CurrentWeapon2 and (CurrentWeapon2.AltFunctionRun and (CurrentWeapon2 ~= CurrentWeapon or (CurrentWeapon2.ZoomLevel ~= v110 or CurrentWeapon2.Mode ~= v111))) then
        CurrentWeapon2.Resimulating = true;
        CurrentWeapon2.AltFunctionRun:Fire(CurrentWeapon2);
        CurrentWeapon2.Resimulating = false;
    end;

    if v106 then
        p99.ReconciliationCorrection = 0;

        return;
    end;

    CalculateMisprediction(p99, v112);
end;

function v1.Init(p115) -- Line: 665
    -- upvalues: u2 (ref), u3 (ref), u4 (ref), u5 (ref), u6 (ref), u14 (ref), u15 (ref), u13 (copy), RefreshConfig (copy)
    u2 = p115:GetModule("Table");
    u3 = p115:GetModule("WeaponController");
    u4 = p115:GetModule("WeaponConstructor");
    u5 = p115:GetModule("BufferScheme");
    u6 = p115:GetModule("GameConfiguration");
    u14 = p115:GetModule("ClientModule");
    u15 = p115:GetModule("Entities");
    u13.TickRate = u6.Get("Game", "TickRate");
    u6.Updated:Connect(RefreshConfig);
end;

function v1.Start(p116) -- Line: 678
    -- upvalues: u7 (ref), u5 (ref), u8 (ref)
    u7 = u5.GetScheme("CharacterState");
    u8 = u5.GetScheme("WeaponState");
end;

return v1;