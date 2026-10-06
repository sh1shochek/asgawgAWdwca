-- Decompiled with Potassium's decompiler.

local v1 = {};
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local CaptureService = game:GetService("CaptureService");
local Promise = require(ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Promise"));

function v1.CaptureScreenshot(u2: function?) -- Line: 13
    -- upvalues: Promise (copy), CaptureService (copy)
    return Promise.new(function(u3, p4) -- Line: 14
        -- upvalues: CaptureService (ref), u2 (copy)
        local success, result = pcall(CaptureService.CaptureScreenshot, CaptureService, function(p5: string) -- Line: 15
            -- upvalues: u2 (ref), u3 (copy)
            if u2 then
                u2(p5);
            end;

            u3(p5);
        end);

        if not success then
            p4(result);
        end;
    end);
end;

return v1;