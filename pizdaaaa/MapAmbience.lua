-- ReplicatedStorage.ClientModules.NewMapAdded.MapAmbience
-- Script path: ReplicatedStorage.ClientModules.NewMapAdded.MapAmbience
-- Decompile time: 12.13 ms

-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local RunService = game:GetService("RunService");
local SoundManager = require(ReplicatedStorage.Shared.Managers.SoundManager);
local SoundData = require(ReplicatedStorage.Shared.Managers.SoundManager.SoundData);
local script_Zones = require(script.Zones);
local u1 = {};
local Random_new_ret = Random.new();
local u2 = nil;
local u3 = {};
local u4 = nil;
local u5 = false;
local u6 = {};
local u7 = {};
local u8 = nil;
local u9 = 0;

local function Has(p10: string) -- Line: 31
    -- upvalues: SoundData (copy)
    return SoundData.Entries[p10] ~= nil;
end;

local function Between(p11) -- Line: 35
    -- upvalues: Random_new_ret (copy)
    return Random_new_ret:NextNumber(p11[1], p11[2]);
end;

local function FindZone(p12: vector) -- Line: 39
    -- upvalues: u3 (copy), u2 (ref)
    local v13 = (1 / 0);
    local v14 = nil;

    for _, v in u3 do
        if v.Parent then
            local v15 = v.CFrame:PointToObjectSpace(p12);
            local v16 = v.Size / 2;

            if math.abs(v15.X) <= v16.X and (math.abs(v15.Y) <= v16.Y and math.abs(v15.Z) <= v16.Z) then
                local v17 = v.Size.X * v.Size.Y * v.Size.Z;

                if v17 < v13 then
                    v14 = v.Name;
                    v13 = v17;
                end;
            end;
        end;
    end;

    if not v14 then
        v14 = u2 and u2.Default;
    end;

    return v14;
end;

local function ApplyZone() -- Line: 62
    -- upvalues: u5 (ref), u2 (ref), u4 (ref), SoundData (copy), u6 (copy), SoundManager (copy), u7 (copy), Random_new_ret (copy)
    local v18 = u5 and (u2 and u4) and u2.Zones[u4];
    local v19 = {};

    if v18 then
        for _, v in v18.Loops do
            if SoundData.Entries[v.Key] ~= nil then
                v19[v.Key] = v;
            end;
        end;
    end;

    for i, v in u6 do
        v.Target = v19[i] and (v19[i].Volume or 0) or 0;
    end;

    for i, v in v19 do
        if not u6[i] then
            local v20 = SoundManager.Play(i, {
                Looped = true,
                Volume = 0,
                Pitch = v.Pitch
            });

            if v20 then
                u6[i] = {
                    Sound = v20,
                    Target = v.Volume,
                    Rate = v.Volume / 2
                };
            end;
        end;
    end;

    table.clear(u7);

    if v18 then
        local os_clock_ret = os.clock();

        for _, v in v18.Random do
            local Time = v.Time;
            u7[v] = os_clock_ret + Random_new_ret:NextNumber(Time[1], Time[2]);
        end;
    end;
end;

local function PlayRandom(p21) -- Line: 99
    -- upvalues: Random_new_ret (copy), SoundData (copy), SoundManager (copy)
    local v22 = p21.Keys[Random_new_ret:NextInteger(1, #p21.Keys)];

    if SoundData.Entries[v22] == nil then
        return;
    end;

    local v23 = {};
    local Volume = p21.Volume;
    v23.Volume = Random_new_ret:NextNumber(Volume[1], Volume[2]);
    local Pitch = p21.Pitch;
    v23.Pitch = Random_new_ret:NextNumber(Pitch[1], Pitch[2]);
    local workspace_CurrentCamera = workspace.CurrentCamera;

    if p21.Positional and workspace_CurrentCamera then
        local v24 = Random_new_ret:NextNumber(-3.141592653589793, 3.141592653589793);
        local CFrame = workspace_CurrentCamera.CFrame;
        v23.Position = CFrame.Position + 2.4984 * (math.cos(v24) * CFrame.RightVector + math.sin(v24) * CFrame.LookVector);
    end;

    SoundManager.Play(v22, v23);
end;

local function Step(p25: number) -- Line: 119
    -- upvalues: u5 (ref), u9 (ref), FindZone (copy), u4 (ref), ApplyZone (copy), u6 (copy), u7 (copy), Random_new_ret (copy), PlayRandom (copy)
    local os_clock_ret = os.clock();

    if u5 and u9 <= os_clock_ret then
        u9 = os_clock_ret + 0.5;
        local workspace_CurrentCamera = workspace.CurrentCamera;

        if workspace_CurrentCamera then
            workspace_CurrentCamera = FindZone(workspace_CurrentCamera.CFrame.Position);
        end;

        if workspace_CurrentCamera ~= u4 then
            u4 = workspace_CurrentCamera;
            ApplyZone();
        end;
    end;

    for i, v in u6 do
        local Sound = v.Sound;

        if Sound.Parent then
            local v26 = v.Target - Sound.Volume;
            local v27 = math.max(v.Rate, 0.01) * p25;
            Sound.Volume = Sound.Volume + math.clamp(v26, -v27, v27);

            if v.Target == 0 and Sound.Volume <= 0 then
                Sound:Destroy();
                u6[i] = nil;
            end;
        else
            u6[i] = nil;
            u4 = nil;
        end;
    end;

    if not u5 then
        return;
    end;

    for i, v in u7 do
        if v <= os_clock_ret then
            local Time = i.Time;
            u7[i] = os_clock_ret + Random_new_ret:NextNumber(Time[1], Time[2]);
            PlayRandom(i);
        end;
    end;
end;

function u1.Start(p28: string, p29: userdata?, p30: boolean) -- Line: 170
    -- upvalues: u1 (copy), u2 (ref), script_Zones (copy), u3 (copy), u5 (ref), u9 (ref), u8 (ref), RunService (copy), Step (copy)
    u1.Stop();
    u2 = script_Zones[p28];

    if not u2 then
        return;
    end;

    if p29 then
        p29 = p29:FindFirstChild("AmbienceZones");
    end;

    if p29 then
        for _, descendant in p29:GetDescendants() do
            if descendant:IsA("BasePart") and u2.Zones[descendant.Name] then
                table.insert(u3, descendant);
            end;
        end;
    end;

    u5 = p30;
    u9 = 0;
    u8 = RunService.Heartbeat:Connect(Step);
end;

function u1.Stop() -- Line: 194
    -- upvalues: u8 (ref), u6 (copy), u7 (copy), u3 (copy), u2 (ref), u4 (ref)
    if u8 then
        u8:Disconnect();
        u8 = nil;
    end;

    for _, v in u6 do
        v.Sound:Destroy();
    end;

    table.clear(u6);
    table.clear(u7);
    table.clear(u3);
    u2 = nil;
    u4 = nil;
end;

function u1.SetActive(p31: boolean) -- Line: 213
    -- upvalues: u5 (ref), u4 (ref), u9 (ref), ApplyZone (copy)
    if u5 == p31 then
        return;
    end;

    u5 = p31;
    u4 = nil;
    u9 = 0;

    if not p31 then
        ApplyZone();
    end;
end;

function u1.GetZone() -- Line: 227
    -- upvalues: u4 (ref)
    return u4;
end;

return u1;