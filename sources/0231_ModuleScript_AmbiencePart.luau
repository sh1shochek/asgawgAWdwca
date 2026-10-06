-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local SoundService = game:GetService("SoundService");
local Workspace = game:GetService("Workspace");
local RunServiceController = require(ReplicatedStorage.Controllers.RunServiceController);
local Observers = require(ReplicatedStorage.Packages.Observers);
local Janitor = require(ReplicatedStorage.Shared.Janitor);
local Sound = require(ReplicatedStorage.Classes.Sound);
local u1 = {};
local u2 = nil;
local u3 = 0;

local function isPointInsideZone(p4: vector, p5: table) -- Line: 40
    local v6 = p5.BoundsCFrame:PointToObjectSpace(p4);
    local HalfSize = p5.HalfSize;
    local v7;

    if math.abs(v6.X) <= HalfSize.X and math.abs(v6.Y) <= HalfSize.Y then
        v7 = math.abs(v6.Z) <= HalfSize.Z;
    else
        v7 = false;
    end;

    return v7;
end;

local function stopHeartbeatIfIdle() -- Line: 50
    -- upvalues: u1 (copy), u2 (ref), u3 (ref)
    if next(u1) == nil then
        if u2 then
            u2:Disconnect();
            u2 = nil;
        end;

        u3 = 0;
    end;
end;

local function stepZones(p8: number) -- Line: 62
    -- upvalues: u3 (ref), Workspace (copy), u1 (copy), u2 (ref)
    u3 = u3 + p8;

    if u3 < 0.06666666666666667 then
        return;
    end;

    local v9 = u3;
    u3 = 0;
    local CurrentCamera = Workspace.CurrentCamera;

    if CurrentCamera then
        CurrentCamera = CurrentCamera.CFrame.Position;
    end;

    if not CurrentCamera then
        return;
    end;

    local math_min_ret = math.min(1, v9 * 3);

    for i, v in pairs(u1) do
        if i:IsDescendantOf(Workspace) then
            local v10 = v.BoundsCFrame:PointToObjectSpace(CurrentCamera);
            local HalfSize = v.HalfSize;
            local v11;

            if math.abs(v10.X) <= HalfSize.X and math.abs(v10.Y) <= HalfSize.Y then
                v11 = math.abs(v10.Z) <= HalfSize.Z;
            else
                v11 = false;
            end;

            for _, v2 in ipairs(v.SoundDataList) do
                local v12 = v11 and (v2.MaximumVolume or 0) or 0;
                local CurrentVolume = v2.CurrentVolume;
                local v13 = v12 - CurrentVolume;

                if v12 > 0 and not v2.Playing then
                    v2.GlobalSound:Resume();
                    v2.Playing = true;
                end;

                if math.abs(v13) <= 0.002 then
                    if CurrentVolume ~= v12 then
                        v2.GlobalSound.Volume = v12;
                    end;

                    v2.CurrentVolume = v12;

                    if v12 == 0 and v2.Playing then
                        v2.GlobalSound:Pause();
                        v2.Playing = false;
                    end;
                else
                    local v14 = CurrentVolume + v13 * math_min_ret;
                    v2.GlobalSound.Volume = v14;
                    v2.CurrentVolume = v14;
                end;
            end;
        else
            u1[i] = nil;
        end;
    end;

    if next(u1) == nil then
        if u2 then
            u2:Disconnect();
            u2 = nil;
        end;

        u3 = 0;
    end;
end;

local function ensureHeartbeat() -- Line: 120
    -- upvalues: u2 (ref), RunServiceController (copy), stepZones (copy)
    if u2 then
        return;
    end;

    u2 = RunServiceController.BindToHeartbeat("Observers.Game.AmbiencePart.UpdateZones", stepZones);
end;

return Observers.observeTag("AmbiencePart", function(u15: userdata) -- Line: 131
    -- upvalues: Janitor (copy), Sound (copy), SoundService (copy), u1 (copy), u2 (ref), RunServiceController (copy), stepZones (copy), u3 (ref)
    if not u15:IsDescendantOf(workspace) then
        return function() -- Line: 133
        end;
    end;

    local v16 = {};

    for _, child in u15:GetChildren() do
        if child:IsA("Sound") then
            table.insert(v16, child);
        end;
    end;

    if #v16 <= 0 then
        return function() -- Line: 144
        end;
    end;

    local u17 = Janitor.new();
    local v18 = {};

    for _, v in v16 do
        local v19 = u17:Add(v:Clone());
        v19.RollOffMode = Enum.RollOffMode.Inverse;
        v19.RollOffMaxDistance = 10000;
        v19.RollOffMinDistance = 10000;
        v19.SoundGroup = Sound.GameplaySoundGroup;
        v19.Parent = SoundService;
        v19.PlayOnRemove = false;
        v19.Volume = 0;
        table.insert(v18, {
            CurrentVolume = 0,
            Playing = false,
            MaximumVolume = v.Volume > 0 and v.Volume or 1,
            GlobalSound = v19
        });
    end;

    local u20 = {
        SoundDataList = v18,
        BoundsCFrame = u15.CFrame,
        HalfSize = u15.Size / 2
    };
    u1[u15] = u20;
    u17:Add(u15:GetPropertyChangedSignal("CFrame"):Connect(function() -- Line: 176
        -- upvalues: u20 (copy), u15 (copy)
        u20.BoundsCFrame = u15.CFrame;
    end));
    u17:Add(u15:GetPropertyChangedSignal("Size"):Connect(function() -- Line: 179
        -- upvalues: u20 (copy), u15 (copy)
        u20.HalfSize = u15.Size / 2;
    end));

    if not u2 then
        u2 = RunServiceController.BindToHeartbeat("Observers.Game.AmbiencePart.UpdateZones", stepZones);
    end;

    u17:Add(function() -- Line: 184
        -- upvalues: u1 (ref), u15 (copy), u2 (ref), u3 (ref)
        u1[u15] = nil;

        if next(u1) == nil then
            if u2 then
                u2:Disconnect();
                u2 = nil;
            end;

            u3 = 0;
        end;
    end);

    return function() -- Line: 189
        -- upvalues: u17 (copy)
        u17:Cleanup();
    end;
end);