-- Decompiled with Potassium's decompiler.

local v1 = {};
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local UserInputService = game:GetService("UserInputService");
local u2 = tick();
local GetUserPlatform = require(ReplicatedStorage.Components.Common.GetUserPlatform);
local Remotes = require(ReplicatedStorage.Database.Security.Remotes);

local function ReportPlayerState() -- Line: 24
    -- upvalues: Remotes (copy), u2 (ref)
    debug.profilebegin("PlayerController.HandleNextFrame");
    local v3 = tick();
    Remotes.Player.BlankRequest.Send(v3);

    if v3 - u2 >= 900 then
        Remotes.Player.AFKTeleport.Send();
        u2 = v3;
    end;

    debug.profileend();
end;

function v1.Initialize() -- Line: 38
    -- upvalues: UserInputService (copy), u2 (ref), Remotes (copy)
    UserInputService.InputBegan:Connect(function() -- Line: 39
        -- upvalues: u2 (ref)
        u2 = tick();
    end);
    UserInputService.InputChanged:Connect(function() -- Line: 43
        -- upvalues: u2 (ref)
        u2 = tick();
    end);
    Remotes.Player.BlankRequest.Listen(function(p4: number) -- Line: 48
        -- upvalues: Remotes (ref)
        local Send = Remotes.Player.ReportPlayerConnect.Send;
        local v5 = (tick() - p4) * 1000;
        local math_floor_ret = math.floor(v5);
        Send((tostring(math_floor_ret)));
    end);
end;

function v1.Start() -- Line: 53
    -- upvalues: GetUserPlatform (copy), Remotes (copy), ReportPlayerState (copy)
    task.delay(5, function() -- Line: 55
        -- upvalues: GetUserPlatform (ref), Remotes (ref)
        local v6 = GetUserPlatform();

        if v6 and #v6 > 0 then
            Remotes.Player.SubmitUserPlatformAnalytics.Send(v6[1]);
        end;
    end);
    task.spawn(function() -- Line: 61
        -- upvalues: ReportPlayerState (ref)
        while true do
            task.wait(5);
            ReportPlayerState();
        end;
    end);
end;

return v1;