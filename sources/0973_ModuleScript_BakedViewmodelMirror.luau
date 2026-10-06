-- Decompiled with Potassium's decompiler.

local ContentProvider = game:GetService("ContentProvider");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local RunService = game:GetService("RunService");
local ViewmodelHand = require(ReplicatedStorage.Shared.ViewmodelHand);
local CFrame_new_ret = CFrame.new(0, 0, 0, -1, 0, 0, 0, 1, 0, 0, 0, 1);
local CFrame_new_ret2 = CFrame.new(0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, -1);
local u1 = {
    SurfaceAppearance = true,
    Decal = true,
    Texture = true
};
local u2 = {};
u2.__index = u2;
local u3 = {};
local u4 = {};
local u5 = {};
local u6 = {};
local u7 = false;
local u8 = {};
local u9 = false;
local u10 = false;
local u11 = false;
local u12 = 0;
local u13 = {};

local function isLoaded(p14: userdata) -- Line: 32
    -- upvalues: u4 (copy), ContentProvider (copy)
    local MeshId = p14.MeshId;

    if u4[MeshId] then
        return true;
    end;

    if ContentProvider:GetAssetFetchStatus(MeshId) ~= Enum.AssetFetchStatus.Success then
        return false;
    end;

    u4[MeshId] = true;

    return true;
end;

local function waitForQuiet() -- Line: 44
    -- upvalues: u12 (ref)
    local v15 = os.clock() - u12;

    while v15 < 2 do
        task.wait(2 - v15);
        v15 = os.clock() - u12;
    end;
end;

local function runDownloads() -- Line: 53
    -- upvalues: u6 (copy), waitForQuiet (copy), u5 (copy), u4 (copy), ContentProvider (copy), u7 (ref)
    while #u6 > 0 do
        waitForQuiet();
        local v16 = {};

        while #v16 < 8 and #u6 > 0 do
            local table_remove_ret = table.remove(u6, 1);
            u5[table_remove_ret.MeshId] = nil;
            local MeshId = table_remove_ret.MeshId;
            local v17;

            if u4[MeshId] then
                v17 = true;
            elseif ContentProvider:GetAssetFetchStatus(MeshId) == Enum.AssetFetchStatus.Success then
                u4[MeshId] = true;
                v17 = true;
            else
                v17 = false;
            end;

            if not v17 then
                table.insert(v16, table_remove_ret);
            end;
        end;

        if #v16 > 0 then
            pcall(ContentProvider.PreloadAsync, ContentProvider, v16);
            task.wait(0.25);
        end;
    end;

    u7 = false;
end;

local function queueDownloads(p18: table) -- Line: 72
    -- upvalues: u5 (copy), u4 (copy), u6 (copy), u7 (ref), runDownloads (copy)
    for _, v in p18 do
        if not (u5[v.MeshId] or u4[v.MeshId]) then
            u5[v.MeshId] = true;
            table.insert(u6, v);
        end;
    end;

    if not u7 and #u6 > 0 then
        u7 = true;
        task.spawn(runDownloads);
    end;
end;

local function runBuilds() -- Line: 86
    -- upvalues: u8 (copy), waitForQuiet (copy), RunService (copy), u9 (ref)
    while #u8 > 0 do
        waitForQuiet();
        RunService.Heartbeat:Wait();
        local table_remove_ret = table.remove(u8, 1);

        if table_remove_ret.Model and not table_remove_ret.Twins then
            table_remove_ret:BuildTwins();
        end;
    end;

    u9 = false;
end;

local function queueBuild(p19) -- Line: 98
    -- upvalues: u8 (copy), u9 (ref), runBuilds (copy)
    table.insert(u8, p19);

    if not u9 then
        u9 = true;
        task.spawn(runBuilds);
    end;
end;

local function preloadBothHands(p20) -- Line: 107
    -- upvalues: ContentProvider (copy)
    local v21 = {};

    for _, v in p20.Entries do
        table.insert(v21, v.part);
        table.insert(v21, v.bake);
    end;

    task.spawn(pcall, ContentProvider.PreloadAsync, ContentProvider, v21);
end;

local function activate() -- Line: 117
    -- upvalues: u10 (ref), u3 (copy), u8 (copy), u9 (ref), runBuilds (copy), preloadBothHands (copy), ReplicatedStorage (copy), queueDownloads (copy)
    if u10 then
        return;
    end;

    u10 = true;
    local v22 = {};

    for i in u3 do
        table.insert(u8, i);

        if not u9 then
            u9 = true;
            task.spawn(runBuilds);
        end;

        preloadBothHands(i);
    end;

    local ViewmodelMirrors = ReplicatedStorage:FindFirstChild("ViewmodelMirrors");

    for _, v in not ViewmodelMirrors and {} or ViewmodelMirrors:GetChildren() do
        if v:IsA("MeshPart") then
            table.insert(v22, v);
        end;
    end;

    queueDownloads(v22);
end;

local function modifierSet(p23: userdata) -- Line: 137
    local v24 = { p23 };

    for _, child in p23:GetChildren() do
        if child:IsA("Decal") then
            table.insert(v24, child);
        end;
    end;

    return v24;
end;

function u2.ReflectPose(p25, p26) -- Line: 147
    -- upvalues: CFrame_new_ret (copy)
    return p25 * CFrame_new_ret * p25:ToObjectSpace(p26);
end;

function u2.new(p27: userdata, p28: userdata, p29: boolean) -- Line: 152
    -- upvalues: u13 (copy), u2 (copy), u3 (copy), u12 (ref), u10 (ref), u8 (copy), u9 (ref), runBuilds (copy), preloadBothHands (copy), queueDownloads (copy)
    local v30 = {};

    for _, descendant in p27:GetDescendants() do
        if descendant:IsA("MeshPart") then
            local v31 = descendant.MeshId:match("%d+");

            if v31 then
                v31 = p28:FindFirstChild(v31);
            end;

            if not (v31 and v31:IsA("MeshPart")) then
                if not u13[descendant.MeshId] then
                    u13[descendant.MeshId] = true;
                    warn((`[BakedViewmodelMirror] No left-hand bake for {descendant:GetFullName()} ({descendant.MeshId})`));
                end;

                return nil;
            end;

            table.insert(v30, {
                part = descendant,
                bake = v31
            });
        end;
    end;

    local v32 = setmetatable({
        Hand = "Right",
        Visible = true,
        Twins = false,
        Model = p27,
        Entries = v30,
        Surfaces = {},
        Ready = {}
    }, u2);
    u3[v32] = true;
    u12 = os.clock();

    if not u10 then
        if p29 then
            queueDownloads(v32:Bakes());
        end;

        return v32;
    end;

    table.insert(u8, v32);

    if not u9 then
        u9 = true;
        task.spawn(runBuilds);
    end;

    preloadBothHands(v32);

    return v32;
end;

function u2.Bakes(p33) -- Line: 189
    local v34 = {};

    for _, v in p33.Entries do
        table.insert(v34, v.bake);
    end;

    return v34;
end;

function u2.HandReady(p35: table, p36: string) -- Line: 198
    -- upvalues: u4 (copy), ContentProvider (copy)
    if not p35.Ready[p36] then
        for _, v in p35.Entries do
            local v37;

            if p36 == "Left" then
                v37 = v.bake;
            else
                v37 = v.part;
            end;

            local MeshId = v37.MeshId;
            local v38;

            if u4[MeshId] then
                v38 = true;
            elseif ContentProvider:GetAssetFetchStatus(MeshId) == Enum.AssetFetchStatus.Success then
                u4[MeshId] = true;
                v38 = true;
            else
                v38 = false;
            end;

            if not v38 then
                return false;
            end;
        end;

        p35.Ready[p36] = true;
    end;

    return true;
end;

function u2.BuildTwins(p39) -- Line: 211
    -- upvalues: u1 (copy), modifierSet (copy)
    if p39.Twins or not p39.Model then
        return;
    end;

    for _, v in p39.Entries do
        local part = v.part;
        local v40 = v.bake:Clone();
        v40.Name = part.Name;
        v40.Archivable = false;
        v40.Anchored = false;
        v40.Massless = true;
        v40.CanCollide = false;
        v40.CanQuery = false;
        v40.CanTouch = false;
        v40.CastShadow = part.CastShadow;
        v40.EnableFluidForces = false;
        v40.CollisionGroup = part.CollisionGroup;
        v40.Size = part.Size;
        v40.Color = part.Color;
        v40.Material = part.Material;
        v40.MaterialVariant = part.MaterialVariant;
        v40.Reflectance = part.Reflectance;
        v40.TextureID = part.TextureID;
        v40.Transparency = part.Transparency;
        v40.DoubleSided = false;
        local v41 = v;

        for _, child in part:GetChildren() do
            if u1[child.ClassName] then
                child:Clone().Parent = v40;
            end;
        end;

        local Weld = Instance.new("Weld");
        Weld.Part0 = part;
        Weld.Part1 = v40;
        Weld.Parent = v40;
        v40.CFrame = part.CFrame;
        v41.twin = v40;
        v41.sourceSet = modifierSet(part);
        v41.twinSet = modifierSet(v40);
    end;

    p39:CreateSurfaces();
    p39.Twins = true;
    p39:WriteVisibility();

    for _, v in p39.Entries do
        if v.part.Parent then
            v.twin.Parent = v.part;
        end;
    end;
end;

function u2.CreateSurfaces(u42) -- Line: 262
    local Folder = Instance.new("Folder");
    Folder.Name = "ViewmodelSurfaceDisplays";
    u42.SurfaceFolder = Folder;

    for _, descendant in u42.Model:GetDescendants() do
        if descendant:IsA("SurfaceGui") then
            local v43 = descendant.Adornee or descendant.Parent;

            if v43 and (v43:IsA("BasePart") and v43:IsDescendantOf(u42.Model)) then
                local Part = Instance.new("Part");
                Part.Name = descendant.Name;
                Part.Anchored = true;
                Part.Transparency = 1;
                Part.CanCollide = false;
                Part.CanTouch = false;
                Part.CanQuery = false;
                Part.CastShadow = false;
                Part.Parent = Folder;
                table.insert(u42.Surfaces, {
                    gui = descendant,
                    part = v43,
                    proxy = Part,
                    originalAdornee = descendant.Adornee
                });
            end;
        end;
    end;

    u42.ParentConnection = u42.Model:GetPropertyChangedSignal("Parent"):Connect(function() -- Line: 285
        -- upvalues: u42 (copy)
        u42:UpdateSurfaceParent();
    end);
end;

function u2.PrepareEquip(p44) -- Line: 291
    -- upvalues: u10 (ref)
    if u10 and not p44.Twins then
        p44:BuildTwins();
    end;
end;

function u2.WriteVisibility(p45) -- Line: 298
    -- upvalues: u11 (ref)
    if not p45.Twins then
        return;
    end;

    local v46 = p45.Hand == "Left";
    local v47 = p45.Visible and not u11;
    local v48 = (v46 or not v47) and 1 or 0;
    local v49 = v46 and v47 and 0 or 1;

    for _, v in p45.Entries do
        for _, v2 in v.sourceSet do
            v2.LocalTransparencyModifier = v48;
        end;

        for _, v2 in v.twinSet do
            v2.LocalTransparencyModifier = v49;
        end;
    end;

    for _, v in p45.Surfaces do
        local v50;

        if v46 then
            v50 = v.proxy;
        else
            v50 = v.originalAdornee;
        end;

        v.gui.Adornee = v50;
    end;

    p45:UpdateSurfaceParent();
end;

function u2.SyncTransparency(p51) -- Line: 320
    for _, v in p51.Entries do
        local Transparency = v.part.Transparency;

        if v.twin.Transparency ~= Transparency then
            v.twin.Transparency = Transparency;
        end;
    end;
end;

function u2.SetLeftHanded(p52: table, p53: boolean) -- Line: 330
    -- upvalues: activate (copy), ContentProvider (copy)
    local v54 = p53 and "Left" or "Right";

    if v54 == p52.Hand and p52.Visible then
        if p53 then
            p52:SyncTransparency();
        end;

        return;
    end;

    if not p52.Twins then
        if not p53 then
            return;
        end;

        activate();
        p52:BuildTwins();
    end;

    local v55 = v54 ~= p52.Hand;

    if v55 then
        p52.Hand = v54;
        p52.PendingSince = os.clock();

        if not p52:HandReady(v54) then
            local v56 = {};

            for _, v in p52.Entries do
                local v57;

                if p53 then
                    v57 = v.bake;
                else
                    v57 = v.part;
                end;

                table.insert(v56, v57);
            end;

            task.spawn(pcall, ContentProvider.PreloadAsync, ContentProvider, v56);
        end;
    end;

    local v58 = p52:HandReady(v54) or os.clock() - p52.PendingSince >= 1.5;

    if v58 and p53 then
        p52:SyncTransparency();
    end;

    if v55 or v58 ~= p52.Visible then
        p52.Visible = v58;
        p52:WriteVisibility();
    end;
end;

function u2.SetSuppressed(p59: boolean) -- Line: 369
    -- upvalues: u11 (ref), u3 (copy)
    u11 = p59;

    if not p59 then
        for i in u3 do
            i:WriteVisibility();
        end;
    end;
end;

function u2.UpdateSurfaceParent(p60) -- Line: 378
    local Model = p60.Model;

    if p60.SurfaceFolder and Model then
        local workspace_CurrentCamera = workspace.CurrentCamera;
        local v61;

        if p60.Hand == "Left" then
            v61 = p60.Visible;
        else
            v61 = false;
        end;

        if not v61 or Model.Parent ~= workspace_CurrentCamera then
            workspace_CurrentCamera = nil;
        end;

        p60.SurfaceFolder.Parent = workspace_CurrentCamera;
    end;
end;

function u2.GetDisplayPose(p62: table, p63, p64) -- Line: 389
    -- upvalues: u2 (copy)
    p62.LastCamera = p63;

    if p62.Hand == "Left" then
        return u2.ReflectPose(p63, p64);
    end;

    return p64;
end;

function u2.UpdateSurfaces(p65) -- Line: 394
    -- upvalues: CFrame_new_ret (copy), CFrame_new_ret2 (copy)
    if p65.Hand ~= "Left" or not p65.Visible then
        return;
    end;

    for _, v in p65.Surfaces do
        local Face = v.gui.Face;
        local v66;

        if Face == Enum.NormalId.Front or Face == Enum.NormalId.Back then
            v66 = CFrame_new_ret;
        else
            v66 = CFrame_new_ret2;
        end;

        v.proxy.Size = v.part.Size;
        v.proxy.CFrame = v.part.CFrame * v66;
    end;
end;

function u2.ToNormalPose(p67: table, p68) -- Line: 408
    -- upvalues: u2 (copy)
    if p67.Hand == "Left" and p67.LastCamera then
        return u2.ReflectPose(p67.LastCamera, p68);
    end;

    return p68;
end;

function u2.Destroy(p69) -- Line: 415
    -- upvalues: u3 (copy)
    u3[p69] = nil;

    if p69.ParentConnection then
        p69.ParentConnection:Disconnect();
    end;

    for _, v in p69.Surfaces do
        if v.gui.Parent then
            v.gui.Adornee = v.originalAdornee;
        end;
    end;

    if p69.SurfaceFolder then
        p69.SurfaceFolder:Destroy();
    end;

    table.clear(p69.Surfaces);

    for _, v in p69.Entries do
        if v.twin then
            v.twin:Destroy();
        end;
    end;

    table.clear(p69.Entries);
    p69.Model = nil;
end;

ViewmodelHand.Changed:Connect(function(p70: boolean) -- Line: 438
    -- upvalues: activate (copy)
    if p70 then
        activate();
    end;
end);

return u2;