-- ReplicatedStorage.Packages.DebugTools.Client.Builtin.Tabs.Performance
-- Script path: ReplicatedStorage.Packages.DebugTools.Client.Builtin.Tabs.Performance
-- Decompile time: 1.09 ms

local RunService = game:GetService("RunService")
local Parent = script.Parent.Parent.Parent
local Tab = require(Parent.Tab)
local Imgui = require(Parent.Imgui)
local u22 = table.freeze({60, 45, 30, 20, 15})
local u23 = {internal = {FPSCap = {Enabled = false, Cap = 0}}, interface = {}}

function u23.internal.FPSCap.Set(a1) -- Line: 19 -- upvalues: u23 (val), RunService (val) -- types: a1: number
    local FPSCap = u23.internal.FPSCap
    if a1 and a1 ~= 0 then
        local Enabled = FPSCap.Enabled
        FPSCap.Enabled = true
        FPSCap.Cap = a1
        if not Enabled then
            task.spawn(function() -- Line: 32 -- upvalues: FPSCap (val), RunService (upval)
                local v1
                while FPSCap.Enabled do
                    v1 = os.clock()
                    RunService.Heartbeat:Wait()
                    if FPSCap.Cap <= 0 then
                        break
                    end
                    repeat
                    until v1 + 1 / FPSCap.Cap < os.clock()
                end
            end)
        end
        return
    end
    FPSCap.Enabled = false
    FPSCap.Cap = 0
end

function u23.interface.IsFPSCapEnabled(a1) -- Line: 47 -- upvalues: u23 (val)
    return u23.internal.FPSCap.Enabled
end

function u23.interface.GetFPSCap(a1) -- Line: 51 -- upvalues: u23 (val)
    return u23.internal.FPSCap.Cap
end

Tab.new("Performance", function(a1) -- Line: 55 -- upvalues: u23 (val), Imgui (val), u22 (val) -- types: a1: userdata
    local FPSCap = u23.internal.FPSCap
    return Imgui:Connect(a1, function() -- Line: 58 -- upvalues: Imgui (upval), FPSCap (val), u22 (upval)
        Imgui:BeginHorizontal()
        Imgui:BeginGroup((UDim2.fromScale(0.5, 1)))
        Imgui:BeginVertical()
        Imgui:Label((("FPS Cap - %*"):format(FPSCap.Enabled and ("Enabled (%*)"):format(FPSCap.Cap) or "Disabled")))
        Imgui:BeginHorizontal()
        for i, j in u22 do
            if Imgui:Button(j).activated() then
                FPSCap.Set(j)
            end
        end
        if FPSCap.Enabled and Imgui:Button("Disable Cap").activated() then
            FPSCap.Set(0)
        end
        Imgui:End()
        Imgui:End()
        Imgui:End()
        Imgui:End()
    end)
end)
return u23.interface