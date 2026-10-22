-- ReplicatedStorage.GameClient.BindsController
-- Script path: ReplicatedStorage.GameClient.BindsController
-- Decompile time: 9.22 ms

-- Decompiled with Potassium's decompiler.

local u1 = {
    FramePriority = {
        MainMenu = true,
        MatchEnd = nil,
        BuyMenu = nil,
        Console = nil,
        Chat = nil,
        Score = nil
    }
};
local ContextActionService = game:GetService("ContextActionService");
local Players = game:GetService("Players");
local UserInputService = game:GetService("UserInputService");
local GuiService = game:GetService("GuiService");
local _ = Players.LocalPlayer;
local u2 = nil;
local u3 = nil;
local u4 = nil;
local u5 = nil;
local u6 = nil;
local u7 = {
    WheelForward = {},
    WheelBackward = {}
};
local u8 = {};
local u9 = {
    [Enum.KeyCode.ButtonL2] = true,
    [Enum.KeyCode.ButtonR2] = true
};
local u10 = nil;
local TouchEnabled = UserInputService.TouchEnabled;
local u11 = nil;

function u1.Bind(p12, u13, p14) -- Line: 54
    -- upvalues: u7 (copy), u1 (copy), ContextActionService (copy), u9 (copy), u8 (copy), u11 (ref)
    for i, v in pairs(u7) do
        if v[p12] then
            u1.Unbind(i, p12);
        end;
    end;

    if not u7[u13] then
        if typeof(u13) == "EnumItem" then
            ContextActionService:BindAction("BindsController_" .. tostring(u13), function(p15, p16, p17) -- Line: 64
                -- upvalues: u9 (ref), u13 (copy), u8 (ref), u7 (ref)
                if p16 == Enum.UserInputState.Cancel then
                    p16 = Enum.UserInputState.End;
                elseif u9[u13] then
                    local v18 = u8[u13] and 0.15 or 0.4;
                    local v19;

                    if p16 == Enum.UserInputState.Begin then
                        v19 = true;
                    elseif p16 == Enum.UserInputState.Change then
                        v19 = v18 <= p17.Position.Z;
                    else
                        v19 = false;
                    end;

                    if v19 == (u8[u13] == true) then
                        return;
                    end;

                    p16 = v19 and Enum.UserInputState.Begin or Enum.UserInputState.End;
                elseif p16 == Enum.UserInputState.Change then
                    return;
                end;

                u8[u13] = p16 == Enum.UserInputState.Begin and true or nil;
                local v20 = u7[u13];

                if v20 then
                    for _, v in pairs(v20) do
                        v(p15, p16, p17);
                    end;
                end;
            end, false, u13);
        end;

        u7[u13] = {};
    end;

    u7[u13][p12] = p14;

    if u11 then
        local v21 = p12:gsub("^Controller_", ""):gsub("_%d+$", "");
        u11.SetButtonCallback(v21, p14);
    end;
end;

function u1.Unbind(p22, p23) -- Line: 103
    -- upvalues: u7 (copy), u1 (copy), ContextActionService (copy)
    if type(p22) == "string" and p23 == nil then
        for i, v in pairs(u7) do
            if v[p22] then
                u1.Unbind(i, p22);
            end;
        end;

        return;
    end;

    local v24 = u7[p22];

    if not v24 then
        return;
    end;

    if not v24[p23] then
        return;
    end;

    v24[p23] = nil;

    if not next(v24) then
        u7[p22] = nil;

        if typeof(p22) == "EnumItem" then
            ContextActionService:UnbindAction("BindsController_" .. tostring(p22));
        end;
    end;
end;

function u1.SetFramePriority(p25, p26) -- Line: 139
    -- upvalues: u1 (copy), u5 (ref)
    u1.FramePriority[p25] = p26 and true or nil;

    if next(u1.FramePriority) then
        u5.SetMouseLock(false);
        u5.SetMouseIconVisibility(true);

        return;
    end;

    u5.SetMouseLock(true);
    u5.SetMouseIconVisibility(false);
end;

function u1.HasFramePriority() -- Line: 151
    -- upvalues: u1 (copy)
    return next(u1.FramePriority);
end;

function u1.IsOnlyFrame(p27) -- Line: 157
    -- upvalues: u1 (copy)
    local FramePriority = u1.FramePriority;
    local v28;

    if FramePriority[p27] == nil then
        v28 = false;
    else
        v28 = next(FramePriority, next(FramePriority)) == nil;
    end;

    return v28;
end;

function u1.Init(p29) -- Line: 164
    -- upvalues: u4 (ref), u2 (ref), u5 (ref), u10 (ref), TouchEnabled (ref), u6 (ref), GuiService (copy), u1 (copy), UserInputService (copy), u8 (copy), u7 (copy)
    u4 = p29:GetModule("SettingsData");
    u2 = p29:GetModule("Gui");
    u5 = p29:GetModule("CameraController");
    u10 = p29:GetModule("GetUserPlatform");
    TouchEnabled = u10() == "Mobile";
    u6 = p29:GetModule("Tick");
    GuiService.MenuOpened:Connect(function() -- Line: 177
        -- upvalues: u1 (ref)
        u1.SetFramePriority("RobloxMenu", true);
    end);
    GuiService.MenuClosed:Connect(function() -- Line: 181
        -- upvalues: u1 (ref)
        u1.SetFramePriority("RobloxMenu", false);
    end);
    UserInputService.InputEnded:Connect(function(p30) -- Line: 188
        -- upvalues: u8 (ref), u7 (ref)
        for _, v in { p30.UserInputType, p30.KeyCode } do
            if u8[v] then
                u8[v] = nil;
                local v31 = u7[v];

                if v31 then
                    for i, v2 in pairs(v31) do
                        v2(i, Enum.UserInputState.End, p30);
                    end;
                end;
            end;
        end;
    end);
    UserInputService.InputChanged:Connect(function(u32) -- Line: 205
        -- upvalues: u7 (ref), u6 (ref)
        if u32.UserInputType == Enum.UserInputType.MouseWheel then
            local Position = u32.Position;

            if Position.Z == 0 then
                return;
            end;

            local u33 = Position.Z > 0 and "WheelForward" or (Position.Z < 0 and "WheelBackward" or nil);
            local v34 = u7[u33];

            if v34 and next(v34) then
                for i, v in pairs(v34) do
                    v(i, Enum.UserInputState.Begin, u32);
                end;

                local u35 = nil;
                u35 = u6.OnTick.Connect({
                    Priority = (1 / 0),

                    Function = function() -- Line: 231, Name: Function
                        -- upvalues: u35 (ref), u7 (ref), u33 (ref), u32 (copy)
                        u35.Disconnect();
                        local v36 = u7[u33];

                        if v36 then
                            for i, v in pairs(v36) do
                                v(i, Enum.UserInputState.End, u32);
                            end;
                        end;
                    end
                });
            end;
        end;
    end);
end;

function u1.Start(p37) -- Line: 248
    -- upvalues: u3 (ref), u2 (ref), u11 (ref), u4 (ref), u1 (copy)
    u3 = u2.GetComponent("Settings");
    u11 = u2.GetComponent("MobileControls");
    local u38 = {};

    for _, child in ipairs(script:GetChildren()) do
        for i, v in p37:GetModule(child.Name).Get() do
            u38[i] = v;

            if u11 then
                u11.SetButtonCallback(i, v.Callback);
            end;
        end;
    end;

    if u11 and u38["Character Use"] then
        u11.SetButtonCallback("Character Pickup", u38["Character Use"].Callback);
    end;

    for i, _ in u4.GetData().Controls.Keybinds do
        if u38[i] then
            u3:AddConnection("Controls", "Keybinds", i, function(p39) -- Line: 276
                -- upvalues: u38 (copy), i (copy), u1 (ref)
                if not u38[i] then
                    return;
                end;

                local v40 = typeof(p39) == "table" and p39 and p39 or { p39 };

                for i2 = 1, 2 do
                    local v41 = `{i}_{i2}`;
                    local v42 = v40[i2];
                    local v43;

                    if v42 == nil or v42 == "None" then
                        u1.Unbind(v41);
                        v43 = i2;
                    else
                        u1.Bind(v41, v42, u38[i].Callback);
                        v43 = i2;
                    end;
                end;
            end);
        end;
    end;

    for i in u4.GetData().Controls["Controller Binds"] do
        if u38[i] then
            u3:AddConnection("Controls", "Controller Binds", i, function(p44) -- Line: 299
                -- upvalues: i (copy), u1 (ref), u38 (copy)
                local v45 = typeof(p44) == "table" and p44 and p44 or { p44 };

                for i2 = 1, 2 do
                    local v46 = `Controller_{i}_{i2}`;
                    local v47 = v45[i2];
                    local v48;

                    if v47 == nil or v47 == "None" then
                        u1.Unbind(v46);
                        v48 = i2;
                    else
                        u1.Bind(v46, v47, u38[i].Callback);
                        v48 = i2;
                    end;
                end;
            end);
        end;
    end;
end;

return u1;