-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local _ = game:GetService("RunService").Heartbeat;
local Signal = require(script.Parent.Parent.Signal);
local Janitor = require(script.Parent.Parent.Janitor);
local u1 = {};
u1.__index = u1;
local u2 = {};
u1.trackers = u2;
u1.itemAdded = Signal.new();
u1.itemRemoved = Signal.new();
u1.bodyPartsToIgnore = {
    UpperTorso = true,
    LowerTorso = true,
    Torso = true,
    LeftHand = true,
    RightHand = true,
    LeftFoot = true,
    RightFoot = true
};

function u1.getCombinedTotalVolumes() -- Line: 35
    -- upvalues: u2 (copy)
    local v3 = 0;

    for i, _ in pairs(u2) do
        v3 = v3 + i.totalVolume;
    end;

    return v3;
end;

function u1.getCharacterSize(p4) -- Line: 43
    local v5;

    if p4 then
        v5 = p4:FindFirstChild("Head");
    else
        v5 = p4;
    end;

    if p4 then
        p4 = p4:FindFirstChild("HumanoidRootPart");
    end;

    if not (p4 and v5) then
        return nil;
    end;

    if not v5:IsA("BasePart") then
        v5 = p4;
    end;

    local Y = v5.Size.Y;
    local Size = p4.Size;

    return Size * Vector3.new(2, 2, 1) + Vector3.new(0, Y, 0), p4.CFrame * CFrame.new(0, Y / 2 - Size.Y / 2, 0);
end;

function u1.new(p6) -- Line: 60
    -- upvalues: u1 (copy), Janitor (copy), Players (copy), u2 (copy)
    local u7 = {};
    setmetatable(u7, u1);
    u7.name = p6;
    u7.totalVolume = 0;
    u7.parts = {};
    u7.partToItem = {};
    u7.items = {};
    u7.whitelistParams = nil;
    u7.characters = {};
    u7.baseParts = {};
    u7.exitDetections = {};
    u7.janitor = Janitor.new();

    if p6 == "player" then
        local function updatePlayerCharacters() -- Line: 76
            -- upvalues: Players (ref), u7 (copy)
            local v8 = {};

            for _, v in pairs(Players:GetPlayers()) do
                local Character = v.Character;

                if Character then
                    v8[Character] = true;
                end;
            end;

            u7.characters = v8;
        end;

        local function playerAdded(p9) -- Line: 87
            -- upvalues: updatePlayerCharacters (copy), u7 (copy)
            local function charAdded(p10) -- Line: 88
                -- upvalues: updatePlayerCharacters (ref), u7 (ref)
                local HumanoidRootPart = p10:FindFirstChild("HumanoidRootPart");

                if not HumanoidRootPart then
                    local v11 = tick();

                    repeat
                        task.wait(0.1);
                        HumanoidRootPart = p10:FindFirstChild("HumanoidRootPart");
                    until HumanoidRootPart or tick() - v11 > 3;
                end;

                if HumanoidRootPart then
                    updatePlayerCharacters();
                    u7:update();
                end;
            end;

            if p9.Character then
                charAdded(p9.Character);
            end;

            p9.CharacterAdded:Connect(charAdded);
            p9.CharacterRemoving:Connect(function(p12) -- Line: 107
                -- upvalues: u7 (ref)
                u7.exitDetections[p12] = nil;
            end);
        end;

        Players.PlayerAdded:Connect(playerAdded);

        for _, v in pairs(Players:GetPlayers()) do
            playerAdded(v);
        end;

        Players.PlayerRemoving:Connect(function(p13) -- Line: 117
            -- upvalues: updatePlayerCharacters (copy), u7 (copy)
            updatePlayerCharacters();
            u7:update();
        end);
    elseif p6 == "item" then
        local function updateItem(p14, p15) -- Line: 124
            -- upvalues: u7 (copy)
            if p14.isCharacter then
                u7.characters[p14.item] = p15;
            elseif p14.isBasePart then
                u7.baseParts[p14.item] = p15;
            end;

            u7:update();
        end;

        u1.itemAdded:Connect(function(p16) -- Line: 132
            -- upvalues: u7 (copy)
            if p16.isCharacter then
                u7.characters[p16.item] = true;
            elseif p16.isBasePart then
                u7.baseParts[p16.item] = true;
            end;

            u7:update();
        end);
        u1.itemRemoved:Connect(function(p17) -- Line: 135
            -- upvalues: u7 (copy)
            u7.exitDetections[p17.item] = nil;

            if p17.isCharacter then
                u7.characters[p17.item] = nil;
            elseif p17.isBasePart then
                u7.baseParts[p17.item] = nil;
            end;

            u7:update();
        end);
    end;

    u2[u7] = true;
    task.defer(u7.update, u7);

    return u7;
end;

function u1._preventMultiFrameUpdates(u18, u19, ...) -- Line: 149
    u18._preventMultiDetails = u18._preventMultiDetails or {};
    local u20 = u18._preventMultiDetails[u19];

    if not u20 then
        u20 = {
            calling = false,
            callsThisFrame = 0,
            updatedThisFrame = false
        };
        u18._preventMultiDetails[u19] = u20;
    end;

    u20.callsThisFrame = u20.callsThisFrame + 1;

    if u20.callsThisFrame ~= 1 then
        return true;
    end;

    local table_pack_ret = table.pack(...);
    task.defer(function() -- Line: 166
        -- upvalues: u20 (ref), u18 (copy), u19 (copy), table_pack_ret (copy)
        local callsThisFrame = u20.callsThisFrame;
        u20.callsThisFrame = 0;

        if callsThisFrame > 1 then
            u18[u19](u18, unpack(table_pack_ret));
        end;
    end);

    return false;
end;

function u1.update(u21) -- Line: 178
    -- upvalues: u1 (copy), Janitor (copy)
    if u21:_preventMultiFrameUpdates("update") then
        return;
    end;

    u21.totalVolume = 0;
    u21.parts = {};
    u21.partToItem = {};
    u21.items = {};

    for i, _ in pairs(u21.characters) do
        local CharacterSize = u1.getCharacterSize(i);

        if CharacterSize then
            u21.totalVolume = u21.totalVolume + CharacterSize.X * CharacterSize.Y * CharacterSize.Z;
            local u22 = u21.janitor:add(Janitor.new(), "destroy", "trackCharacterParts-" .. u21.name);

            local function updateTrackerOnParentChanged(u23) -- Line: 199
                -- upvalues: u22 (ref), u21 (copy)
                u22:add(u23.AncestryChanged:Connect(function() -- Line: 200
                    -- upvalues: u23 (copy), u22 (ref), u21 (ref)
                    if not (u23:IsDescendantOf(game) or (u23.Parent ~= nil or u22 == nil)) then
                        u22:destroy();
                        u22 = nil;
                        u21:update();
                    end;
                end), "Disconnect");
            end;

            local u24 = i;

            for _, child in pairs(i:GetChildren()) do
                if child:IsA("BasePart") and not u1.bodyPartsToIgnore[child.Name] then
                    u21.partToItem[child] = u24;
                    table.insert(u21.parts, child);
                    u22:add(child.AncestryChanged:Connect(function() -- Line: 200
                        -- upvalues: child (copy), u22 (ref), u21 (copy)
                        if not (child:IsDescendantOf(game) or (child.Parent ~= nil or u22 == nil)) then
                            u22:destroy();
                            u22 = nil;
                            u21:update();
                        end;
                    end), "Disconnect");
                end;
            end;

            u22:add(u24.AncestryChanged:Connect(function() -- Line: 200
                -- upvalues: u24 (copy), u22 (ref), u21 (copy)
                if not (u24:IsDescendantOf(game) or (u24.Parent ~= nil or u22 == nil)) then
                    u22:destroy();
                    u22 = nil;
                    u21:update();
                end;
            end), "Disconnect");
            table.insert(u21.items, u24);
        end;
    end;

    for i, _ in pairs(u21.baseParts) do
        local Size = i.Size;
        u21.totalVolume = u21.totalVolume + Size.X * Size.Y * Size.Z;
        u21.partToItem[i] = i;
        table.insert(u21.parts, i);
        table.insert(u21.items, i);
    end;

    u21.whitelistParams = OverlapParams.new();
    u21.whitelistParams.FilterType = Enum.RaycastFilterType.Whitelist;
    u21.whitelistParams.MaxParts = #u21.parts;
    u21.whitelistParams.FilterDescendantsInstances = u21.parts;
end;

return u1;