-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Workspace = game:GetService("Workspace");
local CharacterResolver = require(script.Parent.CharacterResolver);
local u1 = {};

local function botFolder() -- Line: 13
    -- upvalues: ReplicatedStorage (copy)
    return ReplicatedStorage:FindFirstChild("Combatants");
end;

function u1.IsBot(p2: userdata?) -- Line: 17
    local v3;

    if p2 == nil then
        v3 = false;
    else
        v3 = not p2:IsA("Player");
    end;

    return v3;
end;

function u1.BotKey(p4: number) -- Line: 22
    return -(p4 + 1000);
end;

function u1.Key(p5: userdata) -- Line: 26
    if p5:IsA("Player") then
        return p5.UserId;
    end;

    return p5:GetAttribute("UserId");
end;

function u1.FromKey(p6) -- Line: 33
    -- upvalues: Players (copy), ReplicatedStorage (copy)
    local v7 = tonumber(p6);

    if v7 == nil or v7 == 0 then
        return nil;
    end;

    if v7 > -1000 then
        return Players:GetPlayerByUserId(v7);
    end;

    local Combatants = ReplicatedStorage:FindFirstChild("Combatants");

    if Combatants then
        return Combatants:FindFirstChild((tostring(-v7 - 1000)));
    end;

    return nil;
end;

function u1.Name(p8: userdata) -- Line: 45
    if p8:IsA("Player") then
        return p8.Name;
    end;

    local Attribute = p8:GetAttribute("DisplayName");

    if type(Attribute) == "string" then
        return Attribute;
    end;

    return p8.Name;
end;

function u1.DisplayName(p9: userdata) -- Line: 53
    -- upvalues: u1 (copy)
    if p9:IsA("Player") then
        return p9.DisplayName;
    end;

    return u1.Name(p9);
end;

function u1.AvatarUserId(p10: userdata) -- Line: 61
    if p10:IsA("Player") then
        return p10.UserId;
    end;

    local Attribute = p10:GetAttribute("AvatarUserId");

    return type(Attribute) ~= "number" and 1 or Attribute;
end;

function u1.HeadshotImage(p11: userdata, p12: number?) -- Line: 69
    -- upvalues: u1 (copy)
    local v13 = p12 or 150;

    return `rbxthumb://type=AvatarHeadShot&id={u1.AvatarUserId(p11)}&w={v13}&h={v13}`;
end;

function u1.IsAlive(p14: userdata?) -- Line: 74
    -- upvalues: CharacterResolver (copy)
    if p14 == nil then
        return false;
    end;

    if p14:IsA("Player") then
        return CharacterResolver.isAlivePlayer(p14);
    end;

    local Attribute = p14:GetAttribute("Health");
    local v15;

    if p14:GetAttribute("Dead") == true then
        v15 = false;
    else
        v15 = type(Attribute) ~= "number" and true or Attribute > 0;
    end;

    return v15;
end;

function u1.FromName(p16: string) -- Line: 85
    -- upvalues: Players (copy), ReplicatedStorage (copy)
    local v17 = Players:FindFirstChild(p16);

    if v17 and v17:IsA("Player") then
        return v17;
    end;

    local Combatants = ReplicatedStorage:FindFirstChild("Combatants");

    if Combatants then
        for _, child in Combatants:GetChildren() do
            if child:GetAttribute("DisplayName") == p16 then
                return child;
            end;
        end;
    end;

    return nil;
end;

function u1.GetAll() -- Line: 101
    -- upvalues: Players (copy), ReplicatedStorage (copy)
    local v18 = {};

    for _, v in Players:GetPlayers() do
        v18[#v18 + 1] = v;
    end;

    local Combatants = ReplicatedStorage:FindFirstChild("Combatants");

    if Combatants then
        for _, child in Combatants:GetChildren() do
            if child:IsA("Folder") then
                v18[#v18 + 1] = child;
            end;
        end;
    end;

    return v18;
end;

local u19 = {};
local u20 = nil;
local u21 = true;
local u22 = {};

local function markIndexDirty() -- Line: 123
    -- upvalues: u21 (ref)
    u21 = true;
end;

local function shellIndex(p23: userdata) -- Line: 127
    -- upvalues: u20 (ref), u22 (ref), markIndexDirty (copy), u21 (ref), u19 (copy)
    if p23 ~= u20 then
        for _, v in u22 do
            v:Disconnect();
        end;

        u22 = { p23.ChildAdded:Connect(markIndexDirty), p23.ChildRemoved:Connect(markIndexDirty) };
        u20 = p23;
        u21 = true;
    end;

    if u21 then
        u21 = false;
        table.clear(u19);

        for _, child in p23:GetChildren() do
            if child:IsA("Model") and child:GetAttribute("Bot") == true then
                local Attribute = child:GetAttribute("CombatantId");

                if Attribute ~= nil and u19[Attribute] == nil then
                    u19[Attribute] = child;
                end;
            end;
        end;
    end;

    return u19;
end;

function u1.Character(p24: userdata?) -- Line: 155
    -- upvalues: Workspace (copy), shellIndex (copy), u21 (ref)
    if p24 == nil then
        return nil;
    end;

    if p24:IsA("Player") then
        return p24.Character;
    end;

    local Attribute = p24:GetAttribute("CombatantId");
    local Characters = Workspace:FindFirstChild("Characters");

    if not Characters or Attribute == nil then
        return nil;
    end;

    local v25 = shellIndex(Characters)[Attribute];

    if v25 ~= nil and v25.Parent ~= Characters then
        u21 = true;
        v25 = shellIndex(Characters)[Attribute];
    end;

    return v25;
end;

function u1.Observe(u26: function, u27: function?) -- Line: 176
    -- upvalues: Players (copy), ReplicatedStorage (copy)
    local u28 = {};
    local u29 = {};

    local function add(p30: userdata) -- Line: 179
        -- upvalues: u26 (copy)
        if p30:IsA("Player") or p30:IsA("Folder") then
            task.spawn(u26, p30);
        end;
    end;

    local function remove(p31: userdata) -- Line: 184
        -- upvalues: u27 (copy)
        if u27 and (p31:IsA("Player") or p31:IsA("Folder")) then
            task.spawn(u27, p31);
        end;
    end;

    local function bindFolder(p32: userdata) -- Line: 189
        -- upvalues: u29 (copy), add (copy), remove (copy), u26 (copy)
        for _, v in u29 do
            v:Disconnect();
        end;

        table.clear(u29);
        u29[#u29 + 1] = p32.ChildAdded:Connect(add);
        u29[#u29 + 1] = p32.ChildRemoved:Connect(remove);

        for _, child in p32:GetChildren() do
            if child:IsA("Player") or child:IsA("Folder") then
                task.spawn(u26, child);
            end;
        end;
    end;

    u28[#u28 + 1] = Players.PlayerAdded:Connect(add);
    u28[#u28 + 1] = Players.PlayerRemoving:Connect(remove);
    u28[#u28 + 1] = ReplicatedStorage.ChildAdded:Connect(function(p33) -- Line: 202
        -- upvalues: bindFolder (copy)
        if p33.Name == "Combatants" then
            bindFolder(p33);
        end;
    end);

    for _, v in Players:GetPlayers() do
        if v:IsA("Player") or v:IsA("Folder") then
            task.spawn(u26, v);
        end;
    end;

    local Combatants = ReplicatedStorage:FindFirstChild("Combatants");

    if Combatants then
        bindFolder(Combatants);
    end;

    return function() -- Line: 214
        -- upvalues: u28 (copy), u29 (copy)
        for _, v in u28 do
            v:Disconnect();
        end;

        for _, v in u29 do
            v:Disconnect();
        end;
    end;
end;

return table.freeze(u1);