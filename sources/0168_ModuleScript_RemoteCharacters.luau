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

local function restoreEntryParent(p13: table) -- Line: 68
    -- upvalues: ClientCharacterPresentation (copy), Workspace (copy)
    if p13.Shell.Parent ~= ClientCharacterPresentation.GetCulledFolder() then
        return;
    end;

    local VisibleParent = p13.VisibleParent;

    if VisibleParent == nil or not VisibleParent:IsDescendantOf(game) then
        VisibleParent = Workspace:FindFirstChild("Characters") or Workspace;
        p13.VisibleParent = VisibleParent;
    end;

    p13.Shell.Parent = VisibleParent;
end;

local function cullEntryFromWorkspace(p14: table) -- Line: 81
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

local function decodeCurrentEquipped(p15: userdata) -- Line: 93
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

    if typeof(result.Identifier) == "string" then
        return v16, result.Identifier;
    end;

    return v16, nil;
end;

local function syncEquippedWeapon(p17: table, p18: boolean) -- Line: 107
    -- upvalues: decodeCurrentEquipped (copy)
    if not p17.Visible then
        return;
    end;

    local v19, v20 = decodeCurrentEquipped(p17.Player);
    p17.Animator:setWeapon(v19, v20, p18);
end;

local function setEntryVisible(p21: table, p22: boolean) -- Line: 116
    -- upvalues: u11 (ref), RuntimeKinematics (copy), ClientCharacterPresentation (copy), Workspace (copy), CharacterPresentationDescriptor (copy), decodeCurrentEquipped (copy)
    local v23 = p21.Player == u11 and (p21.Visible and p21.Shell:GetAttribute("Dead") ~= true) and true or p22;

    if p21.Visible == v23 then
        if v23 then
            if p21.Shell.Parent ~= ClientCharacterPresentation.GetCulledFolder() then
                return;
            end;

            local VisibleParent = p21.VisibleParent;

            if VisibleParent == nil or not VisibleParent:IsDescendantOf(game) then
                VisibleParent = Workspace:FindFirstChild("Characters") or Workspace;
                p21.VisibleParent = VisibleParent;
            end;

            p21.Shell.Parent = VisibleParent;
        else
            RuntimeKinematics.clear(p21.Shell);
            local CulledFolder = ClientCharacterPresentation.GetCulledFolder();
            local Parent = p21.Shell.Parent;

            if Parent ~= nil and Parent ~= CulledFolder then
                p21.VisibleParent = Parent;
            end;

            if p21.Shell.Parent ~= CulledFolder then
                p21.Shell.Parent = CulledFolder;

                return;
            end;
        end;

        return;
    end;

    p21.Visible = v23;

    if v23 then
        if p21.Shell.Parent == ClientCharacterPresentation.GetCulledFolder() then
            local VisibleParent = p21.VisibleParent;

            if VisibleParent == nil or not VisibleParent:IsDescendantOf(game) then
                VisibleParent = Workspace:FindFirstChild("Characters") or Workspace;
                p21.VisibleParent = VisibleParent;
            end;

            p21.Shell.Parent = VisibleParent;
        end;

        p21.Shell:SetAttribute(CharacterPresentationDescriptor.VisibleAttribute, true);

        if not p21.Visible then
            return;
        end;

        local v24, v25 = decodeCurrentEquipped(p21.Player);
        p21.Animator:setWeapon(v24, v25, false);

        return;
    end;

    p21.Shell:SetAttribute(CharacterPresentationDescriptor.VisibleAttribute, false);
    p21.Animator:stopAnimations(0);
    RuntimeKinematics.clear(p21.Shell);
    local CulledFolder = ClientCharacterPresentation.GetCulledFolder();
    local Parent = p21.Shell.Parent;

    if Parent ~= nil and Parent ~= CulledFolder then
        p21.VisibleParent = Parent;
    end;

    if p21.Shell.Parent ~= CulledFolder then
        p21.Shell.Parent = CulledFolder;
    end;
end;

function u1.SetPinnedPlayer(p26: userdata?) -- Line: 146
    -- upvalues: u11 (ref)
    u11 = p26;
end;

function u1.GetCamera(p27: userdata) -- Line: 151
    -- upvalues: u2 (copy), CharacterResolver (copy)
    local v28 = u2[p27];

    if v28 == nil or (not v28.Visible or v28.LookYaw == nil) then
        return nil;
    end;

    local CameraPart = CharacterResolver.getCameraPart(v28.Shell);

    if CameraPart == nil then
        return nil;
    end;

    local math_clamp_ret = math.clamp(v28.VerticalLook or 0, -1, 1);
    local math_asin_ret = math.asin(math_clamp_ret);

    return CFrame.new(CameraPart.Position) * CFrame.Angles(0, v28.LookYaw, 0) * CFrame.Angles(math_asin_ret, 0, 0);
end;

local function destroyPending(p29: userdata) -- Line: 164
    -- upvalues: u4 (copy)
    local v30 = u4[p29];

    if v30 == nil then
        return;
    end;

    u4[p29] = nil;
    v30.Janitor:Destroy();
end;

local function destroyEntry(p31: userdata, p32: boolean?) -- Line: 173
    -- upvalues: u2 (copy), u3 (copy), setEntryVisible (copy), RuntimeKinematics (copy)
    local v33 = u2[p31];

    if v33 == nil then
        return;
    end;

    u2[p31] = nil;

    if u3[p31.UserId] == v33 then
        u3[p31.UserId] = nil;
    end;

    if p32 ~= false and (v33.Shell.Parent ~= nil and (v33.Shell:GetAttribute("Dead") ~= true and p31.Character == v33.Shell)) then
        setEntryVisible(v33, true);
    end;

    RuntimeKinematics.clear(v33.Shell);
    v33.Janitor:Destroy();
end;

local function releaseHeldShell(p34: userdata) -- Line: 195
    -- upvalues: u12 (copy)
    local v35 = u12[p34];

    if v35 then
        u12[p34] = nil;
        v35:destroy();
    end;
end;

local function retireDeadEntry(p36: table) -- Line: 204
    -- upvalues: setEntryVisible (copy), u2 (copy), u3 (copy), RuntimeKinematics (copy), CharacterPresentationDescriptor (copy), u12 (copy), ClientCharacterPresentation (copy)
    local Player = p36.Player;
    local Shell = p36.Shell;

    if not p36.Visible or Shell.Parent == nil then
        setEntryVisible(p36, false);
        local v37 = u2[Player];

        if v37 == nil then
            return;
        end;

        u2[Player] = nil;

        if u3[Player.UserId] == v37 then
            u3[Player.UserId] = nil;
        end;

        RuntimeKinematics.clear(v37.Shell);
        v37.Janitor:Destroy();

        return;
    end;

    local Animator = p36.Animator;
    Animator:freezeAnimations();
    RuntimeKinematics.clear(Shell);
    Shell:SetAttribute(CharacterPresentationDescriptor.VisibleAttribute, false);

    for _, descendant in Shell:GetDescendants() do
        if descendant:IsA("BasePart") then
            descendant.CanQuery = false;
        end;
    end;

    u12[Shell] = Animator;
    p36.RetainAnimator = true;
    local v38 = u2[Player];

    if v38 ~= nil then
        u2[Player] = nil;

        if u3[Player.UserId] == v38 then
            u3[Player.UserId] = nil;
        end;

        RuntimeKinematics.clear(v38.Shell);
        v38.Janitor:Destroy();
    end;

    task.delay(1.5, function() -- Line: 228
        -- upvalues: u12 (ref), Shell (copy), Animator (copy), ClientCharacterPresentation (ref)
        if u12[Shell] ~= Animator then
            return;
        end;

        local v39 = Shell;
        local v40 = u12[v39];

        if v40 then
            u12[v39] = nil;
            v40:destroy();
        end;

        if Shell.Parent then
            Shell.Parent = ClientCharacterPresentation.GetCulledFolder();
        end;
    end);
end;

local function tryBind(u41: userdata, u42: userdata) -- Line: 239
    -- upvalues: LocalPlayer (copy), Players (copy), u4 (copy), u12 (copy), CharacterPresentationDescriptor (copy), ClientCharacterPresentation (copy), CharacterGeneration (copy), CharacterResolver (copy), u2 (copy), u3 (copy), setEntryVisible (copy), RuntimeKinematics (copy), Janitor (copy), CharacterAnimator (copy), CharacterPose (copy), decodeCurrentEquipped (copy), u1 (copy), retireDeadEntry (copy), Ragdoll (copy)
    if u41 == LocalPlayer or (u41.Parent ~= Players or (u41.Character ~= u42 or u42.Parent == nil)) then
        local v43 = u4[u41];

        if v43 ~= nil then
            u4[u41] = nil;
            v43.Janitor:Destroy();
        end;

        return false;
    end;

    if u42:GetAttribute("Dead") == true then
        if u12[u42] then
            local v44 = u4[u41];

            if v44 ~= nil then
                u4[u41] = nil;
                v44.Janitor:Destroy();
            end;

            return true;
        end;

        u42:SetAttribute(CharacterPresentationDescriptor.VisibleAttribute, false);
        u42.Parent = ClientCharacterPresentation.GetCulledFolder();
        local v45 = u4[u41];

        if v45 ~= nil then
            u4[u41] = nil;
            v45.Janitor:Destroy();
        end;

        return true;
    end;

    local v46 = CharacterGeneration.Get(u42);
    local v47 = CharacterResolver.resolve(u42);

    if v46 == nil or (v47 == nil or v47.Animator == nil) then
        return false;
    end;

    local v48 = u2[u41];

    if v48 ~= nil then
        u2[u41] = nil;

        if u3[u41.UserId] == v48 then
            u3[u41.UserId] = nil;
        end;

        if v48.Shell.Parent ~= nil and (v48.Shell:GetAttribute("Dead") ~= true and u41.Character == v48.Shell) then
            setEntryVisible(v48, true);
        end;

        RuntimeKinematics.clear(v48.Shell);
        v48.Janitor:Destroy();
    end;

    local v49 = u12[u42];

    if v49 then
        u12[u42] = nil;
        v49:destroy();
    end;

    local v50 = Janitor.new();
    local u51 = CharacterAnimator.new(u42);
    u51.Player = u41;
    local u52 = {
        Visible = true,
        LastPosePosition = nil,
        LookYaw = nil,
        VerticalLook = nil,
        LastAnimationUpdateAt = (-1 / 0),
        PresentedFrame = 0,
        RetainAnimator = false,
        Player = u41,
        Shell = u42,
        Generation = v46,
        RootPart = v47.RootPart,
        Joints = CharacterPose.getJoints(u42),
        Animator = u51,
        VisibleParent = u42.Parent,
        Janitor = v50
    };
    u2[u41] = u52;
    u3[u41.UserId] = u52;
    local v53 = u4[u41];

    if v53 ~= nil then
        u4[u41] = nil;
        v53.Janitor:Destroy();
    end;

    v47.RootPart.Anchored = true;
    v47.RootPart.AssemblyLinearVelocity = Vector3.new(0, 0, 0);
    v47.RootPart.AssemblyAngularVelocity = Vector3.new(0, 0, 0);
    v50:Add(function() -- Line: 291
        -- upvalues: u52 (copy), u51 (copy)
        if not u52.RetainAnimator then
            u51:destroy();
        end;
    end);
    v50:Add(u41:GetAttributeChangedSignal("CurrentEquipped"):Connect(function() -- Line: 296
        -- upvalues: u2 (ref), u41 (copy), u52 (copy), decodeCurrentEquipped (ref)
        if u2[u41] == u52 then
            local v54 = u52;

            if not v54.Visible then
                return;
            end;

            local v55, v56 = decodeCurrentEquipped(v54.Player);
            v54.Animator:setWeapon(v55, v56, true);
        end;
    end));
    v50:Add(u42.DescendantAdded:Connect(function() -- Line: 301
        -- upvalues: u52 (copy), CharacterPose (ref), u42 (copy)
        if u52.Joints == nil then
            u52.Joints = CharacterPose.getJoints(u42);
        end;
    end));
    v50:Add(u42.DescendantRemoving:Connect(function(p57) -- Line: 306
        -- upvalues: u52 (copy), u2 (ref), u41 (copy), u3 (ref), setEntryVisible (ref), RuntimeKinematics (ref), u42 (copy), u1 (ref)
        local Joints = u52.Joints;

        if Joints ~= nil and (p57 == Joints.RightShoulder or (p57 == Joints.LeftShoulder or (p57 == Joints.Waist or p57 == Joints.Neck))) then
            u52.Joints = nil;
        end;

        if p57 == u52.RootPart or p57 == u52.Animator.Animator then
            task.defer(function() -- Line: 320
                -- upvalues: u2 (ref), u41 (ref), u52 (ref), u3 (ref), setEntryVisible (ref), RuntimeKinematics (ref), u42 (ref), u1 (ref)
                if u2[u41] == u52 then
                    local v58 = u41;
                    local v59 = u2[v58];

                    if v59 ~= nil then
                        u2[v58] = nil;

                        if u3[v58.UserId] == v59 then
                            u3[v58.UserId] = nil;
                        end;

                        if v59.Shell.Parent ~= nil and (v59.Shell:GetAttribute("Dead") ~= true and v58.Character == v59.Shell) then
                            setEntryVisible(v59, true);
                        end;

                        RuntimeKinematics.clear(v59.Shell);
                        v59.Janitor:Destroy();
                    end;

                    if u41.Character == u42 and u42.Parent ~= nil then
                        u1.Track(u41, u42);
                    end;
                end;
            end);
        end;
    end));
    v50:Add(u42.AncestryChanged:Connect(function(p60, p61) -- Line: 330
        -- upvalues: u2 (ref), u41 (copy), u52 (copy), u3 (ref), RuntimeKinematics (ref), ClientCharacterPresentation (ref)
        if p61 ~= nil or u2[u41] ~= u52 then
            if p61 ~= nil and (u2[u41] == u52 and (not u52.Visible and p61 ~= ClientCharacterPresentation.GetCulledFolder())) then
                task.defer(function() -- Line: 340
                    -- upvalues: u2 (ref), u41 (ref), u52 (ref), ClientCharacterPresentation (ref)
                    if u2[u41] == u52 and (not u52.Visible and u52.Shell.Parent ~= ClientCharacterPresentation.GetCulledFolder()) then
                        local v62 = u52;
                        local CulledFolder = ClientCharacterPresentation.GetCulledFolder();
                        local Parent = v62.Shell.Parent;

                        if Parent ~= nil and Parent ~= CulledFolder then
                            v62.VisibleParent = Parent;
                        end;

                        if v62.Shell.Parent ~= CulledFolder then
                            v62.Shell.Parent = CulledFolder;
                        end;
                    end;
                end);
            end;

            return;
        end;

        local v63 = u41;
        local v64 = u2[v63];

        if v64 == nil then
            return;
        end;

        u2[v63] = nil;

        if u3[v63.UserId] == v64 then
            u3[v63.UserId] = nil;
        end;

        RuntimeKinematics.clear(v64.Shell);
        v64.Janitor:Destroy();
    end));
    v50:Add(u42:GetAttributeChangedSignal("Dead"):Connect(function() -- Line: 351
        -- upvalues: u42 (copy), u2 (ref), u41 (copy), u52 (copy), retireDeadEntry (ref)
        if u42:GetAttribute("Dead") == true and u2[u41] == u52 then
            retireDeadEntry(u52);
        end;
    end));
    v50:Add(u42:GetAttributeChangedSignal(CharacterGeneration.AttributeName):Connect(function() -- Line: 356
        -- upvalues: CharacterGeneration (ref), u42 (copy), u52 (copy), u2 (ref), u41 (copy), u1 (ref)
        if CharacterGeneration.Get(u42) ~= u52.Generation and u2[u41] == u52 then
            u1.Track(u41, u42);
        end;
    end));

    if u52.Visible then
        local v65, v66 = decodeCurrentEquipped(u52.Player);
        u52.Animator:setWeapon(v65, v66, false);
    end;

    setEntryVisible(u52, false);
    task.spawn(function() -- Line: 365
        -- upvalues: u42 (copy), Ragdoll (ref), u41 (copy)
        if u42:IsDescendantOf(game) and u42:GetAttribute("Dead") ~= true then
            local success, result = pcall(Ragdoll.PrepareCharacter, u42);

            if not success then
                warn((`[RemoteCharacters] Ragdoll preparation failed for {u41.Name}: {result}`));
            end;
        end;
    end);

    return true;
end;

function u1.Track(u67: userdata, u68: userdata) -- Line: 376
    -- upvalues: LocalPlayer (copy), u2 (copy), CharacterGeneration (copy), u3 (copy), setEntryVisible (copy), RuntimeKinematics (copy), u4 (copy), tryBind (copy), Janitor (copy)
    if u67 == LocalPlayer or u67.Character ~= u68 then
        return;
    end;

    local v69 = u2[u67];

    if v69 ~= nil and (u68:GetAttribute("Dead") ~= true and (v69.Shell == u68 and v69.Generation == CharacterGeneration.Get(u68))) then
        return;
    end;

    local v70 = u2[u67];

    if v70 ~= nil then
        u2[u67] = nil;

        if u3[u67.UserId] == v70 then
            u3[u67.UserId] = nil;
        end;

        if v70.Shell.Parent ~= nil and (v70.Shell:GetAttribute("Dead") ~= true and u67.Character == v70.Shell) then
            setEntryVisible(v70, true);
        end;

        RuntimeKinematics.clear(v70.Shell);
        v70.Janitor:Destroy();
    end;

    local v71 = u4[u67];

    if v71 ~= nil and v71.Shell == u68 then
        tryBind(u67, u68);

        return;
    end;

    local v72 = u4[u67];

    if v72 ~= nil then
        u4[u67] = nil;
        v72.Janitor:Destroy();
    end;

    local v73 = Janitor.new();
    u4[u67] = {
        Shell = u68,
        Janitor = v73
    };

    local function retry() -- Line: 400
        -- upvalues: u4 (ref), u67 (copy), tryBind (ref), u68 (copy)
        if u4[u67] ~= nil then
            tryBind(u67, u68);
        end;
    end;

    v73:Add(u68.DescendantAdded:Connect(retry));
    v73:Add(u68:GetAttributeChangedSignal("CharacterType"):Connect(retry));
    v73:Add(u68:GetAttributeChangedSignal("Dead"):Connect(retry));
    v73:Add(u68:GetAttributeChangedSignal(CharacterGeneration.AttributeName):Connect(retry));
    v73:Add(u68.AncestryChanged:Connect(function() -- Line: 409
        -- upvalues: u68 (copy), u67 (copy), u4 (ref), tryBind (ref)
        if u68.Parent ~= nil then
            if u4[u67] ~= nil then
                tryBind(u67, u68);
            end;

            return;
        end;

        local v74 = u67;
        local v75 = u4[v74];

        if v75 == nil then
            return;
        end;

        u4[v74] = nil;
        v75.Janitor:Destroy();
    end));

    if u4[u67] ~= nil then
        tryBind(u67, u68);
    end;
end;

function u1.Untrack(p76: userdata, p77: userdata?) -- Line: 419
    -- upvalues: u2 (copy), u3 (copy), setEntryVisible (copy), RuntimeKinematics (copy), u4 (copy)
    local v78 = u2[p76];

    if v78 ~= nil and (p77 == nil or v78.Shell == p77) then
        local v79 = u2[p76];

        if v79 ~= nil then
            u2[p76] = nil;

            if u3[p76.UserId] == v79 then
                u3[p76.UserId] = nil;
            end;

            if v79.Shell.Parent ~= nil and (v79.Shell:GetAttribute("Dead") ~= true and p76.Character == v79.Shell) then
                setEntryVisible(v79, true);
            end;

            RuntimeKinematics.clear(v79.Shell);
            v79.Janitor:Destroy();
        end;
    end;

    local v80 = u4[p76];

    if v80 ~= nil and (p77 == nil or v80.Shell == p77) then
        local v81 = u4[p76];

        if v81 == nil then
            return;
        end;

        u4[p76] = nil;
        v81.Janitor:Destroy();
    end;
end;

function u1.Present(p82: table, p83: any) -- Line: 430
    -- upvalues: BotCharacters (copy), u6 (ref), u7 (copy), u8 (copy), u9 (copy), u10 (copy), u3 (copy), Players (copy), LocalPlayer (copy), CharacterGeneration (copy), u2 (copy), ClientCharacterPresentation (copy), u1 (copy), RootFrame (copy), CharacterPose (copy), Workspace (copy), setEntryVisible (copy), RuntimeKinematics (copy), retireDeadEntry (copy)
    BotCharacters.Present(p82);
    u6 = u6 + 1;
    table.clear(u7);
    table.clear(u8);
    table.clear(u9);
    table.clear(u10);

    for _, v in p82 do
        if v.UserId ~= 0 then
            local v84 = u3[v.UserId];
            local v85;

            if v84 == nil then
                v85 = Players:GetPlayerByUserId(v.UserId);
            else
                v85 = v84.Player;
            end;

            if v85 ~= nil and v85 ~= LocalPlayer then
                if v84 ~= nil and (v84.Generation == v.Generation and CharacterGeneration.Get(v84.Shell) == v.Generation) then
                    v84.PresentedFrame = u6;
                end;

                local RenderPose = v.RenderPose;

                if RenderPose ~= nil then
                    local v86 = u2[v85];
                    local Character = v85.Character;

                    if not (ClientCharacterPresentation.IsOwned(Character) and (Character ~= nil and CharacterGeneration.Get(Character) == RenderPose.Generation)) then
                        Character = ClientCharacterPresentation.Create(v85, RenderPose.Generation);
                    end;

                    if Character ~= nil and (v86 == nil or (v86.Shell ~= Character or v86.Generation ~= RenderPose.Generation)) then
                        u1.Track(v85, Character);
                        v86 = u2[v85];
                    end;

                    if v86 ~= nil and (Character ~= nil and (v86.Shell == Character and (v86.Shell.Parent ~= nil and (v86.Shell:GetAttribute("Dead") ~= true and (v86.Generation == RenderPose.Generation and CharacterGeneration.Get(v86.Shell) == RenderPose.Generation))))) then
                        v86.PresentedFrame = u6;
                        local v87 = RenderPose.VisualRootPosition or RootFrame.simulationToVisualRootPosition(RenderPose.Position, RenderPose.DuckAmount);
                        local v88 = CharacterPose.composeRootCFrame(v87, RenderPose.LookYaw);

                        if v86.RootPart.CFrame ~= v88 then
                            u7[#u7 + 1] = v86.RootPart;
                            u8[#u8 + 1] = v88;
                        end;

                        u9[#u9 + 1] = v86;
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

    for i, v in u9 do
        local v89 = u10[i];
        local Visible = v.Visible;
        setEntryVisible(v, true);
        local LastPosePosition = v.LastPosePosition;
        local v90;

        if LastPosePosition == nil then
            v90 = false;
        else
            v90 = (v89.Position - LastPosePosition).Magnitude > 0.00001;
        end;

        local v91 = not v90 and Vector3.new(0, 0, 0) or v89.Velocity;
        RuntimeKinematics.write(v.Shell, v91, v89.OnGround);
        v.LastPosePosition = v89.Position;
        v.LookYaw = v89.LookYaw;
        v.VerticalLook = v89.VerticalLook;
        local v92 = os_clock_ret - v.LastAnimationUpdateAt;

        if not Visible or v92 >= 0.016666666666666666 then
            v.Animator:updateLocomotion(v91, v89.OnGround, v89.DuckAmount > 0.5, v89.MovementMode == "Ladder");

            if v.Joints ~= nil then
                CharacterPose.applyVerticalLook(v.Joints, v89.VerticalLook, 0.003);
            end;

            local v93;

            if v92 == (1 / 0) then
                v93 = os_clock_ret;
            else
                v93 = v.LastAnimationUpdateAt + math.floor(v92 / 0.016666666666666666) * 0.016666666666666666;
            end;

            v.LastAnimationUpdateAt = v93;
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
                    local v94 = u2[i];

                    if v94 ~= nil then
                        u2[i] = nil;

                        if u3[i.UserId] == v94 then
                            u3[i.UserId] = nil;
                        end;

                        RuntimeKinematics.clear(v94.Shell);
                        v94.Janitor:Destroy();
                    end;

                    ClientCharacterPresentation.Release(i, Shell);
                end;
            else
                local v95 = u2[i];

                if v95 ~= nil then
                    u2[i] = nil;

                    if u3[i.UserId] == v95 then
                        u3[i.UserId] = nil;
                    end;

                    RuntimeKinematics.clear(v95.Shell);
                    v95.Janitor:Destroy();
                end;
            end;
        end;
    end;
end;

function u1.Initialize() -- Line: 554
    -- upvalues: u5 (ref), BotCharacters (copy), Remotes (copy), Players (copy), LocalPlayer (copy), u2 (copy), CharacterActions (copy), CharacterGeneration (copy), u11 (ref), u3 (copy), RuntimeKinematics (copy), u4 (copy), ClientCharacterPresentation (copy)
    if u5 then
        return;
    end;

    u5 = true;
    BotCharacters.Initialize();
    Remotes.Character.Action.Listen(function(p96) -- Line: 561
        -- upvalues: Players (ref), LocalPlayer (ref), u2 (ref), CharacterActions (ref), CharacterGeneration (ref)
        local PlayerByUserId = Players:GetPlayerByUserId(p96.UserId);

        if PlayerByUserId == nil or PlayerByUserId == LocalPlayer then
            return;
        end;

        local v97 = u2[PlayerByUserId];
        local v98 = CharacterActions.ToName(p96.ActionId);

        if v97 ~= nil and (v97.Visible and (v97.Generation == p96.Generation and (CharacterGeneration.Get(v97.Shell) == p96.Generation and (PlayerByUserId.Character == v97.Shell and (v97.Shell:GetAttribute("Dead") ~= true and v98 ~= nil))))) then
            v97.Animator:playAction(v98);
        end;
    end);
    Players.PlayerRemoving:Connect(function(p99) -- Line: 580
        -- upvalues: u11 (ref), u2 (ref), u3 (ref), RuntimeKinematics (ref), u4 (ref), ClientCharacterPresentation (ref)
        if u11 == p99 then
            u11 = nil;
        end;

        local Character = p99.Character;
        local v100 = u2[p99];

        if v100 ~= nil then
            u2[p99] = nil;

            if u3[p99.UserId] == v100 then
                u3[p99.UserId] = nil;
            end;

            RuntimeKinematics.clear(v100.Shell);
            v100.Janitor:Destroy();
        end;

        local v101 = u4[p99];

        if v101 ~= nil then
            u4[p99] = nil;
            v101.Janitor:Destroy();
        end;

        ClientCharacterPresentation.Release(p99, Character);
    end);
end;

return u1;