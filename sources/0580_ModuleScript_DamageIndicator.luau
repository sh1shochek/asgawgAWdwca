-- Decompiled with Potassium's decompiler.

local u1 = {};
u1.__index = u1;
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local TweenService = game:GetService("TweenService");
local Players = game:GetService("Players");
require(script:WaitForChild("Types"));
local LocalPlayer = Players.LocalPlayer;
local workspace_CurrentCamera = workspace.CurrentCamera;
local Remotes = require(ReplicatedStorage.Database.Security.Remotes);
local Janitor = require(ReplicatedStorage.Shared.Janitor);
local u2 = {
    Top = 90,
    Bottom = 270,
    Left = 0,
    Right = 180
};
local u3 = nil;
local u4 = {};

local function GetRelativeRotation(p5: vector, p6: vector, p7: vector) -- Line: 54
    return math.atan2(p7.Z - p5.Z, p7.X - p5.X) - math.atan2(p6.Z - p5.Z, p6.X - p5.X);
end;

local function GetQuadrantPosition(p8: string, p9: number) -- Line: 60
    local v10 = p9 / 3;

    return ({
        Top = UDim2.new(0.5, 0, 0, v10),
        Bottom = UDim2.new(0.5, 0, 1, -v10),
        Left = UDim2.new(0, v10, 0.5, 0),
        Right = UDim2.new(1, -v10, 0.5, 0)
    })[p8];
end;

local function NormalizeAngle(p11: number) -- Line: 70
    local v12 = math.deg(p11) % 360;

    if v12 > 180 then
        return v12 - 360;
    end;

    if v12 < -180 then
        v12 = v12 + 360;
    end;

    return v12;
end;

local function GetQuadrant(p13: vector, p14: vector, p15: vector) -- Line: 81
    local v16 = p13 + p14;
    local v17 = math.atan2(p15.Z - p13.Z, p15.X - p13.X) - math.atan2(v16.Z - p13.Z, v16.X - p13.X);
    local v18 = math.deg(v17) % 360;

    if v18 > 180 then
        v18 = v18 - 360;
    elseif v18 < -180 then
        v18 = v18 + 360;
    end;

    return v18 >= -45 and v18 < 45 and "Top" or (v18 >= 45 and v18 < 135 and "Right" or ((v18 >= 135 or v18 < -135) and "Bottom" or "Left"));
end;

local function scheduleCleanup(u19) -- Line: 99
    local task_delay_ret = task.delay(2, function() -- Line: 100
        -- upvalues: u19 (copy)
        u19:cleanup();
    end);
    u19.Janitor:Add(function() -- Line: 103
        -- upvalues: task_delay_ret (copy)
        if task_delay_ret then
            pcall(task.cancel, task_delay_ret);
        end;
    end);
    u19.CleanupThread = task_delay_ret;
end;

function u1.construct(p20) -- Line: 114
    -- upvalues: GetQuadrantPosition (copy), u2 (copy), scheduleCleanup (copy)
    local CameraPosition = p20.CameraPosition;
    local Position = p20.Position;
    local v21 = CameraPosition + p20.CameraLookVector;
    local v22 = math.atan2(Position.Z - CameraPosition.Z, Position.X - CameraPosition.X) - math.atan2(v21.Z - CameraPosition.Z, v21.X - CameraPosition.X);
    local v23 = math.deg(v22) % 360;

    if v23 > 180 then
        v23 = v23 - 360;
    elseif v23 < -180 then
        v23 = v23 + 360;
    end;

    local v24 = v23 >= -45 and v23 < 45 and "Top" or (v23 >= 45 and v23 < 135 and "Right" or ((v23 >= 135 or v23 < -135) and "Bottom" or "Left"));
    p20.Template.Position = GetQuadrantPosition(v24, p20.ScreenSize);
    p20.Template.Rotation = u2[v24];
    p20.Quadrant = v24;
    scheduleCleanup(p20);
end;

function u1.cleanup(p25) -- Line: 122
    -- upvalues: LocalPlayer (copy), TweenService (copy)
    if p25.Template and p25.Template:IsDescendantOf(LocalPlayer.PlayerGui) then
        p25.Janitor:Add(TweenService:Create(p25.Template, TweenInfo.new(0.5, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {
            ImageTransparency = 1
        })):Play();
        task.wait(0.5);
        p25:destroy();
    end;
end;

function u1.refresh(p26) -- Line: 134
    -- upvalues: scheduleCleanup (copy), TweenService (copy)
    if p26.CleanupThread then
        pcall(task.cancel, p26.CleanupThread);
        p26.CleanupThread = nil;
    end;

    if p26.FadeTween then
        p26.FadeTween:Cancel();
        p26.FadeTween = nil;
    end;

    if p26.SizeTween then
        p26.SizeTween:Cancel();
        p26.SizeTween = nil;
    end;

    local math_max_ret = math.max(0, p26.Template.ImageTransparency - 0.1);
    p26.Template.ImageTransparency = math_max_ret;
    scheduleCleanup(p26);
    local v27 = p26.Janitor:Add(TweenService:Create(p26.Template, TweenInfo.new(0.3, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {
        Size = UDim2.fromOffset(p26.ScreenSize / 3, p26.ScreenSize / 3),
        ImageTransparency = math_max_ret
    }));
    v27:Play();
    p26.SizeTween = v27;
end;

function u1.new(p28: userdata, p29: vector, p30: vector, p31: vector, p32: string) -- Line: 162
    -- upvalues: u1 (copy), Janitor (copy), ReplicatedStorage (copy), u3 (ref), Remotes (copy), TweenService (copy), u4 (copy)
    local u33 = setmetatable({}, u1);
    u33.Janitor = Janitor.new();
    u33.Template = u33.Janitor:Add(ReplicatedStorage.Assets.UI.DamageIndicator.Template:Clone());
    u33.Template.Parent = u3;
    u33.Template.ImageTransparency = 1;
    u33.Template.Name = "Indicator";
    u33.Character = p28;
    u33.ScreenSize = u3.AbsoluteSize.X;
    u33.Position = p29;
    u33.CameraLookVector = p30;
    u33.CameraPosition = p31;
    u33.Janitor:Add(Remotes.Character.CharacterDied.Listen(function() -- Line: 186
        -- upvalues: u33 (copy)
        u33:destroy();
    end));
    u3.Visible = true;
    u33:construct();
    u33.SizeTween = u33.Janitor:Add(TweenService:Create(u33.Template, TweenInfo.new(0.3, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {
        ImageTransparency = 0.2,
        Size = UDim2.fromOffset(u33.ScreenSize / 3, u33.ScreenSize / 3)
    }));
    u33.SizeTween:Play();
    u4[p32] = u33;

    return u33;
end;

function u1.destroy(p34) -- Line: 215
    -- upvalues: u4 (copy)
    local Quadrant = p34.Quadrant;
    p34.Janitor:Destroy();

    if Quadrant then
        u4[Quadrant] = nil;
    end;
end;

function u1.Initialize(p35: any, p36: userdata) -- Line: 226
    -- upvalues: u3 (ref), Remotes (copy), LocalPlayer (copy), workspace_CurrentCamera (copy), u4 (copy), u1 (copy)
    u3 = p36;
    Remotes.UI.CreateDamageIndicator.Listen(function(p37: vector) -- Line: 229
        -- upvalues: LocalPlayer (ref), workspace_CurrentCamera (ref), u4 (ref), u1 (ref)
        if LocalPlayer.Character then
            local Position = workspace_CurrentCamera.CFrame.Position;
            local LookVector = workspace_CurrentCamera.CFrame.LookVector;
            local v38 = Position + LookVector;
            local v39 = math.atan2(p37.Z - Position.Z, p37.X - Position.X) - math.atan2(v38.Z - Position.Z, v38.X - Position.X);
            local v40 = math.deg(v39) % 360;

            if v40 > 180 then
                v40 = v40 - 360;
            elseif v40 < -180 then
                v40 = v40 + 360;
            end;

            local v41 = v40 >= -45 and v40 < 45 and "Top" or (v40 >= 45 and v40 < 135 and "Right" or ((v40 >= 135 or v40 < -135) and "Bottom" or "Left"));
            local v42 = u4[v41];

            if v42 then
                v42:refresh();

                return;
            end;

            u1.new(LocalPlayer.Character, p37, LookVector, Position, v41);
        end;
    end);
end;

return u1;