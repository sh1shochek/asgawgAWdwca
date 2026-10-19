-- RemoteCharacters (ModuleScript)
-- full path: ReplicatedStorage.Controllers.CharacterController.RemoteCharacters

-- Decompiled with Potassium's decompiler.

local HttpService = game:GetService("HttpService");
local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Workspace = game:GetService("Workspace");
local CharacterAnimator = require(ReplicatedStorage.Classes.Character.Classes.CharacterAnimator);
local Ragdoll = require(ReplicatedStorage.Classes.Ragdoll);
local CharacterActions = require(ReplicatedStorage.Database.Components.CharacterActions);
local Remotes = require(ReplicatedStorage.Database.Security.Remotes);
local CharacterGeneration = require(ReplicatedStorage.Components.Common.CharacterGeneration);
local ClientCharacterPresentation = require(ReplicatedStorage.Components.Common.ClientCharacterPresentation);
local CharacterPresentationDescriptor = require(ReplicatedStorage.Components.Common.CharacterPresentationDescriptor);
local CharacterPose = require(ReplicatedStorage.Components.Common.CharacterPose);
local SurvivalDowned = require(ReplicatedStorage.Components.Common.SurvivalDowned);
local CharacterResolver = require(ReplicatedStorage.Components.Common.CharacterResolver);
local RootFrame = require(ReplicatedStorage.MovementV2.RootFrame);
local RuntimeKinematics = require(ReplicatedStorage.MovementV2.RuntimeKinematics);
local Janitor = require(ReplicatedStorage.Shared.Janitor);
local BotCharacters = require(script.Parent.BotCharacters);
local LocalPlayer = Players.LocalPlayer;
local u1 = {};
local u2 = {};
local u3 = {};
local u4 = {};
local u5 = false;
local u6 = 0;
local u7 = {};
local u8 = {};
local u9 = {};
local u10 = {};
local u11 = nil;
local u12 = setmetatable({}, {
    __mode = "k"
});

local function restoreEntryParent(p13: table) -- Line: 69
    -- upvalues: ClientCharacterPresentation (copy), Workspace (copy)
    if p13.Shell.Parent ~= ClientCharacterPresentation.GetCulledFolder() then
        return;
    end;

    local VisibleParent = p13.VisibleParent;

    if VisibleParent == nil or (VisibleParent == ClientCharacterPresentation.GetCulledFolder() or not VisibleParent:IsDescendantOf(game)) then
        VisibleParent = Workspace:FindFirstChild("Characters") or Workspace;
        p13.VisibleParent = VisibleParent;
    end;

    p13.Shell.Parent = VisibleParent;
end;

local function cullEntryFromWorkspace(p14: table) -- Line: 87
    -- upvalues: ClientCharacterPresentation (copy)
    local CulledFolder = ClientCharacterPresentation.GetCulledFolder();
    local Parent = p14.Shell.Parent;

    if Parent ~= nil and Parent ~= CulledFolder then
        p14.VisibleParent = Parent;
    end;

    if p14.Shell.Parent ~= CulledFolder then
        p14.Shell.Parent = CulledFolder;
    end;
end;

local function decodeCurrentEquipped(p15: userdata) -- Line: 99
    -- upvalues: HttpService (copy)
    local Attribute = p15:GetAttribute("CurrentEquipped");

    if typeof(Attribute) ~= "string" or Attribute == "" then
        return nil, nil;
    end;

    local success, result = pcall(HttpService.JSONDecode, HttpService, Attribute);

    if not success or typeof(result) ~= "table" then
        return nil, nil;
    end;

    local v16;

    if typeof(result.Name) == "string" then
        v16 = result.Name;
    else
        v16 = nil;
    end;

    local v17;

    if typeof(result.Identifier) == "string" then
        v17 = result.Identifier;
    else
        v17 = nil;
    end;

    return v16, v17;
end;

local function syncEquippedWeapon(p18: table, p19: boolean) -- Line: 113
    -- upvalues: decodeCurrentEquipped (copy)
    if not p18.Visible then
        return;
    end;

    local v20, v21 = decodeCurrentEquipped(p18.Player);
    p18.Animator:setWeapon(v20, v21, p19);
end;

local function setEntryVisible(p22: table, p23: boolean) -- Line: 122
    -- upvalues: u11 (ref), RuntimeKinematics (copy), ClientCharacterPresentation (copy), restoreEntryParent (copy), CharacterPresentationDescriptor (copy), decodeCurrentEquipped (copy)
    local v24 = p22.Player == u11 and (p22.Visible and p22.Shell:GetAttribute("Dead") ~= true) and true or p23;

    if p22.Visible == v24 then
        if v24 then
            restoreEntryParent(p22);
        else
            RuntimeKinematics.clear(p22.Shell);
            local CulledFolder = ClientCharacterPresentation.GetCulledFolder();
            local Parent = p22.Shell.Parent;

            if Parent ~= nil and Parent ~= CulledFolder then
                p22.VisibleParent = Parent;
            end;

            if p22.Shell.Parent ~= CulledFolder then
                p22.Shell.Parent = CulledFolder;

                return;
            end;
        end;

        return;
    end;

    p22.Visible = v24;

    if v24 then
        restoreEntryParent(p22);
        p22.Shell:SetAttribute(CharacterPresentationDescriptor.VisibleAttribute, true);

        if not p22.Visible then
            return;
        end;

        local v25, v26 = decodeCurrentEquipped(p22.Player);
        p22.Animator:setWeapon(v25, v26, false);

        return;
    end;

    p22.Shell:SetAttribute(CharacterPresentationDescriptor.VisibleAttribute, false);
    p22.Animator:stopAnimations(0);
    RuntimeKinematics.clear(p22.Shell);
    local CulledFolder = ClientCharacterPresentation.GetCulledFolder();
    local Parent = p22.Shell.Parent;

    if Parent ~= nil and Parent ~= CulledFolder then
        p22.VisibleParent = Parent;
    end;

    if p22.Shell.Parent ~= CulledFolder then
        p22.Shell.Parent = CulledFolder;
    end;
end;

function u1.SetPinnedPlayer(p27: userdata?) -- Line: 152
    -- upvalues: u11 (ref)
    u11 = p27;
end;

function u1.GetCamera(p28: userdata) -- Line: 157
    -- upvalues: u2 (copy), CharacterResolver (copy), SurvivalDowned (copy)
    local v29 = u2[p28];

    if v29 == nil or (not v29.Visible or v29.LookYaw == nil) then
        return nil;
    end;

    local CameraPart = CharacterResolver.getCameraPart(v29.Shell);

    if CameraPart == nil then
        return nil;
    end;

    local math_clamp_ret = math.clamp(v29.VerticalLook or 0, -1, 1);
    local math_asin_ret = math.asin(math_clamp_ret);
    local v30;

    if SurvivalDowned.IsDowned(p28) then
        v30 = CameraPart.Position - Vector3.new(0, SurvivalDowned.EYE_DROP, 0);
    else
        v30 = CameraPart.Position;
    end;

    return CFrame.new(v30) * CFrame.Angles(0, v29.LookYaw, 0) * CFrame.Angles(math_asin_ret, 0, 0);
end;

function u1.GetShell(p31: userdata) -- Line: 175
    -- upvalues: u2 (copy)
    local v32 = u2[p31];

    if v32 == nil or not v32.Visible then
        return nil;
    end;

    return v32.Shell;
end;

local function destroyPending(p33: userdata) -- Line: 180
    -- upvalues: u4 (copy)
    local v34 = u4[p33];

    if v34 == nil then
        return;
    end;

    u4[p33] = nil;
    v34.Janitor:Destroy();
end;

local function destroyEntry(p35: userdata, p36: boolean?) -- Line: 189
    -- upvalues: u2 (copy), u3 (copy), setEntryVisible (copy), RuntimeKinematics (copy)
    local v37 = u2[p35];

    if v37 == nil then
        return;
    end;

    u2[p35] = nil;

    if u3[p35.UserId] == v37 then
        u3[p35.UserId] = nil;
    end;

    if p36 ~= false and (v37.Shell.Parent ~= nil and (v37.Shell:GetAttribute("Dead") ~= true and p35.Character == v37.Shell)) then
        setEntryVisible(v37, true);
    end;

    RuntimeKinematics.clear(v37.Shell);
    v37.Janitor:Destroy();
end;

local function releaseHeldShell(p38: userdata) -- Line: 211
    -- upvalues: u12 (copy)
    local v39 = u12[p38];

    if v39 then
        u12[p38] = nil;
        v39:destroy();
    end;
end;

local function retireDeadEntry(p40: table) -- Line: 220
    -- upvalues: setEntryVisible (copy), u2 (copy), u3 (copy), RuntimeKinematics (copy), CharacterPresentationDescriptor (copy), u12 (copy), ClientCharacterPresentation (copy)
    local Player = p40.Player;
    local Shell = p40.Shell;

    if not p40.Visible or Shell.Parent == nil then
        setEntryVisible(p40, false);
        local v41 = u2[Player];

        if v41 == nil then
            return;
        end;

        u2[Player] = nil;

        if u3[Player.UserId] == v41 then
            u3[Player.UserId] = nil;
        end;

        RuntimeKinematics.clear(v41.Shell);
        v41.Janitor:Destroy();

        return;
    end;

    local Animator = p40.Animator;
    Animator:freezeAnimations();
    RuntimeKinematics.clear(Shell);
    Shell:SetAttribute(CharacterPresentationDescriptor.VisibleAttribute, false);

    for _, descendant in Shell:GetDescendants() do
        if descendant:IsA("BasePart") then
            descendant.CanQuery = false;
        end;
    end;

    u12[Shell] = Animator;
    p40.RetainAnimator = true;
    local v42 = u2[Player];

    if v42 ~= nil then
        u2[Player] = nil;

        if u3[Player.UserId] == v42 then
            u3[Player.UserId] = nil;
        end;

        RuntimeKinematics.clear(v42.Shell);
        v42.Janitor:Destroy();
    end;

    task.delay(1.5, function() -- Line: 244
        -- upvalues: u12 (ref), Shell (copy), Animator (copy), ClientCharacterPresentation (ref)
        if u12[Shell] ~= Animator then
            return;
        end;

        local v43 = Shell;
        local v44 = u12[v43];

        if v44 then
            u12[v43] = nil;
            v44:destroy();
        end;

        if Shell.Parent then
            Shell.Parent = ClientCharacterPresentation.GetCulledFolder();
        end;
    end);
end;

local function tryBind(u45: userdata, u46: userdata) -- Line: 255
    -- upvalues: LocalPlayer (copy), Players (copy), u4 (copy), u12 (copy), CharacterPresentationDescriptor (copy), ClientCharacterPresentation (copy), CharacterGeneration (copy), CharacterResolver (copy), u2 (copy), u3 (copy), setEntryVisible (copy), RuntimeKinematics (copy), Janitor (copy), CharacterAnimator (copy), CharacterPose (copy), decodeCurrentEquipped (copy), u1 (copy), retireDeadEntry (copy), Ragdoll (copy)
    if u45 == LocalPlayer or (u45.Parent ~= Players or (u45.Character ~= u46 or u46.Parent == nil)) then
        local v47 = u4[u45];

        if v47 ~= nil then
            u4[u45] = nil;
            v47.Janitor:Destroy();
        end;

        return false;
    end;

    if u46:GetAttribute("Dead") == true then
        if u12[u46] then
            local v48 = u4[u45];

            if v48 ~= nil then
                u4[u45] = nil;
                v48.Janitor:Destroy();
            end;

            return true;
        end;

        u46:SetAttribute(CharacterPresentationDescriptor.VisibleAttribute, false);
        u46.Parent = ClientCharacterPresentation.GetCulledFolder();
        local v49 = u4[u45];

        if v49 ~= nil then
            u4[u45] = nil;
            v49.Janitor:Destroy();
        end;

        return true;
    end;

    local v50 = CharacterGeneration.Get(u46);
    local v51 = CharacterResolver.resolve(u46);

    if v50 == nil or (v51 == nil or v51.Animator == nil) then
        return false;
    end;

    local v52 = u2[u45];

    if v52 ~= nil then
        u2[u45] = nil;

        if u3[u45.UserId] == v52 then
            u3[u45.UserId] = nil;
        end;

        if v52.Shell.Parent ~= nil and (v52.Shell:GetAttribute("Dead") ~= true and u45.Character == v52.Shell) then
            setEntryVisible(v52, true);
        end;

        RuntimeKinematics.clear(v52.Shell);
        v52.Janitor:Destroy();
    end;

    local v53 = u12[u46];

    if v53 then
        u12[u46] = nil;
        v53:destroy();
    end;

    local v54 = Janitor.new();
    local u55 = CharacterAnimator.new(u46);
    u55.Player = u45;
    local u56 = {
        Visible = true,
        LastPosePosition = nil,
        LookYaw = nil,
        VerticalLook = nil,
        LastAnimationUpdateAt = (-1 / 0),
        PresentedFrame = 0,
        RetainAnimator = false,
        Player = u45,
        Shell = u46,
        Generation = v50,
        RootPart = v51.RootPart,
        Joints = CharacterPose.getJoints(u46),
        Animator = u55
    };
    local v57;

    if u46.Parent == ClientCharacterPresentation.GetCulledFolder() then
        v57 = nil;
    else
        v57 = u46.Parent;
    end;

    u56.VisibleParent = v57;
    u56.Janitor = v54;
    u2[u45] = u56;
    u3[u45.UserId] = u56;
    local v58 = u4[u45];

    if v58 ~= nil then
        u4[u45] = nil;
        v58.Janitor:Destroy();
    end;

    v51.RootPart.Anchored = true;
    v51.RootPart.AssemblyLinearVelocity = Vector3.new(0, 0, 0);
    v51.RootPart.AssemblyAngularVelocity = Vector3.new(0, 0, 0);
    v54:Add(function() -- Line: 308
        -- upvalues: u56 (copy), u55 (copy)
        if not u56.RetainAnimator then
            u55:destroy();
        end;
    end);
    v54:Add(u45:GetAttributeChangedSignal("CurrentEquipped"):Connect(function() -- Line: 313
        -- upvalues: u2 (ref), u45 (copy), u56 (copy), decodeCurrentEquipped (ref)
        if u2[u45] == u56 then
            local v59 = u56;

            if not v59.Visible then
                return;
            end;

            local v60, v61 = decodeCurrentEquipped(v59.Player);
            v59.Animator:setWeapon(v60, v61, true);
        end;
    end));
    v54:Add(u46.DescendantAdded:Connect(function() -- Line: 318
        -- upvalues: u56 (copy), CharacterPose (ref), u46 (copy)
        if u56.Joints == nil then
            u56.Joints = CharacterPose.getJoints(u46);
        end;
    end));
    v54:Add(u46.DescendantRemoving:Connect(function(p62) -- Line: 323
        -- upvalues: u56 (copy), u2 (ref), u45 (copy), u3 (ref), setEntryVisible (ref), RuntimeKinematics (ref), u46 (copy), u1 (ref)
        local Joints = u56.Joints;

        if Joints ~= nil and (p62 == Joints.RightShoulder or (p62 == Joints.LeftShoulder or (p62 == Joints.Waist or p62 == Joints.Neck))) then
            u56.Joints = nil;
        end;

        if p62 == u56.RootPart or p62 == u56.Animator.Animator then
            task.defer(function() -- Line: 337
                -- upvalues: u2 (ref), u45 (ref), u56 (ref), u3 (ref), setEntryVisible (ref), RuntimeKinematics (ref), u46 (ref), u1 (ref)
                if u2[u45] == u56 then
                    local v63 = u45;
                    local v64 = u2[v63];

                    if v64 ~= nil then
                        u2[v63] = nil;

                        if u3[v63.UserId] == v64 then
                            u3[v63.UserId] = nil;
                        end;

                        if v64.Shell.Parent ~= nil and (v64.Shell:GetAttribute("Dead") ~= true and v63.Character == v64.Shell) then
                            setEntryVisible(v64, true);
                        end;

                        RuntimeKinematics.clear(v64.Shell);
                        v64.Janitor:Destroy();
                    end;

                    if u45.Character == u46 and u46.Parent ~= nil then
                        u1.Track(u45, u46);
                    end;
                end;
            end);
        end;
    end));
    v54:Add(u46.AncestryChanged:Connect(function(p65, p66) -- Line: 347
        -- upvalues: u2 (ref), u45 (copy), u56 (copy), u3 (ref), RuntimeKinematics (ref), ClientCharacterPresentation (ref)
        if p66 ~= nil or u2[u45] ~= u56 then
            if p66 ~= nil and (u2[u45] == u56 and (not u56.Visible and p66 ~= ClientCharacterPresentation.GetCulledFolder())) then
                task.defer(function() -- Line: 357
                    -- upvalues: u2 (ref), u45 (ref), u56 (ref), ClientCharacterPresentation (ref)
                    if u2[u45] == u56 and (not u56.Visible and u56.Shell.Parent ~= ClientCharacterPresentation.GetCulledFolder()) then
                        local v67 = u56;
                        local CulledFolder = ClientCharacterPresentation.GetCulledFolder();
                        local Parent = v67.Shell.Parent;

                        if Parent ~= nil and Parent ~= CulledFolder then
                            v67.VisibleParent = Parent;
                        end;

                        if v67.Shell.Parent ~= CulledFolder then
                            v67.Shell.Parent = CulledFolder;
                        end;
                    end;
                end);
            end;

            return;
        end;

        local v68 = u45;
        local v69 = u2[v68];

        if v69 == nil then
            return;
        end;

        u2[v68] = nil;

        if u3[v68.UserId] == v69 then
            u3[v68.UserId] = nil;
        end;

        RuntimeKinematics.clear(v69.Shell);
        v69.Janitor:Destroy();
    end));
    v54:Add(u46:GetAttributeChangedSignal("Dead"):Connect(function() -- Line: 368
        -- upvalues: u46 (copy), u2 (ref), u45 (copy), u56 (copy), retireDeadEntry (ref)
        if u46:GetAttribute("Dead") == true and u2[u45] == u56 then
            retireDeadEntry(u56);
        end;
    end));
    v54:Add(u46:GetAttributeChangedSignal(CharacterGeneration.AttributeName):Connect(function() -- Line: 373
        -- upvalues: CharacterGeneration (ref), u46 (copy), u56 (copy), u2 (ref), u45 (copy), u1 (ref)
        if CharacterGeneration.Get(u46) ~= u56.Generation and u2[u45] == u56 then
            u1.Track(u45, u46);
        end;
    end));

    if u56.Visible then
        local v70, v71 = decodeCurrentEquipped(u56.Player);
        u56.Animator:setWeapon(v70, v71, false);
    end;

    setEntryVisible(u56, false);
    task.spawn(function() -- Line: 382
        -- upvalues: u46 (copy), Ragdoll (ref), u45 (copy)
        if u46:IsDescendantOf(game) and u46:GetAttribute("Dead") ~= true then
            local success, result = pcall(Ragdoll.PrepareCharacter, u46);

            if not success then
                warn((`[RemoteCharacters] Ragdoll preparation failed for {u45.Name}: {result}`));
            end;
        end;
    end);

    return true;
end;

function u1.Track(u72: userdata, u73: userdata) -- Line: 393
    -- upvalues: LocalPlayer (copy), u2 (copy), CharacterGeneration (copy), u3 (copy), setEntryVisible (copy), RuntimeKinematics (copy), u4 (copy), tryBind (copy), Janitor (copy)
    if u72 == LocalPlayer or u72.Character ~= u73 then
        return;
    end;

    local v74 = u2[u72];

    if v74 ~= nil and (u73:GetAttribute("Dead") ~= true and (v74.Shell == u73 and v74.Generation == CharacterGeneration.Get(u73))) then
        return;
    end;

    local v75 = u2[u72];

    if v75 ~= nil then
        u2[u72] = nil;

        if u3[u72.UserId] == v75 then
            u3[u72.UserId] = nil;
        end;

        if v75.Shell.Parent ~= nil and (v75.Shell:GetAttribute("Dead") ~= true and u72.Character == v75.Shell) then
            setEntryVisible(v75, true);
        end;

        RuntimeKinematics.clear(v75.Shell);
        v75.Janitor:Destroy();
    end;

    local v76 = u4[u72];

    if v76 ~= nil and v76.Shell == u73 then
        tryBind(u72, u73);

        return;
    end;

    local v77 = u4[u72];

    if v77 ~= nil then
        u4[u72] = nil;
        v77.Janitor:Destroy();
    end;

    local v78 = Janitor.new();
    u4[u72] = {
        Shell = u73,
        Janitor = v78
    };

    local function retry() -- Line: 417
        -- upvalues: u4 (ref), u72 (copy), tryBind (ref), u73 (copy)
        if u4[u72] ~= nil then
            tryBind(u72, u73);
        end;
    end;

    v78:Add(u73.DescendantAdded:Connect(retry));
    v78:Add(u73:GetAttributeChangedSignal("CharacterType"):Connect(retry));
    v78:Add(u73:GetAttributeChangedSignal("Dead"):Connect(retry));
    v78:Add(u73:GetAttributeChangedSignal(CharacterGeneration.AttributeName):Connect(retry));
    v78:Add(u73.AncestryChanged:Connect(function() -- Line: 426
        -- upvalues: u73 (copy), u72 (copy), u4 (ref), tryBind (ref)
        if u73.Parent ~= nil then
            if u4[u72] ~= nil then
                tryBind(u72, u73);
            end;

            return;
        end;

        local v79 = u72;
        local v80 = u4[v79];

        if v80 == nil then
            return;
        end;

        u4[v79] = nil;
        v80.Janitor:Destroy();
    end));

    if u4[u72] ~= nil then
        tryBind(u72, u73);
    end;
end;

function u1.Untrack(p81: userdata, p82: userdata?) -- Line: 436
    -- upvalues: u2 (copy), u3 (copy), setEntryVisible (copy), RuntimeKinematics (copy), u4 (copy)
    local v83 = u2[p81];

    if v83 ~= nil and (p82 == nil or v83.Shell == p82) then
        local v84 = u2[p81];

        if v84 ~= nil then
            u2[p81] = nil;

            if u3[p81.UserId] == v84 then
                u3[p81.UserId] = nil;
            end;

            if v84.Shell.Parent ~= nil and (v84.Shell:GetAttribute("Dead") ~= true and p81.Character == v84.Shell) then
                setEntryVisible(v84, true);
            end;

            RuntimeKinematics.clear(v84.Shell);
            v84.Janitor:Destroy();
        end;
    end;

    local v85 = u4[p81];

    if v85 ~= nil and (p82 == nil or v85.Shell == p82) then
        local v86 = u4[p81];

        if v86 == nil then
            return;
        end;

        u4[p81] = nil;
        v86.Janitor:Destroy();
    end;
end;

function u1.Present(p87: table, p88: any) -- Line: 447
    -- upvalues: BotCharacters (copy), u6 (ref), u7 (copy), u8 (copy), u9 (copy), u10 (copy), u3 (copy), Players (copy), LocalPlayer (copy), CharacterGeneration (copy), u2 (copy), ClientCharacterPresentation (copy), u1 (copy), RootFrame (copy), CharacterPose (copy), Workspace (copy), setEntryVisible (copy), RuntimeKinematics (copy), SurvivalDowned (copy), retireDeadEntry (copy)
    BotCharacters.Present(p87);
    u6 = u6 + 1;
    table.clear(u7);
    table.clear(u8);
    table.clear(u9);
    table.clear(u10);

    for _, v in p87 do
        if v.UserId ~= 0 then
            local v89 = u3[v.UserId];
            local v90;

            if v89 == nil then
                v90 = Players:GetPlayerByUserId(v.UserId);
            else
                v90 = v89.Player;
            end;

            if v90 ~= nil and v90 ~= LocalPlayer then
                if v89 ~= nil and (v89.Generation == v.Generation and CharacterGeneration.Get(v89.Shell) == v.Generation) then
                    v89.PresentedFrame = u6;
                end;

                local RenderPose = v.RenderPose;

                if RenderPose ~= nil then
                    local v91 = u2[v90];
                    local Character = v90.Character;

                    if not (ClientCharacterPresentation.IsOwned(Character) and (Character ~= nil and CharacterGeneration.Get(Character) == RenderPose.Generation)) then
                        Character = ClientCharacterPresentation.Create(v90, RenderPose.Generation);
                    end;

                    if Character ~= nil and (v91 == nil or (v91.Shell ~= Character or v91.Generation ~= RenderPose.Generation)) then
                        u1.Track(v90, Character);
                        v91 = u2[v90];
                    end;

                    if v91 ~= nil and (Character ~= nil and (v91.Shell == Character and (v91.Shell.Parent ~= nil and (v91.Shell:GetAttribute("Dead") ~= true and (v91.Generation == RenderPose.Generation and CharacterGeneration.Get(v91.Shell) == RenderPose.Generation))))) then
                        v91.PresentedFrame = u6;
                        local v92 = RenderPose.VisualRootPosition or RootFrame.simulationToVisualRootPosition(RenderPose.Position, RenderPose.DuckAmount);
                        local v93 = CharacterPose.composeRootCFrame(v92, RenderPose.LookYaw);

                        if v91.RootPart.CFrame ~= v93 then
                            u7[#u7 + 1] = v91.RootPart;
                            u8[#u8 + 1] = v93;
                        end;

                        u9[#u9 + 1] = v91;
                        u10[#u10 + 1] = RenderPose;
                    end;
                end;
            end;
        end;
    end;

    if #u7 == 1 then
        u7[1].CFrame = u8[1];
    elseif #u7 > 1 then
        Workspace:BulkMoveTo(u7, u8, Enum.BulkMoveMode.FireCFrameChanged);
    end;

    local os_clock_ret = os.clock();
    local ServerTimeNow = Workspace:GetServerTimeNow();

    for i, v in u9 do
        local v94 = u10[i];
        local Visible = v.Visible;
        setEntryVisible(v, true);
        local LastPosePosition = v.LastPosePosition;
        local v95;

        if LastPosePosition == nil then
            v95 = false;
        else
            v95 = (v94.Position - LastPosePosition).Magnitude > 0.00001;
        end;

        local v96 = not v95 and Vector3.new(0, 0, 0) or v94.Velocity;
        RuntimeKinematics.write(v.Shell, v96, v94.OnGround);
        v.LastPosePosition = v94.Position;
        v.LookYaw = v94.LookYaw;
        v.VerticalLook = v94.VerticalLook;
        local v97 = os_clock_ret - v.LastAnimationUpdateAt;

        if not Visible or v97 >= 0.016666666666666666 then
            local v98 = v94.DuckAmount > 0.5;
            local v99 = v94.MovementMode == "Ladder";
            local v100 = SurvivalDowned.IsDowned(v.Player);
            v.Animator:setDowned(v100);
            local Animator = v.Animator;
            local v101;

            if v100 then
                local math_clamp_ret = math.clamp(v94.VerticalLook, -1, 1);
                v101 = math.asin(math_clamp_ret);
            else
                v101 = nil;
            end;

            Animator:setDownedAim(v101);
            v.Animator:updateLocomotion(v96, v94.OnGround, v98, v99);

            if v.Joints ~= nil then
                CharacterPose.applyVerticalLook(v.Joints, v100 and 0 or v94.VerticalLook, 0.003);
            end;

            v.Animator:setBlinded(ServerTimeNow < (v.Player:GetAttribute("FlashedUntil") or 0));
            local v102;

            if v97 == (1 / 0) then
                v102 = os_clock_ret;
            else
                v102 = v.LastAnimationUpdateAt + math.floor(v97 / 0.016666666666666666) * 0.016666666666666666;
            end;

            v.LastAnimationUpdateAt = v102;
        end;
    end;

    for i, v in u2 do
        if v.PresentedFrame ~= u6 then
            if i.Parent == Players and (i.Character == v.Shell and v.Shell.Parent ~= nil) then
                if v.Shell:GetAttribute("Dead") == true then
                    retireDeadEntry(v);
                elseif CharacterGeneration.Get(v.Shell) == v.Generation then
                    setEntryVisible(v, false);
                else
                    local Shell = v.Shell;
                    local v103 = u2[i];

                    if v103 ~= nil then
                        u2[i] = nil;

                        if u3[i.UserId] == v103 then
                            u3[i.UserId] = nil;
                        end;

                        RuntimeKinematics.clear(v103.Shell);
                        v103.Janitor:Destroy();
                    end;

                    ClientCharacterPresentation.Release(i, Shell);
                end;
            else
                local v104 = u2[i];

                if v104 ~= nil then
                    u2[i] = nil;

                    if u3[i.UserId] == v104 then
                        u3[i.UserId] = nil;
                    end;

                    RuntimeKinematics.clear(v104.Shell);
                    v104.Janitor:Destroy();
                end;
            end;
        end;
    end;
end;

function u1.Initialize() -- Line: 580
    -- upvalues: u5 (ref), BotCharacters (copy), Remotes (copy), Players (copy), LocalPlayer (copy), u2 (copy), CharacterActions (copy), CharacterGeneration (copy), u11 (ref), u3 (copy), RuntimeKinematics (copy), u4 (copy), ClientCharacterPresentation (copy)
    if u5 then
        return;
    end;

    u5 = true;
    BotCharacters.Initialize();
    Remotes.Character.Action.Listen(function(p105) -- Line: 587
        -- upvalues: Players (ref), LocalPlayer (ref), u2 (ref), CharacterActions (ref), CharacterGeneration (ref)
        local PlayerByUserId = Players:GetPlayerByUserId(p105.UserId);

        if PlayerByUserId == nil or PlayerByUserId == LocalPlayer then
            return;
        end;

        local v106 = u2[PlayerByUserId];
        local v107 = CharacterActions.ToName(p105.ActionId);

        if v106 ~= nil and (v106.Visible and (v106.Generation == p105.Generation and (CharacterGeneration.Get(v106.Shell) == p105.Generation and (PlayerByUserId.Character == v106.Shell and (v106.Shell:GetAttribute("Dead") ~= true and v107 ~= nil))))) then
            v106.Animator:playAction(v107);
        end;
    end);
    Players.PlayerRemoving:Connect(function(p108) -- Line: 606
        -- upvalues: u11 (ref), u2 (ref), u3 (ref), RuntimeKinematics (ref), u4 (ref), ClientCharacterPresentation (ref)
        if u11 == p108 then
            u11 = nil;
        end;

        local Character = p108.Character;
        local v109 = u2[p108];

        if v109 ~= nil then
            u2[p108] = nil;

            if u3[p108.UserId] == v109 then
                u3[p108.UserId] = nil;
            end;

            RuntimeKinematics.clear(v109.Shell);
            v109.Janitor:Destroy();
        end;

        local v110 = u4[p108];

        if v110 ~= nil then
            u4[p108] = nil;
            v110.Janitor:Destroy();
        end;

        ClientCharacterPresentation.Release(p108, Character);
    end);
end;

return u1;