-- ReplicatedStorage.Shared.WeaponConstructor.AltFunctions.Silencer
-- Script path: ReplicatedStorage.Shared.WeaponConstructor.AltFunctions.Silencer
-- Decompile time: 4.52 ms

-- Decompiled with Potassium's decompiler.

local v1 = {};
local buffer_create_ret = buffer.create(4);

function v1.Off(p2) -- Line: 12
    p2.PacketDirty = true;
    p2.Mode = 2;
    p2.AltFunctionRun:Fire(p2);
    p2.SilencerMode = nil;
end;

function v1.On(p3) -- Line: 20
    p3.PacketDirty = true;
    p3.Mode = 1;
    p3.AltFunctionRun:Fire(p3);
    p3.SilencerMode = nil;
end;

function v1.Clear(p4) -- Line: 36
    p4.PacketDirty = true;

    if p4.Silencer then
        local Timer = p4.Timer;
        p4.FireDelay = Timer;
        p4.ReloadDelay = Timer;
        p4.InspectDelay = Timer;
        p4.AltFunctionDelay = Timer;
    end;

    p4.Silencer = false;
    p4.SilencerAction = false;
    p4.SilencerDelay = 0;
    p4.SilencerMode = nil;
end;

function v1.Run(p5: any, p6: boolean?) -- Line: 61
    -- upvalues: buffer_create_ret (copy)
    p5.PacketDirty = true;
    local Timer = p5.Timer;
    local AltFunction = p5.Data.AltFunction;
    local Full = AltFunction.SilencerRemove.Full;
    p5.SilencerMode = p5.Mode == 1 and 3 or 4;

    if p5.Mode == 1 then
        if not p6 then
            p5:PlayAnimation("SilencerOff");
        end;

        buffer.writef32(buffer_create_ret, 0, Timer + Full);
    else
        if not p6 then
            p5:PlayAnimation("SilencerOn");
        end;

        buffer.writef32(buffer_create_ret, 0, Timer + AltFunction.SilencerApply.Full);
    end;

    p5.Silencer = true;
    local buffer_readf32_ret = buffer.readf32(buffer_create_ret, 0);
    p5.SilencerDelay = buffer_readf32_ret;
    p5.FireDelay = buffer_readf32_ret;
    p5.ReloadDelay = buffer_readf32_ret;
    p5.InspectDelay = buffer_readf32_ret;
    p5.AltFunctionDelay = buffer_readf32_ret;
end;

return v1;