-- Decompiled with Potassium's decompiler.

local v1 = {};
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local ActivateButton = require(ReplicatedStorage.Components.Common.InterfaceAnimations.ActivateButton);
local MenuState = require(ReplicatedStorage.Interface.MenuState);
local UpdateLogs = require(ReplicatedStorage.Database.Custom.UpdateLogs);
local u2 = nil;
local u3 = nil;
local u4 = nil;
local u5 = nil;

local function buildLog(u6: table) -- Line: 36
    -- upvalues: ReplicatedStorage (copy), u3 (ref), u4 (ref), ActivateButton (copy), u5 (ref)
    local v7 = ReplicatedStorage.Assets.UI.Updates.Update:Clone();
    v7.Name = u6.Date;
    v7.Container.HEADING.Text = u6.Title;
    v7.Container.DATE.Text = u6.Date;
    v7.Parent = u3;
    local v8 = ReplicatedStorage.Assets.UI.Updates.Date:Clone();
    v8.Image = u6.Banner;
    v8.Info.Mode.Text = u6.Title;
    v8.Info.Description.Text = u6.Date;
    v8.Name = u6.Date;
    v8.Parent = u4.Content.UpdateDates.Container;

    for _, v in u6.Headers do
        local v9 = ReplicatedStorage.Assets.UI.Updates.Category:Clone();
        v9.Category.Text = `[{v.Title}]`;
        v9.Parent = v7.Container;

        for _, v2 in v.Logs do
            local v10 = ReplicatedStorage.Assets.UI.Updates.Log:Clone();
            v10.Log.Text = v2;
            v10.Parent = v9;
        end;
    end;

    ActivateButton(v8);
    v8.MouseButton1Click:Connect(function() -- Line: 63
        -- upvalues: u3 (ref), u6 (copy), u5 (ref)
        for _, child in u3:GetChildren() do
            if child:IsA("Frame") then
                child.Visible = child.Name == u6.Date;
            end;
        end;

        u5.Image = u6.Banner;
        u5.Description.Text = u6.Date;
    end);

    return v7;
end;

function v1.Initialize(p11, p12) -- Line: 81
    -- upvalues: u2 (ref), u3 (ref), u4 (ref), u5 (ref), UpdateLogs (copy), buildLog (copy), ActivateButton (copy), MenuState (copy)
    u2 = p12;
    u3 = u2.Main.UpdateScroller;
    u4 = u2.Main.Sidebar;
    u5 = u4.Heading;
    u5.Image = UpdateLogs[1].Banner;
    u5.Description.Text = UpdateLogs[1].Date;

    for i = 1, #UpdateLogs do
        buildLog(UpdateLogs[i]).Visible = i == 1;
        local _ = i;
    end;

    local Close = u2.Close;
    ActivateButton(Close);
    Close.MouseButton1Click:Connect(function() -- Line: 97
        -- upvalues: u2 (ref)
        u2.Visible = false;
    end);

    local function updateDashboardSectionsVisibility() -- Line: 102
        -- upvalues: u2 (ref)
        local Dashboard = u2.Parent:FindFirstChild("Dashboard");

        if not Dashboard then
            return;
        end;

        local Visible = u2.Visible;
        local Left = Dashboard:FindFirstChild("Left");
        local v13;

        if Left then
            v13 = Left:FindFirstChild("News");
        else
            v13 = Left;
        end;

        if Left then
            Left = Left:FindFirstChild("Featured");
        end;

        local Rewards = Dashboard:FindFirstChild("Rewards");

        if v13 then
            v13.Visible = not Visible;
        end;

        if Left then
            Left.Visible = not Visible;
        end;

        if Rewards then
            Rewards.Visible = not Visible;
        end;
    end;

    u2:GetPropertyChangedSignal("Visible"):Connect(updateDashboardSectionsVisibility);
    updateDashboardSectionsVisibility();
    MenuState.OnScreenChanged:Connect(function(p14, p15) -- Line: 128
        -- upvalues: u2 (ref)
        if p15 ~= nil and p15 ~= "Dashboard" then
            u2.Visible = false;
        end;
    end);
end;

return v1;