-- Decompiled with Potassium's decompiler.

local u1 = {};
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Players = game:GetService("Players");
local DataController = require(ReplicatedStorage.Controllers.DataController);
local ActivateButton = require(ReplicatedStorage.Components.Common.InterfaceAnimations.ActivateButton);
local IsTutorialMode = require(ReplicatedStorage.Components.Common.IsTutorialMode);
local Constants = require(ReplicatedStorage.Database.Custom.Constants);
local Remotes = require(ReplicatedStorage.Database.Security.Remotes);
local MenuState = require(ReplicatedStorage.Interface.MenuState);
local LocalPlayer = Players.LocalPlayer;
local u2 = nil;
local u3 = nil;
local u4 = false;
local u5 = 0;

local function isOwed() -- Line: 49
    -- upvalues: Constants (copy), IsTutorialMode (copy), DataController (copy), LocalPlayer (copy)
    if not (Constants.TUTORIAL_TELEPORT_ENABLED and (not IsTutorialMode() and DataController.IsDataLoaded(LocalPlayer))) then
        return false;
    end;

    local v6;

    if DataController.Get(LocalPlayer, "TutorialPrompted") == true then
        v6 = false;
    else
        v6 = DataController.Get(LocalPlayer, "TutorialCompleted") ~= true;
    end;

    return v6;
end;

local function hidePrompt() -- Line: 59
    -- upvalues: u2 (ref)
    if u2 then
        u2.Visible = false;
    end;
end;

local function tryShowPrompt() -- Line: 67
    -- upvalues: u4 (ref), u2 (ref), isOwed (copy), u3 (ref), MenuState (copy), Remotes (copy)
    if u4 or not (u2 and isOwed()) then
        return;
    end;

    if not u3.Menu.Visible or (MenuState.IsInspectActive() or MenuState.IsCaseSceneActive()) then
        return;
    end;

    local CurrentScreen = MenuState.GetCurrentScreen();

    if CurrentScreen ~= nil and CurrentScreen ~= "Dashboard" then
        return;
    end;

    u4 = true;
    u2.Visible = true;
    Remotes.Player.MarkTutorialPrompted.Send();
end;

function u1.IsPending() -- Line: 89
    -- upvalues: u4 (ref), isOwed (copy)
    return u4 or isOwed();
end;

function u1.RequestTeleport() -- Line: 95
    -- upvalues: Constants (copy), u5 (ref), Remotes (copy)
    if not Constants.TUTORIAL_TELEPORT_ENABLED then
        return;
    end;

    local os_clock_ret = os.clock();

    if os_clock_ret - u5 < 1 then
        return;
    end;

    u5 = os_clock_ret;
    Remotes.Modes.SelectGamemode.Send("Tutorial");
end;

function u1.Initialize(p7: userdata, p8: userdata) -- Line: 110
    -- upvalues: u3 (ref), u2 (ref), ActivateButton (copy), u1 (copy), hidePrompt (copy)
    u3 = p7;
    u2 = p8;
    u2.Visible = false;
    local Join = u2:FindFirstChild("Join");

    if Join then
        ActivateButton(Join, true, u3);
        Join.MouseButton1Click:Connect(u1.RequestTeleport);
    end;

    local Title = u2:FindFirstChild("Title");

    if Title then
        Title = Title:FindFirstChild("Close");
    end;

    if Title then
        ActivateButton(Title, true, u3);
        Title.MouseButton1Click:Connect(hidePrompt);
    end;
end;

function u1.Start() -- Line: 131
    -- upvalues: DataController (copy), LocalPlayer (copy), tryShowPrompt (copy), u3 (ref), u2 (ref), MenuState (copy)
    DataController.CreateListener(LocalPlayer, "TutorialPrompted", tryShowPrompt);
    DataController.CreateListener(LocalPlayer, "TutorialCompleted", tryShowPrompt);
    u3.Menu:GetPropertyChangedSignal("Visible"):Connect(function() -- Line: 135
        -- upvalues: u3 (ref), tryShowPrompt (ref), u2 (ref)
        if u3.Menu.Visible then
            tryShowPrompt();

            return;
        end;

        if u2 then
            u2.Visible = false;
        end;
    end);
    MenuState.OnScreenChanged:Connect(function(p9, p10) -- Line: 142
        -- upvalues: tryShowPrompt (ref), u2 (ref)
        if p10 == "Dashboard" then
            tryShowPrompt();

            return;
        end;

        if u2 then
            u2.Visible = false;
        end;
    end);
    tryShowPrompt();
end;

return u1;