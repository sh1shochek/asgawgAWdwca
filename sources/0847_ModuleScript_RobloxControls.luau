-- Decompiled with Potassium's decompiler.

local ContextActionService = game:GetService("ContextActionService");
local StarterGui = game:GetService("StarterGui");
local Players = game:GetService("Players");
local Promise = require(script.Parent.Promise);
local BindableEvent = Instance.new("BindableEvent");
local u1 = { Enum.CoreGuiType.All };
local u2 = {
    Public = {},
    Private = {}
};

function u2.Private.OnRespawnCharacterRequested() -- Line: 27
    -- upvalues: Players (copy)
    local Character = Players.LocalPlayer.Character;

    if not Character then
        return;
    end;

    local v3 = Character:FindFirstChildOfClass("Humanoid");

    if not v3 then
        return;
    end;

    v3.Health = 0;
end;

function u2.Public.SetCoreAsync(p4, ...) -- Line: 63
    -- upvalues: Promise (copy), StarterGui (copy)
    local u5 = { ... };

    return Promise.new(function(p6) -- Line: 66
        -- upvalues: StarterGui (ref), u5 (copy)
        local v7 = nil;

        while not v7 do
            local v8;
            v7, v8 = pcall(StarterGui.SetCore, StarterGui, table.unpack(u5));

            if not v7 then
                warn(v8);
            end;

            task.wait(0.5);
        end;

        return p6();
    end);
end;

function u2.Public.GetCoreAsync(p9, ...) -- Line: 100
    -- upvalues: Promise (copy), StarterGui (copy)
    local u10 = { ... };

    return Promise.new(function(p11) -- Line: 103
        -- upvalues: StarterGui (ref), u10 (copy)
        local v12 = nil;
        local v13 = nil;

        while not v12 do
            v12, v13 = pcall(StarterGui.SetCore, StarterGui, table.unpack(u10));

            if not v12 then
                warn(v13);
            end;

            task.wait(0.5);
        end;

        return p11(v13);
    end);
end;

function u2.Public.SetRespawnCallback(p14: any, p15: function) -- Line: 133
    -- upvalues: u2 (copy)
    u2.Private.OnRespawnCharacterRequested = p15;
end;

function u2.Public.DisableRespawning(p16) -- Line: 147
    p16:SetCoreAsync("ResetButtonCallback", false);
end;

function u2.Public.EnableRespawning(p17) -- Line: 161
    -- upvalues: BindableEvent (copy)
    p17:SetCoreAsync("ResetButtonCallback", BindableEvent);
end;

function u2.Public.SetDefaultCoreGui(p18, ...) -- Line: 179
    -- upvalues: u1 (ref), StarterGui (copy)
    u1 = { ... };
    StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.All, false);

    for _, v in u1 do
        StarterGui:SetCoreGuiEnabled(v, true);
    end;
end;

function u2.Public.EnableCoreGui(p19) -- Line: 199
    -- upvalues: u1 (ref), StarterGui (copy)
    for _, v in u1 do
        StarterGui:SetCoreGuiEnabled(v, true);
    end;
end;

function u2.Public.DisableCoreGui(p20) -- Line: 215
    -- upvalues: u1 (ref), StarterGui (copy)
    for _, v in u1 do
        StarterGui:SetCoreGuiEnabled(v, false);
    end;
end;

function u2.Public.DisableCharacterInput(p21) -- Line: 231
    -- upvalues: ContextActionService (copy)
    ContextActionService:BindAction("RobloxControls-FreezeAction", function() -- Line: 232
        return Enum.ContextActionResult.Sink;
    end, false, table.unpack(Enum.PlayerActions:GetEnumItems()));
end;

function u2.Public.EnableCharacterInput(p22) -- Line: 247
    -- upvalues: ContextActionService (copy)
    ContextActionService:UnbindAction("RobloxControls-FreezeAction");
end;

u2.Public:DisableRespawning();
BindableEvent.Event:Connect(function() -- Line: 252
    -- upvalues: u2 (copy)
    u2.Private.OnRespawnCharacterRequested();
end);

return u2.Public;