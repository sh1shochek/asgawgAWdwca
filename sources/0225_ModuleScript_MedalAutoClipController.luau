-- Decompiled with Potassium's decompiler.

local v1 = {};
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local RunService = game:GetService("RunService");
local MedalClipper = require(ReplicatedStorage:WaitForChild("Shared"):WaitForChild("MedalClipper"));
local Remotes = require(ReplicatedStorage.Database.Security.Remotes);
local u2 = RunService:IsStudio();

local function triggerMedalClip(p3: table) -- Line: 25
    -- upvalues: u2 (copy), MedalClipper (copy)
    if u2 then
        print("[MedalAutoClipController]", "Received clip request", `eventId={p3.EventId}`, `eventName={p3.EventName}`, `duration={p3.Duration}`, (`captureDelayMs={p3.CaptureDelayMs or 0}`));
    end;

    local success, result = pcall(MedalClipper.TriggerClip, MedalClipper, p3.EventId, p3.EventName, {
        duration = p3.Duration,
        captureDelayMs = p3.CaptureDelayMs,
        contextTags = p3.ContextTags
    });

    if success then
        if u2 then
            print("[MedalAutoClipController]", "Medal TriggerClip completed", p3.EventName);
        end;

        return;
    end;

    warn((`[MedalAutoClipController] Failed to trigger Medal clip: {result}`));
end;

function v1.Initialize() -- Line: 50
    -- upvalues: Remotes (copy), triggerMedalClip (copy)
    Remotes.Collaborations.MedalAutoClip.Listen(triggerMedalClip);
end;

return v1;