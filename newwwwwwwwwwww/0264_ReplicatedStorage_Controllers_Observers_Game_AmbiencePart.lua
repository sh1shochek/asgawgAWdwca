-- AmbiencePart (ModuleScript)
-- full path: ReplicatedStorage.Controllers.Observers.Game.AmbiencePart

-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local SoundService = game:GetService("SoundService");
local Workspace = game:GetService("Workspace");
local LocalPlayer = game:GetService("Players").LocalPlayer;
local RunServiceController = require(ReplicatedStorage.Controllers.RunServiceController);
local DataController = require(ReplicatedStorage.Controllers.DataController);
local Observers = require(ReplicatedStorage.Packages.Observers);
local Janitor = require(ReplicatedStorage.Shared.Janitor);
local Sound = require(ReplicatedStorage.Classes.Sound);
local u1 = {};
local u2 = nil;
local u3 = 0;
local u4 = 1;
local u5 = 0;

local function getClosestZonePoint(p6: vector, p7: table) -- Line: 59
    local v8 = p7.BoundsCFrame:PointToObjectSpace(p6);
    local HalfSize = p7.HalfSize;

    return v8, v8:Max(-HalfSize):Min(HalfSize);
end;

local function stopRenderStepIfIdle() -- Line: 67
    -- upvalues: u1 (copy), u2 (ref), u3 (ref)
    if next(u1) == nil then
        if u2 then
            u2:Disconnect();
            u2 = nil;
        end;

        u3 = 0;
    end;
end;

local function stepVolumes(p9: table, p10: number, p11: number) -- Line: 79
    -- upvalues: u4 (ref)
    for _, v in ipairs(p9.SoundDataList) do
        local v12 = p10 <= v.AudibleRange and (v.MaximumVolume * u4 or 0) or 0;
        local CurrentVolume = v.CurrentVolume;
        local v13 = v12 - CurrentVolume;

        if v12 > 0 and not v.Playing then
            v.LoopSound:Resume();
            v.Playing = true;
        end;

        if math.abs(v13) <= 0.002 then
            if CurrentVolume ~= v12 then
                v.LoopSound.Volume = v12;
            end;

            v.CurrentVolume = v12;

            if v12 == 0 and v.Playing then
                v.LoopSound:Pause();
                v.Playing = false;
            end;
        else
            local v14 = CurrentVolume + v13 * p11;
            v.LoopSound.Volume = v14;
            v.CurrentVolume = v14;
        end;
    end;
end;

local function stepZones(p15: number) -- Line: 115
    -- upvalues: u3 (ref), u5 (ref), Workspace (copy), u1 (copy), stepVolumes (copy), u2 (ref)
    u3 = u3 + p15;
    local v16 = u3;
    local v17 = u3 >= 0.06666666666666667;

    if not v17 and u5 == 0 then
        return;
    end;

    local CurrentCamera = Workspace.CurrentCamera;

    if CurrentCamera then
        CurrentCamera = CurrentCamera.CFrame.Position;
    end;

    if not CurrentCamera then
        return;
    end;

    if v17 then
        u3 = 0;
    end;

    local math_min_ret = math.min(1, v16 * 3);

    for i, v in pairs(u1) do
        local Emitter = v.Emitter;

        if v17 or Emitter then
            if i:IsDescendantOf(Workspace) then
                local v18 = v.BoundsCFrame:PointToObjectSpace(CurrentCamera);
                local HalfSize = v.HalfSize;
                local v19 = v18:Max(-HalfSize):Min(HalfSize);

                if Emitter and Emitter.Position ~= v19 then
                    Emitter.Position = v19;
                end;

                if v17 then
                    stepVolumes(v, (v18 - v19).Magnitude, math_min_ret);
                end;
            else
                u1[i] = nil;
            end;
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

local function ensureRenderStep() -- Line: 157
    -- upvalues: u2 (ref), RunServiceController (copy), stepZones (copy)
    if u2 then
        return;
    end;

    u2 = RunServiceController.BindToRenderStep("Observers.Game.AmbiencePart.UpdateZones", Enum.RenderPriority.Last.Value, stepZones);
end;

DataController.CreateListener(LocalPlayer, "Settings.Audio.Audio.Master Volume", function(p20) -- Line: 173
    -- upvalues: u4 (ref)
    u4 = (tonumber(p20) or 100) / 100;

    return nil;
end);

return Observers.observeTag("AmbiencePart", function(u21: userdata) -- Line: 181
    -- upvalues: Janitor (copy), u5 (ref), Sound (copy), SoundService (copy), u1 (copy), u2 (ref), RunServiceController (copy), stepZones (copy), u3 (ref)
    if not u21:IsDescendantOf(workspace) then
        return function() -- Line: 183
        end;
    end;

    local v22 = {};

    for _, child in u21:GetChildren() do
        if child:IsA("Sound") then
            table.insert(v22, child);
        end;
    end;

    if #v22 <= 0 then
        return function() -- Line: 194
        end;
    end;

    local u23 = Janitor.new();
    local v24 = {};
    local v25;

    if u21:GetAttribute("Positional") == true then
        v25 = u23:Add(Instance.new("Attachment"));
        v25.Name = "AmbienceEmitter";
        v25.Parent = u21;
        u5 = u5 + 1;
        u23:Add(function() -- Line: 208
            -- upvalues: u5 (ref)
            u5 = u5 - 1;
        end, true);
    else
        v25 = nil;
    end;

    for _, v in v22 do
        local v26 = u23:Add(v:Clone());

        if not v25 then
            v26.RollOffMode = Enum.RollOffMode.Inverse;
            v26.RollOffMaxDistance = 10000;
            v26.RollOffMinDistance = 10000;
        end;

        v26.SoundGroup = Sound.GameplaySoundGroup;
        v26.Parent = v25 or SoundService;
        v26.PlayOnRemove = false;
        v26.Volume = 0;
        table.insert(v24, {
            CurrentVolume = 0,
            Playing = false,
            MaximumVolume = v.Volume > 0 and (v.Volume or 1) or 1,
            LoopSound = v26,
            AudibleRange = v25 and v.RollOffMaxDistance or 0
        });
    end;

    local u27 = {
        SoundDataList = v24,
        BoundsCFrame = u21.CFrame,
        HalfSize = u21.Size / 2,
        Emitter = v25
    };
    u1[u21] = u27;
    u23:Add(u21:GetPropertyChangedSignal("CFrame"):Connect(function() -- Line: 242
        -- upvalues: u27 (copy), u21 (copy)
        u27.BoundsCFrame = u21.CFrame;
    end));
    u23:Add(u21:GetPropertyChangedSignal("Size"):Connect(function() -- Line: 245
        -- upvalues: u27 (copy), u21 (copy)
        u27.HalfSize = u21.Size / 2;
    end));

    if not u2 then
        u2 = RunServiceController.BindToRenderStep("Observers.Game.AmbiencePart.UpdateZones", Enum.RenderPriority.Last.Value, stepZones);
    end;

    u23:Add(function() -- Line: 250
        -- upvalues: u1 (ref), u21 (copy), u2 (ref), u3 (ref)
        u1[u21] = nil;

        if next(u1) == nil then
            if u2 then
                u2:Disconnect();
                u2 = nil;
            end;

            u3 = 0;
        end;
    end);

    return function() -- Line: 255
        -- upvalues: u23 (copy)
        u23:Cleanup();
    end;
end);