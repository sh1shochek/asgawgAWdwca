-- Decompiled with Potassium's decompiler.

local u1 = {};
local StarterGui = game:GetService("StarterGui");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local RunService = game:GetService("RunService");
local Players = game:GetService("Players");
u1.MIN_SIZE = 0.04;
u1.MAX_SIZE = 0.4;
u1.MIN_POSITION = -2;
u1.MAX_POSITION = 2;
u1.DEFAULT_TRANSPARENCY = 0;
u1.MAX_TRANSPARENCY = 0.65;
u1.DEFAULT_ENABLED = true;
local u2 = { "Gameplay", "Middle", "MobileButtons" };
local u3 = {
    Position = {
        X = 0.5,
        Y = 0.5
    },
    Size = {
        X = 0.1,
        Y = 0.1
    },
    Transparency = u1.DEFAULT_TRANSPARENCY,
    Enabled = u1.DEFAULT_ENABLED
};
local u4 = nil;
local u5 = nil;

local function IsFiniteNumber(p6) -- Line: 58
    local v7;

    if typeof(p6) == "number" and (p6 == p6 and p6 ~= (1 / 0)) then
        v7 = p6 ~= (-1 / 0);
    else
        v7 = false;
    end;

    return v7;
end;

local function CopyButtonLayout(p8: table) -- Line: 64
    return {
        Position = {
            X = p8.Position.X,
            Y = p8.Position.Y
        },
        Size = {
            X = p8.Size.X,
            Y = p8.Size.Y
        },
        Transparency = p8.Transparency,
        Enabled = p8.Enabled
    };
end;

local function FindAuthoredMainGui() -- Line: 75
    -- upvalues: StarterGui (copy), RunService (copy), Players (copy), ReplicatedStorage (copy)
    local MainGui = StarterGui:FindFirstChild("MainGui");

    if MainGui then
        return MainGui;
    end;

    if RunService:IsClient() then
        local PlayerGui = Players.LocalPlayer:WaitForChild("PlayerGui", 10);

        if PlayerGui then
            PlayerGui = PlayerGui:WaitForChild("MainGui", 10);
        end;

        if PlayerGui then
            task.wait();
        end;

        return PlayerGui;
    end;

    local Assets = ReplicatedStorage:WaitForChild("Assets", 10);

    if Assets then
        Assets = Assets:WaitForChild("UI", 10);
    end;

    if Assets then
        Assets = Assets:WaitForChild("MainGui", 10);
    end;

    return Assets;
end;

local function FindButtonsFrameUnder(p9: userdata?) -- Line: 100
    -- upvalues: u2 (copy)
    for _, v in ipairs(u2) do
        if not p9 then
            return nil;
        end;

        p9 = p9:FindFirstChild(v);
    end;

    return p9;
end;

local function FindHostedButtonsFrame() -- Line: 112
    -- upvalues: RunService (copy), Players (copy)
    if not RunService:IsClient() then
        return nil;
    end;

    local v10 = Players.LocalPlayer:FindFirstChildOfClass("PlayerGui");

    if v10 then
        v10 = v10:FindFirstChild("MobileControlsGui");
    end;

    if v10 then
        v10 = v10:FindFirstChild("MobileButtons");
    end;

    return v10;
end;

local function FindAuthoredButtonsFrame(p11: userdata?) -- Line: 121
    -- upvalues: FindAuthoredMainGui (copy), RunService (copy), Players (copy), FindButtonsFrameUnder (copy)
    local v12 = p11 or FindAuthoredMainGui();
    local v13 = os.clock() + 10;

    while true do
        local v14;

        if RunService:IsClient() then
            v14 = Players.LocalPlayer:FindFirstChildOfClass("PlayerGui");

            if v14 then
                v14 = v14:FindFirstChild("MobileControlsGui");
            end;

            if v14 then
                v14 = v14:FindFirstChild("MobileButtons");
            end;
        else
            v14 = nil;
        end;

        local v15 = v14 or FindButtonsFrameUnder(v12);

        if v15 then
            return v15;
        end;

        if v13 <= os.clock() then
            return nil;
        end;

        task.wait(0.1);
    end;
end;

local function IsConfigurableButton(p16: userdata) -- Line: 139
    return p16:IsA("TextButton");
end;

local function BuildDefaultLayout(p17: userdata?) -- Line: 144
    -- upvalues: FindAuthoredButtonsFrame (copy), u1 (copy)
    local v18 = {};
    local v19 = {};
    local v20 = FindAuthoredButtonsFrame(p17);

    if v20 then
        for _, child in ipairs(v20:GetChildren()) do
            if child:IsA("TextButton") and child:IsA("GuiObject") then
                v18[child.Name] = {
                    Position = {
                        X = child.Position.X.Scale,
                        Y = child.Position.Y.Scale
                    },
                    Size = {
                        X = child.Size.X.Scale,
                        Y = child.Size.Y.Scale
                    },
                    Transparency = u1.DEFAULT_TRANSPARENCY,
                    Enabled = u1.DEFAULT_ENABLED
                };
                table.insert(v19, child.Name);
            end;
        end;
    else
        warn("[MobileHUD] Authored MobileButtons frame not found; defaults are empty");
    end;

    table.sort(v19);

    return v18, v19;
end;

local function EnsureDefaults() -- Line: 171
    -- upvalues: u4 (ref), u5 (ref), BuildDefaultLayout (copy)
    if u4 and u5 then
        return u4, u5;
    end;

    local v21, v22 = BuildDefaultLayout();

    if #v22 > 0 then
        u4 = v21;
        u5 = v22;
    end;

    return v21, v22;
end;

local function HasValidPositionAndSize(p23) -- Line: 185
    if typeof(p23) ~= "table" then
        return false;
    end;

    local Position = p23.Position;
    local Size = p23.Size;

    if typeof(Position) ~= "table" or typeof(Size) ~= "table" then
        return false;
    end;

    local X = Position.X;
    local v24;

    if typeof(X) == "number" and (X == X and X ~= (1 / 0)) then
        v24 = X ~= (-1 / 0);
    else
        v24 = false;
    end;

    if v24 then
        local Y = Position.Y;

        if typeof(Y) == "number" and (Y == Y and Y ~= (1 / 0)) then
            v24 = Y ~= (-1 / 0);
        else
            v24 = false;
        end;

        if v24 then
            local X2 = Size.X;

            if typeof(X2) == "number" and (X2 == X2 and X2 ~= (1 / 0)) then
                v24 = X2 ~= (-1 / 0);
            else
                v24 = false;
            end;

            if v24 then
                local Y2 = Size.Y;

                if typeof(Y2) == "number" and (Y2 == Y2 and Y2 ~= (1 / 0)) then
                    v24 = Y2 ~= (-1 / 0);
                else
                    v24 = false;
                end;
            end;
        end;
    end;

    return v24;
end;

function u1.CaptureDefaults(p25: userdata) -- Line: 204
    -- upvalues: BuildDefaultLayout (copy), u4 (ref), u5 (ref)
    local v26, v27 = BuildDefaultLayout(p25);

    if #v27 > 0 then
        u4 = v26;
        u5 = v27;
    end;
end;

function u1.GetButtonNames() -- Line: 212
    -- upvalues: u4 (ref), u5 (ref), BuildDefaultLayout (copy)
    local v28;

    if u4 and u5 then
        v28 = u5;
    else
        local v29;
        v29, v28 = BuildDefaultLayout();

        if #v28 > 0 then
            u4 = v29;
            u5 = v28;
        end;
    end;

    return table.clone(v28);
end;

function u1.GetDefaultLayout() -- Line: 219
    -- upvalues: u4 (ref), u5 (ref), BuildDefaultLayout (copy), CopyButtonLayout (copy)
    local v30;

    if u4 and u5 then
        v30 = u4;
    else
        local v31;
        v30, v31 = BuildDefaultLayout();

        if #v31 > 0 then
            u4 = v30;
            u5 = v31;
        end;
    end;

    local v32 = {};

    for i, v in pairs(v30) do
        v32[i] = CopyButtonLayout(v);
    end;

    return v32;
end;

function u1.GetDefaultButtonLayout(p33: string) -- Line: 230
    -- upvalues: u4 (ref), u5 (ref), BuildDefaultLayout (copy), CopyButtonLayout (copy), u3 (copy)
    local v34;

    if u4 and u5 then
        v34 = u4;
    else
        local v35;
        v34, v35 = BuildDefaultLayout();

        if #v35 > 0 then
            u4 = v34;
            u5 = v35;
        end;
    end;

    local v36 = v34[p33];

    if v36 then
        return CopyButtonLayout(v36);
    end;

    return CopyButtonLayout(u3);
end;

function u1.IsKnownButton(p37: string) -- Line: 241
    -- upvalues: u4 (ref), u5 (ref), BuildDefaultLayout (copy)
    local v38;

    if u4 and u5 then
        v38 = u4;
    else
        local v39;
        v38, v39 = BuildDefaultLayout();

        if #v39 > 0 then
            u4 = v38;
            u5 = v39;
        end;
    end;

    return v38[p37] ~= nil;
end;

function u1.ClampButtonLayout(p40: table) -- Line: 248
    -- upvalues: u1 (copy)
    return {
        Position = {
            X = math.clamp(p40.Position.X, u1.MIN_POSITION, u1.MAX_POSITION),
            Y = math.clamp(p40.Position.Y, u1.MIN_POSITION, u1.MAX_POSITION)
        },
        Size = {
            X = math.clamp(p40.Size.X, u1.MIN_SIZE, u1.MAX_SIZE),
            Y = math.clamp(p40.Size.Y, u1.MIN_SIZE, u1.MAX_SIZE)
        },
        Transparency = math.clamp(p40.Transparency, 0, u1.MAX_TRANSPARENCY),
        Enabled = p40.Enabled == true
    };
end;

function u1.SanitizeLayout(p41) -- Line: 266
    -- upvalues: u1 (copy), HasValidPositionAndSize (copy)
    local DefaultLayout = u1.GetDefaultLayout();

    if typeof(p41) ~= "table" then
        return DefaultLayout;
    end;

    for i, v in pairs(DefaultLayout) do
        local v42 = p41[i];

        if HasValidPositionAndSize(v42) then
            local ClampButtonLayout = u1.ClampButtonLayout;
            local v43 = {
                Position = {
                    X = v42.Position.X,
                    Y = v42.Position.Y
                },
                Size = {
                    X = v42.Size.X,
                    Y = v42.Size.Y
                }
            };
            local Transparency = v42.Transparency;
            local v44;

            if typeof(Transparency) == "number" and (Transparency == Transparency and Transparency ~= (1 / 0)) then
                v44 = Transparency ~= (-1 / 0);
            else
                v44 = false;
            end;

            local v45;

            if v44 then
                v45 = v42.Transparency;
            else
                v45 = v.Transparency;
            end;

            v43.Transparency = v45;
            local v46;

            if typeof(v42.Enabled) == "boolean" then
                v46 = v42.Enabled;
            else
                v46 = v.Enabled;
            end;

            v43.Enabled = v46;
            DefaultLayout[i] = ClampButtonLayout(v43);
        end;
    end;

    return DefaultLayout;
end;

function u1.AreButtonLayoutsEqual(p47: table, p48: table) -- Line: 291
    local v49;

    if p47.Position.X == p48.Position.X and (p47.Position.Y == p48.Position.Y and (p47.Size.X == p48.Size.X and (p47.Size.Y == p48.Size.Y and p47.Transparency == p48.Transparency))) then
        v49 = p47.Enabled == p48.Enabled;
    else
        v49 = false;
    end;

    return v49;
end;

function u1.AreLayoutsEqual(p50: table, p51: table) -- Line: 302
    -- upvalues: u1 (copy)
    for _, v in ipairs(u1.GetButtonNames()) do
        local v52 = p50[v] or u1.GetDefaultButtonLayout(v);
        local v53 = p51[v] or u1.GetDefaultButtonLayout(v);

        if not u1.AreButtonLayoutsEqual(v52, v53) then
            return false;
        end;
    end;

    return true;
end;

return u1;