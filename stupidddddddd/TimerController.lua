-- ReplicatedStorage.Controllers.TimerController
-- Script path: ReplicatedStorage.Controllers.TimerController
-- Decompile time: 1.35 ms

local u0 = {}
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local u6 = {}

local function WaitForTimersLoaded(a1) -- Line: 16 -- upvalues: ReplicatedStorage (val) -- types: a1: number
    local v1 = 0
    while not ReplicatedStorage:GetAttribute("TimersLoaded") do
        v1 = v1 + task.wait()
        if a1 <= v1 then
            break
        end
    end
end

local function FireTimerListeners(a1) -- Line: 28 -- upvalues: u6 (val), u0 (val) -- types: a1: string
    local v1 = u6[a1]
    if v1 and #v1 ~= 0 then
        local v2 = u0.GetTimer(a1)
        for i, j in v1 do
            j(v2)
        end
        return
    end
end

function u0.GetTimer(a1) -- Line: 45 -- upvalues: ReplicatedStorage (val) -- types: a1: string
    local Attribute = ReplicatedStorage:GetAttribute((("timers_source/%*"):format(a1)))
    assert(typeof(Attribute) == "number", "Timer attribute is not a number.")
    return Attribute
end

function u0.ListenToTimerChanged(a1, a2) -- Line: 53 -- upvalues: u0 (val), u6 (val) -- types: a1: string, a2: function
    local v1 = u0.GetTimer(a1)
    local v2 = u6[a1] or {}
    u6[a1] = v2
    table.insert(u6[a1], a2)
    a2(v1)
end

function u0.Initialize() -- Line: 64 -- upvalues: WaitForTimersLoaded (val), ReplicatedStorage (val), u6 (val), u0 (val)
    local find, v1, v2
    WaitForTimersLoaded(10)
    for i in ReplicatedStorage:GetAttributes() do
        find = string.find
        v1 = string.lower(i)
        if find(v1, "timers_source") then
            local u25 = string.gsub(i, "timers_source/", "")
            v1 = u6[u25]
            if v1 and #v1 ~= 0 then
                v2 = u0.GetTimer(u25)
                for j, k in v1 do
                    k(v2)
                end
            end
            ;(ReplicatedStorage:GetAttributeChangedSignal(i)):Connect(function() -- Line: 71 -- upvalues: u25 (val), u6 (upval), u0 (upval)
                local v1 = u25
                local v2 = u6[v1]
                if v2 then
                    if #v2 == 0 then
                        return
                    end
                    local v3 = u0.GetTimer(v1)
                    for i, j in v2 do
                        j(v3)
                    end
                end
            end)
        end
    end
end

return u0