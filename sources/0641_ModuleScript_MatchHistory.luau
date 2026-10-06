-- Decompiled with Potassium's decompiler.

local v1 = {};
local ReplicatedStorage = game:GetService("ReplicatedStorage");
require(script.Parent.Types);
local Format = require(script.Parent.Format);
local MapIcon = require(script.Parent.MapIcon);
local CareerData = require(script.Parent.CareerData);
local MatchDetails = require(script.Parent.MatchDetails);
local ActivateButton = require(ReplicatedStorage.Components.Common.InterfaceAnimations.ActivateButton);
local Router = require(ReplicatedStorage.Database.Security.Router);
local table_freeze_ret = table.freeze({ "Template", "ServerBrowserTemplate" });
local u2 = nil;
local u3 = nil;

local function SetText(p4: userdata, p5: string, p6: string) -- Line: 36
    local v7 = p4:FindFirstChild(p5);

    if v7 and v7:IsA("TextLabel") then
        v7.Text = p6;
    end;
end;

local function BindDetailsButton(p8: userdata, u9: any) -- Line: 45
    -- upvalues: Router (copy), MatchDetails (copy), ActivateButton (copy)
    local function open() -- Line: 46
        -- upvalues: Router (ref), MatchDetails (ref), u9 (copy)
        Router.broadcastRouter("RunInterfaceSound", "UI Click");
        MatchDetails.Open(u9);
    end;

    local Details = p8:FindFirstChild("Details");

    if Details and Details:IsA("GuiButton") then
        ActivateButton(Details);
        Details.MouseButton1Click:Connect(open);
        local Tooltip = Details:FindFirstChild("Tooltip");

        if Tooltip then
            local Title = Tooltip:FindFirstChild("Title");
            local Desc = Tooltip:FindFirstChild("Desc");

            if Title then
                Title.Text = "MATCH DETAILS";
            end;

            if Desc then
                Desc.Text = "Open the full scoreboard for this match.";
            end;
        end;
    end;

    local MapBackground = p8:FindFirstChild("MapBackground");

    if MapBackground then
        MapBackground = MapBackground:FindFirstChild("ImageButton");
    end;

    if MapBackground and MapBackground:IsA("GuiButton") then
        MapBackground.MouseButton1Click:Connect(open);
    end;
end;

local function CreateRow(p10: any, p11: number) -- Line: 79
    -- upvalues: u3 (ref), Format (copy), MatchDetails (copy), MapIcon (copy), BindDetailsButton (copy), u2 (ref)
    local v12 = u3:Clone();
    v12.Name = `Match_{p11}`;
    v12.LayoutOrder = p11;
    v12.Visible = true;
    local string_upper_ret = string.upper(p10.Map);
    local MapName = v12:FindFirstChild("MapName");

    if MapName and MapName:IsA("TextLabel") then
        MapName.Text = string_upper_ret;
    end;

    local v13 = Format.DateTime(p10.CompletedAt);
    local Date = v12:FindFirstChild("Date");

    if Date and Date:IsA("TextLabel") then
        Date.Text = v13;
    end;

    local string_upper_ret2 = string.upper(p10.ServerGamemode);
    local Gamemode = v12:FindFirstChild("Gamemode");

    if Gamemode and Gamemode:IsA("TextLabel") then
        Gamemode.Text = string_upper_ret2;
    end;

    local Score = v12:FindFirstChild("Score");

    if Score then
        Score.RichText = true;
        Score.Text = Format.MatchScore(p10.Team, p10.CTScore, p10.TScore);
    end;

    local Status = v12:FindFirstChild("Status");

    if Status then
        MatchDetails.ApplyStatus(Status, p10.Result);
    end;

    local MapBackground = v12:FindFirstChild("MapBackground");

    if MapBackground then
        MapBackground = MapBackground:FindFirstChild("ImageButton");
    end;

    if MapBackground and MapBackground:IsA("ImageButton") then
        MapBackground.Image = MapIcon.Get(p10.Map);
    end;

    BindDetailsButton(v12, p10);
    v12.Parent = u2;
end;

local function ClearRows() -- Line: 113
    -- upvalues: u2 (ref)
    for _, child in ipairs(u2:GetChildren()) do
        if child:IsA("Frame") and string.sub(child.Name, 1, 6) == "Match_" then
            child:Destroy();
        end;
    end;
end;

function v1.Bind(p14: userdata) -- Line: 124
    -- upvalues: u2 (ref), table_freeze_ret (copy), u3 (ref), MatchDetails (copy)
    local History = p14:FindFirstChild("History");

    if History then
        History = History:FindFirstChild("Main");
    end;

    if History then
        History = History:FindFirstChild("MatchHistory");
    end;

    local v15;

    if History then
        v15 = History:FindFirstChild("Container");
    else
        v15 = History;
    end;

    u2 = v15;

    if not u2 then
        return;
    end;

    if History and History:IsA("GuiObject") then
        History.Visible = true;
    end;

    for _, child in ipairs(u2:GetChildren()) do
        if child:IsA("Frame") and table.find(table_freeze_ret, child.Name) ~= nil then
            if u3 then
                child:Destroy();
            else
                u3 = child;
                u3.Visible = false;
            end;
        end;
    end;

    MatchDetails.Bind(p14);
end;

function v1.Render() -- Line: 155
    -- upvalues: CareerData (copy), u2 (ref), u3 (ref), ClearRows (copy), CreateRow (copy)
    local v16 = CareerData.Get();

    if not (u2 and (u3 and v16)) then
        return;
    end;

    ClearRows();

    for i, v in ipairs(v16.Matches) do
        CreateRow(v, i);
    end;

    local Empty = u2:FindFirstChild("Empty");

    if Empty and Empty:IsA("GuiObject") then
        Empty.Visible = #v16.Matches == 0;
    end;
end;

function v1.Close() -- Line: 175
    -- upvalues: MatchDetails (copy)
    MatchDetails.Close();
end;

return v1;