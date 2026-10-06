-- Decompiled with Potassium's decompiler.

local v1 = {};
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local GuiService = game:GetService("GuiService");
local script_CareerData = require(script.CareerData);
local script_Selection = require(script.Selection);
local script_Overview = require(script.Overview);
local script_WeaponStats = require(script.WeaponStats);
local script_MatchHistory = require(script.MatchHistory);
local script_WeaponIcon = require(script.WeaponIcon);
local ActivateButton = require(ReplicatedStorage.Components.Common.InterfaceAnimations.ActivateButton);
local SetTabSelected = require(ReplicatedStorage.Components.Common.InterfaceAnimations.SetTabSelected);
local Router = require(ReplicatedStorage.Database.Security.Router);
local MenuState = require(ReplicatedStorage.Interface.MenuState);
local table_freeze_ret = table.freeze({
    Overview = "Overview",
    MatchHistory = "Matchhistory",
    WeaponStats = "WeaponStats",
    Leaderboard = "Leaderboard"
});
local table_freeze_ret2 = table.freeze({ "Overview", "MatchHistory", "WeaponStats", "Leaderboard" });
local u2 = nil;
local u3 = nil;
local u4 = "Overview";
local u5 = {};

local function GetPage(p6: string) -- Line: 56
    -- upvalues: u3 (ref)
    local v7 = u3:FindFirstChild(p6);

    if v7 and v7:IsA("Frame") then
        return v7;
    end;

    return nil;
end;

local function UpdateTabButtons() -- Line: 64
    -- upvalues: u5 (copy), SetTabSelected (copy), u4 (ref)
    for i, v in pairs(u5) do
        SetTabSelected(v, i == u4);
    end;
end;

local function ShowTab(p8: string) -- Line: 72
    -- upvalues: u4 (ref), table_freeze_ret (copy), u3 (ref), script_MatchHistory (copy), u5 (copy), SetTabSelected (copy), script_Overview (copy)
    u4 = p8;

    for i, v in pairs(table_freeze_ret) do
        local v9 = u3:FindFirstChild(v);

        if not (v9 and v9:IsA("Frame")) then
            v9 = nil;
        end;

        if v9 then
            v9.Visible = i == p8;
        end;
    end;

    if p8 ~= "MatchHistory" then
        script_MatchHistory.Close();
    end;

    for i, v in pairs(u5) do
        SetTabSelected(v, i == u4);
    end;

    script_Overview.RefreshSelection();
end;

local function SelectTab(p10: string) -- Line: 93
    -- upvalues: u4 (ref), Router (copy), ShowTab (copy)
    if u4 == p10 then
        return;
    end;

    Router.broadcastRouter("RunInterfaceSound", "UI Click");
    ShowTab(p10);
end;

local function Render() -- Line: 104
    -- upvalues: script_Overview (copy), script_WeaponStats (copy), script_MatchHistory (copy)
    script_Overview.Render();
    script_WeaponStats.Render();
    script_MatchHistory.Render();
end;

function v1.Initialize(p11: any, p12: userdata) -- Line: 113
    -- upvalues: u2 (ref), u3 (ref), table_freeze_ret (copy), u5 (copy), ActivateButton (copy), u4 (ref), Router (copy), ShowTab (copy), script_Overview (copy), script_WeaponStats (copy), script_MatchHistory (copy), MenuState (copy), table_freeze_ret2 (copy), GuiService (copy)
    u2 = p12;
    u3 = p12:WaitForChild("Pages");
    u2.Visible = false;
    local Categories = p12:WaitForChild("Top"):WaitForChild("Categories");

    for i in pairs(table_freeze_ret) do
        local v13 = Categories:FindFirstChild(i);

        if v13 and v13:IsA("GuiButton") then
            u5[i] = v13;
            ActivateButton(v13);
            v13.MouseButton1Click:Connect(function() -- Line: 124
                -- upvalues: i (copy), u4 (ref), Router (ref), ShowTab (ref)
                local v14 = i;

                if u4 == v14 then
                    return;
                end;

                Router.broadcastRouter("RunInterfaceSound", "UI Click");
                ShowTab(v14);
            end);
        end;
    end;

    local v15 = u3:FindFirstChild(table_freeze_ret.Overview);

    if not (v15 and v15:IsA("Frame")) then
        v15 = nil;
    end;

    if v15 then
        script_Overview.Bind(v15);
        script_Overview.BindTab(u5.Overview);
    end;

    local v16 = u3:FindFirstChild(table_freeze_ret.WeaponStats);

    if not (v16 and v16:IsA("Frame")) then
        v16 = nil;
    end;

    if v16 then
        script_WeaponStats.Bind(v16);
    end;

    local v17 = u3:FindFirstChild(table_freeze_ret.MatchHistory);

    if not (v17 and v17:IsA("Frame")) then
        v17 = nil;
    end;

    if v17 then
        script_MatchHistory.Bind(v17);
    end;

    MenuState.RegisterBumperOverride(u2, function(p18: boolean) -- Line: 147
        -- upvalues: MenuState (ref), Categories (copy), table_freeze_ret2 (ref), u4 (ref), Router (ref), ShowTab (ref), GuiService (ref), table_freeze_ret (ref), u3 (ref), u5 (ref)
        local NextBumperTab = MenuState.GetNextBumperTab(Categories, table_freeze_ret2, u4, p18);

        if NextBumperTab and u4 ~= NextBumperTab then
            Router.broadcastRouter("RunInterfaceSound", "UI Click");
            ShowTab(NextBumperTab);
        end;

        local SelectedObject = GuiService.SelectedObject;
        local v19 = u3:FindFirstChild(table_freeze_ret[u4]);

        if not (v19 and v19:IsA("Frame")) then
            v19 = nil;
        end;

        local v20;

        if SelectedObject == nil then
            v20 = false;
        else
            v20 = SelectedObject:IsDescendantOf(Categories);
        end;

        local v21;

        if SelectedObject == nil then
            v21 = false;
        else
            v21 = SelectedObject:IsDescendantOf(u3);

            if v21 then
                if v19 then
                    v19 = SelectedObject:IsDescendantOf(v19);
                end;

                v21 = not v19;
            end;
        end;

        if v20 or v21 then
            GuiService.SelectedObject = u5[u4];
        end;

        return true;
    end);
    ShowTab("Overview");
end;

function v1.Start() -- Line: 173
    -- upvalues: script_CareerData (copy), Render (copy), script_Selection (copy), script_WeaponIcon (copy), script_Overview (copy), script_WeaponStats (copy), script_MatchHistory (copy), MenuState (copy), u2 (ref), ShowTab (copy)
    script_CareerData.Listen();
    script_CareerData.Changed:Connect(Render);
    script_Selection.Changed:Connect(Render);
    script_WeaponIcon.Changed:Connect(function() -- Line: 181
        -- upvalues: script_CareerData (ref), script_Overview (ref), script_WeaponStats (ref), script_MatchHistory (ref)
        if script_CareerData.IsLoaded() then
            script_Overview.Render();
            script_WeaponStats.Render();
            script_MatchHistory.Render();
        end;
    end);
    MenuState.OnScreenChanged:Connect(function(p22, p23) -- Line: 188
        -- upvalues: u2 (ref), script_MatchHistory (ref), ShowTab (ref), script_CareerData (ref), script_Overview (ref), script_WeaponStats (ref)
        if p23 ~= "Career" then
            if u2 and not u2.Visible then
                script_MatchHistory.Close();
            end;

            return;
        end;

        ShowTab("Overview");
        script_CareerData.Request();
        script_Overview.Render();
        script_WeaponStats.Render();
        script_MatchHistory.Render();
    end);

    if script_CareerData.IsLoaded() then
        script_Overview.Render();
        script_WeaponStats.Render();
        script_MatchHistory.Render();
    end;
end;

return v1;