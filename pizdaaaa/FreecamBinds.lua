-- ReplicatedStorage.GameClient.BindsController.FreecamBinds
-- Script path: ReplicatedStorage.GameClient.BindsController.FreecamBinds
-- Decompile time: 4.84 ms

-- Decompiled with Potassium's decompiler.

local v1 = {};
local u2 = nil;
local u3 = nil;
local u4 = 0;
local u5 = 0;
local u6 = 0;
local u7 = 0;
local u8 = 0;
local u9 = 0;
local u40 = {
    ["Freecam Forward"] = {
        Callback = function(p10, p11) -- Line: 23, Name: Callback
            -- upvalues: u2 (ref), u3 (ref), u4 (ref), u7 (ref), u6 (ref), u8 (ref), u9 (ref), u5 (ref)
            if not u2.GetState() and p11 == Enum.UserInputState.Begin then
                return;
            end;

            if next(u3.FramePriority) and p11 == Enum.UserInputState.Begin then
                return;
            end;

            u4 = p11 == Enum.UserInputState.Begin and -1 or 0;
            u2.SetFreecamMoveDirection(u7 + u6, u8 + u9, u4 + u5);
        end
    },
    ["Freecam Backward"] = {
        Callback = function(p12, p13) -- Line: 39, Name: Callback
            -- upvalues: u2 (ref), u3 (ref), u5 (ref), u7 (ref), u6 (ref), u8 (ref), u9 (ref), u4 (ref)
            if not u2.GetState() and p13 == Enum.UserInputState.Begin then
                return;
            end;

            if next(u3.FramePriority) and p13 == Enum.UserInputState.Begin then
                return;
            end;

            u5 = p13 == Enum.UserInputState.Begin and 1 or 0;
            u2.SetFreecamMoveDirection(u7 + u6, u8 + u9, u4 + u5);
        end
    },
    ["Freecam Left"] = {
        Callback = function(p14, p15) -- Line: 55, Name: Callback
            -- upvalues: u2 (ref), u3 (ref), u7 (ref), u6 (ref), u8 (ref), u9 (ref), u4 (ref), u5 (ref)
            if not u2.GetState() and p15 == Enum.UserInputState.Begin then
                return;
            end;

            if next(u3.FramePriority) and p15 == Enum.UserInputState.Begin then
                return;
            end;

            u7 = p15 == Enum.UserInputState.Begin and -1 or 0;
            u2.SetFreecamMoveDirection(u7 + u6, u8 + u9, u4 + u5);
        end
    },
    ["Freecam Right"] = {
        Callback = function(p16, p17) -- Line: 71, Name: Callback
            -- upvalues: u2 (ref), u3 (ref), u6 (ref), u7 (ref), u8 (ref), u9 (ref), u4 (ref), u5 (ref)
            if not u2.GetState() and p17 == Enum.UserInputState.Begin then
                return;
            end;

            if next(u3.FramePriority) and p17 == Enum.UserInputState.Begin then
                return;
            end;

            u6 = p17 == Enum.UserInputState.Begin and 1 or 0;
            u2.SetFreecamMoveDirection(u7 + u6, u8 + u9, u4 + u5);
        end
    },
    ["Freecam Down"] = {
        Callback = function(p18, p19) -- Line: 87, Name: Callback
            -- upvalues: u2 (ref), u3 (ref), u8 (ref), u7 (ref), u6 (ref), u9 (ref), u4 (ref), u5 (ref)
            if not u2.GetState() and p19 == Enum.UserInputState.Begin then
                return;
            end;

            if next(u3.FramePriority) and p19 == Enum.UserInputState.Begin then
                return;
            end;

            u8 = p19 == Enum.UserInputState.Begin and -1 or 0;
            u2.SetFreecamMoveDirection(u7 + u6, u8 + u9, u4 + u5);
        end
    },
    ["Freecam Up"] = {
        Callback = function(p20, p21) -- Line: 103, Name: Callback
            -- upvalues: u2 (ref), u3 (ref), u9 (ref), u7 (ref), u6 (ref), u8 (ref), u4 (ref), u5 (ref)
            if not u2.GetState() and p21 == Enum.UserInputState.Begin then
                return;
            end;

            if next(u3.FramePriority) and p21 == Enum.UserInputState.Begin then
                return;
            end;

            u9 = p21 == Enum.UserInputState.Begin and 1 or 0;
            u2.SetFreecamMoveDirection(u7 + u6, u8 + u9, u4 + u5);
        end
    },
    ["Freecam Walk"] = {
        Callback = function(p22, p23) -- Line: 119, Name: Callback
            -- upvalues: u2 (ref), u3 (ref)
            if not u2.GetState() and p23 == Enum.UserInputState.Begin then
                return;
            end;

            if next(u3.FramePriority) and p23 == Enum.UserInputState.Begin then
                return;
            end;

            u2.SetFreecamShift(p23 == Enum.UserInputState.Begin);
        end
    },
    ["Freecam Mouse Wheel Up"] = {
        Callback = function(p24: any, p25: any, p26: userdata) -- Line: 133, Name: Callback
            -- upvalues: u2 (ref), u3 (ref)
            if not u2.GetState() then
                return;
            end;

            if next(u3.FramePriority) then
                return;
            end;

            u2.SetFreecamMouseWheelPosition(-1);
        end
    },
    ["Freecam Mouse Wheel Down"] = {
        Callback = function(p27: any, p28: any, p29: userdata) -- Line: 147, Name: Callback
            -- upvalues: u2 (ref), u3 (ref)
            if not u2.GetState() then
                return;
            end;

            if next(u3.FramePriority) then
                return;
            end;

            u2.SetFreecamMouseWheelPosition(1);
        end
    },
    ["Freecam Field Of View Increase"] = {
        Callback = function(p30: any, p31: any, p32: userdata) -- Line: 161, Name: Callback
            -- upvalues: u2 (ref), u3 (ref)
            if not u2.GetState() then
                return;
            end;

            if next(u3.FramePriority) then
                return;
            end;

            u2.SetFreecamMouseWheelPosition2(-1);
        end
    },
    ["Freecam Field Of View Decrease"] = {
        Callback = function(p33: any, p34: any, p35: userdata) -- Line: 175, Name: Callback
            -- upvalues: u2 (ref), u3 (ref)
            if not u2.GetState() then
                return;
            end;

            if next(u3.FramePriority) then
                return;
            end;

            u2.SetFreecamMouseWheelPosition2(1);
        end
    },
    ["Freecam Up Speed"] = {
        Callback = function(p36, p37) -- Line: 190, Name: Callback
            -- upvalues: u2 (ref), u3 (ref)
            if not u2.GetState() and p37 == Enum.UserInputState.Begin then
                return;
            end;

            if next(u3.FramePriority) and p37 == Enum.UserInputState.Begin then
                return;
            end;

            u2.SetFreecamUpSpeedKey(p37 == Enum.UserInputState.Begin and 1 or 0);
        end
    },
    ["Freecam Down Speed"] = {
        Callback = function(p38, p39) -- Line: 204, Name: Callback
            -- upvalues: u2 (ref), u3 (ref)
            if not u2.GetState() and p39 == Enum.UserInputState.Begin then
                return;
            end;

            if next(u3.FramePriority) and p39 == Enum.UserInputState.Begin then
                return;
            end;

            u2.SetFreecamDownSpeedKey(p39 == Enum.UserInputState.Begin and -1 or 0);
        end
    }
};

function v1.Get() -- Line: 220
    -- upvalues: u40 (copy)
    return u40;
end;

function v1.Init(p41) -- Line: 226
    -- upvalues: u2 (ref), u3 (ref)
    u2 = p41:GetModule("Freecam");
    u3 = p41:GetModule("BindsController");
end;

return v1;