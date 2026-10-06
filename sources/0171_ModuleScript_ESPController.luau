-- Decompiled with Potassium's decompiler.

local v1 = {};
local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Workspace = game:GetService("Workspace");
local LocalPlayer = Players.LocalPlayer;
local Participants = require(ReplicatedStorage.Components.Common.Participants);
local Color3_fromRGB_ret = Color3.fromRGB(255, 70, 70);
local Color3_fromRGB_ret2 = Color3.fromRGB(255, 255, 255);
local u2 = {};
local u3 = nil;
local u4 = false;

local function isEnemy(p5: userdata) -- Line: 30
    -- upvalues: LocalPlayer (copy), Participants (copy), Workspace (copy)
    if p5 == LocalPlayer or not Participants.IsAlive(p5) then
        return false;
    end;

    if Workspace:GetAttribute("Gamemode") == "Deathmatch" then
        return true;
    end;

    local Attribute = p5:GetAttribute("Team");
    local v6;

    if Attribute == "Terrorists" or Attribute == "Counter-Terrorists" then
        v6 = Attribute ~= LocalPlayer:GetAttribute("Team");
    else
        v6 = false;
    end;

    return v6;
end;

local function getContainer() -- Line: 41
    -- upvalues: u3 (ref), Workspace (copy)
    if u3 and u3.Parent then
        return u3;
    end;

    local Folder = Instance.new("Folder");
    Folder.Name = "VIPESP";
    Folder.Parent = Workspace.CurrentCamera;
    u3 = Folder;

    return Folder;
end;

local function clear() -- Line: 52
    -- upvalues: u2 (copy)
    for _, v in u2 do
        v:Destroy();
    end;

    table.clear(u2);
end;

local function refresh() -- Line: 59
    -- upvalues: Participants (copy), isEnemy (copy), Workspace (copy), u2 (copy), Color3_fromRGB_ret (copy), Color3_fromRGB_ret2 (copy), u3 (ref)
    local v7 = {};

    for _, v in Participants.GetAll() do
        if isEnemy(v) then
            local v8 = Participants.Character(v);

            if v8 and v8:IsDescendantOf(Workspace) then
                v7[v8] = true;
            end;
        end;
    end;

    for i, v in u2 do
        if not v7[i] then
            v:Destroy();
            u2[i] = nil;
        end;
    end;

    for i in v7 do
        if u2[i] == nil then
            local Highlight = Instance.new("Highlight");
            Highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop;
            Highlight.FillColor = Color3_fromRGB_ret;
            Highlight.FillTransparency = 0.55;
            Highlight.OutlineColor = Color3_fromRGB_ret2;
            Highlight.OutlineTransparency = 0;
            Highlight.Adornee = i;
            local v9;

            if u3 and u3.Parent then
                v9 = u3;
            else
                v9 = Instance.new("Folder");
                v9.Name = "VIPESP";
                v9.Parent = Workspace.CurrentCamera;
                u3 = v9;
            end;

            Highlight.Parent = v9;
            u2[i] = Highlight;
        end;
    end;
end;

local function run() -- Line: 90
    -- upvalues: u4 (ref), LocalPlayer (copy), refresh (copy), u2 (copy)
    if u4 then
        return;
    end;

    u4 = true;
    task.spawn(function() -- Line: 95
        -- upvalues: LocalPlayer (ref), refresh (ref), u2 (ref), u4 (ref)
        while LocalPlayer:GetAttribute("VIPESP") == true do
            refresh();
            task.wait(0.25);
        end;

        for _, v in u2 do
            v:Destroy();
        end;

        table.clear(u2);
        u4 = false;
    end);
end;

function v1.Start() -- Line: 108
    -- upvalues: LocalPlayer (copy), u4 (ref), refresh (copy), u2 (copy)
    LocalPlayer:GetAttributeChangedSignal("VIPESP"):Connect(function() -- Line: 109
        -- upvalues: LocalPlayer (ref), u4 (ref), refresh (ref), u2 (ref)
        if LocalPlayer:GetAttribute("VIPESP") == true then
            if u4 then
                return;
            end;

            u4 = true;
            task.spawn(function() -- Line: 95
                -- upvalues: LocalPlayer (ref), refresh (ref), u2 (ref), u4 (ref)
                while LocalPlayer:GetAttribute("VIPESP") == true do
                    refresh();
                    task.wait(0.25);
                end;

                for _, v in u2 do
                    v:Destroy();
                end;

                table.clear(u2);
                u4 = false;
            end);
        end;
    end);

    if LocalPlayer:GetAttribute("VIPESP") == true then
        if u4 then
            return;
        end;

        u4 = true;
        task.spawn(function() -- Line: 95
            -- upvalues: LocalPlayer (ref), refresh (ref), u2 (ref), u4 (ref)
            while LocalPlayer:GetAttribute("VIPESP") == true do
                refresh();
                task.wait(0.25);
            end;

            for _, v in u2 do
                v:Destroy();
            end;

            table.clear(u2);
            u4 = false;
        end);
    end;
end;

return v1;