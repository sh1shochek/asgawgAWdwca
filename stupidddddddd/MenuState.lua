-- ReplicatedStorage.Interface.MenuState
-- Script path: ReplicatedStorage.Interface.MenuState
-- Decompile time: 4.15 ms

local u0 = {}
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local GuiService = game:GetService("GuiService")
local Lighting = game:GetService("Lighting")
local PlayerGui = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
local Signal = require(ReplicatedStorage.Packages.Signal)
u0.OnScreenChanged = Signal.new()
u0.OnInspectStateChanged = Signal.new()
u0.OnCaseSceneStateChanged = Signal.new()
u0.OnTradeUpStateChanged = Signal.new()
local u38 = nil
local u39 = false
local u40 = false
local u41 = false
local u42 = nil
local u43 = nil
local u44 = false
local u45 = {}
local u46 = {
    Loadout = true,
    Inventory = true,
    Gamemodes = true,
    Settings = true,
    Store = true,
    Career = true,
    Progression = true,
    GlobalMarketPlace = true,
    Blackmarket = true,
}
local u47 = {Blackmarket = true}
local u48 = nil
local u49 = nil

local function getMenuBlur() -- Line: 94 -- upvalues: u49 (ref), Lighting (val)
    if u49 then
        return u49
    end
    u49 = Lighting:FindFirstChild("Menu")
    return u49
end

local function isEffectivelyVisible(a1) -- Line: 118 -- upvalues: PlayerGui (val) -- types: a1: userdata
    if not a1:IsDescendantOf(PlayerGui) then
        return false
    end
    local Parent = a1
    while Parent do
        if not Parent:IsA("GuiObject") then
            break
        end
        if not Parent.Visible then
            return false
        end
        Parent = Parent.Parent
    end
    return true
end

function u0.Initialize(a1) -- Line: 138 -- upvalues: u48 (ref), u49 (ref), Lighting (val) -- types: a1: userdata
    u48 = a1
    if not u49 then
        u49 = Lighting:FindFirstChild("Menu")
    end
    u49 = u49
end

function u0.GetCurrentScreen() -- Line: 143 -- upvalues: u38 (ref)
    return u38
end

function u0.IsPreservableScreen(a1) -- Line: 147 -- upvalues: u46 (val) -- types: a1: string?
    local v1 = false
    if a1 ~= nil then
        v1 = u46[a1] == true
    end
    return v1
end

function u0.IsSceneScreen(a1) -- Line: 152 -- upvalues: u47 (val) -- types: a1: string?
    local v1 = false
    if a1 ~= nil then
        v1 = u47[a1] == true
    end
    return v1
end

function u0.IsInspectActive() -- Line: 156 -- upvalues: u39 (ref)
    return u39
end

function u0.IsStoreEnabled() -- Line: 161 -- upvalues: ReplicatedStorage (val)
    return ReplicatedStorage:GetAttribute("Environment") == "Production"
end

function u0.SetScreen(a1) -- Line: 166 -- upvalues: u38 (ref), u0 (val) -- types: a1: string?
    if a1 == u38 then
        return
    end
    if a1 == "Store" and not u0.IsStoreEnabled() then
        return
    end
    local v1 = u38
    u38 = a1
    u0.OnScreenChanged:Fire(v1, a1)
end

function u0.SetWantsMainMenu(a1) -- Line: 178 -- upvalues: u44 (ref) -- types: a1: boolean
    u44 = a1 == true
end

function u0.WantsMainMenu() -- Line: 183 -- upvalues: u44 (ref)
    return u44
end

function u0.HideMenu() -- Line: 187 -- upvalues: u48 (ref), PlayerGui (val), u0 (val)
    if not u48 then
        u48 = PlayerGui:FindFirstChild("MainGui")
    end
    local v1 = u48
    local v2 = if not v1 then nil else v1:FindFirstChild("Menu")
    if v2 then
        v2.Visible = false
    end
    u0.SetScreen(nil)
end

function u0.EnterInspect() -- Line: 197 -- upvalues: u39 (ref), u42 (ref), u38 (ref), u0 (val)
    if u39 then
        return
    end
    u42 = u38
    u39 = true
    u0.OnInspectStateChanged:Fire(true)
end

function u0.ExitInspect() -- Line: 208 -- upvalues: u39 (ref), u0 (val), u42 (ref)
    if not u39 then
        return
    end
    u39 = false
    u0.OnInspectStateChanged:Fire(false)
    u42 = nil
end

function u0.GetScreenBeforeInspect() -- Line: 219 -- upvalues: u42 (ref)
    return u42
end

function u0.IsCaseSceneActive() -- Line: 223 -- upvalues: u40 (ref)
    return u40
end

function u0.EnterCaseScene() -- Line: 228 -- upvalues: u40 (ref), u43 (ref), u38 (ref), u0 (val)
    if u40 then
        return
    end
    u43 = u38
    u40 = true
    u0.OnCaseSceneStateChanged:Fire(true)
end

function u0.ExitCaseScene() -- Line: 239 -- upvalues: u40 (ref), u0 (val), u43 (ref)
    if not u40 then
        return
    end
    u40 = false
    u0.OnCaseSceneStateChanged:Fire(false)
    u43 = nil
end

function u0.GetScreenBeforeCaseScene() -- Line: 250 -- upvalues: u43 (ref)
    return u43
end

function u0.IsTradeUpActive() -- Line: 255 -- upvalues: u41 (ref)
    return u41
end

function u0.EnterTradeUp() -- Line: 260 -- upvalues: u41 (ref), u0 (val)
    if u41 then
        return
    end
    u41 = true
    u0.OnTradeUpStateChanged:Fire(true)
end

function u0.ExitTradeUp() -- Line: 269 -- upvalues: u41 (ref), u0 (val)
    if not u41 then
        return
    end
    u41 = false
    u0.OnTradeUpStateChanged:Fire(false)
end

local u74 = nil

function u0.HoldNavigationSelection(a1) -- Line: 283 -- upvalues: u74 (ref) -- types: a1: userdata?
    u74 = a1
end

function u0.IsNavigationSelectionHeld() -- Line: 287 -- upvalues: u74 (ref), GuiService (val)
    local v1 = false
    if u74 ~= nil then
        v1 = GuiService.SelectedObject == u74
    end
    return v1
end

function u0.IsSelectionWithin(a1) -- Line: 294 -- upvalues: GuiService (val) -- types: a1: userdata
    local SelectedObject = GuiService.SelectedObject
    local v1 = false
    if SelectedObject ~= nil then
        v1 = true
        if SelectedObject ~= a1 then
            v1 = SelectedObject:IsDescendantOf(a1)
        end
    end
    return v1
end

local function isUsableSelection(a1) -- Line: 301 -- upvalues: isEffectivelyVisible (val) -- types: a1: userdata
    return a1.Selectable and a1.Interactable and isEffectivelyVisible(a1)
end

function u0.RegisterBumperOverride(a1, a2, a3, a4, a5) -- Line: 310
    -- upvalues: u45 (val)
    for i, v in ipairs(u45) do
        if v.frame == a1 then
            v.handler = a2
            v.selectionScope = a3
            v.refocusTarget = a4
            v.isActive = a5
            return
        end
    end
    table.insert(u45, {
        frame = a1,
        handler = a2,
        selectionScope = a3,
        refocusTarget = a4,
        isActive = a5,
    })
end

function u0.HandleBumperInput(a1) -- Line: 337
    -- upvalues: u45 (val), isEffectivelyVisible (val), u0 (val), GuiService (val)
    local u44, v1
    for i, v in ipairs(u45) do
        local selectionScope = v.selectionScope
        v1 = false
        if v.isActive ~= nil then
            v1 = v.isActive()
        end
        if isEffectivelyVisible(v.frame) then
            if selectionScope and not v1 and not u0.IsSelectionWithin(selectionScope) then
                continue
            end
            if v.handler(v2) then
                if selectionScope then
                    u44 = v.refocusTarget or selectionScope
                    task.defer(function() -- Line: 353 -- upvalues: GuiService (upval), selectionScope (val), isEffectivelyVisible (upval), u44 (val)
                        local Selectable_2
                        local SelectedObject = GuiService.SelectedObject
                        if SelectedObject and SelectedObject:IsDescendantOf(selectionScope) then
                            local Selectable = SelectedObject.Selectable and SelectedObject.Interactable and isEffectivelyVisible(SelectedObject)
                            if Selectable then
                                return
                            end
                        end
                        for i, v in ipairs(u44:GetDescendants()) do
                            if v:IsA("GuiObject") then
                                Selectable_2 = v.Selectable and v.Interactable and isEffectivelyVisible(v)
                                if Selectable_2 then
                                    GuiService.SelectedObject = v
                                    return
                                end
                            end
                        end
                    end)
                end
                return true
            end
        end
    end
    return false
end

function u0.GetNextBumperTab(a1, a2, a3, a4) -- Line: 374 -- types: a1: userdata, a2: table, a3: string?, a4: boolean
    local v1, v2
    local v3 = {}
    for i, v in ipairs(a2) do
        v1 = a1:FindFirstChild(v)
        if v1 and v1:IsA("GuiObject") and v1.Visible then
            table.insert(v3, v)
        end
    end
    local v4 = #v3
    if v4 == 0 then
        return nil
    end
    if not (if not a3 then nil else table.find(v3, a3)) then
        return v3[1]
    end
    local v5 = if not a4 then 1 else -1
    return v3[(v2 - 1 + v5) % v4 + 1]
end

function u0.SetBlurEnabled(a1) -- Line: 403 -- upvalues: u49 (ref), Lighting (val) -- types: a1: boolean
    if not u49 then
        u49 = Lighting:FindFirstChild("Menu")
    end
    local v1 = u49
    if v1 then
        v1.Enabled = a1
    end
end

function u0.GetMenuFrame() -- Line: 111 -- upvalues: u48 (ref), PlayerGui (val)
    if not u48 then
        u48 = PlayerGui:FindFirstChild("MainGui")
    end
    local v1 = u48
    if v1 then
        return (v1:FindFirstChild("Menu"))
    end
    return nil
end

function u0.GetMainGui() -- Line: 104 -- upvalues: u48 (ref), PlayerGui (val)
    if not u48 then
        u48 = PlayerGui:FindFirstChild("MainGui")
    end
    return u48
end

return u0