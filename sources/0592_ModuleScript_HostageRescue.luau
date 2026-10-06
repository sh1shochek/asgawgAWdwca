-- Decompiled with Potassium's decompiler.

local u1 = {};
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Players = game:GetService("Players");
local GameState = require(ReplicatedStorage.Database.Components.GameState);
local LocalPlayer = Players.LocalPlayer;
local DataController = require(ReplicatedStorage.Controllers.DataController);
local Observers = require(ReplicatedStorage.Packages.Observers);
local Janitor = require(ReplicatedStorage.Shared.Janitor);
local u2 = {};
local u3 = nil;

local function UpdateTemplateState(p4: any, p5: string) -- Line: 37
    p4.Idle.Visible = p5 ~= "Carrying";
    p4.Action.Visible = p5 == "Carrying";
end;

local function ClearFrame(p6: userdata) -- Line: 42
    -- upvalues: u2 (copy)
    for _, child in ipairs(p6:GetChildren()) do
        if u2[child] then
            u2[child]:Destroy();
            u2[child] = nil;
        end;
    end;
end;

local function UpdateTemplateSizes() -- Line: 51
    -- upvalues: u3 (ref)
    local v7 = {};

    for _, child in ipairs(u3:GetChildren()) do
        if child:IsA("Frame") then
            table.insert(v7, child);
        end;
    end;

    for _, v in ipairs(v7) do
        v.Size = UDim2.fromScale(1 / #v7, 1);
    end;
end;

local function UpdatePosition(p8: number) -- Line: 64
    -- upvalues: u3 (ref)
    if not u3 then
        return;
    end;

    u3.Position = UDim2.new(0.029, 0, 0, 240 - (200 - p8 * 200) + 50);
end;

local function UpdateVisibility() -- Line: 76
    -- upvalues: u3 (ref)
    if not u3 then
        return;
    end;

    u3.Visible = workspace:GetAttribute("Gamemode") == "Hostage Rescue";
end;

function u1.CreateTemplate(p9: userdata) -- Line: 87
    -- upvalues: ReplicatedStorage (copy), u3 (ref), UpdateTemplateSizes (copy)
    local v10 = ReplicatedStorage.Assets.UI.HostageRescue.Template:Clone();
    v10.Parent = u3;
    UpdateTemplateSizes();

    return v10;
end;

function u1.Initialize(p11: any, p12: userdata) -- Line: 97
    -- upvalues: u3 (ref), DataController (copy), LocalPlayer (copy), UpdatePosition (copy), UpdateVisibility (copy), GameState (copy), ClearFrame (copy), Observers (copy), Janitor (copy), UpdateTemplateSizes (copy), u1 (copy), u2 (copy)
    u3 = p12;
    DataController.CreateListener(LocalPlayer, "Settings.Game.Radar/Tablet.Radar Hud Size", UpdatePosition);
    local v13 = DataController.Get(LocalPlayer, "Settings.Game.Radar/Tablet.Radar Hud Size") or 1;

    if u3 then
        u3.Position = UDim2.new(0.029, 0, 0, 240 - (200 - v13 * 200) + 50);
    end;

    if u3 then
        u3.Visible = workspace:GetAttribute("Gamemode") == "Hostage Rescue";
    end;

    workspace:GetAttributeChangedSignal("Gamemode"):Connect(UpdateVisibility);
    GameState.ListenToState(function(p14, p15) -- Line: 112
        -- upvalues: ClearFrame (ref), u3 (ref)
        if p15 == "Buy Period" or p15 == "Warmup" then
            ClearFrame(u3);
        end;
    end);
    Observers.observeTag("Hostage", function(u16: userdata) -- Line: 119
        -- upvalues: Janitor (ref), UpdateTemplateSizes (ref), u1 (ref), u2 (ref)
        local v17 = Janitor.new();
        v17:Add(UpdateTemplateSizes);
        local u18 = v17:Add(u1.CreateTemplate(u16));
        u2[u18] = v17;
        local v19 = u16:GetAttribute("State") or "Idle";
        u18.Idle.Visible = v19 ~= "Carrying";
        u18.Action.Visible = v19 == "Carrying";
        v17:Add(u16:GetAttributeChangedSignal("State"):Connect(function() -- Line: 125
            -- upvalues: u18 (copy), u16 (copy)
            local v20 = u18;
            local v21 = u16:GetAttribute("State") or "Idle";
            v20.Idle.Visible = v21 ~= "Carrying";
            v20.Action.Visible = v21 == "Carrying";
        end));

        return function() -- Line: 128
            -- upvalues: u2 (ref), u18 (copy)
            if u2[u18] then
                u2[u18]:Destroy();
                u2[u18] = nil;
            end;
        end;
    end);
end;

return u1;