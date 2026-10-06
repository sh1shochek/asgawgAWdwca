-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Players = game:GetService("Players");
require(script.Parent.Parent.Types);
local LocalPlayer = Players.LocalPlayer;
local u1 = nil;
local u2 = 0;

local function getVIPMenu() -- Line: 23
    -- upvalues: u1 (ref), ReplicatedStorage (copy)
    if u1 then
        return u1;
    end;

    local success, result = pcall(function() -- Line: 28
        -- upvalues: ReplicatedStorage (ref)
        return require(ReplicatedStorage.Interface.Screens.Gameplay.Middle.VIPMenu);
    end);

    if success then
        u1 = result;

        return u1;
    end;

    warn((`Failed to load VIPMenu module: {tostring(result)}`));

    return nil;
end;

local function toggleVIPMenu() -- Line: 43
    -- upvalues: u2 (ref), LocalPlayer (copy), u1 (ref), ReplicatedStorage (copy)
    local os_clock_ret = os.clock();

    if os_clock_ret - u2 < 0.15 then
        return;
    end;

    u2 = os_clock_ret;

    if LocalPlayer:GetAttribute("IsPlayerChatting") then
        return;
    end;

    local v3;

    if u1 then
        v3 = u1;
    else
        local success, result = pcall(function() -- Line: 28
            -- upvalues: ReplicatedStorage (ref)
            return require(ReplicatedStorage.Interface.Screens.Gameplay.Middle.VIPMenu);
        end);

        if success then
            u1 = result;
            v3 = u1;
        else
            warn((`Failed to load VIPMenu module: {tostring(result)}`));
            v3 = nil;
        end;
    end;

    if v3 then
        v3.toggleFrame();
    end;
end;

return table.freeze({
    Name = "VIP Menu",
    Group = "Default",
    Category = "UI Keys",
    BindPriority = Enum.ContextActionPriority.High.Value + 1,

    Callback = function(p4: any, p5: userdata) -- Line: 63, Name: onInput
        -- upvalues: u2 (ref), LocalPlayer (copy), u1 (ref), ReplicatedStorage (copy)
        if p4 ~= Enum.UserInputState.Begin then
            return;
        end;

        local os_clock_ret = os.clock();

        if os_clock_ret - u2 < 0.15 then
            return;
        end;

        u2 = os_clock_ret;

        if LocalPlayer:GetAttribute("IsPlayerChatting") then
            return;
        end;

        local v6;

        if u1 then
            v6 = u1;
        else
            local success, result = pcall(function() -- Line: 28
                -- upvalues: ReplicatedStorage (ref)
                return require(ReplicatedStorage.Interface.Screens.Gameplay.Middle.VIPMenu);
            end);

            if success then
                u1 = result;
                v6 = u1;
            else
                warn((`Failed to load VIPMenu module: {tostring(result)}`));
                v6 = nil;
            end;
        end;

        if v6 then
            v6.toggleFrame();
        end;
    end
});