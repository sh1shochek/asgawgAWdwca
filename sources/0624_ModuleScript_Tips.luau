-- Decompiled with Potassium's decompiler.

local u1 = {};
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local UserInputService = game:GetService("UserInputService");
local HttpService = game:GetService("HttpService");
local Players = game:GetService("Players");
local LocalPlayer = Players.LocalPlayer;
local DataController = require(ReplicatedStorage.Controllers.DataController);
local InventoryController = require(ReplicatedStorage.Controllers.InventoryController);
local SpectateController = require(ReplicatedStorage.Controllers.SpectateController);
local GetWeaponProperties = require(ReplicatedStorage.Components.Common.GetWeaponProperties);
local GetUserPlatform = require(ReplicatedStorage.Components.Common.GetUserPlatform);
local GetBindIcon = require(ReplicatedStorage.Components.Common.GetBindIcon);
local CharacterResolver = require(ReplicatedStorage.Components.Common.CharacterResolver);
local IsTutorialMode = require(ReplicatedStorage.Components.Common.IsTutorialMode);
local KeybindParser = require(ReplicatedStorage.Controllers.InputController.KeybindParser);
local Pages = require(ReplicatedStorage.Database.Custom.GameStats.UI.Settings.Pages);
local UDim2_fromScale_ret = UDim2.fromScale(0.985, 0.62);
local u2 = { "Primary", "Secondary", "Melee", "Grenade" };
local u3 = {
    Menu = "Main Menu",
    ChooseTeam = "Choose Team",
    Scoreboard = "Scoreboard",
    Reload = "Reload",
    WeaponMod = "Secondary Fire",
    Plant = "Fire"
};
local u4 = { "Menu", "ChooseTeam", "Scoreboard", "Plant", "WeaponMod", "Reload" };
local u5 = {
    SpectatePrevious = {
        Computer = Enum.UserInputType.MouseButton1,
        Console = Enum.KeyCode.ButtonL1
    },
    SpectateNext = {
        Computer = Enum.UserInputType.MouseButton2,
        Console = Enum.KeyCode.ButtonR1
    },
    SpectateCamera = {
        Computer = Enum.KeyCode.Space,
        Console = Enum.KeyCode.ButtonA
    }
};
local u6 = {
    [Enum.KeyCode.LeftControl] = "CTRL",
    [Enum.KeyCode.RightControl] = "CTRL",
    [Enum.KeyCode.LeftShift] = "SHIFT",
    [Enum.KeyCode.RightShift] = "SHIFT",
    [Enum.KeyCode.LeftAlt] = "ALT",
    [Enum.KeyCode.RightAlt] = "ALT",
    [Enum.KeyCode.Tab] = "TAB",
    [Enum.KeyCode.CapsLock] = "CAPS",
    [Enum.KeyCode.Space] = "SPACE",
    [Enum.KeyCode.Return] = "ENTER",
    [Enum.KeyCode.Backspace] = "BACK"
};
local u7 = {
    [Enum.UserInputType.MouseButton1] = "LMB",
    [Enum.UserInputType.MouseButton2] = "RMB",
    [Enum.UserInputType.MouseButton3] = "MMB"
};
local u8 = {
    [Enum.KeyCode.ButtonA] = "A",
    [Enum.KeyCode.ButtonB] = "B",
    [Enum.KeyCode.ButtonX] = "X",
    [Enum.KeyCode.ButtonY] = "Y",
    [Enum.KeyCode.ButtonL1] = "LB",
    [Enum.KeyCode.ButtonR1] = "RB",
    [Enum.KeyCode.ButtonL2] = "LT",
    [Enum.KeyCode.ButtonR2] = "RT",
    [Enum.KeyCode.ButtonL3] = "LS",
    [Enum.KeyCode.ButtonR3] = "RS"
};
local u9 = nil;
local u10 = nil;
local u11 = {};
local u12 = {};
local u13 = {};
local u14 = table.find(GetUserPlatform(), "Mobile") ~= nil;
local u15 = true;
local u16 = false;
local u17 = nil;
local u18 = false;
local u19 = false;
local u20 = nil;
local u21 = {
    Plant = false,
    Reload = false
};
local RaycastParams_new_ret = RaycastParams.new();
RaycastParams_new_ret.FilterType = Enum.RaycastFilterType.Exclude;
RaycastParams_new_ret.IgnoreWater = true;

local function decodeJSON(p22) -- Line: 153
    -- upvalues: HttpService (copy)
    if typeof(p22) ~= "string" then
        return nil;
    end;

    local success, result = pcall(HttpService.JSONDecode, HttpService, p22);

    if success and typeof(result) == "table" then
        return result;
    end;

    return nil;
end;

local function isAlive() -- Line: 161
    -- upvalues: CharacterResolver (copy), LocalPlayer (copy)
    return CharacterResolver.isAliveCharacter(LocalPlayer.Character);
end;

local function updateHasBomb() -- Line: 165
    -- upvalues: LocalPlayer (copy), HttpService (copy), u18 (ref)
    local Attribute = LocalPlayer:GetAttribute("Slot5");
    local v23;

    if typeof(Attribute) == "string" then
        local v24;
        v24, v23 = pcall(HttpService.JSONDecode, HttpService, Attribute);

        if not v24 or typeof(v23) ~= "table" then
            v23 = nil;
        end;
    else
        v23 = nil;
    end;

    local v25;

    if v23 == nil then
        v25 = false;
    else
        v25 = v23.Weapon == "C4";
    end;

    u18 = v25;
end;

local function updateEquippedState() -- Line: 171
    -- upvalues: LocalPlayer (copy), HttpService (copy), GetWeaponProperties (copy), u19 (ref), u20 (ref)
    local Attribute = LocalPlayer:GetAttribute("CurrentEquipped");
    local v26;

    if typeof(Attribute) == "string" then
        local v27;
        v27, v26 = pcall(HttpService.JSONDecode, HttpService, Attribute);

        if not v27 or typeof(v26) ~= "table" then
            v26 = nil;
        end;
    else
        v26 = nil;
    end;

    local v28 = v26 and v26.Name and GetWeaponProperties(v26.Name);
    local v29;

    if v28 == nil then
        v29 = false;
    else
        v29 = v28.Class == "Weapon";
    end;

    local v30;

    if v29 then
        v30 = v28.MuzzleType ~= "Zeus x27";
    else
        v30 = v29;
    end;

    u19 = v30;
    local v31;

    if v29 then
        v31 = v28.HasScope and "Scope" or (v28.HasSuppressor and "Suppressor" or (v28.ShootingOptions == "Burst" and "Burst Fire" or nil));
    else
        v31 = nil;
    end;

    u20 = v31;
end;

local function isInPlantZone() -- Line: 185
    -- upvalues: LocalPlayer (copy), Players (copy), RaycastParams_new_ret (copy)
    local Character = LocalPlayer.Character;

    if Character then
        Character = Character.PrimaryPart or Character:FindFirstChild("HumanoidRootPart");
    end;

    if not Character then
        return false;
    end;

    local v32 = { workspace.CurrentCamera };

    for _, v in ipairs(Players:GetPlayers()) do
        if v.Character then
            table.insert(v32, v.Character);
        end;
    end;

    local Map = workspace:FindFirstChild("Map");

    if Map then
        Map = Map:FindFirstChild("Barriers");
    end;

    if Map then
        table.insert(v32, Map);
    end;

    RaycastParams_new_ret.FilterDescendantsInstances = v32;
    local v33 = workspace:Raycast(Character.Position, Vector3.new(-0, -5, -0), RaycastParams_new_ret);
    local v34;

    if v33 == nil then
        v34 = false;
    else
        v34 = v33.Instance:HasTag("PlantArea") and v33.Instance:GetAttribute("Site") ~= nil;
    end;

    return v34;
end;

local function canReload() -- Line: 212
    -- upvalues: InventoryController (copy), IsTutorialMode (copy)
    local CurrentEquipped = InventoryController.getCurrentEquipped();
    local v35;

    if CurrentEquipped then
        v35 = CurrentEquipped.Properties;
    else
        v35 = CurrentEquipped;
    end;

    if not (v35 and (v35.Rounds and not v35.RechargeTime)) then
        return false;
    end;

    if CurrentEquipped.IsReloading or CurrentEquipped.Rounds >= v35.Rounds then
        return false;
    end;

    return (workspace:GetAttribute("Gamemode") == "Deathmatch" or IsTutorialMode()) and v35.ReloadAnimationCount == 1 and true or (CurrentEquipped.Capacity or 0) > 0;
end;

local function updateAvailability() -- Line: 230
    -- upvalues: u18 (ref), isInPlantZone (copy), u19 (ref), canReload (copy), u21 (copy)
    local v36 = u18 and isInPlantZone();
    local v37 = u19 and canReload();
    local v38 = v36 ~= u21.Plant and true or v37 ~= u21.Reload;
    u21.Plant = v36;
    u21.Reload = v37;

    return v38;
end;

local function bindingToText(p39) -- Line: 239
    -- upvalues: u7 (copy), u6 (copy), UserInputService (copy)
    if p39.EnumType == Enum.UserInputType then
        return u7[p39];
    end;

    local v40 = u6[p39];

    if v40 then
        return v40;
    end;

    local StringForKeyCode = UserInputService:GetStringForKeyCode(p39);

    if StringForKeyCode and StringForKeyCode ~= "" then
        return string.upper(StringForKeyCode);
    end;

    return string.upper(p39.Name);
end;

local function getBindLabels(p41: userdata) -- Line: 256
    local v42 = nil;
    local v43 = nil;

    for _, child in ipairs(p41:GetChildren()) do
        if child.Name == "Bind" then
            if child:IsA("TextLabel") then
                v42 = child;
            elseif child:IsA("ImageLabel") then
                v43 = child;
            end;
        end;
    end;

    return v42, v43;
end;

function u1.IsGamepadPreferred() -- Line: 274
    -- upvalues: UserInputService (copy)
    return UserInputService.PreferredInput == Enum.PreferredInput.Gamepad;
end;

function u1.ResolveActionBinding(p44: string) -- Line: 279
    -- upvalues: u1 (copy), DataController (copy), LocalPlayer (copy), Pages (copy), KeybindParser (copy)
    local v45 = u1.IsGamepadPreferred() and "Console" or "Computer";
    local v46 = nil;
    local v47 = false;
    local v48 = DataController.Get(LocalPlayer, "Settings.Keyboard/Mouse");

    if typeof(v48) == "table" then
        for _, v in pairs(v48) do
            if typeof(v) == "table" and typeof(v[p44]) == "table" then
                v46 = v[p44][v45];
                v47 = true;
                break;
            end;
        end;
    end;

    if not v47 then
        local Setting = Pages.GetSetting("Keybinds", p44);

        if Setting then
            Setting = Setting.Default;
        end;

        if typeof(Setting) == "table" then
            v46 = Setting[v45];
        end;
    end;

    if typeof(v46) ~= "string" or v46 == "" then
        return nil;
    end;

    local v49 = KeybindParser.parse(v46);

    if typeof(v49) == "EnumItem" then
        return v49;
    end;

    return nil;
end;

function u1.GetActionKeyText(p50: string) -- Line: 316
    -- upvalues: u1 (copy), u8 (copy), bindingToText (copy)
    local v51 = u1.ResolveActionBinding(p50);

    if not v51 then
        return nil;
    end;

    local v52 = u8[v51];

    if v52 then
        return v52;
    end;

    if u1.IsGamepadPreferred() then
        return nil;
    end;

    return bindingToText(v51);
end;

function u1.ApplyBindingToKeybind(p53: userdata, p54: any) -- Line: 332
    -- upvalues: getBindLabels (copy), GetBindIcon (copy), bindingToText (copy)
    local v55, v56 = getBindLabels(p53);
    local v57 = GetBindIcon(p54);

    if v56 and v57 then
        v56.Image = v57;
        v56.Visible = true;

        if v55 then
            v55.Visible = false;
        end;

        return true;
    end;

    if p54 then
        p54 = bindingToText(p54);
    end;

    if not (v55 and p54) then
        if v55 then
            v55.Visible = false;
        end;

        if v56 then
            v56.Visible = false;
        end;

        return false;
    end;

    v55.Text = p54;
    v55.Visible = true;

    if v56 then
        v56.Visible = false;
    end;

    return true;
end;

local function mirrorX(p58, p59) -- Line: 367
    return Vector2.new(1 - p58.X, p58.Y), UDim2.new(1 - p59.X.Scale, -p59.X.Offset, p59.Y.Scale, p59.Y.Offset);
end;

function u1.MirrorRow(p60: userdata) -- Line: 374
    local Keybind = p60:FindFirstChild("Keybind");

    if Keybind and Keybind:IsA("GuiObject") then
        local AnchorPoint = Keybind.AnchorPoint;
        local Position = Keybind.Position;
        local Vector2_new_ret = Vector2.new(1 - AnchorPoint.X, AnchorPoint.Y);
        local UDim2_new_ret = UDim2.new(1 - Position.X.Scale, -Position.X.Offset, Position.Y.Scale, Position.Y.Offset);
        Keybind.AnchorPoint = Vector2_new_ret;
        Keybind.Position = UDim2_new_ret;
    end;

    local Title = p60:FindFirstChild("Title");

    if Title and Title:IsA("TextLabel") then
        local AnchorPoint = Title.AnchorPoint;
        local Position = Title.Position;
        local Vector2_new_ret = Vector2.new(1 - AnchorPoint.X, AnchorPoint.Y);
        local UDim2_new_ret = UDim2.new(1 - Position.X.Scale, -Position.X.Offset, Position.Y.Scale, Position.Y.Offset);
        Title.AnchorPoint = Vector2_new_ret;
        Title.Position = UDim2_new_ret;
        Title.TextXAlignment = Enum.TextXAlignment.Right;
    end;

    local v61 = p60:FindFirstChildOfClass("UIGradient");

    if v61 then
        v61.Rotation = v61.Rotation + 180;
    end;
end;

local function mirrorRow(p62: table) -- Line: 392
    -- upvalues: u1 (copy)
    u1.MirrorRow(p62.Frame);
end;

local function createChooseTeamRow() -- Line: 396
    -- upvalues: u9 (ref)
    local Menu = u9:FindFirstChild("Menu");

    if u9:FindFirstChild("ChooseTeam") or not (Menu and Menu:IsA("GuiObject")) then
        return;
    end;

    local v63 = Menu:Clone();
    v63.Name = "ChooseTeam";
    local Title = v63:FindFirstChild("Title");

    if Title and Title:IsA("TextLabel") then
        Title.Text = "Choose Team";
    end;

    v63.Parent = u9;
end;

local function hideUnusedRows() -- Line: 412
    -- upvalues: u9 (ref), u3 (copy), u5 (copy)
    for _, child in ipairs(u9:GetChildren()) do
        if child:IsA("GuiObject") and not (u3[child.Name] or u5[child.Name]) then
            child.Visible = false;
        end;
    end;
end;

local function loadRows(p64: table, p65: table) -- Line: 420
    -- upvalues: u9 (ref), u1 (copy)
    for i in pairs(p64) do
        local v66 = u9:FindFirstChild(i);
        local v67;

        if v66 then
            v67 = v66:FindFirstChild("Keybind");
        else
            v67 = v66;
        end;

        local v68;

        if v66 then
            v68 = v66:FindFirstChild("Title");
        else
            v68 = v66;
        end;

        if v66 and (v66:IsA("GuiObject") and (v67 and (v67:IsA("GuiButton") and (v68 and v68:IsA("TextLabel"))))) then
            local v69 = {
                HasBind = false,
                Frame = v66,
                Keybind = v67,
                Title = v68
            };
            v66.Visible = false;
            u1.MirrorRow(v69.Frame);
            p65[i] = v69;
        else
            warn((`[Tips] Row "{i}" is missing or malformed`));
        end;
    end;
end;

local function renderBinds() -- Line: 438
    -- upvalues: u12 (copy), u1 (copy), u3 (copy), u13 (copy), u5 (copy)
    for i, v in pairs(u12) do
        v.HasBind = u1.ApplyBindingToKeybind(v.Keybind, u1.ResolveActionBinding(u3[i]));
    end;

    local v70 = u1.IsGamepadPreferred() and "Console" or "Computer";

    for i, v in pairs(u13) do
        v.HasBind = u1.ApplyBindingToKeybind(v.Keybind, u5[i][v70]);
    end;
end;

local function applyGameplayRows() -- Line: 449
    -- upvalues: u20 (ref), u12 (copy), u21 (copy)
    if u20 and u12.WeaponMod then
        u12.WeaponMod.Title.Text = u20;
    end;

    local v71 = {
        Reload = u21.Reload,
        WeaponMod = u20 ~= nil,
        Plant = u21.Plant
    };

    for i, v in pairs(u12) do
        v.Frame.Visible = v.HasBind and v71[i] ~= false;
    end;
end;

local function setRowsVisible(p72: table, p73: boolean) -- Line: 465
    for _, v in pairs(p72) do
        local v74;

        if p73 then
            v74 = v.HasBind;
        else
            v74 = p73;
        end;

        v.Frame.Visible = v74;
    end;
end;

local function applySpectateRows(p75: boolean) -- Line: 473
    -- upvalues: SpectateController (copy), u13 (copy)
    local v76 = SpectateController.GetCurrentSpectateInstance() ~= nil;
    local v77 = {
        SpectatePrevious = v76,
        SpectateNext = v76,
        SpectateCamera = SpectateController.CanSwitchPerspective()
    };

    for i, v in pairs(u13) do
        v.Frame.Visible = p75 and v.HasBind and v77[i] ~= false;
    end;
end;

local function setPolling(p78: boolean) -- Line: 490
    -- upvalues: u17 (ref), u18 (ref), isInPlantZone (copy), u19 (ref), canReload (copy), u21 (copy), applyGameplayRows (copy)
    if p78 == (u17 ~= nil) then
        return;
    end;

    if p78 then
        u17 = task.spawn(function() -- Line: 496
            -- upvalues: u18 (ref), isInPlantZone (ref), u19 (ref), canReload (ref), u21 (ref), applyGameplayRows (ref)
            while true do
                local v79 = u18 and isInPlantZone();
                local v80 = u19 and canReload();
                local v81 = v79 ~= u21.Plant and true or v80 ~= u21.Reload;
                u21.Plant = v79;
                u21.Reload = v80;

                if v81 then
                    applyGameplayRows();
                end;

                task.wait(0.25);
            end;
        end);

        return;
    end;

    task.cancel(u17);
    u17 = nil;
    u21.Plant = false;
    u21.Reload = false;
end;

local function getMode() -- Line: 514
    -- upvalues: u14 (copy), u15 (ref), LocalPlayer (copy), CharacterResolver (copy)
    return (u14 or not u15) and "Hidden" or (LocalPlayer:GetAttribute("IsSpectating") and "Spectate" or (CharacterResolver.isAliveCharacter(LocalPlayer.Character) and "Gameplay" or "Hidden"));
end;

local function refresh() -- Line: 525
    -- upvalues: u16 (ref), u14 (copy), u15 (ref), LocalPlayer (copy), CharacterResolver (copy), u9 (ref), applySpectateRows (copy), setPolling (copy), u18 (ref), isInPlantZone (copy), u19 (ref), canReload (copy), u21 (copy), applyGameplayRows (copy), u12 (copy)
    u16 = false;
    local v82 = (u14 or not u15) and "Hidden" or (LocalPlayer:GetAttribute("IsSpectating") and "Spectate" or (CharacterResolver.isAliveCharacter(LocalPlayer.Character) and "Gameplay" or "Hidden"));
    u9.Visible = v82 ~= "Hidden";
    applySpectateRows(v82 == "Spectate");
    setPolling(v82 == "Gameplay");

    if v82 ~= "Gameplay" then
        for _, v in pairs(u12) do
            v.Frame.Visible = false;
        end;

        return;
    end;

    local v83 = u18 and isInPlantZone();
    local v84 = u19 and canReload();

    if v83 == u21.Plant then
        local _ = v84 == u21.Reload;
    end;

    u21.Plant = v83;
    u21.Reload = v84;
    applyGameplayRows();
end;

local function queueRefresh() -- Line: 544
    -- upvalues: u16 (ref), refresh (copy)
    if u16 then
        return;
    end;

    u16 = true;
    task.defer(refresh);
end;

local function onCharacterAdded(p85: userdata) -- Line: 552
    -- upvalues: queueRefresh (copy), u16 (ref), refresh (copy)
    p85:GetAttributeChangedSignal("Dead"):Connect(queueRefresh);
    p85:GetAttributeChangedSignal("Health"):Connect(queueRefresh);
    local v86 = p85:FindFirstChildOfClass("Humanoid");

    if v86 then
        v86.Died:Connect(queueRefresh);
    end;

    if u16 then
        return;
    end;

    u16 = true;
    task.defer(refresh);
end;

local function positionAboveHotbar() -- Line: 568
    -- upvalues: u9 (ref), u10 (ref), u11 (copy), UDim2_fromScale_ret (copy)
    local Parent = u9.Parent;

    if not (Parent and Parent:IsA("GuiObject")) then
        return;
    end;

    local v87 = nil;

    if u10 and u10.Visible then
        for _, v in ipairs(u11) do
            if v.Visible and (v87 == nil or v.AbsolutePosition.Y < v87) then
                v87 = v.AbsolutePosition.Y;
            end;
        end;
    end;

    if v87 == nil then
        return;
    end;

    u9.Position = UDim2.new(UDim2_fromScale_ret.X, UDim.new(0, v87 - Parent.AbsolutePosition.Y - 0.01 * Parent.AbsoluteSize.Y));
end;

local function followHotbar(p88: userdata) -- Line: 593
    -- upvalues: u10 (ref), positionAboveHotbar (copy), u2 (copy), u11 (copy), u9 (ref)
    local Gameplay = p88:FindFirstChild("Gameplay");

    if Gameplay then
        Gameplay = Gameplay:FindFirstChild("Bottom");
    end;

    if Gameplay then
        Gameplay = Gameplay:FindFirstChild("Inventory");
    end;

    if not (Gameplay and Gameplay:IsA("GuiObject")) then
        warn("[Tips] Inventory hotbar not found; the tips keep their default position");

        return;
    end;

    u10 = Gameplay;
    Gameplay:GetPropertyChangedSignal("Visible"):Connect(positionAboveHotbar);

    for _, v in ipairs(u2) do
        local v89 = Gameplay:FindFirstChild(v);

        if v89 and v89:IsA("GuiObject") then
            table.insert(u11, v89);
            v89:GetPropertyChangedSignal("AbsolutePosition"):Connect(positionAboveHotbar);
            v89:GetPropertyChangedSignal("Visible"):Connect(positionAboveHotbar);
        end;
    end;

    local Parent = u9.Parent;

    if Parent and Parent:IsA("GuiObject") then
        Parent:GetPropertyChangedSignal("AbsoluteSize"):Connect(positionAboveHotbar);
    end;

    positionAboveHotbar();
end;

function u1.Initialize(p90: userdata, p91: userdata) -- Line: 624
    -- upvalues: u9 (ref), u14 (copy), UDim2_fromScale_ret (copy), followHotbar (copy), createChooseTeamRow (copy), hideUnusedRows (copy), loadRows (copy), u3 (copy), u12 (copy), u4 (copy), u5 (copy), u13 (copy)
    u9 = p91;
    u9.Visible = false;

    if u14 then
        return;
    end;

    u9.AnchorPoint = Vector2.new(1, 1);
    u9.Position = UDim2_fromScale_ret;
    followHotbar(p90);
    local v92 = u9:FindFirstChildOfClass("UIListLayout");

    if v92 then
        v92.HorizontalAlignment = Enum.HorizontalAlignment.Right;
    end;

    createChooseTeamRow();
    hideUnusedRows();
    loadRows(u3, u12);

    for i, v in ipairs(u4) do
        local v93 = u12[v];

        if v93 then
            v93.Frame.LayoutOrder = i;
        end;
    end;

    loadRows(u5, u13);
end;

function u1.Start() -- Line: 654
    -- upvalues: u14 (copy), LocalPlayer (copy), HttpService (copy), u18 (ref), updateEquippedState (copy), renderBinds (copy), DataController (copy), u15 (ref), u16 (ref), refresh (copy), UserInputService (copy), updateHasBomb (copy), queueRefresh (copy), SpectateController (copy), onCharacterAdded (copy), u9 (ref), u17 (ref), u21 (copy)
    if u14 then
        return;
    end;

    local Attribute = LocalPlayer:GetAttribute("Slot5");
    local v94;

    if typeof(Attribute) == "string" then
        local v95;
        v95, v94 = pcall(HttpService.JSONDecode, HttpService, Attribute);

        if not v95 or typeof(v94) ~= "table" then
            v94 = nil;
        end;
    else
        v94 = nil;
    end;

    local v96;

    if v94 == nil then
        v96 = false;
    else
        v96 = v94.Weapon == "C4";
    end;

    u18 = v96;
    updateEquippedState();
    renderBinds();
    DataController.CreateListener(LocalPlayer, "Settings.Game.HUD.Enable Game Instructor Messages", function(p97: boolean?) -- Line: 663
        -- upvalues: u15 (ref), u16 (ref), refresh (ref)
        u15 = p97 ~= false;

        if u16 then
            return;
        end;

        u16 = true;
        task.defer(refresh);
    end);

    local function onBindsChanged() -- Line: 669
        -- upvalues: renderBinds (ref), u16 (ref), refresh (ref)
        renderBinds();

        if u16 then
            return;
        end;

        u16 = true;
        task.defer(refresh);
    end;

    DataController.CreateListener(LocalPlayer, "Settings.Keyboard/Mouse", onBindsChanged);
    UserInputService:GetPropertyChangedSignal("PreferredInput"):Connect(onBindsChanged);
    LocalPlayer:GetAttributeChangedSignal("CurrentEquipped"):Connect(function() -- Line: 676
        -- upvalues: updateEquippedState (ref), u16 (ref), refresh (ref)
        updateEquippedState();

        if u16 then
            return;
        end;

        u16 = true;
        task.defer(refresh);
    end);
    LocalPlayer:GetAttributeChangedSignal("Slot5"):Connect(updateHasBomb);
    LocalPlayer:GetAttributeChangedSignal("IsSpectating"):Connect(queueRefresh);
    SpectateController.ListenToSpectate:Connect(queueRefresh);
    SpectateController.ListenToFreecam:Connect(queueRefresh);
    LocalPlayer:GetAttributeChangedSignal("Team"):Connect(queueRefresh);
    LocalPlayer.CharacterAdded:Connect(onCharacterAdded);
    LocalPlayer.CharacterRemoving:Connect(function() -- Line: 689
        -- upvalues: LocalPlayer (ref), u9 (ref), u17 (ref), u21 (ref)
        if not LocalPlayer:GetAttribute("IsSpectating") then
            u9.Visible = false;

            if u17 ~= nil == false then
                return;
            end;

            task.cancel(u17);
            u17 = nil;
            u21.Plant = false;
            u21.Reload = false;
        end;
    end);

    if LocalPlayer.Character then
        onCharacterAdded(LocalPlayer.Character);
    end;

    refresh();
end;

return u1;