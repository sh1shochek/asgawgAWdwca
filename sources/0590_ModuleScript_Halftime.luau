-- Decompiled with Potassium's decompiler.

local v1 = {};
local ReplicatedStorage = game:GetService("ReplicatedStorage");
require(script:WaitForChild("Types"));
local GameState = require(ReplicatedStorage.Database.Components.GameState);
local u2 = nil;
local u3 = 0;

local function hideHalftime() -- Line: 21
    -- upvalues: u3 (ref), u2 (ref)
    u3 = u3 + 1;
    u2.Visible = false;
end;

local function normalizeTeam(p4: string) -- Line: 26
    return (p4 == "Counter-Terrorists" or p4 == "CT") and "Counter-Terrorists" or ((p4 == "Terrorists" or p4 == "T") and "Terrorists" or nil);
end;

local function getHeader() -- Line: 38
    -- upvalues: u2 (ref)
    local v5 = u2 and u2:FindFirstChild("Title");

    if v5 then
        v5 = v5:FindFirstChild("Header");
    end;

    return v5;
end;

local function getContextLabel(p6: userdata) -- Line: 43
    local Context = p6:FindFirstChild("Context");

    if Context and Context:IsA("TextLabel") then
        return Context;
    end;

    return nil;
end;

local function updateHeaderTeamVisibility(u7: userdata, p8: string) -- Line: 48
    local v9 = p8 == "Counter-Terrorists";
    local v10 = not v9;
    local u11 = false;

    local function setVisibleIfGuiObject(p12: string, p13: boolean) -- Line: 53
        -- upvalues: u7 (copy), u11 (ref)
        local v14 = u7:FindFirstChild(p12);

        if v14 and v14:IsA("GuiObject") then
            v14.Visible = p13;
            u11 = true;
        end;
    end;

    local CT = u7:FindFirstChild("CT");

    if CT and CT:IsA("GuiObject") then
        CT.Visible = v9;
        u11 = true;
    end;

    local T = u7:FindFirstChild("T");

    if T and T:IsA("GuiObject") then
        T.Visible = v10;
        u11 = true;
    end;

    local PlayingCT = u7:FindFirstChild("PlayingCT");

    if PlayingCT and PlayingCT:IsA("GuiObject") then
        PlayingCT.Visible = v9;
        u11 = true;
    end;

    local PlayingT = u7:FindFirstChild("PlayingT");

    if PlayingT and PlayingT:IsA("GuiObject") then
        PlayingT.Visible = v10;
        u11 = true;
    end;

    return u11;
end;

local function showHalftime(p15: string, p16: number?) -- Line: 69
    -- upvalues: u3 (ref), u2 (ref), updateHeaderTeamVisibility (copy)
    local v17 = (p15 == "Counter-Terrorists" or p15 == "CT") and "Counter-Terrorists" or ((p15 == "Terrorists" or p15 == "T") and "Terrorists" or nil);

    if not v17 then
        warn(("[Halftime] Unsupported NextTeam value: %s"):format((tostring(p15))));
        u3 = u3 + 1;
        u2.Visible = false;

        return false;
    end;

    local v18 = "Playing as " .. v17;
    local v19 = u2 and u2:FindFirstChild("Title");

    if v19 then
        v19 = v19:FindFirstChild("Header");
    end;

    if not v19 then
        warn("[Halftime] Missing Title.Header");
        u3 = u3 + 1;
        u2.Visible = false;

        return false;
    end;

    local Context = v19:FindFirstChild("Context");

    if not (Context and Context:IsA("TextLabel")) then
        Context = nil;
    end;

    if not (updateHeaderTeamVisibility(v19, v17) or Context) then
        warn("[Halftime] Missing Title.Header CT/T + PlayingCT/PlayingT visuals and Context TextLabel");
        u3 = u3 + 1;
        u2.Visible = false;

        return false;
    end;

    if Context then
        Context.Text = v18;
    end;

    u3 = u3 + 1;
    local u20 = u3;
    u2.Visible = true;

    if p16 ~= nil then
        local v21 = tonumber(p16) or 0;
        local math_max_ret = math.max(v21, 0);
        task.delay(math_max_ret, function() -- Line: 105
            -- upvalues: u20 (copy), u3 (ref), u2 (ref)
            if u20 ~= u3 then
                return;
            end;

            u2.Visible = false;
        end);
    end;

    return true;
end;

function v1.Show(p22: string, p23: number?) -- Line: 119
    -- upvalues: u2 (ref), showHalftime (copy)
    if u2 then
        return showHalftime(p22, p23);
    end;

    warn("[Halftime] Frame is not initialized");

    return false;
end;

function v1.Hide() -- Line: 128
    -- upvalues: u2 (ref), u3 (ref)
    if not u2 then
        return;
    end;

    u3 = u3 + 1;
    u2.Visible = false;
end;

function v1.Initialize(p24, p25) -- Line: 136
    -- upvalues: u2 (ref), GameState (copy), u3 (ref)
    u2 = p25;
    u2.Visible = false;
    GameState.ListenToState(function(p26, p27) -- Line: 140
        -- upvalues: u3 (ref), u2 (ref)
        if p27 == "Buy Period" or p27 == "Round In Progress" then
            u3 = u3 + 1;
            u2.Visible = false;
        end;
    end);
end;

return v1;