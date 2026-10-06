-- Decompiled with Potassium's decompiler.

local RunService = game:GetService("RunService");
local Parent = script.Parent.Parent.Parent;
local Tab = require(Parent.Tab);
local Imgui = require(Parent.Imgui);
local table_freeze_ret = table.freeze({ 60, 45, 30, 20, 15 });
local u1 = {
    internal = {
        FPSCap = {
            Enabled = false,
            Cap = 0
        }
    },
    interface = {}
};

function u1.internal.FPSCap.Set(p2: number) -- Line: 19
    -- upvalues: u1 (copy), RunService (copy)
    local FPSCap = u1.internal.FPSCap;

    if not p2 or p2 == 0 then
        FPSCap.Enabled = false;
        FPSCap.Cap = 0;

        return;
    end;

    local Enabled = FPSCap.Enabled;
    FPSCap.Enabled = true;
    FPSCap.Cap = p2;

    if not Enabled then
        task.spawn(function() -- Line: 32
            -- upvalues: FPSCap (copy), RunService (ref)
            while FPSCap.Enabled do
                local os_clock_ret = os.clock();
                RunService.Heartbeat:Wait();

                if FPSCap.Cap <= 0 then
                    break;
                end;

                while os_clock_ret + 1 / FPSCap.Cap >= os.clock() do

                end;
            end;
        end);
    end;
end;

function u1.interface.IsFPSCapEnabled(p3) -- Line: 47
    -- upvalues: u1 (copy)
    return u1.internal.FPSCap.Enabled;
end;

function u1.interface.GetFPSCap(p4) -- Line: 51
    -- upvalues: u1 (copy)
    return u1.internal.FPSCap.Cap;
end;

Tab.new("Performance", function(p5: userdata) -- Line: 55
    -- upvalues: u1 (copy), Imgui (copy), table_freeze_ret (copy)
    local FPSCap = u1.internal.FPSCap;

    return Imgui:Connect(p5, function() -- Line: 58
        -- upvalues: Imgui (ref), FPSCap (copy), table_freeze_ret (ref)
        Imgui:BeginHorizontal();
        Imgui:BeginGroup(UDim2.fromScale(0.5, 1));
        Imgui:BeginVertical();
        Imgui:Label((`FPS Cap - {FPSCap.Enabled and `Enabled ({FPSCap.Cap})` or "Disabled"}`));
        Imgui:BeginHorizontal();

        for _, v in table_freeze_ret do
            if Imgui:Button(v).activated() then
                FPSCap.Set(v);
            end;
        end;

        if FPSCap.Enabled and Imgui:Button("Disable Cap").activated() then
            FPSCap.Set(0);
        end;

        Imgui:End();
        Imgui:End();
        Imgui:End();
        Imgui:End();
    end);
end);

return u1.interface;