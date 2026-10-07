-- ReplicatedStorage.Controllers.CaptureController
-- Script path: ReplicatedStorage.Controllers.CaptureController
-- Decompile time: 0.44 ms

local v1 = {}
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CaptureService = game:GetService("CaptureService")
local Promise = require((ReplicatedStorage:WaitForChild("Shared")):WaitForChild("Promise"))

function v1.CaptureScreenshot(a1) -- Line: 13 -- upvalues: Promise (val), CaptureService (val) -- types: a1: function?
    return Promise.new(function(a1_2, a2) -- Line: 14 -- upvalues: CaptureService (upval), a1 (val)
        local v1 = CaptureService
        local success, result = pcall(CaptureService.CaptureScreenshot, v1, function(a1_3) -- Line: 15 -- upvalues: a1 (upval), a1_2 (val) -- types: a1_3: string
            if a1 then
                a1(a1_3)
            end
            a1_2(a1_3)
        end)
        if not success then
            a2(result)
        end
    end)
end

return v1