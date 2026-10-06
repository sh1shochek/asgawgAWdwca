-- Decompiled with Potassium's decompiler.

local u1 = {};
local ContextActionService = game:GetService("ContextActionService");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local UserInputService = game:GetService("UserInputService");
local Players = game:GetService("Players");
require(script:WaitForChild("Types"));
local DataController = require(ReplicatedStorage.Controllers.DataController);
local CharacterResolver = require(ReplicatedStorage.Components.Common.CharacterResolver);
local MenuState = require(ReplicatedStorage.Interface.MenuState);
local Router = require(ReplicatedStorage.Database.Security.Router);
local Pages = require(ReplicatedStorage.Database.Custom.GameStats.UI.Settings.Pages);
local KeybindParser = require(script:WaitForChild("KeybindParser"));
local Actions = script:WaitForChild("Actions");
local LocalPlayer = Players.LocalPlayer;
local u2 = {};
local u3 = {};
local u4 = {};
local u5 = {};
local u6 = { "Computer", "Console" };

local function handleInput(p7: string, p8: any, p9: userdata) -- Line: 46
    -- upvalues: u4 (copy), MenuState (copy), u3 (copy)
    local v10 = u4[p7];

    if not v10 then
        return;
    end;

    local MenuFrame = MenuState.GetMenuFrame();
    local CurrentScreen = MenuState.GetCurrentScreen();
    local MainGui = MenuState.GetMainGui();

    if MainGui then
        MainGui = MainGui:FindFirstChild("Gameplay");
    end;

    local v11;

    if MainGui then
        v11 = MainGui:FindFirstChild("Bottom");
    else
        v11 = MainGui;
    end;

    if MainGui then
        MainGui = MainGui:FindFirstChild("Middle");
    end;

    if MainGui then
        MainGui = MainGui:FindFirstChild("TeamSelection");
    end;

    local v12 = MainGui and MainGui:IsA("GuiObject") and (MainGui.Visible and (v11 and v11:IsA("GuiObject"))) and not v11.Visible;

    if ((CurrentScreen ~= nil or MenuFrame and MenuFrame.Visible == true) and true or v12 == true) and (v10.Category ~= "UI Keys" and v10.Category ~= "Communication Options" and p8 == Enum.UserInputState.Begin) then
        v10.IsActive = false;

        return;
    end;

    if u3[v10.Group] ~= true then
        if p8 ~= Enum.UserInputState.Begin and v10.IsActive then
            v10.IsActive = false;
            task.spawn(v10.Callback, p8, p9);
        end;

        return;
    end;

    v10.IsActive = p8 == Enum.UserInputState.Begin;
    task.spawn(v10.Callback, p8, p9);
end;

local function newWheelInput(p13: number) -- Line: 89
    return {
        UserInputType = Enum.UserInputType.MouseWheel,
        Delta = Vector3.new(0, p13, 0)
    };
end;

local function handleScrollWheelInput(p14: string?, p15: number) -- Line: 97
    -- upvalues: handleInput (copy)
    if not p14 then
        return;
    end;

    handleInput(p14, Enum.UserInputState.Begin, {
        UserInputType = Enum.UserInputType.MouseWheel,
        Delta = Vector3.new(0, p15, 0)
    });
    task.defer(handleInput, p14, Enum.UserInputState.End, {
        UserInputType = Enum.UserInputType.MouseWheel,
        Delta = Vector3.new(0, p15, 0)
    });
end;

local function unbindActionKeys(p16: string) -- Line: 105
    -- upvalues: u4 (copy), ContextActionService (copy), u5 (copy), u2 (copy)
    local v17 = u4[p16];

    if not v17 then
        return;
    end;

    ContextActionService:UnbindAction(p16);

    for _, v in ipairs(v17.Keybinds) do
        if typeof(v) == "string" then
            if u5[v] == p16 then
                u5[v] = nil;
            end;
        elseif u2[v] == p16 then
            u2[v] = nil;
        end;
    end;

    v17.Keybinds = {};
end;

function u1.registerAction(p18) -- Line: 130
    -- upvalues: u4 (copy)
    u4[p18.Name] = {
        IsActive = false,
        Category = p18.Category,
        Callback = p18.Callback,
        Group = p18.Group,
        BindPriority = p18.BindPriority,
        Name = p18.Name,
        Keybinds = {}
    };
end;

function u1.bindKeybinds(u19: string, p20: table) -- Line: 144
    -- upvalues: u4 (copy), unbindActionKeys (copy), u5 (copy), u2 (copy), handleInput (copy), ContextActionService (copy)
    local v21 = u4[u19];

    if not v21 then
        return;
    end;

    unbindActionKeys(u19);
    local v22 = {};
    local v23 = {};

    for _, v in ipairs(p20) do
        if typeof(v) == "string" then
            if v == "ScrollWheelUp" or v == "ScrollWheelDown" then
                local v24 = u5[v];

                if v24 then
                    warn((`[InputController] {u19}: {v} is already bound to {v24}, keybind dropped`));
                else
                    table.insert(v22, v);
                    u5[v] = u19;
                end;
            end;
        else
            local v25 = u2[v];

            if v25 then
                warn((`[InputController] {u19}: {tostring(v)} is already bound to {v25}, keybind dropped`));
            else
                table.insert(v22, v);
                table.insert(v23, v);
                u2[v] = u19;
            end;
        end;
    end;

    v21.Keybinds = v22;

    if #v23 > 0 then
        local function v29(p26: any, p27: any, p28: userdata) -- Line: 186
            -- upvalues: handleInput (ref), u19 (copy)
            handleInput(u19, p27, p28);
        end;

        if v21.BindPriority ~= nil then
            ContextActionService:BindActionAtPriority(u19, v29, false, v21.BindPriority, table.unpack(v23));

            return;
        end;

        ContextActionService:BindAction(u19, v29, false, table.unpack(v23));
    end;
end;

function u1.loadActionsFromDatabase(p30) -- Line: 206
    -- upvalues: Pages (copy), unbindActionKeys (copy), u6 (copy), KeybindParser (copy), u1 (copy), u2 (copy)
    local v31 = {};

    for _, v in pairs(p30) do
        for i, v2 in pairs(v) do
            if typeof(v2) == "table" then
                local Setting = Pages.GetSetting("Keybinds", i);

                if Setting and Setting.IsEnabled == false then
                    unbindActionKeys(i);
                else
                    local v32 = v2;
                    local v33 = {};

                    for _, v3 in ipairs(u6) do
                        local v34 = v32[v3];

                        if v34 and v34 ~= "" then
                            local v35 = KeybindParser.parse(v34);

                            if v35 then
                                table.insert(v33, v35);
                            end;
                        end;
                    end;

                    v31[i] = v33;
                end;
            end;
        end;
    end;

    local v36 = v31["Switch Viewmodel Left/Right Hand"] == nil;

    if v36 then
        unbindActionKeys("Switch Viewmodel Left/Right Hand");
    end;

    for i in pairs(v31) do
        unbindActionKeys(i);
    end;

    for i, v in pairs(v31) do
        u1.bindKeybinds(i, v);
    end;

    if v36 then
        local Setting = Pages.GetSetting("Keybinds", "Switch Viewmodel Left/Right Hand");

        if Setting then
            Setting = KeybindParser.parse(Setting.Default.Computer);
        end;

        if typeof(Setting) == "EnumItem" and u2[Setting] == nil then
            u1.bindKeybinds("Switch Viewmodel Left/Right Hand", { Setting });
        end;
    end;
end;

function u1.isActionActive(p37: string) -- Line: 265
    -- upvalues: u4 (copy)
    local v38 = u4[p37];

    return v38 and v38.IsActive or false;
end;

function u1.enableGroup(p39: string) -- Line: 272
    -- upvalues: u3 (copy)
    u3[p39] = true;
end;

function u1.disableGroup(p40: string) -- Line: 278
    -- upvalues: u3 (copy)
    u3[p40] = nil;
end;

function u1.GetActionKeybind(p41: string) -- Line: 284
    -- upvalues: u4 (copy)
    local v42 = u4[p41];

    if not v42 or #v42.Keybinds == 0 then
        return nil;
    end;

    local v43 = v42.Keybinds[1];

    if typeof(v43) == "string" then
        return v43;
    end;

    return tostring(v43):match("%.(%w+)$") or tostring(v43);
end;

function u1.Initialize() -- Line: 301
    -- upvalues: Actions (copy), u1 (copy), CharacterResolver (copy), LocalPlayer (copy), ContextActionService (copy), DataController (copy), Router (copy)
    for _, child in ipairs(Actions:GetChildren()) do
        if child:IsA("ModuleScript") then
            u1.registerAction((require(child)));
        end;
    end;

    u1.enableGroup("Default");
    CharacterResolver.observeCharacter(LocalPlayer, function(p44) -- Line: 311
        -- upvalues: ContextActionService (ref)
        if p44 then
            ContextActionService:UnbindAction("jumpAction");
        end;

        return function() -- Line: 315
        end;
    end);
    DataController.CreateListener(LocalPlayer, "Settings.Keyboard/Mouse", function(p45) -- Line: 318
        -- upvalues: u1 (ref)
        if p45 then
            u1.loadActionsFromDatabase(p45);
        end;
    end);
    Router.observerRouter("RebindKeybinds", function() -- Line: 325
        -- upvalues: DataController (ref), LocalPlayer (ref), u1 (ref)
        local v46 = DataController.Get(LocalPlayer, "Settings.Keyboard/Mouse");

        if not v46 then
            return false;
        end;

        u1.loadActionsFromDatabase(v46);

        return true;
    end);
end;

function u1.getActionKeybinds(p47: string) -- Line: 337
    -- upvalues: u4 (copy)
    local v48 = {};
    local v49 = u4[p47];

    if v49 then
        for _, v in ipairs(v49.Keybinds) do
            if typeof(v) ~= "string" then
                table.insert(v48, v);
            end;
        end;
    end;

    return v48;
end;

function u1.isBindingPressed(p50) -- Line: 352
    -- upvalues: UserInputService (copy)
    if typeof(p50) ~= "EnumItem" then
        return false;
    end;

    if p50.EnumType ~= Enum.KeyCode then
        if p50.EnumType == Enum.UserInputType then
            return UserInputService:IsMouseButtonPressed(p50);
        end;

        return false;
    end;

    if p50 == Enum.KeyCode.ButtonR2 and true or p50 == Enum.KeyCode.ButtonL2 then
        for _, v in UserInputService:GetConnectedGamepads() do
            for _, v2 in UserInputService:GetGamepadState(v) do
                if v2.KeyCode == p50 and v2.Position.Z > 0.3 then
                    return true;
                end;
            end;
        end;

        return false;
    end;

    local Name = p50.Name;

    if not (string.match(Name, "^Button") or string.match(Name, "^DPad")) then
        return UserInputService:IsKeyDown(p50);
    end;

    for _, v in UserInputService:GetConnectedGamepads() do
        if UserInputService:IsGamepadButtonDown(v, p50) then
            return true;
        end;
    end;

    return false;
end;

function u1.isActionPressed(p51: string, p52: table?) -- Line: 397
    -- upvalues: u1 (copy)
    local ActionKeybinds = u1.getActionKeybinds(p51);

    if #ActionKeybinds == 0 then
        ActionKeybinds = p52 or ActionKeybinds;
    end;

    for _, v in ipairs(ActionKeybinds) do
        if u1.isBindingPressed(v) then
            return true;
        end;
    end;

    return false;
end;

function u1.Start() -- Line: 417
    -- upvalues: UserInputService (copy), u5 (copy), handleInput (copy)
    UserInputService.InputChanged:Connect(function(p53: userdata) -- Line: 418
        -- upvalues: u5 (ref), handleInput (ref)
        if p53.UserInputType ~= Enum.UserInputType.MouseWheel then
            return;
        end;

        local Z = p53.Position.Z;

        if Z <= 0 then
            if Z < 0 then
                local ScrollWheelDown = u5.ScrollWheelDown;

                if not ScrollWheelDown then
                    return;
                end;

                handleInput(ScrollWheelDown, Enum.UserInputState.Begin, {
                    Delta = Vector3.new(0, -1, 0),
                    UserInputType = Enum.UserInputType.MouseWheel
                });
                task.defer(handleInput, ScrollWheelDown, Enum.UserInputState.End, {
                    Delta = Vector3.new(0, -1, 0),
                    UserInputType = Enum.UserInputType.MouseWheel
                });
            end;

            return;
        end;

        local ScrollWheelUp = u5.ScrollWheelUp;

        if not ScrollWheelUp then
            return;
        end;

        handleInput(ScrollWheelUp, Enum.UserInputState.Begin, {
            Delta = Vector3.new(0, 1, 0),
            UserInputType = Enum.UserInputType.MouseWheel
        });
        task.defer(handleInput, ScrollWheelUp, Enum.UserInputState.End, {
            Delta = Vector3.new(0, 1, 0),
            UserInputType = Enum.UserInputType.MouseWheel
        });
    end);
end;

return u1;