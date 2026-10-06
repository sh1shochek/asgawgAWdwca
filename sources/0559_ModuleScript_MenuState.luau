-- Decompiled with Potassium's decompiler.

local u1 = {};
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local GuiService = game:GetService("GuiService");
local Lighting = game:GetService("Lighting");
local PlayerGui = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui");
local Signal = require(ReplicatedStorage.Packages.Signal);
u1.OnScreenChanged = Signal.new();
u1.OnInspectStateChanged = Signal.new();
u1.OnCaseSceneStateChanged = Signal.new();
u1.OnTradeUpStateChanged = Signal.new();
local u2 = nil;
local u3 = false;
local u4 = false;
local u5 = false;
local u6 = nil;
local u7 = nil;
local u8 = false;
local u9 = {};
local u10 = {
    Loadout = true,
    Inventory = true,
    Gamemodes = true,
    Settings = true,
    Store = true,
    Career = true,
    Progression = true,
    GlobalMarketPlace = true,
    Blackmarket = true
};
local u11 = {
    Blackmarket = true
};
local u12 = nil;
local u13 = nil;

local function getMenuBlur() -- Line: 94
    -- upvalues: u13 (ref), Lighting (copy)
    if u13 then
        return u13;
    end;

    u13 = Lighting:FindFirstChild("Menu");

    return u13;
end;

local function getMainGui() -- Line: 104
    -- upvalues: u12 (ref), PlayerGui (copy)
    if not u12 then
        u12 = PlayerGui:FindFirstChild("MainGui");
    end;

    return u12;
end;

local function getMenuFrame() -- Line: 111
    -- upvalues: u12 (ref), PlayerGui (copy)
    if not u12 then
        u12 = PlayerGui:FindFirstChild("MainGui");
    end;

    local v14 = u12;

    if v14 then
        return v14:FindFirstChild("Menu");
    end;

    return nil;
end;

local function isEffectivelyVisible(p15: userdata) -- Line: 118
    -- upvalues: PlayerGui (copy)
    if not p15:IsDescendantOf(PlayerGui) then
        return false;
    end;

    while p15 and p15:IsA("GuiObject") do
        if not p15.Visible then
            return false;
        end;

        p15 = p15.Parent;
    end;

    return true;
end;

function u1.Initialize(p16: userdata) -- Line: 138
    -- upvalues: u12 (ref), u13 (ref), Lighting (copy)
    u12 = p16;
    local v17;

    if u13 then
        v17 = u13;
    else
        u13 = Lighting:FindFirstChild("Menu");
        v17 = u13;
    end;

    u13 = v17;
end;

function u1.GetCurrentScreen() -- Line: 143
    -- upvalues: u2 (ref)
    return u2;
end;

function u1.IsPreservableScreen(p18: string?) -- Line: 147
    -- upvalues: u10 (copy)
    local v19;

    if p18 == nil then
        v19 = false;
    else
        v19 = u10[p18] == true;
    end;

    return v19;
end;

function u1.IsSceneScreen(p20: string?) -- Line: 152
    -- upvalues: u11 (copy)
    local v21;

    if p20 == nil then
        v21 = false;
    else
        v21 = u11[p20] == true;
    end;

    return v21;
end;

function u1.IsInspectActive() -- Line: 156
    -- upvalues: u3 (ref)
    return u3;
end;

function u1.IsStoreEnabled() -- Line: 161
    -- upvalues: ReplicatedStorage (copy)
    return ReplicatedStorage:GetAttribute("Environment") == "Production";
end;

function u1.SetScreen(p22: string?) -- Line: 166
    -- upvalues: u2 (ref), u1 (copy)
    if p22 == u2 or p22 == "Store" and not u1.IsStoreEnabled() then
        return;
    end;

    local v23 = u2;
    u2 = p22;
    u1.OnScreenChanged:Fire(v23, p22);
end;

function u1.SetWantsMainMenu(p24: boolean) -- Line: 178
    -- upvalues: u8 (ref)
    u8 = p24 == true;
end;

function u1.WantsMainMenu() -- Line: 183
    -- upvalues: u8 (ref)
    return u8;
end;

function u1.HideMenu() -- Line: 187
    -- upvalues: u12 (ref), PlayerGui (copy), u1 (copy)
    if not u12 then
        u12 = PlayerGui:FindFirstChild("MainGui");
    end;

    local v25 = u12;
    local v26;

    if v25 then
        v26 = v25:FindFirstChild("Menu");
    else
        v26 = nil;
    end;

    if v26 then
        v26.Visible = false;
    end;

    u1.SetScreen(nil);
end;

function u1.EnterInspect() -- Line: 197
    -- upvalues: u3 (ref), u6 (ref), u2 (ref), u1 (copy)
    if u3 then
        return;
    end;

    u6 = u2;
    u3 = true;
    u1.OnInspectStateChanged:Fire(true);
end;

function u1.ExitInspect() -- Line: 208
    -- upvalues: u3 (ref), u1 (copy), u6 (ref)
    if not u3 then
        return;
    end;

    u3 = false;
    u1.OnInspectStateChanged:Fire(false);
    u6 = nil;
end;

function u1.GetScreenBeforeInspect() -- Line: 219
    -- upvalues: u6 (ref)
    return u6;
end;

function u1.IsCaseSceneActive() -- Line: 223
    -- upvalues: u4 (ref)
    return u4;
end;

function u1.EnterCaseScene() -- Line: 228
    -- upvalues: u4 (ref), u7 (ref), u2 (ref), u1 (copy)
    if u4 then
        return;
    end;

    u7 = u2;
    u4 = true;
    u1.OnCaseSceneStateChanged:Fire(true);
end;

function u1.ExitCaseScene() -- Line: 239
    -- upvalues: u4 (ref), u1 (copy), u7 (ref)
    if not u4 then
        return;
    end;

    u4 = false;
    u1.OnCaseSceneStateChanged:Fire(false);
    u7 = nil;
end;

function u1.GetScreenBeforeCaseScene() -- Line: 250
    -- upvalues: u7 (ref)
    return u7;
end;

function u1.IsTradeUpActive() -- Line: 255
    -- upvalues: u5 (ref)
    return u5;
end;

function u1.EnterTradeUp() -- Line: 260
    -- upvalues: u5 (ref), u1 (copy)
    if u5 then
        return;
    end;

    u5 = true;
    u1.OnTradeUpStateChanged:Fire(true);
end;

function u1.ExitTradeUp() -- Line: 269
    -- upvalues: u5 (ref), u1 (copy)
    if not u5 then
        return;
    end;

    u5 = false;
    u1.OnTradeUpStateChanged:Fire(false);
end;

local u27 = nil;

function u1.HoldNavigationSelection(p28: userdata?) -- Line: 283
    -- upvalues: u27 (ref)
    u27 = p28;
end;

function u1.IsNavigationSelectionHeld() -- Line: 287
    -- upvalues: u27 (ref), GuiService (copy)
    local v29;

    if u27 == nil then
        v29 = false;
    else
        v29 = GuiService.SelectedObject == u27;
    end;

    return v29;
end;

function u1.IsSelectionWithin(p30: userdata) -- Line: 294
    -- upvalues: GuiService (copy)
    local SelectedObject = GuiService.SelectedObject;
    local v31;

    if SelectedObject == nil then
        v31 = false;
    else
        v31 = SelectedObject == p30 and true or SelectedObject:IsDescendantOf(p30);
    end;

    return v31;
end;

local function isUsableSelection(p32: userdata) -- Line: 301
    -- upvalues: isEffectivelyVisible (copy)
    local v33 = p32.Selectable and p32.Interactable and isEffectivelyVisible(p32);

    return v33;
end;

function u1.RegisterBumperOverride(p34: userdata, p35: function, p36: userdata?, p37: userdata?, p38: function?) -- Line: 310
    -- upvalues: u9 (copy)
    for _, v in ipairs(u9) do
        if v.frame == p34 then
            v.handler = p35;
            v.selectionScope = p36;
            v.refocusTarget = p37;
            v.isActive = p38;

            return;
        end;
    end;

    table.insert(u9, {
        frame = p34,
        handler = p35,
        selectionScope = p36,
        refocusTarget = p37,
        isActive = p38
    });
end;

function u1.HandleBumperInput(p39: boolean) -- Line: 337
    -- upvalues: u9 (copy), isEffectivelyVisible (copy), u1 (copy), GuiService (copy)
    for _, v in ipairs(u9) do
        local selectionScope = v.selectionScope;
        local v40;

        if v.isActive == nil then
            v40 = false;
        else
            v40 = v.isActive();
        end;

        if isEffectivelyVisible(v.frame) and (not selectionScope or (v40 or u1.IsSelectionWithin(selectionScope))) and v.handler(p39) then
            if selectionScope then
                local u41 = v.refocusTarget or selectionScope;
                task.defer(function() -- Line: 353
                    -- upvalues: GuiService (ref), selectionScope (copy), isEffectivelyVisible (ref), u41 (copy)
                    local SelectedObject = GuiService.SelectedObject;

                    if SelectedObject and SelectedObject:IsDescendantOf(selectionScope) then
                        local v42 = SelectedObject.Selectable and SelectedObject.Interactable and isEffectivelyVisible(SelectedObject);

                        if v42 then
                            return;
                        end;
                    end;

                    for _, descendant in ipairs(u41:GetDescendants()) do
                        if descendant:IsA("GuiObject") then
                            local v43 = descendant.Selectable and descendant.Interactable and isEffectivelyVisible(descendant);

                            if v43 then
                                GuiService.SelectedObject = descendant;

                                return;
                            end;
                        end;
                    end;
                end);
            end;

            return true;
        end;
    end;

    return false;
end;

function u1.GetNextBumperTab(p44: userdata, p45: table, p46: string?, p47: boolean) -- Line: 374
    local v48 = {};

    for _, v in ipairs(p45) do
        local v49 = p44:FindFirstChild(v);

        if v49 and (v49:IsA("GuiObject") and v49.Visible) then
            table.insert(v48, v);
        end;
    end;

    local v50 = #v48;

    if v50 == 0 then
        return nil;
    end;

    local v51;

    if p46 then
        v51 = table.find(v48, p46);
    else
        v51 = nil;
    end;

    if v51 then
        return v48[(v51 - 1 + (p47 and -1 or 1)) % v50 + 1];
    end;

    return v48[1];
end;

function u1.SetBlurEnabled(p52: boolean) -- Line: 403
    -- upvalues: u13 (ref), Lighting (copy)
    local v53;

    if u13 then
        v53 = u13;
    else
        u13 = Lighting:FindFirstChild("Menu");
        v53 = u13;
    end;

    if v53 then
        v53.Enabled = p52;
    end;
end;

u1.GetMenuFrame = getMenuFrame;
u1.GetMainGui = getMainGui;

return u1;