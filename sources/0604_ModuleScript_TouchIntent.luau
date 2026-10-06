-- Decompiled with Potassium's decompiler.

local v1 = {};
local Players = game:GetService("Players");
local UserInputService = game:GetService("UserInputService");
local Workspace = game:GetService("Workspace");
local CameraInput = require(Players.LocalPlayer:WaitForChild("PlayerScripts"):WaitForChild("PlayerModule"):WaitForChild("CameraModule"):WaitForChild("CameraInput"));
local u2 = {};
local u3 = {};

local function toVector2(p4: vector) -- Line: 55
    return Vector2.new(p4.X, p4.Y);
end;

local function getDragDistance() -- Line: 61
    -- upvalues: Workspace (copy)
    local CurrentCamera = Workspace.CurrentCamera;

    if not CurrentCamera then
        return 8;
    end;

    local ViewportSize = CurrentCamera.ViewportSize;
    local v5 = math.min(ViewportSize.X, ViewportSize.Y) * 0.03;

    return math.max(8, v5);
end;

local function isInCore(p6: userdata, p7) -- Line: 72
    local v8 = p6.AbsoluteSize / 2;
    local v9 = p7 - (p6.AbsolutePosition + v8);
    local v10 = v8 * 0.6;
    local v11;

    if math.abs(v9.X) <= v10.X then
        v11 = math.abs(v9.Y) <= v10.Y;
    else
        v11 = false;
    end;

    return v11;
end;

local function firePendingTap(p12: userdata) -- Line: 81
    -- upvalues: u2 (copy)
    local v13 = u2[p12];

    if not (v13 and (not v13.isDrag and v13.pendingTap)) then
        return;
    end;

    local pendingTap = v13.pendingTap;
    v13.pendingTap = nil;
    pendingTap();
end;

local function promoteToDrag(p14: userdata, p15: table, p16) -- Line: 93
    -- upvalues: u3 (copy), CameraInput (copy)
    p15.isDrag = true;
    p15.pendingTap = nil;
    u3[p15.button] = true;

    if p15.onDrag then
        p15.onDrag(p14);
    end;

    CameraInput.addTouchMove(p16);
end;

function v1.track(p17: userdata, p18: userdata, p19: function?) -- Line: 109
    -- upvalues: u2 (copy), u3 (copy)
    if p17.UserInputType ~= Enum.UserInputType.Touch or u2[p17] then
        return;
    end;

    local v20 = {
        isDrag = false,
        pendingTap = nil,
        button = p18
    };
    local Position = p17.Position;
    v20.startPosition = Vector2.new(Position.X, Position.Y);
    v20.onDrag = p19;
    u2[p17] = v20;
    u3[p18] = false;
end;

function v1.onTap(p21: userdata, p22: function) -- Line: 126
    -- upvalues: u2 (copy), firePendingTap (copy)
    local v23 = u2[p21];

    if v23 then
        local button = v23.button;
        local v24 = button.AbsoluteSize / 2;
        local v25 = v23.startPosition - (button.AbsolutePosition + v24);
        local v26 = v24 * 0.6;
        local v27;

        if math.abs(v25.X) <= v26.X then
            v27 = math.abs(v25.Y) <= v26.Y;
        else
            v27 = false;
        end;

        if not v27 then
            v23.pendingTap = p22;
            task.delay(0.07, firePendingTap, p21);

            return;
        end;
    end;

    p22();
end;

function v1.lastTouchWasDrag(p28: userdata) -- Line: 138
    -- upvalues: u3 (copy)
    return u3[p28] == true;
end;

UserInputService.InputChanged:Connect(function(p29: userdata) -- Line: 145
    -- upvalues: u2 (copy), CameraInput (copy), Workspace (copy), u3 (copy)
    local v30 = u2[p29];

    if not v30 then
        return;
    end;

    if v30.isDrag then
        CameraInput.addTouchMove(Vector2.new(p29.Delta.X, p29.Delta.Y));

        return;
    end;

    local Position = p29.Position;
    local v31 = Vector2.new(Position.X, Position.Y) - v30.startPosition;
    local Magnitude = v31.Magnitude;
    local CurrentCamera = Workspace.CurrentCamera;
    local v32;

    if CurrentCamera then
        local ViewportSize = CurrentCamera.ViewportSize;
        local v33 = math.min(ViewportSize.X, ViewportSize.Y) * 0.03;
        v32 = math.max(8, v33);
    else
        v32 = 8;
    end;

    if v32 < Magnitude then
        v30.isDrag = true;
        v30.pendingTap = nil;
        u3[v30.button] = true;

        if v30.onDrag then
            v30.onDrag(p29);
        end;

        CameraInput.addTouchMove(v31);
    end;
end);
UserInputService.InputEnded:Connect(function(u34: userdata) -- Line: 162
    -- upvalues: u2 (copy)
    if not u2[u34] then
        return;
    end;

    local v35 = u2[u34];

    if v35 and (not v35.isDrag and v35.pendingTap) then
        local pendingTap = v35.pendingTap;
        v35.pendingTap = nil;
        pendingTap();
    end;

    task.defer(function() -- Line: 169
        -- upvalues: u2 (ref), u34 (copy)
        u2[u34] = nil;
    end);
end);

return v1;