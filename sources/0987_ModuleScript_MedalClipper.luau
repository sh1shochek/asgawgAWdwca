-- Decompiled with Potassium's decompiler.

local HttpService = game:GetService("HttpService");
local RunService = game:GetService("RunService");
local Base64 = require(script.Parent:WaitForChild("Base64"));
local v1 = {};
local u2 = RunService:IsStudio();

local function debugPrint(...) -- Line: 23
    -- upvalues: u2 (copy)
    if u2 then
        print("[MedalClipper]", ...);
    end;
end;

function v1.TriggerClip(p3: table, p4: string, p5: string, p6: table?) -- Line: 29
    -- upvalues: debugPrint (copy), Base64 (copy), HttpService (copy)
    local v7 = p6 or {};
    debugPrint("TriggerClip", `eventId={p4}`, `eventName={p5}`, `duration={v7.duration or 30}`, (`captureDelayMs={v7.captureDelayMs or 0}`));
    local v8 = {
        eventId = p4,
        eventName = p5,
        triggerActions = { "SaveClip" },
        clipOptions = {
            duration = v7.duration or 30,
            captureDelayMs = v7.captureDelayMs
        }
    };

    if v7.contextTags and next(v7.contextTags) then
        v8.contextTags = v7.contextTags;
    end;

    print("[_MAPIEvent][v1/event/invoke]", Base64.ToBase64(HttpService:JSONEncode({
        gameEvent = v8,
        universeId = game.GameId
    })));
end;

return v1;