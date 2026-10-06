-- Decompiled with Potassium's decompiler.

local u1 = {};
u1.__index = u1;
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local RunService = game:GetService("RunService");
local StarterGui = game:GetService("StarterGui");
local LocalPlayer = game:GetService("Players").LocalPlayer;
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui");
local Sound = require(ReplicatedStorage.Classes.Sound);
local GetUserPlatform = require(ReplicatedStorage.Components.Common.GetUserPlatform);
local Router = require(ReplicatedStorage.Database.Security.Router);
local Profiler = require(ReplicatedStorage.Shared.Profiler);
local Promise = require(ReplicatedStorage.Shared.Promise);
local DataController = require(ReplicatedStorage.Controllers.DataController);
local script_MenuState = require(script.MenuState);
local script_GamepadNavigation = require(script.GamepadNavigation);
local Screens = script:WaitForChild("Screens");
local Mobile = require(ReplicatedStorage.Database.Custom.GameStats.UI.Mobile);
local v2 = StarterGui:FindFirstChild("MainGui") or ReplicatedStorage.Assets.UI:FindFirstChild("MainGui");

if v2 then
    Mobile.CaptureDefaults(v2);
end;

local MainGui = PlayerGui:WaitForChild("MainGui", (1 / 0));

if not v2 then
    Mobile.CaptureDefaults(MainGui);
end;

local u3 = 1;
local u4 = nil;
local u5 = nil;
local u6 = nil;
local u7 = { "Ammo", "Armor", "Health", "Inventory", "Money" };
local u8 = {
    ["Screens.Gameplay.Middle.RoundWon"] = true,
    ["Screens.Gameplay.Top.PlayerInfo"] = true,
    ["Screens.Gameplay.Middle.TutorialDiaklogue"] = true
};
local u9 = 0;
local u10 = 0;

local function resetInterfaceLoadBudget() -- Line: 90
    -- upvalues: u9 (ref), u10 (ref)
    u9 = os.clock();
    u10 = 0;
end;

local function maybeYieldInterfaceLoad() -- Line: 95
    -- upvalues: u10 (ref), u9 (ref), RunService (copy)
    u10 = u10 + 1;

    if u10 < 4 and os.clock() - u9 < 0.00125 then
        return;
    end;

    RunService.Heartbeat:Wait();
    u9 = os.clock();
    u10 = 0;
end;

local function runInterfacePhase(p11: string, p12: string, p13: function, ...) -- Line: 108
    -- upvalues: Profiler (copy)
    debug.setmemorycategory((`Interface.{p11}`));
    Profiler.mark((`Interface.Module.{p11}`));
    Profiler.mark((`Interface.Phase.{p12}`));

    return Profiler.scope(`Interface.Callback.{p12}`, p13, ...);
end;

local function promiseRequire(p14: userdata, p15: string) -- Line: 116
    -- upvalues: Promise (copy), runInterfacePhase (copy)
    return Promise.try(runInterfacePhase, p15, "Require", require, p14):catch(warn);
end;

local function loadInterfaceModule(p16: userdata, u17: string, u18: userdata) -- Line: 120
    -- upvalues: Promise (copy), runInterfacePhase (copy), MainGui (copy)
    Promise.try(runInterfacePhase, u17, "Require", require, p16):catch(warn):andThen(function(u19) -- Line: 121
        -- upvalues: Promise (ref), runInterfacePhase (ref), u17 (copy), MainGui (ref), u18 (copy)
        if typeof(u19) ~= "table" then
            return;
        end;

        local v20;

        if u19.Initialize then
            v20 = Promise.try(runInterfacePhase, u17, "Initialize", u19.Initialize, MainGui, u18);
        else
            v20 = Promise.resolve();
        end;

        v20:andThen(function() -- Line: 135
            -- upvalues: u19 (copy), Promise (ref), runInterfacePhase (ref), u17 (ref)
            if u19.Start then
                return Promise.try(runInterfacePhase, u17, "Start", u19.Start);
            end;
        end):catch(warn);
    end);
end;

local function loadInterfaceTree(p21: userdata, p22: userdata?) -- Line: 147
    -- upvalues: loadInterfaceTree (copy), Profiler (copy), u8 (copy), RunService (copy), Promise (copy), runInterfacePhase (copy), MainGui (copy), u10 (ref), u9 (ref)
    if p22 then
        for _, child in ipairs(p21:GetChildren()) do
            local u23 = p22:FindFirstChild(child.Name);

            if child:IsA("Folder") then
                if u23 then
                    loadInterfaceTree(child, u23);
                else
                    warn((`Missing corresponding interface folder : "{string.lower(child:GetFullName())}"`));
                end;
            elseif child:IsA("ModuleScript") then
                local InstancePath = Profiler.getInstancePath(child, script);

                if not u8[InstancePath] then
                    if u23 then
                        Promise.try(runInterfacePhase, InstancePath, "Require", require, child):catch(warn):andThen(function(u24) -- Line: 121
                            -- upvalues: Promise (ref), runInterfacePhase (ref), InstancePath (copy), MainGui (ref), u23 (copy)
                            if typeof(u24) ~= "table" then
                                return;
                            end;

                            local v25;

                            if u24.Initialize then
                                v25 = Promise.try(runInterfacePhase, InstancePath, "Initialize", u24.Initialize, MainGui, u23);
                            else
                                v25 = Promise.resolve();
                            end;

                            v25:andThen(function() -- Line: 135
                                -- upvalues: u24 (copy), Promise (ref), runInterfacePhase (ref), InstancePath (ref)
                                if u24.Start then
                                    return Promise.try(runInterfacePhase, InstancePath, "Start", u24.Start);
                                end;
                            end):catch(warn);
                        end);
                        u10 = u10 + 1;

                        if u10 >= 4 or os.clock() - u9 >= 0.00125 then
                            RunService.Heartbeat:Wait();
                            u9 = os.clock();
                            u10 = 0;
                        end;
                    elseif RunService:IsStudio() then
                        warn((`Missing corresponding interface module for : "{string.lower(child:GetFullName())}"`));
                    end;
                end;
            end;
        end;

        return;
    end;

    warn((`Pointer: "{p21.Name}" is not apart of interface.`));
end;

local function getInterfaceSoundGroup(p26: string) -- Line: 180
    -- upvalues: u4 (ref), Sound (copy), u6 (ref), u5 (ref)
    if p26 == "Interface" then
        if not (u4 and u4.Sounds) then
            u4 = Sound.new("Interface");
        end;

        return u4;
    end;

    if p26 == "ArmsDealer" then
        if not (u6 and u6.Sounds) then
            u6 = Sound.new("ArmsDealer");
        end;

        return u6;
    end;

    if not (u5 and u5.Sounds) then
        u5 = Sound.new("Store");
    end;

    return u5;
end;

local function playInterfaceSound(p27: string, p28: string) -- Line: 204
    -- upvalues: getInterfaceSoundGroup (copy), PlayerGui (copy), u3 (ref)
    local v29 = getInterfaceSoundGroup(p27);

    if v29 then
        return v29:playOneTime({
            Parent = PlayerGui,
            Name = p28
        }, u3);
    end;
end;

function u1.guarantee(p30: function) -- Line: 219
    local v31 = nil;

    for i = 1, 15 do
        local v32;
        v32, v31 = pcall(p30);

        if v32 then
            return true;
        end;

        local v33;

        if i < 15 then
            task.wait(0.1);
            v33 = i;
        else
            v33 = i;
        end;
    end;

    warn((`[Interface] Core GUI initialization failed after 15 attempts: {tostring(v31)}`));

    return false, v31;
end;

function u1.Initialize() -- Line: 236
    -- upvalues: script_MenuState (copy), MainGui (copy), script_GamepadNavigation (copy), u1 (copy), StarterGui (copy), GetUserPlatform (copy), Profiler (copy), u7 (copy), DataController (copy), LocalPlayer (copy), u3 (ref), Router (copy), u4 (ref), Sound (copy), PlayerGui (copy), playInterfaceSound (copy)
    script_MenuState.Initialize(MainGui);
    script_GamepadNavigation.Initialize();
    u1.guarantee(function() -- Line: 240
        -- upvalues: StarterGui (ref)
        StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.All, false);
        StarterGui:SetCore("ResetButtonCallback", false);
    end);
    local Bottom = MainGui:WaitForChild("Gameplay"):WaitForChild("Bottom");
    local u34 = {};
    local u35 = table.find(GetUserPlatform(), "Mobile") ~= nil;

    local function getOrCreateHUDScale(p36: userdata) -- Line: 252
        local HUDScale = p36:FindFirstChild("HUDScale");

        if HUDScale and HUDScale:IsA("UIScale") then
            return HUDScale;
        end;

        local v37 = p36:FindFirstChildOfClass("UIScale");

        if v37 then
            v37.Name = "HUDScale";

            return v37;
        end;

        local UIScale = Instance.new("UIScale");
        UIScale.Name = "HUDScale";
        UIScale.Parent = p36;

        return UIScale;
    end;

    local function applyHUDScale(p38: number) -- Line: 271
        -- upvalues: u35 (copy), u34 (copy)
        local v39 = u35 and 1 or p38;

        for _, v in ipairs(u34) do
            v.Scale = v39;
        end;
    end;

    Profiler.spawn("Interface.Initialize.HUDScale", function() -- Line: 281
        -- upvalues: Profiler (ref), u7 (ref), Bottom (copy), u34 (copy), DataController (ref), LocalPlayer (ref), u35 (copy)
        task.wait(0.1);
        Profiler.mark("Interface.HUDScale.Setup");

        for _, v in ipairs(u7) do
            local v40 = Bottom:FindFirstChild(v);

            if v40 and v40:IsA("Frame") then
                local HUDScale = v40:FindFirstChild("HUDScale");

                if not (HUDScale and HUDScale:IsA("UIScale")) then
                    HUDScale = v40:FindFirstChildOfClass("UIScale");

                    if HUDScale then
                        HUDScale.Name = "HUDScale";
                    else
                        HUDScale = Instance.new("UIScale");
                        HUDScale.Name = "HUDScale";
                        HUDScale.Parent = v40;
                    end;
                end;

                table.insert(u34, HUDScale);
            end;
        end;

        local v41 = u35 and 1 or (DataController.Get(LocalPlayer, "Settings.Game.HUD.Scale") or 1);

        for _, v in ipairs(u34) do
            v.Scale = v41;
        end;
    end);
    DataController.CreateListener(LocalPlayer, "Settings.Game.HUD.Scale", function(p42: number) -- Line: 296
        -- upvalues: u35 (copy), u34 (copy)
        local v43 = u35 and 1 or (p42 or 1);

        for _, v in ipairs(u34) do
            v.Scale = v43;
        end;
    end);
    DataController.CreateListener(LocalPlayer, "Settings.Audio.Music.Main Menu Volume", function(p44: number?) -- Line: 300
        -- upvalues: u3 (ref)
        u3 = (tonumber(p44) or 100) / 100;
    end);
    Router.observerRouter("RunInterfaceSound", function(p45: string) -- Line: 304
        -- upvalues: u4 (ref), Sound (ref), PlayerGui (ref), u3 (ref)
        if not (u4 and u4.Sounds) then
            u4 = Sound.new("Interface");
        end;

        local v46 = u4;

        if not v46 then
            return;
        end;

        v46:playOneTime({
            Parent = PlayerGui,
            Name = p45
        }, u3);
    end);
    Router.observerRouter("RunStoreSound", function(p47: string) -- Line: 307
        -- upvalues: playInterfaceSound (ref)
        return playInterfaceSound("Store", p47);
    end);
    Router.observerRouter("RunArmsDealerSound", function(p48: string) -- Line: 311
        -- upvalues: playInterfaceSound (ref)
        return playInterfaceSound("ArmsDealer", p48);
    end);
end;

function u1.Start() -- Line: 316
    -- upvalues: u9 (ref), u10 (ref), loadInterfaceTree (copy), Screens (copy), MainGui (copy)
    u9 = os.clock();
    u10 = 0;
    loadInterfaceTree(Screens, MainGui);
end;

return u1;