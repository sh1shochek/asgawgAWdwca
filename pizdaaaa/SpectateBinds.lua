-- ReplicatedStorage.GameClient.BindsController.SpectateBinds
-- Script path: ReplicatedStorage.GameClient.BindsController.SpectateBinds
-- Decompile time: 5.57 ms

-- Decompiled with Potassium's decompiler.

local v1 = {};
local u2 = nil;
local u3 = nil;
local u10 = {
    ["Spectate Next"] = {
        Callback = function(p4, p5) -- Line: 16, Name: Callback
            -- upvalues: u3 (ref), u2 (ref)
            if next(u3.FramePriority) then
                return;
            end;

            if p5 == Enum.UserInputState.Begin then
                u2.Next();
            end;
        end
    },
    ["Spectate Previous"] = {
        Callback = function(p6, p7) -- Line: 28, Name: Callback
            -- upvalues: u3 (ref), u2 (ref)
            if next(u3.FramePriority) then
                return;
            end;

            if p7 == Enum.UserInputState.Begin then
                u2.Previous();
            end;
        end
    },
    ["Spectate Mode"] = {
        Callback = function(p8, p9) -- Line: 40, Name: Callback
            -- upvalues: u3 (ref), u2 (ref)
            if next(u3.FramePriority) then
                return;
            end;

            if p9 == Enum.UserInputState.Begin then
                u2.ChangeMode();
            end;
        end
    }
};

function v1.Get() -- Line: 54
    -- upvalues: u10 (copy)
    return u10;
end;

function v1.Init(p11) -- Line: 60
    -- upvalues: u2 (ref), u3 (ref)
    u2 = p11:GetModule("Spectate");
    u3 = p11:GetModule("BindsController");
end;

return v1;