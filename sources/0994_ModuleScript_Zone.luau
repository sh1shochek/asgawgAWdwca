-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local RunService = game:GetService("RunService");
local Heartbeat = RunService.Heartbeat;
local u1 = RunService:IsClient() and Players.LocalPlayer;
game:GetService("ReplicatedStorage");
local HttpService = game:GetService("HttpService");
local enums = require(script.Enum).enums;
local script_Janitor = require(script.Janitor);
local script_Signal = require(script.Signal);
local script_ZonePlusReference = require(script.ZonePlusReference);
local Object = script_ZonePlusReference.getObject();
local script_ZoneController = script.ZoneController;
local Tracker = script_ZoneController.Tracker;
local CollectiveWorldModel = script_ZoneController.CollectiveWorldModel;
local u2 = require(script_ZoneController);
local v3 = game:GetService("RunService"):IsClient() and "Client" or "Server";
local v4;

if Object then
    v4 = Object:FindFirstChild(v3);
else
    v4 = Object;
end;

if v4 then
    return require(Object.Value);
end;

local u5 = {};
u5.__index = u5;

if not v4 then
    script_ZonePlusReference.addToReplicatedStorage();
end;

u5.enum = enums;

function u5.new(p6) -- Line: 34
    -- upvalues: u5 (copy), enums (copy), script_Janitor (copy), HttpService (copy), u2 (copy), script_Signal (copy), u1 (copy)
    local u7 = {};
    setmetatable(u7, u5);
    local v8 = typeof(p6);

    if v8 ~= "table" and v8 ~= "Instance" then
        error("The zone container must be a model, folder, basepart or table!");
    end;

    u7.accuracy = enums.Accuracy.High;
    u7.autoUpdate = true;
    u7.respectUpdateQueue = true;
    local v9 = script_Janitor.new();
    u7.janitor = v9;
    u7._updateConnections = v9:add(script_Janitor.new(), "destroy");
    u7.container = p6;
    u7.zoneParts = {};
    u7.overlapParams = {};
    u7.region = nil;
    u7.volume = nil;
    u7.boundMin = nil;
    u7.boundMax = nil;
    u7.recommendedMaxParts = nil;
    u7.zoneId = HttpService:GenerateGUID();
    u7.activeTriggers = {};
    u7.occupants = {};
    u7.trackingTouchedTriggers = {};
    u7.enterDetection = enums.Detection.Centre;
    u7.exitDetection = enums.Detection.Centre;
    u7._currentEnterDetection = nil;
    u7._currentExitDetection = nil;
    u7.totalPartVolume = 0;
    u7.allZonePartsAreBlocks = true;
    u7.trackedItems = {};
    u7.settingsGroupName = nil;
    u7.worldModel = workspace;
    u7.onItemDetails = {};
    u7.itemsToUntrack = {};
    u2.updateDetection(u7);
    u7.updated = v9:add(script_Signal.new(), "destroy");
    local v10 = { "player", "part", "localPlayer", "item" };
    local v11 = { "entered", "exited" };

    for _, v in pairs(v10) do
        local u12 = v;
        local u13 = 0;
        local u14 = 0;

        for _, v2 in pairs(v11) do
            local v15 = v9:add(script_Signal.new(true), "destroy");
            local u16 = v2:sub(1, 1):upper() .. v2:sub(2);
            u7[u12 .. u16] = v15;
            v15.connectionsChanged:Connect(function(p17) -- Line: 105
                -- upvalues: u12 (copy), u1 (ref), u16 (copy), u13 (ref), u14 (ref), u2 (ref), u7 (copy)
                if u12 == "localPlayer" and (not u1 and p17 == 1) then
                    error(("Can only connect to \'localPlayer%s\' on the client!"):format(u16));
                end;

                u13 = u14;
                u14 = u14 + p17;

                if u13 == 0 and u14 > 0 then
                    u2._registerConnection(u7, u12, u16);

                    return;
                end;

                if u13 > 0 and u14 == 0 then
                    u2._deregisterConnection(u7, u12);
                end;
            end);
        end;
    end;

    u5.touchedConnectionActions = {};

    for _, v in pairs(v10) do
        local u18 = u7[("_%sTouchedZone"):format(v)];

        if u18 then
            u7.trackingTouchedTriggers[v] = {};

            u5.touchedConnectionActions[v] = function(p19) -- Line: 129
                -- upvalues: u18 (copy), u7 (copy)
                u18(u7, p19);
            end;
        end;
    end;

    u7:_update();
    u2._registerZone(u7);
    v9:add(function() -- Line: 140
        -- upvalues: u2 (ref), u7 (copy)
        u2._deregisterZone(u7);
    end, true);

    return u7;
end;

function u5.fromRegion(p20, p21) -- Line: 147
    -- upvalues: u5 (copy)
    local Model = Instance.new("Model");

    local function createCube(p22, p23) -- Line: 150
        -- upvalues: createCube (copy), Model (copy)
        if p23.X <= 2024 and (p23.Y <= 2024 and p23.Z <= 2024) then
            local Part = Instance.new("Part");
            Part.CFrame = p22;
            Part.Size = p23;
            Part.Anchored = true;
            Part.Parent = Model;

            return;
        end;

        local v24 = p23 * 0.25;
        local v25 = p23 * 0.5;
        createCube(p22 * CFrame.new(-v24.X, -v24.Y, -v24.Z), v25);
        createCube(p22 * CFrame.new(-v24.X, -v24.Y, v24.Z), v25);
        createCube(p22 * CFrame.new(-v24.X, v24.Y, -v24.Z), v25);
        createCube(p22 * CFrame.new(-v24.X, v24.Y, v24.Z), v25);
        createCube(p22 * CFrame.new(v24.X, -v24.Y, -v24.Z), v25);
        createCube(p22 * CFrame.new(v24.X, -v24.Y, v24.Z), v25);
        createCube(p22 * CFrame.new(v24.X, v24.Y, -v24.Z), v25);
        createCube(p22 * CFrame.new(v24.X, v24.Y, v24.Z), v25);
    end;

    createCube(p20, p21);
    local v26 = u5.new(Model);
    v26:relocate();

    return v26;
end;

function u5._calculateRegion(p27, p28, p29) -- Line: 179
    local v30 = {
        Min = {},
        Max = {}
    };

    for i, v in pairs(v30) do
        v.Values = {};

        function v.parseCheck(p31, p32) -- Line: 183
            -- upvalues: i (copy)
            if i == "Min" then
                return p31 <= p32;
            end;

            if i == "Max" then
                return p32 <= p31;
            end;
        end;

        function v.parse(p33, p34) -- Line: 190
            for i2, v2 in pairs(p34) do
                if p33.parseCheck(v2, p33.Values[i2] or v2) then
                    p33.Values[i2] = v2;
                end;
            end;
        end;
    end;

    for _, v in pairs(p28) do
        local v35 = v.Size * 0.5;
        local v36 = {
            v.CFrame * CFrame.new(-v35.X, -v35.Y, -v35.Z),
            v.CFrame * CFrame.new(-v35.X, -v35.Y, v35.Z),
            v.CFrame * CFrame.new(-v35.X, v35.Y, -v35.Z),
            v.CFrame * CFrame.new(-v35.X, v35.Y, v35.Z),
            v.CFrame * CFrame.new(v35.X, -v35.Y, -v35.Z),
            v.CFrame * CFrame.new(v35.X, -v35.Y, v35.Z),
            v.CFrame * CFrame.new(v35.X, v35.Y, -v35.Z),
            v.CFrame * CFrame.new(v35.X, v35.Y, v35.Z)
        };

        for _, v2 in pairs(v36) do
            local Components, v37, v38 = v2:GetComponents();
            local v39 = { Components, v37, v38 };
            v30.Min:parse(v39);
            v30.Max:parse(v39);
        end;
    end;

    local function roundToFour(p40) -- Line: 222
        return math.floor((p40 + 2) / 4) * 4;
    end;

    local v41 = {};
    local v42 = {};

    for i, v in pairs(v30) do
        local v43 = i;

        for _, v2 in pairs(v.Values) do
            local v44;

            if p29 then
                v44 = v2;
            else
                v44 = math.floor((v2 + (v43 == "Min" and -2 or 2) + 2) / 4) * 4;
            end;

            table.insert(v43 == "Min" and v42 and v42 or v41, v44);
        end;
    end;

    local Vector3_new_ret = Vector3.new(unpack(v42));
    local Vector3_new_ret2 = Vector3.new(unpack(v41));

    return Region3.new(Vector3_new_ret, Vector3_new_ret2), Vector3_new_ret, Vector3_new_ret2;
end;

function u5._displayBounds(p45) -- Line: 245
    if not p45.displayBoundParts then
        p45.displayBoundParts = true;

        for i, v in pairs({
            BoundMin = p45.boundMin,
            BoundMax = p45.boundMax
        }) do
            local Part = Instance.new("Part");
            Part.Anchored = true;
            Part.CanCollide = false;
            Part.Transparency = 0.5;
            Part.Size = Vector3.new(1, 1, 1);
            Part.Color = Color3.fromRGB(255, 0, 0);
            Part.CFrame = CFrame.new(v);
            Part.Name = i;
            Part.Parent = workspace;
            p45.janitor:add(Part, "Destroy");
        end;
    end;
end;

function u5._update(u46) -- Line: 264
    -- upvalues: RunService (copy)
    local container = u46.container;
    local v47 = {};
    local u48 = 0;
    u46._updateConnections:clean();
    local v49 = typeof(container);
    local v50 = {};

    if v49 == "table" then
        for _, v in pairs(container) do
            if v:IsA("BasePart") then
                table.insert(v47, v);
            end;
        end;
    elseif v49 == "Instance" then
        if container:IsA("BasePart") then
            table.insert(v47, container);
        else
            table.insert(v50, container);

            for _, descendant in pairs(container:GetDescendants()) do
                if descendant:IsA("BasePart") then
                    table.insert(v47, descendant);
                else
                    table.insert(v50, descendant);
                end;
            end;
        end;
    end;

    u46.zoneParts = v47;
    u46.overlapParams = {};
    local v51 = true;

    for _, v in pairs(v47) do
        local _, result = pcall(function() -- Line: 298
            -- upvalues: v (copy)
            return v.Shape.Name;
        end);

        if result ~= "Block" then
            v51 = false;
        end;
    end;

    u46.allZonePartsAreBlocks = v51;
    local OverlapParams_new_ret = OverlapParams.new();
    OverlapParams_new_ret.FilterType = Enum.RaycastFilterType.Include;
    OverlapParams_new_ret.MaxParts = #v47;
    OverlapParams_new_ret.FilterDescendantsInstances = v47;
    u46.overlapParams.zonePartsWhitelist = OverlapParams_new_ret;
    local OverlapParams_new_ret2 = OverlapParams.new();
    OverlapParams_new_ret2.FilterType = Enum.RaycastFilterType.Exclude;
    OverlapParams_new_ret2.FilterDescendantsInstances = v47;
    u46.overlapParams.zonePartsIgnorelist = OverlapParams_new_ret2;

    local function update() -- Line: 318
        -- upvalues: u46 (copy), u48 (ref), RunService (ref)
        if u46.autoUpdate then
            local os_clock_ret = os.clock();

            if u46.respectUpdateQueue then
                u48 = u48 + 1;
                os_clock_ret = os_clock_ret + 0.1;
            end;

            local u52 = nil;
            u52 = RunService.Heartbeat:Connect(function() -- Line: 326
                -- upvalues: os_clock_ret (ref), u52 (ref), u46 (ref), u48 (ref)
                if os_clock_ret <= os.clock() then
                    u52:Disconnect();

                    if u46.respectUpdateQueue then
                        u48 = u48 - 1;
                    end;

                    if u48 == 0 and u46.zoneId then
                        u46:_update();
                    end;
                end;
            end);
        end;
    end;

    local function verifyDefaultCollision(p53) -- Line: 340
        local CollisionGroup = p53.CollisionGroup;

        if CollisionGroup ~= "Default" and CollisionGroup ~= "Debris" then
            error("Zone parts must belong to the \'Default\' or \'Debris\' CollisionGroup.");
        end;
    end;

    local v54 = { "Size", "Position" };

    for _, v in pairs(v47) do
        local u55 = v;

        for _, v2 in pairs(v54) do
            u46._updateConnections:add(u55:GetPropertyChangedSignal(v2):Connect(update), "Disconnect");
        end;

        local CollisionGroup = u55.CollisionGroup;

        if CollisionGroup ~= "Default" and CollisionGroup ~= "Debris" then
            error("Zone parts must belong to the \'Default\' or \'Debris\' CollisionGroup.");
        end;

        u46._updateConnections:add(u55:GetPropertyChangedSignal("CollisionGroupId"):Connect(function() -- Line: 352
            -- upvalues: u55 (copy)
            local CollisionGroup2 = u55.CollisionGroup;

            if CollisionGroup2 ~= "Default" and CollisionGroup2 ~= "Debris" then
                error("Zone parts must belong to the \'Default\' or \'Debris\' CollisionGroup.");
            end;
        end), "Disconnect");
    end;

    local v56 = { "ChildAdded", "ChildRemoved" };

    for _, _ in pairs(v50) do
        for _, v in pairs(v56) do
            u46._updateConnections:add(u46.container[v]:Connect(function(p57) -- Line: 359
                -- upvalues: u46 (copy), u48 (ref), RunService (ref)
                if p57:IsA("BasePart") and u46.autoUpdate then
                    local os_clock_ret = os.clock();

                    if u46.respectUpdateQueue then
                        u48 = u48 + 1;
                        os_clock_ret = os_clock_ret + 0.1;
                    end;

                    local u58 = nil;
                    u58 = RunService.Heartbeat:Connect(function() -- Line: 326
                        -- upvalues: os_clock_ret (ref), u58 (ref), u46 (ref), u48 (ref)
                        if os_clock_ret <= os.clock() then
                            u58:Disconnect();

                            if u46.respectUpdateQueue then
                                u48 = u48 - 1;
                            end;

                            if u48 == 0 and u46.zoneId then
                                u46:_update();
                            end;
                        end;
                    end);
                end;
            end), "Disconnect");
        end;
    end;

    local v59, v60, v61 = u46:_calculateRegion(v47);
    local v62, _, _ = u46:_calculateRegion(v47, true);
    u46.region = v59;
    u46.exactRegion = v62;
    u46.boundMin = v60;
    u46.boundMax = v61;
    local Size = v59.Size;
    u46.volume = Size.X * Size.Y * Size.Z;
    u46:_updateTouchedConnections();
    u46.updated:Fire();
end;

function u5._updateOccupants(p63, p64, p65) -- Line: 395
    local v66 = p63.occupants[p64];

    if not v66 then
        v66 = {};
        p63.occupants[p64] = v66;
    end;

    local v67 = {};

    for i, v in pairs(v66) do
        local v68 = p65[i];

        if v68 == nil or v68 ~= v then
            v66[i] = nil;

            if not v67.exited then
                v67.exited = {};
            end;

            table.insert(v67.exited, i);
        end;
    end;

    for i, _ in pairs(p65) do
        if v66[i] == nil then
            v66[i] = i:IsA("Player") and (i.Character or true) or true;

            if not v67.entered then
                v67.entered = {};
            end;

            table.insert(v67.entered, i);
        end;
    end;

    return v67;
end;

function u5._formTouchedConnection(p69, p70) -- Line: 425
    -- upvalues: script_Janitor (copy)
    local v71 = "_touchedJanitor" .. p70;
    local v72 = p69[v71];

    if v72 then
        v72:clean();
    else
        p69[v71] = p69.janitor:add(script_Janitor.new(), "destroy");
    end;

    p69:_updateTouchedConnection(p70);
end;

function u5._updateTouchedConnection(p73, p74) -- Line: 437
    local v75 = p73["_touchedJanitor" .. p74];

    if not v75 then
        return;
    end;

    for _, v in pairs(p73.zoneParts) do
        v75:add(v.Touched:Connect(p73.touchedConnectionActions[p74], p73), "Disconnect");
    end;
end;

function u5._updateTouchedConnections(p76) -- Line: 446
    for i, _ in pairs(p76.touchedConnectionActions) do
        local v77 = p76["_touchedJanitor" .. i];

        if v77 then
            v77:cleanup();
            p76:_updateTouchedConnection(i);
        end;
    end;
end;

function u5._disconnectTouchedConnection(p78, p79) -- Line: 457
    local v80 = "_touchedJanitor" .. p79;
    local v81 = p78[v80];

    if v81 then
        v81:cleanup();
        p78[v80] = nil;
    end;
end;

local function round(p82, p83) -- Line: 466
    return math.round(p82 * 10 ^ p83) * 10 ^ (-p83);
end;

function u5._partTouchedZone(u84, u85) -- Line: 469
    -- upvalues: script_Janitor (copy), Heartbeat (copy), enums (copy)
    local part = u84.trackingTouchedTriggers.part;

    if part[u85] then
        return;
    end;

    local u86 = 0;
    local u87 = false;
    local Position = u85.Position;
    local os_clock_ret = os.clock();
    local u88 = u84.janitor:add(script_Janitor.new(), "destroy");
    part[u85] = u88;

    if not ({
        Seat = true,
        VehicleSeat = true
    })[u85.ClassName] and ({
        HumanoidRootPart = true
    })[u85.Name] then
        u85.CanTouch = false;
    end;

    local u89 = math.round(u85.Size.X * u85.Size.Y * u85.Size.Z * 100000) * 0.00001;
    u84.totalPartVolume = u84.totalPartVolume + u89;
    u88:add(Heartbeat:Connect(function() -- Line: 487
        -- upvalues: u86 (ref), enums (ref), u84 (copy), u85 (copy), u87 (ref), Position (ref), os_clock_ret (ref), u88 (copy)
        local os_clock_ret2 = os.clock();

        if u86 <= os_clock_ret2 then
            local Property = enums.Accuracy.getProperty(u84.accuracy);
            u86 = os_clock_ret2 + Property;
            local v90 = u84:findPoint(u85.CFrame) or u84:findPart(u85);

            if u87 then
                if not v90 then
                    u87 = false;
                    Position = u85.Position;
                    os_clock_ret = os.clock();
                    u84.partExited:Fire(u85);
                end;
            else
                if v90 then
                    u87 = true;
                    u84.partEntered:Fire(u85);

                    return;
                end;

                if (u85.Position - Position).Magnitude > 1.5 and Property <= os_clock_ret2 - os_clock_ret then
                    u88:cleanup();
                end;
            end;
        end;
    end), "Disconnect");
    u88:add(function() -- Line: 518
        -- upvalues: part (copy), u85 (copy), u84 (copy), u89 (copy)
        part[u85] = nil;
        u85.CanTouch = true;
        u84.totalPartVolume = math.round((u84.totalPartVolume - u89) * 100000) * 0.00001;
    end, true);
end;

local u94 = {
    Ball = function(p91) -- Line: 526
        return "GetPartBoundsInRadius", { p91.Position, p91.Size.X };
    end,

    Block = function(p92) -- Line: 529
        return "GetPartBoundsInBox", { p92.CFrame, p92.Size };
    end,

    Other = function(p93) -- Line: 532
        return "GetPartsInPart", { p93 };
    end
};

function u5._getRegionConstructor(p95, u96, p97) -- Line: 536
    -- upvalues: u94 (copy)
    local success, result = pcall(function() -- Line: 537
        -- upvalues: u96 (copy)
        return u96.Shape.Name;
    end);
    local v98 = nil;
    local v99 = nil;

    if success and p95.allZonePartsAreBlocks then
        local v100 = u94[result];

        if v100 then
            v98, v99 = v100(u96);
        end;
    end;

    if not v98 then
        v99 = { u96 };
        v98 = "GetPartsInPart";
    end;

    if p97 then
        table.insert(v99, p97);
    end;

    return v98, v99;
end;

function u5.findLocalPlayer(p101) -- Line: 557
    -- upvalues: u1 (copy)
    if not u1 then
        error("Can only call \'findLocalPlayer\' on the client!");
    end;

    return p101:findPlayer(u1);
end;

function u5._find(p102, p103, p104) -- Line: 564
    -- upvalues: u2 (copy)
    u2.updateDetection(p102);
    local TouchingZones = u2.getTouchingZones(p104, false, p102._currentEnterDetection, u2.trackers[p103]);

    for _, v in pairs(TouchingZones) do
        if v == p102 then
            return true;
        end;
    end;

    return false;
end;

function u5.findPlayer(p105, p106) -- Line: 576
    local Character = p106.Character;

    if Character then
        Character = Character:FindFirstChild("HumanoidRootPart");
    end;

    if Character then
        return p105:_find("player", p106.Character);
    end;

    return false;
end;

function u5.findItem(p107, p108) -- Line: 585
    return p107:_find("item", p108);
end;

function u5.findPart(p109, p110) -- Line: 589
    local v111, v112 = p109:_getRegionConstructor(p110, p109.overlapParams.zonePartsWhitelist);
    local v113 = p109.worldModel[v111](p109.worldModel, unpack(v112));

    if #v113 > 0 then
        return true, v113;
    end;

    return false;
end;

function u5.getCheckerPart(p114) -- Line: 599
    -- upvalues: u2 (copy)
    local checkerPart = p114.checkerPart;

    if not checkerPart then
        checkerPart = p114.janitor:add(Instance.new("Part"), "Destroy");
        checkerPart.Size = Vector3.new(0.1, 0.1, 0.1);
        checkerPart.Name = "ZonePlusCheckerPart";
        checkerPart.Anchored = true;
        checkerPart.Transparency = 1;
        checkerPart.CanCollide = false;
        p114.checkerPart = checkerPart;
    end;

    local worldModel = p114.worldModel;

    if worldModel == workspace then
        worldModel = u2.getWorkspaceContainer();
    end;

    if checkerPart.Parent ~= worldModel then
        checkerPart.Parent = worldModel;
    end;

    return checkerPart;
end;

function u5.findPoint(p115, p116) -- Line: 620
    if typeof(p116) == "Vector3" then
        p116 = CFrame.new(p116);
    end;

    local CheckerPart = p115:getCheckerPart();
    CheckerPart.CFrame = p116;
    local v117, v118 = p115:_getRegionConstructor(CheckerPart, p115.overlapParams.zonePartsWhitelist);
    local v119 = p115.worldModel[v117](p115.worldModel, unpack(v118));

    if #v119 > 0 then
        return true, v119;
    end;

    return false;
end;

function u5._getAll(p120, p121) -- Line: 637
    -- upvalues: u2 (copy)
    u2.updateDetection(p120);
    local v122 = {};
    local v123 = u2._getZonesAndItems(p121, {
        self = true
    }, p120.volume, false, p120._currentEnterDetection)[p120];

    if v123 then
        for i, _ in pairs(v123) do
            table.insert(v122, i);
        end;
    end;

    return v122;
end;

function u5.getPlayers(p124) -- Line: 650
    return p124:_getAll("player");
end;

function u5.getItems(p125) -- Line: 654
    return p125:_getAll("item");
end;

function u5.getParts(p126) -- Line: 658
    local v127 = {};

    if p126.activeTriggers.part then
        for i, _ in pairs(p126.trackingTouchedTriggers.part) do
            table.insert(v127, i);
        end;

        return v127;
    end;

    local PartBoundsInBox = p126.worldModel:GetPartBoundsInBox(p126.region.CFrame, p126.region.Size, p126.overlapParams.zonePartsIgnorelist);

    for _, v in pairs(PartBoundsInBox) do
        if p126:findPart(v) then
            table.insert(v127, v);
        end;
    end;

    return v127;
end;

function u5.getRandomPoint(p128) -- Line: 679
    local exactRegion = p128.exactRegion;
    local Size = exactRegion.Size;
    local CFrame2 = exactRegion.CFrame;
    local Random_new_ret = Random.new();
    local v129 = nil;
    local v130, v131;

    repeat
        v130 = CFrame2 * CFrame.new(Random_new_ret:NextNumber(-Size.X / 2, Size.X / 2), Random_new_ret:NextNumber(-Size.Y / 2, Size.Y / 2), Random_new_ret:NextNumber(-Size.Z / 2, Size.Z / 2));
        local v132;
        v132, v131 = p128:findPoint(v130);
        v129 = v132 and true or v129;
    until v129;

    return v130.Position, v131;
end;

function u5.setAccuracy(p133, p134) -- Line: 698
    -- upvalues: enums (copy)
    local v135 = tonumber(p134);

    if v135 then
        if not enums.Accuracy.getName(v135) then
            error(("%s is an invalid enumId!"):format(v135));
        end;
    else
        v135 = enums.Accuracy[p134];

        if not v135 then
            error(("\'%s\' is an invalid enumName!"):format(p134));
        end;
    end;

    p133.accuracy = v135;
end;

function u5.setDetection(p136, p137) -- Line: 714
    -- upvalues: enums (copy)
    local v138 = tonumber(p137);

    if v138 then
        if not enums.Detection.getName(v138) then
            error(("%s is an invalid enumId!"):format(v138));
        end;
    else
        v138 = enums.Detection[p137];

        if not v138 then
            error(("\'%s\' is an invalid enumName!"):format(p137));
        end;
    end;

    p136.enterDetection = v138;
    p136.exitDetection = v138;
end;

function u5.trackItem(u139, u140) -- Line: 731
    -- upvalues: script_Janitor (copy), Tracker (copy)
    local v141 = u140:IsA("BasePart");
    local v142;

    if v141 then
        v142 = false;
    else
        v142 = u140:FindFirstChild("HumanoidRootPart") ~= nil;
    end;

    assert(v141 or v142, "Only BaseParts or Characters/NPCs can be tracked!");

    if u139.trackedItems[u140] then
        return;
    end;

    if u139.itemsToUntrack[u140] then
        u139.itemsToUntrack[u140] = nil;
    end;

    local v143 = u139.janitor:add(script_Janitor.new(), "destroy");
    local v144 = {
        janitor = v143,
        item = u140,
        isBasePart = v141,
        isCharacter = v142
    };
    u139.trackedItems[u140] = v144;
    v143:add(u140.AncestryChanged:Connect(function() -- Line: 756
        -- upvalues: u140 (copy), u139 (copy)
        if not u140:IsDescendantOf(game) then
            u139:untrackItem(u140);
        end;
    end), "Disconnect");
    require(Tracker).itemAdded:Fire(v144);
end;

function u5.untrackItem(p145, p146) -- Line: 766
    -- upvalues: Tracker (copy)
    local v147 = p145.trackedItems[p146];

    if v147 then
        v147.janitor:destroy();
    end;

    p145.trackedItems[p146] = nil;
    require(Tracker).itemRemoved:Fire(v147);
end;

function u5.bindToGroup(p148, p149) -- Line: 777
    -- upvalues: u2 (copy)
    p148:unbindFromGroup();
    (u2.getGroup(p149) or u2.setGroup(p149))._memberZones[p148.zoneId] = p148;
    p148.settingsGroupName = p149;
end;

function u5.unbindFromGroup(p150) -- Line: 784
    -- upvalues: u2 (copy)
    if p150.settingsGroupName then
        local Group = u2.getGroup(p150.settingsGroupName);

        if Group then
            Group._memberZones[p150.zoneId] = nil;
        end;

        p150.settingsGroupName = nil;
    end;
end;

function u5.relocate(p151) -- Line: 794
    -- upvalues: CollectiveWorldModel (copy)
    if p151.hasRelocated then
        return;
    end;

    local v152 = require(CollectiveWorldModel).setupWorldModel(p151);
    p151.worldModel = v152;
    p151.hasRelocated = true;
    local container = p151.container;

    if typeof(container) == "table" then
        container = Instance.new("Folder");

        for _, v in pairs(p151.zoneParts) do
            v.Parent = container;
        end;
    end;

    p151.relocationContainer = p151.janitor:add(container, "Destroy", "RelocationContainer");
    container.Parent = v152;
end;

function u5._onItemCallback(u153, p154, p155, u156, u157) -- Line: 815
    local v158 = u153.onItemDetails[u156];

    if not v158 then
        v158 = {};
        u153.onItemDetails[u156] = v158;
    end;

    if #v158 == 0 then
        u153.itemsToUntrack[u156] = true;
    end;

    table.insert(v158, u156);
    u153:trackItem(u156);

    local function triggerCallback() -- Line: 827
        -- upvalues: u157 (copy), u153 (copy), u156 (copy)
        u157();

        if u153.itemsToUntrack[u156] then
            u153.itemsToUntrack[u156] = nil;
            u153:untrackItem(u156);
        end;
    end;

    if u153:findItem(u156) == p155 then
        u157();

        if u153.itemsToUntrack[u156] then
            u153.itemsToUntrack[u156] = nil;
            u153:untrackItem(u156);
        end;
    else
        local u159 = nil;
        u159 = u153[p154]:Connect(function(p160) -- Line: 840
            -- upvalues: u159 (ref), u156 (copy), u157 (copy), u153 (copy)
            if u159 and p160 == u156 then
                u159:Disconnect();
                u159 = nil;
                u157();

                if u153.itemsToUntrack[u156] then
                    u153.itemsToUntrack[u156] = nil;
                    u153:untrackItem(u156);
                end;
            end;
        end);
    end;
end;

function u5.onItemEnter(p161, ...) -- Line: 862
    p161:_onItemCallback("itemEntered", true, ...);
end;

function u5.onItemExit(p162, ...) -- Line: 866
    p162:_onItemCallback("itemExited", false, ...);
end;

function u5.destroy(p163) -- Line: 870
    p163:unbindFromGroup();
    p163.janitor:destroy();
end;

u5.Destroy = u5.destroy;

return u5;