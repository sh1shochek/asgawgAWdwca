-- Decompiled with Potassium's decompiler.

local v1 = {};
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Constants = require(ReplicatedStorage.Database.Custom.Constants);
local Remotes = require(ReplicatedStorage.Database.Security.Remotes);
local GetUserPlatform = require(ReplicatedStorage.Components.Common.GetUserPlatform);
local ActivateButton = require(ReplicatedStorage.Components.Common.InterfaceAnimations.ActivateButton);
local GamepadNavigation = require(ReplicatedStorage.Interface.GamepadNavigation);
local u2 = nil;
local u3 = nil;

local function GetPromptPlatform() -- Line: 31
    -- upvalues: GetUserPlatform (copy)
    local v4 = GetUserPlatform();

    return table.find(v4, "Mobile") and "Mobile" or (table.find(v4, "Console") and not table.find(v4, "PC") and "Console" or nil);
end;

function v1.Initialize(p5, p6) -- Line: 45
    -- upvalues: u2 (ref), ActivateButton (copy), u3 (ref), Remotes (copy), GamepadNavigation (copy)
    u2 = p6;
    u2.Visible = false;
    local Buttons = u2.Buttons.Buttons;
    ActivateButton(Buttons.Yes);
    ActivateButton(Buttons.No);
    Buttons.Yes.MouseButton1Click:Connect(function() -- Line: 52
        -- upvalues: u2 (ref), u3 (ref), Remotes (ref)
        u2.Visible = false;

        if u3 then
            Remotes.Modes.SelectGamemode.Send((`{u3}Server`));
        end;
    end);
    Buttons.No.MouseButton1Click:Connect(function() -- Line: 58
        -- upvalues: u2 (ref)
        u2.Visible = false;
    end);
    GamepadNavigation.TrapPopup(u2, function() -- Line: 62
        -- upvalues: Buttons (copy)
        return Buttons.Yes;
    end);
end;

function v1.Start() -- Line: 69
    -- upvalues: GetPromptPlatform (copy), GetUserPlatform (copy), Constants (copy), u3 (ref), u2 (ref)
    local v7 = GetPromptPlatform();
    local v8 = warn;
    local v9 = `[SwitchServerPrompt] platforms={table.concat(GetUserPlatform(), ",")} promptPlatform={v7} `;
    local v10 = `placeId={game.PlaceId} isDeviceServer={Constants.IS_DEVICE_SERVER} `;
    local v11;

    if v7 then
        v11 = Constants.GetDeviceServerPlaceId(v7, game.PlaceId);
    else
        v11 = v7;
    end;

    v8(v9 .. v10 .. `target={v11} ` .. `isVIP={workspace:GetAttribute("IsVIPServer")}`);

    if not v7 then
        return;
    end;

    if Constants.IS_DEVICE_SERVER or not Constants.GetDeviceServerPlaceId(v7, game.PlaceId) then
        return;
    end;

    if workspace:GetAttribute("IsVIPServer") == true then
        return;
    end;

    u3 = v7;
    u2.TextLabel.Text = `Do you want to join {v7} only servers?`;
    u2.Visible = true;
end;

return v1;