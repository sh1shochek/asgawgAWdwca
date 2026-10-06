-- Decompiled with Potassium's decompiler.

local u1 = {};
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local LocalPlayer = game:GetService("Players").LocalPlayer;
local InputController = require(ReplicatedStorage.Controllers.InputController);
local DataController = require(ReplicatedStorage.Controllers.DataController);
local RunServiceController = require(ReplicatedStorage.Controllers.RunServiceController);
local CenterScreenRaycast = require(ReplicatedStorage.Components.Common.CenterScreenRaycast);
local CharacterResolver = require(ReplicatedStorage.Components.Common.CharacterResolver);
local u2 = nil;
local u3 = nil;
local u4 = nil;
local u5 = nil;

local function FormatKeybind(p6: string?) -- Line: 31
    return not p6 and "E" or p6:gsub("Enum%.KeyCode%.", ""):gsub("Enum%.UserInputType%.", ""):gsub("Enum%.CustomInputType%.", "");
end;

local function IsCharacterAlive(p7: userdata) -- Line: 39
    -- upvalues: CharacterResolver (copy)
    return CharacterResolver.isAliveCharacter(p7.Character);
end;

local function ShouldRunUpdate() -- Line: 43
    -- upvalues: LocalPlayer (copy), CharacterResolver (copy)
    local v8;

    if workspace:GetAttribute("Gamemode") == "Hostage Rescue" then
        v8 = CharacterResolver.isAliveCharacter(LocalPlayer.Character);
    else
        v8 = false;
    end;

    return v8;
end;

local function StopUpdateConnection() -- Line: 47
    -- upvalues: u5 (ref)
    if u5 then
        u5:Disconnect();
        u5 = nil;
    end;
end;

local function SyncUpdateConnection() -- Line: 54
    -- upvalues: LocalPlayer (copy), CharacterResolver (copy), u5 (ref), RunServiceController (copy), u2 (ref), u1 (copy)
    local v9;

    if workspace:GetAttribute("Gamemode") == "Hostage Rescue" then
        v9 = CharacterResolver.isAliveCharacter(LocalPlayer.Character);
    else
        v9 = false;
    end;

    if v9 then
        if u5 then
            return;
        end;

        u5 = RunServiceController.BindToHeartbeat("UI.HoverHostage.Update", function(p10) -- Line: 60
            -- upvalues: LocalPlayer (ref), CharacterResolver (ref), u2 (ref), u5 (ref), u1 (ref)
            local v11;

            if workspace:GetAttribute("Gamemode") == "Hostage Rescue" then
                v11 = CharacterResolver.isAliveCharacter(LocalPlayer.Character);
            else
                v11 = false;
            end;

            if v11 then
                u2.Visible = u1.GetHoverState();

                return;
            end;

            u2.Visible = false;

            if u5 then
                u5:Disconnect();
                u5 = nil;
            end;
        end);

        return;
    end;

    u2.Visible = false;

    if u5 then
        u5:Disconnect();
        u5 = nil;
    end;
end;

local function TrackCharacter(p12: userdata?) -- Line: 77
    -- upvalues: u3 (ref), u4 (ref), SyncUpdateConnection (copy), LocalPlayer (copy), CharacterResolver (copy), u5 (ref), RunServiceController (copy), u2 (ref), u1 (copy)
    if u3 then
        u3:Disconnect();
        u3 = nil;
    end;

    if u4 then
        u4:Disconnect();
        u4 = nil;
    end;

    if p12 then
        u3 = p12:GetAttributeChangedSignal("Dead"):Connect(SyncUpdateConnection);
        u4 = p12.ChildAdded:Connect(function(p13: userdata) -- Line: 89
            -- upvalues: LocalPlayer (ref), CharacterResolver (ref), u5 (ref), RunServiceController (ref), u2 (ref), u1 (ref)
            if p13:IsA("Humanoid") then
                local v14;

                if workspace:GetAttribute("Gamemode") == "Hostage Rescue" then
                    v14 = CharacterResolver.isAliveCharacter(LocalPlayer.Character);
                else
                    v14 = false;
                end;

                if v14 then
                    if u5 then
                        return;
                    end;

                    u5 = RunServiceController.BindToHeartbeat("UI.HoverHostage.Update", function(p15) -- Line: 60
                        -- upvalues: LocalPlayer (ref), CharacterResolver (ref), u2 (ref), u5 (ref), u1 (ref)
                        local v16;

                        if workspace:GetAttribute("Gamemode") == "Hostage Rescue" then
                            v16 = CharacterResolver.isAliveCharacter(LocalPlayer.Character);
                        else
                            v16 = false;
                        end;

                        if v16 then
                            u2.Visible = u1.GetHoverState();

                            return;
                        end;

                        u2.Visible = false;

                        if u5 then
                            u5:Disconnect();
                            u5 = nil;
                        end;
                    end);

                    return;
                end;

                u2.Visible = false;

                if u5 then
                    u5:Disconnect();
                    u5 = nil;
                end;
            end;
        end);
    end;

    local v17;

    if workspace:GetAttribute("Gamemode") == "Hostage Rescue" then
        v17 = CharacterResolver.isAliveCharacter(LocalPlayer.Character);
    else
        v17 = false;
    end;

    if v17 then
        if u5 then
            return;
        end;

        u5 = RunServiceController.BindToHeartbeat("UI.HoverHostage.Update", function(p18) -- Line: 60
            -- upvalues: LocalPlayer (ref), CharacterResolver (ref), u2 (ref), u5 (ref), u1 (ref)
            local v19;

            if workspace:GetAttribute("Gamemode") == "Hostage Rescue" then
                v19 = CharacterResolver.isAliveCharacter(LocalPlayer.Character);
            else
                v19 = false;
            end;

            if v19 then
                u2.Visible = u1.GetHoverState();

                return;
            end;

            u2.Visible = false;

            if u5 then
                u5:Disconnect();
                u5 = nil;
            end;
        end);

        return;
    end;

    u2.Visible = false;

    if u5 then
        u5:Disconnect();
        u5 = nil;
    end;
end;

function u1.GetHoverState() -- Line: 102
    -- upvalues: CenterScreenRaycast (copy)
    return CenterScreenRaycast.GetHoveredHostage(5) ~= nil;
end;

function u1.Initialize(p20, p21) -- Line: 109
    -- upvalues: u2 (ref), InputController (copy), DataController (copy), LocalPlayer (copy), SyncUpdateConnection (copy), TrackCharacter (copy), u3 (ref), u4 (ref), CharacterResolver (copy), u5 (ref), RunServiceController (copy), u1 (copy)
    u2 = p21;

    local function UpdateFrameText() -- Line: 113
        -- upvalues: InputController (ref), u2 (ref)
        local ActionKeybind = InputController.GetActionKeybind("Use");
        u2.Text = `[{not ActionKeybind and "E" or ActionKeybind:gsub("Enum%.KeyCode%.", ""):gsub("Enum%.UserInputType%.", ""):gsub("Enum%.CustomInputType%.", "")}] Pick Up Hostage`;
    end;

    local ActionKeybind = InputController.GetActionKeybind("Use");
    u2.Text = `[{not ActionKeybind and "E" or ActionKeybind:gsub("Enum%.KeyCode%.", ""):gsub("Enum%.UserInputType%.", ""):gsub("Enum%.CustomInputType%.", "")}] Pick Up Hostage`;
    DataController.CreateListener(LocalPlayer, "Settings.Keyboard/Mouse", function(p22) -- Line: 122
        -- upvalues: UpdateFrameText (copy)
        if not p22 then
            return;
        end;

        task.defer(UpdateFrameText);
    end);
    workspace:GetAttributeChangedSignal("Gamemode"):Connect(SyncUpdateConnection);
    LocalPlayer.CharacterAdded:Connect(TrackCharacter);
    LocalPlayer.CharacterRemoving:Connect(function() -- Line: 132
        -- upvalues: u3 (ref), u4 (ref), LocalPlayer (ref), CharacterResolver (ref), u5 (ref), RunServiceController (ref), u2 (ref), u1 (ref)
        if u3 then
            u3:Disconnect();
            u3 = nil;
        end;

        if u4 then
            u4:Disconnect();
            u4 = nil;
        end;

        local v23;

        if workspace:GetAttribute("Gamemode") == "Hostage Rescue" then
            v23 = CharacterResolver.isAliveCharacter(LocalPlayer.Character);
        else
            v23 = false;
        end;

        if v23 then
            if u5 then
                return;
            end;

            u5 = RunServiceController.BindToHeartbeat("UI.HoverHostage.Update", function(p24) -- Line: 60
                -- upvalues: LocalPlayer (ref), CharacterResolver (ref), u2 (ref), u5 (ref), u1 (ref)
                local v25;

                if workspace:GetAttribute("Gamemode") == "Hostage Rescue" then
                    v25 = CharacterResolver.isAliveCharacter(LocalPlayer.Character);
                else
                    v25 = false;
                end;

                if v25 then
                    u2.Visible = u1.GetHoverState();

                    return;
                end;

                u2.Visible = false;

                if u5 then
                    u5:Disconnect();
                    u5 = nil;
                end;
            end);

            return;
        end;

        u2.Visible = false;

        if u5 then
            u5:Disconnect();
            u5 = nil;
        end;
    end);
    TrackCharacter(LocalPlayer.Character);
end;

return u1;