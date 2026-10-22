-- ReplicatedStorage.GameClient.BindsController.GuiBinds
-- Script path: ReplicatedStorage.GameClient.BindsController.GuiBinds
-- Decompile time: 3.88 ms

-- Decompiled with Potassium's decompiler.

local v1 = {};
local _ = game:GetService("Players").LocalPlayer;
local u2 = nil;
local u3 = nil;
local u4 = nil;
local u5 = nil;
local u6 = nil;
local u7 = nil;
local u8 = nil;
local u9 = nil;
local u10 = nil;
local u11 = nil;
local u12 = nil;
local u13 = nil;
local u14 = nil;
local u15 = nil;
local u16 = nil;
local u17 = nil;
local u18 = nil;
local u19 = nil;
local u36 = {
    MainMenu = {
        Callback = function(p20, p21) -- Line: 23, Name: Callback
            -- upvalues: u17 (ref), u19 (ref), u7 (ref), u8 (ref), u9 (ref), u3 (ref), u5 (ref)
            if p21 ~= Enum.UserInputState.Begin then
                return;
            end;

            if u17.FramePriority.Console then
                return;
            end;

            if u19.Navigating() then
                return;
            end;

            if u7.IsBusy() or (u8.IsBusy() or u9.IsBusy()) then
                return;
            end;

            u7.Close();
            u8.Close(true);
            u3.DropDeactive("GLOBAL");
            u5.Visible();
        end
    },
    ["Team Selection"] = {
        Callback = function(p22, p23) -- Line: 55, Name: Callback
            -- upvalues: u17 (ref), u7 (ref), u8 (ref), u9 (ref), u3 (ref), u10 (ref)
            if p23 ~= Enum.UserInputState.Begin then
                return;
            end;

            if u17.FramePriority.Console then
                return;
            end;

            if u7.IsBusy() or (u8.IsBusy() or u9.IsBusy()) then
                return;
            end;

            u7.Close();
            u8.Close();
            u3.DropDeactive("GLOBAL");
            u10.Activate();
        end
    },
    Buymenu = {
        Callback = function(p24, p25) -- Line: 82, Name: Callback
            -- upvalues: u17 (ref), u19 (ref), u11 (ref)
            if not u17.FramePriority.Buymenu and next(u17.FramePriority) then
                return;
            end;

            if p25 ~= Enum.UserInputState.Begin or u19.Navigating() then
                return;
            end;

            u11.Visible();
        end
    },
    Console = {
        Callback = function(p26, p27) -- Line: 96, Name: Callback
            -- upvalues: u18 (ref)
            if p27 ~= Enum.UserInputState.Begin then
                return;
            end;

            u18.Open();
        end
    },
    Chat = {
        Callback = function(p28, p29) -- Line: 106, Name: Callback
            -- upvalues: u17 (ref), u12 (ref)
            if not (u17.FramePriority.MatchEnd or (u17.FramePriority.Chat or not next(u17.FramePriority))) then
                return;
            end;

            if p29 ~= Enum.UserInputState.Begin then
                return;
            end;

            u12.SetVisible(true, "ALL");
        end
    },
    ["Team Chat"] = {
        Callback = function(p30, p31) -- Line: 120, Name: Callback
            -- upvalues: u17 (ref), u12 (ref)
            if not (u17.FramePriority.MatchEnd or (u17.FramePriority.Chat or not next(u17.FramePriority))) then
                return;
            end;

            if p31 ~= Enum.UserInputState.Begin then
                return;
            end;

            u12.SetVisible(true, "TEAM");
        end
    },
    Scoreboard = {
        Callback = function(p32, p33) -- Line: 134, Name: Callback
            -- upvalues: u15 (ref), u17 (ref)
            if p33 == Enum.UserInputState.Begin then
                if u15.IsPinned() then
                    u15.SetScoreVisibility(false);

                    return;
                end;

                if next(u17.FramePriority) then
                    return;
                end;

                u15.SetScoreVisibility(true);
            end;

            if p33 == Enum.UserInputState.End then
                if u15.IsPinned() then
                    return;
                end;

                u15.SetScoreVisibility(false);
            end;
        end
    },
    ["Hide HUD"] = {
        Callback = function(p34, p35) -- Line: 159, Name: Callback
            -- upvalues: u17 (ref), u4 (ref)
            if next(u17.FramePriority) then
                return;
            end;

            if p35 ~= Enum.UserInputState.Begin then
                return;
            end;

            u4.Hide();
        end
    }
};

function v1.Get() -- Line: 175
    -- upvalues: u36 (copy)
    return u36;
end;

function v1.Init(p37) -- Line: 181
    -- upvalues: u2 (ref), u17 (ref)
    u2 = p37:GetModule("Gui");
    u17 = p37:GetModule("BindsController");
end;

function v1.Start(p38) -- Line: 186
    -- upvalues: u3 (ref), u2 (ref), u4 (ref), u6 (ref), u7 (ref), u8 (ref), u9 (ref), u18 (ref), u5 (ref), u10 (ref), u11 (ref), u12 (ref), u13 (ref), u14 (ref), u15 (ref), u16 (ref), u19 (ref)
    u3 = u2.GetComponent("Settings");
    u4 = u2.GetComponent("HUD");
    u6 = u2.GetComponent("MobileControls");
    u7 = u2.GetComponent("CaseInspect");
    u8 = u2.GetComponent("Inspect");
    u9 = u2.GetComponent("Inventory");
    u18 = u2.GetComponent("Console");
    u5 = u2.GetComponent("MainMenu");
    u10 = u2.GetComponent("TeamSelection");
    u11 = u2.GetComponent("Buymenu");
    u12 = u2.GetComponent("Chat");
    u13 = u2.GetComponent("Notification");
    u14 = u2.GetComponent("Defuse");
    u15 = u2.GetComponent("Score");
    u16 = u2.GetComponent("Ping");
    u19 = u2.GetComponent("Gamepad");
end;

return v1;