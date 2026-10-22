-- ReplicatedStorage.ClientModules.DebugVisualizers
-- Script path: ReplicatedStorage.ClientModules.DebugVisualizers
-- Decompile time: 13.39 ms

-- Decompiled with Potassium's decompiler.

local u1 = {};
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Players = game:GetService("Players");
local Workspace = game:GetService("Workspace");
local LocalPlayer = Players.LocalPlayer;
local Enums = require(ReplicatedStorage.Shared.Utility.Enums);
local CollisionState = require(ReplicatedStorage.Shared.CollisionModule.CollisionState);
local CharacterModel = require(ReplicatedStorage.Shared.CharacterModel);
local u2 = nil;
local u3 = nil;
local u4 = nil;
local u5 = nil;
local u6 = false;
local u7 = false;
local u8 = false;
local u9 = nil;
local u10 = {
    ClipTransparency = 0.7,
    ZoneTransparency = 0.7,
    SpawnTransparency = 0.5,
    ImpactTransparency = 0.35,
    ImpactTime = 4,
    LagCompTransparency = 0.75,
    LagCompHitTransparency = 0.35,
    ClientBodyTransparency = 0.75,
    ClipColor = Color3.fromRGB(255, 60, 60),
    LadderColor = Color3.fromRGB(255, 140, 0),
    ZoneColor = Color3.fromRGB(60, 160, 255),
    SpawnColor = Color3.fromRGB(60, 255, 120),
    ClientImpactColor = Color3.fromRGB(27, 206, 39),
    ServerImpactColor = Color3.fromRGB(255, 0, 4),
    HitmarkerColor = Color3.fromRGB(255, 230, 40),
    LagCompColor = Color3.fromRGB(0, 255, 200),
    LagCompHitColor = Color3.fromRGB(255, 40, 140),
    ClientBodyColor = Color3.fromRGB(255, 120, 0)
};
local u11 = {
    T = Color3.fromRGB(255, 190, 60),
    CT = Color3.fromRGB(80, 170, 255)
};

local function CreateVisualPart(p12: string, p13: any, p14: boolean, p15: boolean, p16, p17: vector, p18, p19: number, p20: userdata) -- Line: 90
    local v21;

    if p14 or p13 == Enum.PartType.Wedge then
        v21 = Instance.new("WedgePart");
    elseif p15 or p13 == Enum.PartType.CornerWedge then
        v21 = Instance.new("CornerWedgePart");
    else
        v21 = Instance.new("Part");

        if p13 == Enum.PartType.Cylinder then
            v21.Shape = Enum.PartType.Cylinder;
        elseif p13 == Enum.PartType.Ball then
            v21.Shape = Enum.PartType.Ball;
        else
            v21.Shape = Enum.PartType.Block;
        end;
    end;

    v21.Name = p12;
    v21.Anchored = true;
    v21.CanCollide = false;
    v21.CanQuery = false;
    v21.CanTouch = false;
    v21.CastShadow = false;
    v21.Material = Enum.Material.Neon;
    v21.Color = p18;
    v21.Transparency = p19;
    local math_max_ret = math.max(p17.X, 0.001);
    local math_max_ret2 = math.max(p17.Y, 0.001);
    local math_max_ret3 = math.max(p17.Z, 0.001);
    v21.Size = Vector3.new(math_max_ret, math_max_ret2, math_max_ret3);
    v21.CFrame = p16;
    v21.Parent = p20;

    return v21;
end;

local function CreateClipFromObject(p22: any, p23: userdata) -- Line: 138
    -- upvalues: CreateVisualPart (copy), u10 (copy)
    local Size = p22.Size;
    local CFrame2 = p22.CFrame;

    if not (Size and CFrame2) then
        return nil;
    end;

    local Shape = p22.Shape;
    local v24 = false;
    local v25 = false;

    if typeof(p22.IsA) == "function" then
        if p22:IsA("WedgePart") then
            v24 = true;
        elseif p22:IsA("CornerWedgePart") then
            v25 = true;
        end;
    end;

    local v26 = p22.Name == "Ladder";

    return CreateVisualPart(v26 and "Ladder" or "Clip", Shape, v24, v25, CFrame2, Size, v26 and u10.LadderColor or u10.ClipColor, u10.ClipTransparency, p23);
end;

local function BuildClips() -- Line: 173
    -- upvalues: u2 (ref), CollisionState (copy), CreateClipFromObject (copy), Enums (copy), CreateVisualPart (copy), u10 (copy)
    if u2 then
        u2:Destroy();
        u2 = nil;
    end;

    local Folder = Instance.new("Folder");
    Folder.Name = "ConsoleClipDebug";
    local v27 = CollisionState.HullRecordCount or 0;
    local HullInstance = CollisionState.HullInstance;

    if v27 > 0 and (HullInstance and next(HullInstance)) then
        for i = 1, v27 do
            local v28 = HullInstance[i];
            local v29;

            if v28 then
                CreateClipFromObject(v28, Folder);
                v29 = i;
            else
                v29 = i;
            end;
        end;
    elseif CollisionState.CurrentBuffer then
        for _, v in CollisionState.CurrentBuffer do
            local CFrame_new_ret = CFrame.new(v.Position);

            if v.Orientation then
                CFrame_new_ret = CFrame_new_ret * CFrame.Angles(v.Orientation.X, v.Orientation.Y, v.Orientation.Z);
            end;

            local v30 = v.Shape == 6;
            local v31;

            if v30 then
                v31 = Enum.PartType.Block;
            else
                v31 = Enums.PartShape and Enums.PartShape[v.Shape] or Enum.PartType.Block;
            end;

            CreateClipFromObject({
                Name = v30 and "Ladder" or "Clip",
                Size = v.Size,
                CFrame = CFrame_new_ret,
                Shape = v31
            }, Folder);
        end;
    end;

    if #Folder:GetChildren() == 0 and (v27 > 0 and (CollisionState.StandMin and CollisionState.StandMax)) then
        local v32 = CollisionState.HalfDefaultCollisionBox or Vector3.new(0, 0, 0);

        for i = 1, v27 do
            local v33 = CollisionState.StandMin[i];
            local v34 = CollisionState.StandMax[i];
            local v35;

            if v33 and v34 then
                local v36 = v33 + v32;
                local v37 = v34 - v32;
                local v38 = (v36 + v37) * 0.5;
                CreateVisualPart("Clip", Enum.PartType.Block, false, false, CFrame.new(v38.X, v38.Y, v38.Z), v37 - v36, u10.ClipColor, u10.ClipTransparency, Folder);
                v35 = i;
            else
                v35 = i;
            end;
        end;
    end;

    Folder.Parent = workspace;
    u2 = Folder;
end;

local u39 = {
    BuyZones = Color3.fromRGB(60, 160, 255),
    Kill = Color3.fromRGB(255, 60, 60),
    Detects = Color3.fromRGB(255, 200, 60),
    Plants = Color3.fromRGB(160, 60, 255)
};

local function GroupColorFor(p40: userdata) -- Line: 248
    -- upvalues: u39 (copy), u10 (copy)
    while p40 and p40 ~= workspace do
        local v41 = u39[p40.Name];

        if v41 then
            return v41;
        end;

        p40 = p40.Parent;
    end;

    return u10.ZoneColor;
end;

local function BuildZones() -- Line: 260
    -- upvalues: u3 (ref), CreateVisualPart (copy), u39 (copy), u10 (copy)
    if u3 then
        u3:Destroy();
        u3 = nil;
    end;

    local Map = workspace:FindFirstChild("Map");

    if Map then
        Map = Map:FindFirstChild("Zones");
    end;

    if not Map then
        return false, "no Zones folder on the current map";
    end;

    local Folder = Instance.new("Folder");
    Folder.Name = "ConsoleZoneDebug";
    local v42 = 0;

    for _, descendant in Map:GetDescendants() do
        if descendant:IsA("BasePart") then
            local v43 = descendant:IsA("WedgePart");
            local v44 = descendant:IsA("CornerWedgePart");
            local v45;

            if descendant:IsA("Part") then
                v45 = descendant.Shape;
            else
                v45 = nil;
            end;

            local v46 = descendant;
            local v47;

            while true do
                if not v46 or v46 == workspace then
                    v47 = u10.ZoneColor;
                    break;
                end;

                v47 = u39[v46.Name];

                if v47 then
                    break;
                end;

                v46 = v46.Parent;
            end;

            CreateVisualPart(descendant.Name, v45, v43, v44, descendant.CFrame, descendant.Size, v47, u10.ZoneTransparency, Folder);
            v42 = v42 + 1;
        end;
    end;

    Folder.Parent = workspace;
    u3 = Folder;

    return true, ("showing %d zone volumes"):format(v42);
end;

local function BuildSpawns() -- Line: 304
    -- upvalues: u4 (ref), u10 (copy), u11 (copy), CreateVisualPart (copy)
    if u4 then
        u4:Destroy();
        u4 = nil;
    end;

    local Map = workspace:FindFirstChild("Map");

    if Map then
        Map = Map:FindFirstChild("Spawns");
    end;

    if not Map then
        return false, "no Spawns folder on the current map";
    end;

    local Folder = Instance.new("Folder");
    Folder.Name = "ConsoleSpawnDebug";
    local v48 = 0;

    for _, descendant in Map:GetDescendants() do
        if descendant:IsA("BasePart") then
            local SpawnColor = u10.SpawnColor;
            local Parent = descendant.Parent;
            local v49 = descendant;

            while Parent and Parent ~= Map.Parent do
                if u11[Parent.Name] then
                    SpawnColor = u11[Parent.Name];
                    break;
                end;

                Parent = Parent.Parent;
            end;

            local v50 = v49:IsA("WedgePart");
            local v51 = v49:IsA("CornerWedgePart");
            local v52;

            if v49:IsA("Part") then
                v52 = v49.Shape;
            else
                v52 = nil;
            end;

            CreateVisualPart(v49.Name, v52, v50, v51, v49.CFrame, v49.Size, SpawnColor, u10.SpawnTransparency, Folder);
            v48 = v48 + 1;
        end;
    end;

    Folder.Parent = workspace;
    u4 = Folder;

    return true, ("showing %d spawn points"):format(v48);
end;

local function RefreshClipAppearance() -- Line: 359
    -- upvalues: u2 (ref), u10 (copy)
    if not u2 then
        return;
    end;

    for _, child in u2:GetChildren() do
        if child:IsA("BasePart") then
            child.Color = child.Name == "Ladder" and u10.LadderColor or u10.ClipColor;
            child.Transparency = u10.ClipTransparency;
        end;
    end;
end;

local function RefreshZoneAppearance() -- Line: 370
    -- upvalues: u3 (ref), u10 (copy)
    if not u3 then
        return;
    end;

    for _, child in u3:GetChildren() do
        if child:IsA("BasePart") then
            child.Transparency = u10.ZoneTransparency;
        end;
    end;
end;

function u1.SetClips(p53: boolean) -- Line: 381
    -- upvalues: u6 (ref), BuildClips (copy), u2 (ref)
    u6 = p53 == true;

    if not p53 then
        if u2 then
            u2:Destroy();
            u2 = nil;
        end;

        return "clips hidden";
    end;

    BuildClips();
    local v54 = u2 and #u2:GetChildren() or 0;

    return v54 == 0 and "no collision hulls loaded yet (map not built?)" or ("showing %d collision hulls (clips)"):format(v54);
end;

function u1.SetClipColor(p55: number, p56: number, p57: number) -- Line: 400
    -- upvalues: u10 (copy), RefreshClipAppearance (copy)
    u10.ClipColor = Color3.fromRGB(p55, p56, p57);
    RefreshClipAppearance();

    return ("clip color = %d %d %d"):format(p55, p56, p57);
end;

function u1.SetClipTransparency(p58: number) -- Line: 406
    -- upvalues: u10 (copy), RefreshClipAppearance (copy)
    u10.ClipTransparency = math.clamp(p58, 0, 1);
    RefreshClipAppearance();

    return ("clip transparency = %.2f"):format(u10.ClipTransparency);
end;

function u1.SetZones(p59: boolean) -- Line: 412
    -- upvalues: u7 (ref), BuildZones (copy), u3 (ref)
    u7 = p59 == true;

    if p59 then
        local _, v60 = BuildZones();

        return v60;
    end;

    if u3 then
        u3:Destroy();
        u3 = nil;
    end;

    return "zones hidden";
end;

function u1.SetSpawns(p61: boolean) -- Line: 427
    -- upvalues: u8 (ref), BuildSpawns (copy), u4 (ref)
    u8 = p61 == true;

    if p61 then
        local _, v62 = BuildSpawns();

        return v62;
    end;

    if u4 then
        u4:Destroy();
        u4 = nil;
    end;

    return "spawns hidden";
end;

function u1.SetZoneColor(p63: number, p64: number, p65: number) -- Line: 442
    -- upvalues: u10 (copy), u3 (ref), BuildZones (copy)
    u10.ZoneColor = Color3.fromRGB(p63, p64, p65);

    if u3 then
        BuildZones();
    end;

    return ("zone color = %d %d %d"):format(p63, p64, p65);
end;

function u1.SetZoneTransparency(p66: number) -- Line: 452
    -- upvalues: u10 (copy), RefreshZoneAppearance (copy)
    u10.ZoneTransparency = math.clamp(p66, 0, 1);
    RefreshZoneAppearance();

    return ("zone transparency = %.2f"):format(u10.ZoneTransparency);
end;

local function GetImpactsFolder() -- Line: 462
    -- upvalues: u5 (ref), Workspace (copy)
    if not (u5 and u5.Parent) then
        u5 = Instance.new("Folder");
        u5.Name = "ConsoleImpactDebug";
        u5.Parent = Workspace.Terrain;
    end;

    return u5;
end;

function u1.AddClientImpact(p67: vector) -- Line: 471
    -- upvalues: Workspace (copy), u10 (copy), u5 (ref)
    local BoxHandleAdornment = Instance.new("BoxHandleAdornment");
    BoxHandleAdornment.Name = "ClientImpact";
    BoxHandleAdornment.Adornee = Workspace.Terrain;
    BoxHandleAdornment.Size = Vector3.new(0.25, 0.25, 0.25);
    BoxHandleAdornment.CFrame = CFrame.new(p67.X, p67.Y, p67.Z);
    BoxHandleAdornment.Color3 = u10.ClientImpactColor;
    BoxHandleAdornment.Transparency = u10.ImpactTransparency;
    BoxHandleAdornment.AlwaysOnTop = true;
    BoxHandleAdornment.ZIndex = 1;

    if not (u5 and u5.Parent) then
        u5 = Instance.new("Folder");
        u5.Name = "ConsoleImpactDebug";
        u5.Parent = Workspace.Terrain;
    end;

    BoxHandleAdornment.Parent = u5;
    task.delay(u10.ImpactTime, function() -- Line: 483
        -- upvalues: BoxHandleAdornment (copy)
        if BoxHandleAdornment and BoxHandleAdornment.Parent then
            BoxHandleAdornment:Destroy();
        end;
    end);
end;

function u1.AddServerImpact(p68: vector) -- Line: 490
    -- upvalues: Workspace (copy), u10 (copy), u5 (ref)
    local BoxHandleAdornment = Instance.new("BoxHandleAdornment");
    BoxHandleAdornment.Name = "ServerImpact";
    BoxHandleAdornment.Adornee = Workspace.Terrain;
    BoxHandleAdornment.Size = Vector3.new(0.3, 0.3, 0.3);
    BoxHandleAdornment.CFrame = CFrame.new(p68.X, p68.Y, p68.Z);
    BoxHandleAdornment.Color3 = u10.ServerImpactColor;
    BoxHandleAdornment.Transparency = u10.ImpactTransparency;
    BoxHandleAdornment.AlwaysOnTop = true;
    BoxHandleAdornment.ZIndex = 2;

    if not (u5 and u5.Parent) then
        u5 = Instance.new("Folder");
        u5.Name = "ConsoleImpactDebug";
        u5.Parent = Workspace.Terrain;
    end;

    BoxHandleAdornment.Parent = u5;
    task.delay(u10.ImpactTime, function() -- Line: 502
        -- upvalues: BoxHandleAdornment (copy)
        if BoxHandleAdornment and BoxHandleAdornment.Parent then
            BoxHandleAdornment:Destroy();
        end;
    end);
end;

function u1.ClearImpacts() -- Line: 509
    -- upvalues: u5 (ref)
    if u5 then
        u5:Destroy();
        u5 = nil;
    end;
end;

function u1.IsImpacts() -- Line: 516
    -- upvalues: LocalPlayer (ref), Players (copy)
    local v69 = LocalPlayer or Players.LocalPlayer;
    local v70;

    if v69 == nil then
        v70 = false;
    else
        v70 = v69:GetAttribute("ShowImpacts") == true;
    end;

    return v70;
end;

local u71 = nil;

local function GetServerShotsFolder() -- Line: 527
    -- upvalues: u71 (ref), Workspace (copy)
    if not (u71 and u71.Parent) then
        u71 = Instance.new("Folder");
        u71.Name = "ConsoleServerShotDebug";
        u71.Parent = Workspace.Terrain;
    end;

    return u71;
end;

local function AddShotAdornment(p72: string, p73, p74: vector, p75, p76: number, p77: number) -- Line: 538
    -- upvalues: Workspace (copy), u71 (ref), u10 (copy)
    local BoxHandleAdornment = Instance.new("BoxHandleAdornment");
    BoxHandleAdornment.Name = p72;
    BoxHandleAdornment.Adornee = Workspace.Terrain;
    BoxHandleAdornment.Size = p74;
    BoxHandleAdornment.CFrame = p73;
    BoxHandleAdornment.Color3 = p75;
    BoxHandleAdornment.Transparency = p76;
    BoxHandleAdornment.AlwaysOnTop = true;
    BoxHandleAdornment.ZIndex = p77;

    if not (u71 and u71.Parent) then
        u71 = Instance.new("Folder");
        u71.Name = "ConsoleServerShotDebug";
        u71.Parent = Workspace.Terrain;
    end;

    BoxHandleAdornment.Parent = u71;
    task.delay(u10.ImpactTime, function() -- Line: 550
        -- upvalues: BoxHandleAdornment (copy)
        if BoxHandleAdornment and BoxHandleAdornment.Parent then
            BoxHandleAdornment:Destroy();
        end;
    end);
end;

function u1.AddHitmarker(p78: vector) -- Line: 558
    -- upvalues: AddShotAdornment (copy), u10 (copy)
    AddShotAdornment("Hitmarker", CFrame.new(p78.X, p78.Y, p78.Z), Vector3.new(0.35, 0.35, 0.35), u10.HitmarkerColor, 0.1, 5);
end;

function u1.AddHitboxMarker(p79, p80: vector, p81: boolean?) -- Line: 574
    -- upvalues: AddShotAdornment (copy), u10 (copy)
    AddShotAdornment(p81 and "LagCompHitbox_Hit" or "LagCompHitbox", p79, p80, p81 and u10.LagCompHitColor or u10.LagCompColor, p81 and u10.LagCompHitTransparency or u10.LagCompTransparency, p81 and 4 or 3);
end;

function u1.AddClientBodies(p82: string?) -- Line: 594
    -- upvalues: LocalPlayer (ref), Players (copy), Workspace (copy), CharacterModel (copy), AddShotAdornment (copy), u10 (copy)
    local v83 = LocalPlayer or Players.LocalPlayer;

    if not v83 or v83:GetAttribute("ShowServerShots") ~= true then
        return;
    end;

    local Characters = Workspace:FindFirstChild("Characters");

    if not Characters then
        return;
    end;

    for _, child in Characters:GetChildren() do
        if child:IsA("Model") and child.Name ~= p82 then
            local v84 = child;

            for i, v in CharacterModel.GetHitboxParts(child) do
                local HitboxBox, v85 = CharacterModel.GetHitboxBox(v84, i, v);
                AddShotAdornment("ClientBody", HitboxBox and v.CFrame * HitboxBox or v.CFrame, v85 * 2, u10.ClientBodyColor, u10.ClientBodyTransparency, 2);
            end;
        end;
    end;
end;

function u1.Init(p86) -- Line: 621
    -- upvalues: u9 (ref)
    u9 = p86:GetModule("Network");
end;

function u1.Start(p87) -- Line: 625
    -- upvalues: u9 (ref), u1 (copy), LocalPlayer (ref), Players (copy), u2 (ref), u3 (ref), u4 (ref), u7 (ref), BuildZones (copy), u8 (ref), BuildSpawns (copy), u6 (ref), CollisionState (copy), BuildClips (copy)
    if not u9 then
        u9 = p87:GetModule("Network");
    end;

    if u9 and (u9.Debug and u9.Debug.ShotMarker) then
        u9.Debug.ShotMarker.On(function(p88) -- Line: 631
            -- upvalues: u1 (ref)
            if p88.Kind == "Impact" then
                u1.AddServerImpact(p88.Position);
            end;
        end);
    end;

    if u9 and (u9.Debug and u9.Debug.ServerShot) then
        u9.Debug.ServerShot.On(function(p89) -- Line: 641
            -- upvalues: u1 (ref)
            if p89.Hit and p89.Hit.Magnitude > 0.001 then
                u1.AddHitmarker(p89.Hit);
            end;

            for _, v in ipairs(p89.Boxes or {}) do
                u1.AddHitboxMarker(v.CFrame, v.Size, v.Hit);
            end;
        end);
    end;

    local function WatchPlayer(u90: userdata) -- Line: 653
        -- upvalues: u1 (ref)
        u90:GetAttributeChangedSignal("ShowImpacts"):Connect(function() -- Line: 654
            -- upvalues: u90 (copy), u1 (ref)
            if u90:GetAttribute("ShowImpacts") ~= true then
                u1.ClearImpacts();
            end;
        end);
        u90:GetAttributeChangedSignal("ShowServerShots"):Connect(function() -- Line: 659
            -- upvalues: u90 (copy), u1 (ref)
            if u90:GetAttribute("ShowServerShots") ~= true then
                u1.ClearServerShots();
            end;
        end);
    end;

    if LocalPlayer then
        WatchPlayer(LocalPlayer);
    else
        Players:GetPropertyChangedSignal("LocalPlayer"):Connect(function() -- Line: 669
            -- upvalues: LocalPlayer (ref), Players (ref), WatchPlayer (copy)
            LocalPlayer = Players.LocalPlayer;

            if LocalPlayer then
                WatchPlayer(LocalPlayer);
            end;
        end);
    end;

    local Module = p87:GetModule("NewMapAdded");

    if Module then
        if Module.OnMapRemove then
            Module.OnMapRemove:Connect(function() -- Line: 683
                -- upvalues: u2 (ref), u3 (ref), u4 (ref)
                if u2 then
                    u2:Destroy();
                    u2 = nil;
                end;

                if u3 then
                    u3:Destroy();
                    u3 = nil;
                end;

                if u4 then
                    u4:Destroy();
                    u4 = nil;
                end;
            end);
        end;

        if Module.OnMapAdded then
            Module.OnMapAdded:Connect(function() -- Line: 691
                -- upvalues: u7 (ref), BuildZones (ref), u8 (ref), BuildSpawns (ref), u6 (ref), CollisionState (ref), BuildClips (ref)
                if u7 then
                    BuildZones();
                end;

                if u8 then
                    BuildSpawns();
                end;

                if u6 then
                    task.spawn(function() -- Line: 697
                        -- upvalues: CollisionState (ref), u6 (ref), BuildClips (ref)
                        for i = 1, 300 do
                            if CollisionState.HullRecordCount and CollisionState.HullRecordCount > 0 then
                                break;
                            end;

                            task.wait();
                            local _ = i;
                        end;

                        if u6 then
                            BuildClips();
                        end;
                    end);
                end;
            end);
        end;
    end;
end;

return u1;