-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Workspace = game:GetService("Workspace");
local HttpService = game:GetService("HttpService");
local Common = ReplicatedStorage.Components.Common;
local BotPresentationState = require(Common.BotPresentationState);
local BotWeaponModel = require(Common.BotWeaponModel);
local BotWeaponEffects = require(Common.BotWeaponEffects);
local BotWeaponRecoil = require(Common.BotWeaponRecoil);
local CharacterGeneration = require(Common.CharacterGeneration);
local CharacterPose = require(Common.CharacterPose);
local CharacterResolver = require(Common.CharacterResolver);
local ClientCharacterPresentation = require(Common.ClientCharacterPresentation);
local CharacterPresentationDescriptor = require(Common.CharacterPresentationDescriptor);
local CharacterAnimator = require(ReplicatedStorage.Classes.Character.Classes.CharacterAnimator);
local RootFrame = require(ReplicatedStorage.MovementV2.RootFrame);
local RuntimeKinematics = require(ReplicatedStorage.MovementV2.RuntimeKinematics);
local BotCombatCodec = require(ReplicatedStorage.MovementV2.BotCombatCodec);
local Transport = require(ReplicatedStorage.MovementV2.Transport);
local Janitor = require(ReplicatedStorage.Shared.Janitor);
local Signal = require(ReplicatedStorage.Packages.Signal);
local Defuser = require(ReplicatedStorage.Controllers.Observers.Character.Components.Defuser);
local Ragdoll = require(ReplicatedStorage.Classes.Ragdoll);
local u1 = {
    CombatEvent = Signal.new()
};
local u2 = {};
local u3 = {};
local u4 = {};
local u5 = {};
local u6 = {};
local u7 = {};
local u8 = {};
local u9 = {};
local u10 = {};
local u11 = 0;
local u12 = false;
local u13 = nil;
local u14 = nil;
local u15 = {};
local u16 = {};
local u17 = {};

local function destroyShell(p18: table) -- Line: 83
    -- upvalues: BotWeaponModel (copy), RuntimeKinematics (copy)
    BotWeaponModel.destroy(p18.Weapon);
    BotWeaponModel.clear(p18.Shell);
    RuntimeKinematics.clear(p18.Shell);

    if p18.Defuser then
        p18.Defuser:Destroy();
    end;

    p18.Animator:destroy();
    p18.Shell:Destroy();
end;

local function releaseCorpseSource(p19: number, p20: table?) -- Line: 95
    -- upvalues: u16 (copy), destroyShell (copy)
    local v21 = u16[p19];

    if v21 == nil or p20 ~= nil and v21 ~= p20 then
        return;
    end;

    u16[p19] = nil;
    destroyShell(v21);
end;

local function destroyEntry(p22: table) -- Line: 104
    -- upvalues: destroyShell (copy)
    local Entry = p22.Entry;

    if Entry ~= nil then
        p22.Entry = nil;
        destroyShell(Entry);
    end;
end;

local function hide(p23: table) -- Line: 112
    -- upvalues: CharacterPresentationDescriptor (copy), RuntimeKinematics (copy), ClientCharacterPresentation (copy)
    if p23.Visible then
        p23.Visible = false;
        p23.Shell:SetAttribute(CharacterPresentationDescriptor.VisibleAttribute, false);
        p23.Animator:stopAnimations(0);
        RuntimeKinematics.clear(p23.Shell);
        p23.LastPosition = nil;
    end;

    p23.Shell.Parent = ClientCharacterPresentation.GetCulledFolder();
end;

local function cullCorpseShell(p24: table) -- Line: 124
    -- upvalues: BotWeaponModel (copy), hide (copy)
    BotWeaponModel.destroy(p24.Weapon);
    BotWeaponModel.clear(p24.Shell);
    p24.Weapon = nil;

    if p24.Defuser then
        p24.Defuser:Destroy();
        p24.Defuser = nil;
    end;

    hide(p24);
end;

local function retireToCorpse(p25: table) -- Line: 137
    -- upvalues: CharacterPresentationDescriptor (copy), RuntimeKinematics (copy), BotWeaponModel (copy), hide (copy), u15 (copy), destroyShell (copy)
    local Entry = p25.Entry;

    if Entry == nil then
        return;
    end;

    p25.Entry = nil;
    p25.CorpseGeneration = Entry.Descriptor.Generation;
    Entry.Shell:SetAttribute("Health", 0);
    Entry.Shell:SetAttribute("Dead", true);

    if Entry.Visible then
        Entry.Shell:SetAttribute(CharacterPresentationDescriptor.VisibleAttribute, false);
        Entry.Animator:freezeAnimations();
        RuntimeKinematics.clear(Entry.Shell);

        for _, descendant in Entry.Shell:GetDescendants() do
            if descendant:IsA("BasePart") then
                descendant.CanQuery = false;
            end;
        end;

        task.delay(1.5, function() -- Line: 156
            -- upvalues: Entry (copy), BotWeaponModel (ref), hide (ref)
            if Entry.Shell.Parent ~= nil then
                local v26 = Entry;
                BotWeaponModel.destroy(v26.Weapon);
                BotWeaponModel.clear(v26.Shell);
                v26.Weapon = nil;

                if v26.Defuser then
                    v26.Defuser:Destroy();
                    v26.Defuser = nil;
                end;

                hide(v26);
            end;
        end);
    else
        BotWeaponModel.destroy(Entry.Weapon);
        BotWeaponModel.clear(Entry.Shell);
        Entry.Weapon = nil;

        if Entry.Defuser then
            Entry.Defuser:Destroy();
            Entry.Defuser = nil;
        end;

        hide(Entry);
    end;

    local v27 = u15[Entry.Descriptor.CombatantId];

    if v27 then
        destroyShell(v27.Entry);
    end;

    u15[Entry.Descriptor.CombatantId] = {
        Entry = Entry,
        Generation = Entry.Descriptor.Generation,
        ExpiresAt = os.clock() + 1.5
    };
end;

local function releaseEntry(p28: table, p29: any) -- Line: 175
    -- upvalues: retireToCorpse (copy), destroyShell (copy)
    if p28.Entry ~= nil and (p29 ~= nil and (p29.Dead or p29.Health <= 0)) then
        retireToCorpse(p28);

        return;
    end;

    local Entry = p28.Entry;

    if Entry ~= nil then
        p28.Entry = nil;
        destroyShell(Entry);
    end;
end;

local function readDescriptor(p30: userdata) -- Line: 184
    -- upvalues: BotPresentationState (copy)
    local Attribute = p30:GetAttribute("WeaponName");
    local Attribute2 = p30:GetAttribute("WeaponRevision");
    local Attribute3 = p30:GetAttribute("ObjectiveAction");
    local v31 = {
        BotLoadout = p30:GetAttribute("BotLoadout"),
        CombatantId = p30:GetAttribute("CombatantId"),
        ActorId = p30:GetAttribute("ActorId"),
        Generation = p30:GetAttribute("Generation"),
        DisplayName = p30:GetAttribute("DisplayName"),
        Team = p30:GetAttribute("Team"),
        CharacterName = p30:GetAttribute("CharacterName"),
        Health = p30:GetAttribute("Health"),
        MaxHealth = p30:GetAttribute("MaxHealth"),
        Dead = p30:GetAttribute("Dead")
    };

    if Attribute3 ~= "Planting" and Attribute3 ~= "Defusing" then
        Attribute3 = nil;
    end;

    v31.ObjectiveAction = Attribute3;
    v31.WeaponName = (type(Attribute) ~= "string" or #Attribute > 48) and "" or Attribute;
    v31.WeaponRevision = (type(Attribute2) ~= "number" or (Attribute2 < 0 or (Attribute2 > 4294967295 or Attribute2 % 1 ~= 0))) and 0 or Attribute2;

    if BotPresentationState.validate(v31) and p30.Name == tostring(v31.CombatantId) then
        return v31;
    end;

    return nil;
end;

local function refresh(p32: userdata, p33: table) -- Line: 215
    -- upvalues: readDescriptor (copy), u3 (copy), BotPresentationState (copy), retireToCorpse (copy), destroyShell (copy)
    local v34 = readDescriptor(p32);
    local Descriptor = p33.Descriptor;

    if Descriptor ~= nil and u3[Descriptor.ActorId] == p33 then
        u3[Descriptor.ActorId] = nil;
    end;

    if v34 ~= nil then
        u3[v34.ActorId] = p33;

        if Descriptor == nil or not BotPresentationState.sameLife(Descriptor, v34) then
            p33.LastEventSequence = nil;
        end;
    end;

    local Entry = p33.Entry;

    if Entry ~= nil then
        if v34 == nil or not (BotPresentationState.sameLife(Entry.Descriptor, v34) and (Entry.Descriptor.CharacterName == v34.CharacterName and (Entry.Descriptor.BotLoadout == v34.BotLoadout and BotPresentationState.decide(v34, nil) ~= "Destroy"))) then
            if p33.Entry == nil or (v34 == nil or not v34.Dead and v34.Health > 0) then
                local Entry2 = p33.Entry;

                if Entry2 ~= nil then
                    p33.Entry = nil;
                    destroyShell(Entry2);
                end;
            else
                retireToCorpse(p33);
            end;
        else
            Entry.Descriptor = v34;
            Entry.Shell.Name = v34.DisplayName;
            Entry.Shell:SetAttribute("Team", v34.Team);
            Entry.Shell:SetAttribute("Health", v34.Health);
            Entry.Shell:SetAttribute("MaxHealth", v34.MaxHealth);
        end;
    end;

    if Descriptor ~= nil and (v34 == nil or not BotPresentationState.sameLife(Descriptor, v34)) then
        p33.LastDescriptor = Descriptor;
    end;

    p33.Descriptor = v34;
end;

local function untrack(p35: userdata) -- Line: 251
    -- upvalues: u2 (copy), u3 (copy), destroyShell (copy)
    local v36 = u2[p35];

    if v36 == nil then
        return;
    end;

    u2[p35] = nil;
    local Descriptor = v36.Descriptor;

    if Descriptor ~= nil and u3[Descriptor.ActorId] == v36 then
        u3[Descriptor.ActorId] = nil;
    end;

    v36.Descriptor = nil;
    v36.Janitor:Destroy();
    local Entry = v36.Entry;

    if Entry ~= nil then
        v36.Entry = nil;
        destroyShell(Entry);
    end;
end;

local function track(u37: userdata) -- Line: 266
    -- upvalues: u2 (copy), Janitor (copy), refresh (copy)
    if not u37:IsA("Folder") or u2[u37] ~= nil then
        return;
    end;

    local u38 = {
        Descriptor = nil,
        Entry = nil,
        LastEventSequence = nil,
        Folder = u37,
        Janitor = Janitor.new()
    };
    u2[u37] = u38;
    u38.Janitor:Add(u37.AttributeChanged:Connect(function() -- Line: 273
        -- upvalues: refresh (ref), u37 (copy), u38 (copy)
        refresh(u37, u38);
    end));
    refresh(u37, u38);
end;

local function bindFolder(u39: userdata) -- Line: 279
    -- upvalues: u14 (ref), u13 (ref), u2 (copy), u3 (copy), destroyShell (copy), Janitor (copy), track (copy), untrack (copy), ReplicatedStorage (copy)
    if u39 == u14 or not u39:IsA("Folder") then
        return;
    end;

    if u13 ~= nil then
        u13:Destroy();
    end;

    for i in u2 do
        local v40 = u2[i];

        if v40 ~= nil then
            u2[i] = nil;
            local Descriptor = v40.Descriptor;

            if Descriptor ~= nil and u3[Descriptor.ActorId] == v40 then
                u3[Descriptor.ActorId] = nil;
            end;

            v40.Descriptor = nil;
            v40.Janitor:Destroy();
            local Entry = v40.Entry;

            if Entry ~= nil then
                v40.Entry = nil;
                destroyShell(Entry);
            end;
        end;
    end;

    u14 = u39;
    u13 = Janitor.new();
    u13:Add(u39.ChildAdded:Connect(track));
    u13:Add(u39.ChildRemoved:Connect(untrack));
    u13:Add(u39.AncestryChanged:Connect(function() -- Line: 293
        -- upvalues: u39 (copy), ReplicatedStorage (ref), u2 (ref), u3 (ref), destroyShell (ref), u14 (ref), u13 (ref)
        if u39.Parent ~= ReplicatedStorage then
            for i in u2 do
                local v41 = u2[i];

                if v41 ~= nil then
                    u2[i] = nil;
                    local Descriptor = v41.Descriptor;

                    if Descriptor ~= nil and u3[Descriptor.ActorId] == v41 then
                        u3[Descriptor.ActorId] = nil;
                    end;

                    v41.Descriptor = nil;
                    v41.Janitor:Destroy();
                    local Entry = v41.Entry;

                    if Entry ~= nil then
                        v41.Entry = nil;
                        destroyShell(Entry);
                    end;
                end;
            end;

            u14 = nil;
            u13:Destroy();
            u13 = nil;
        end;
    end));

    for _, child in u39:GetChildren() do
        track(child);
    end;
end;

function u1.Initialize() -- Line: 308
    -- upvalues: u12 (ref), Transport (copy), BotCombatCodec (copy), u1 (copy), ReplicatedStorage (copy), bindFolder (copy)
    if u12 then
        return;
    end;

    u12 = true;
    Transport.getClientChannels().BotCombat.OnClientEvent:Connect(function(p42) -- Line: 313
        -- upvalues: BotCombatCodec (ref), u1 (ref)
        local v43 = BotCombatCodec.decode(p42);

        if v43 ~= nil then
            u1.PresentCombatEvents(v43);
        end;
    end);
    ReplicatedStorage.ChildAdded:Connect(function(p44) -- Line: 319
        -- upvalues: bindFolder (ref)
        if p44.Name == "Combatants" then
            bindFolder(p44);
        end;
    end);
    local Combatants = ReplicatedStorage:FindFirstChild("Combatants");

    if Combatants ~= nil then
        bindFolder(Combatants);
    end;
end;

local function poseRootCFrame(p45) -- Line: 330
    -- upvalues: RootFrame (copy), CharacterPose (copy)
    local v46 = p45.VisualRootPosition or RootFrame.simulationToVisualRootPosition(p45.Position, p45.DuckAmount);

    return CharacterPose.composeRootCFrame(v46, p45.LookYaw);
end;

local function createEntry(p47: userdata, u48: any, p49) -- Line: 336
    -- upvalues: ReplicatedStorage (copy), CharacterPresentationDescriptor (copy), CharacterGeneration (copy), ClientCharacterPresentation (copy), HttpService (copy), CharacterResolver (copy), Workspace (copy), Ragdoll (copy), CharacterPose (copy), CharacterAnimator (copy), Defuser (copy)
    local Assets = ReplicatedStorage:FindFirstChild("Assets");
    local v50;

    if Assets == nil then
        v50 = nil;
    else
        v50 = Assets:FindFirstChild("Characters");
    end;

    local v51;

    if v50 == nil then
        v51 = nil;
    else
        v51 = v50:FindFirstChild(u48.CharacterName);
    end;

    if v51 == nil or not v51:IsA("Model") then
        return nil;
    end;

    local u52 = v51:Clone();
    u52.Name = u48.DisplayName;
    u52:SetAttribute("CharacterType", "PlayerCustomCharacter");
    u52:SetAttribute("CharacterName", u48.CharacterName);
    u52:SetAttribute("Bot", true);
    u52:SetAttribute("CombatantId", u48.CombatantId);
    u52:SetAttribute("ActorId", u48.ActorId);
    u52:SetAttribute("Team", u48.Team);
    u52:SetAttribute("Health", u48.Health);
    u52:SetAttribute("MaxHealth", u48.MaxHealth);
    u52:SetAttribute("Dead", false);
    u52:SetAttribute(CharacterPresentationDescriptor.OwnedAttribute, true);
    u52:SetAttribute(CharacterPresentationDescriptor.VisibleAttribute, true);
    CharacterGeneration.Set(u52, u48.Generation);
    ClientCharacterPresentation.PrepareRuntimeRig(u52);

    if u48.BotLoadout then
        local v53 = HttpService:JSONDecode(u48.BotLoadout);
        u52:SetAttribute("BotLoadout", u48.BotLoadout);

        if v53.Gloves then
            local Gloves = v53.Gloves;
            u52:SetAttribute("EquippedGloves", HttpService:JSONEncode(Gloves));
            local Gloves2 = require(ReplicatedStorage.Database.Components.Libraries.Skins).GetGloves(Gloves.Name, Gloves.Skin, Gloves.Float);

            if Gloves2 then
                require(ReplicatedStorage.Database.Components.Common.AttachGlovesToCharacter)(Gloves2:GetChildren(), u52, u52:FindFirstChild("CharacterArmor") or u52);
                Gloves2:Destroy();
            end;
        end;
    end;

    local v54 = CharacterResolver.resolve(u52);

    if v54 == nil then
        u52:Destroy();

        return nil;
    end;

    u52:PivotTo(p49 * v54.RootPart.CFrame:ToObjectSpace(u52:GetPivot()));
    u52.Parent = Workspace:FindFirstChild("Characters") or Workspace;
    task.spawn(function() -- Line: 381
        -- upvalues: u52 (copy), Ragdoll (ref), u48 (copy)
        if u52:IsDescendantOf(game) and u52:GetAttribute("Dead") ~= true then
            local success, result = pcall(Ragdoll.PrepareCharacter, u52);

            if not success then
                warn((`[BotCharacters] Ragdoll preparation failed for {u48.DisplayName}: {result}`));
            end;
        end;
    end);

    return {
        Visible = true,
        LastPosition = nil,
        LastAnimationAt = (-1 / 0),
        Weapon = nil,
        Descriptor = u48,
        Shell = u52,
        Root = v54.RootPart,
        Joints = CharacterPose.getJoints(u52),
        Animator = CharacterAnimator.new(u52),
        Defuser = Defuser.new(p47, u52)
    };
end;

local function needsWeapon(p55: table, p56: any) -- Line: 404
    local v57 = p56.WeaponName or "";
    local Weapon = p55.Weapon;

    if v57 == "" then
        return Weapon ~= nil;
    end;

    return (Weapon == nil or Weapon.Name ~= v57) and true or Weapon.Revision ~= (p56.WeaponRevision or 0);
end;

local function syncWeapon(p58: table, p59: any) -- Line: 412
    -- upvalues: BotWeaponModel (copy), BotWeaponRecoil (copy)
    local v60 = p59.WeaponName or "";
    local Weapon = p58.Weapon;
    local v61;

    if v60 == "" then
        v61 = Weapon ~= nil;
    else
        v61 = (Weapon == nil or Weapon.Name ~= v60) and true or Weapon.Revision ~= (p59.WeaponRevision or 0);
    end;

    if not v61 then
        return;
    end;

    local v62 = p59.WeaponName or "";
    local v63;

    if p58.Weapon == nil then
        v63 = false;
    else
        v63 = p58.Weapon.Name ~= v62;
    end;

    BotWeaponModel.stow(p58.Shell, p58.Weapon);
    p58.Weapon = nil;
    p58.Recoil = nil;
    p58.Animator:setWeapon(nil, nil, false);

    if v62 == "" then
        return;
    end;

    local v64 = BotWeaponModel.attach(p58.Shell, v62, p59.WeaponRevision or 0);

    if v64 ~= nil then
        p58.Weapon = v64;
        p58.Recoil = BotWeaponRecoil.new(v62);
        p58.Animator:setWeapon(v62, tostring(v64.Revision), v63);
    end;
end;

function u1.PresentCombatEvents(p65: table) -- Line: 433
    -- upvalues: Workspace (copy), u3 (copy), BotCombatCodec (copy), u17 (ref), BotPresentationState (copy), CharacterGeneration (copy), u1 (copy), BotWeaponEffects (copy)
    local ServerTimeNow = Workspace:GetServerTimeNow();

    for _, v in p65 do
        local v66 = u3[v.ActorId];
        local v67;

        if v66 then
            v67 = v66.Entry;
        else
            v67 = nil;
        end;

        local v68;

        if v66 then
            v68 = v66.Descriptor;
        else
            v68 = nil;
        end;

        if v66 ~= nil and (v67 ~= nil and v68 ~= nil) then
            local Weapon = v67.Weapon;
            local v69;

            if v68.WeaponName == v.WeaponName and (v68.WeaponRevision == v.WeaponRevision and (Weapon ~= nil and Weapon.Name == v.WeaponName)) then
                v69 = Weapon.Revision == v.WeaponRevision;
            else
                v69 = false;
            end;

            local v70;

            if (v.WeaponRevision or 0) > (v68.WeaponRevision or 0) then
                v70 = true;
            elseif v68.WeaponName == v.WeaponName then
                v70 = v68.WeaponRevision == v.WeaponRevision;
            else
                v70 = false;
            end;

            if v69 or not (v70 and (v.ActorId == v68.ActorId and (v.Generation == v68.Generation and ServerTimeNow - v.ServerTime <= BotCombatCodec.MaxEventAgeSeconds))) then
                if v69 and (BotCombatCodec.canPresent(v, v68, v67.Visible, v66.LastEventSequence, ServerTimeNow) and (v67.Shell:IsDescendantOf(Workspace) and (BotPresentationState.sameLife(v67.Descriptor, v68) and CharacterGeneration.Get(v67.Shell) == v.Generation))) then
                    v66.LastEventSequence = v.Sequence;
                    u1.CombatEvent:Fire(v);
                    v67.Animator:playAction(v.Kind);

                    if v.Kind == "Shoot" and v.Target ~= nil then
                        if v67.Recoil then
                            v67.Recoil:OnShot(ServerTimeNow);
                        end;

                        BotWeaponEffects.shoot(Weapon, v.Target, v.Sequence, v67.Shell:GetAttribute("SpectatedFirstPerson") == true);
                    elseif v.Kind == "Reload" then
                        BotWeaponEffects.reloadSound(Weapon, v67.Root, v67.Shell:GetAttribute("SpectatedFirstPerson") == true);
                    end;
                end;
            else
                u17[v66] = v;
            end;
        end;
    end;
end;

function u1.GetEquipment(p71: number, p72: number) -- Line: 491
    -- upvalues: u3 (copy), HttpService (copy)
    local v73 = u3[p71];
    local v74;

    if v73 then
        v74 = v73.Entry;
    else
        v74 = nil;
    end;

    if not (v74 and (v74.Visible and v74.Descriptor.Generation == p72)) then
        return nil;
    end;

    local Weapon = v74.Weapon;

    if not Weapon then
        return nil;
    end;

    local v75 = v74.Descriptor.BotLoadout and HttpService:JSONDecode(v74.Descriptor.BotLoadout);

    if v75 then
        v75 = v75.Weapons[Weapon.Name];
    end;

    return {
        Name = Weapon.Name,
        Revision = Weapon.Revision,
        Skin = not v75 and "Stock" or v75.Skin,
        Float = not v75 and 0 or v75.Float
    };
end;

function u1.GetRecoil(p76: number, p77: number) -- Line: 511
    -- upvalues: u3 (copy), Workspace (copy)
    local v78 = u3[p76];
    local v79;

    if v78 then
        v79 = v78.Entry;
    else
        v79 = nil;
    end;

    if v79 and (v79.Visible and (v79.Weapon and (v79.Recoil and v79.Descriptor.Generation == p77))) then
        return v79.Recoil:Step(Workspace:GetServerTimeNow());
    end;

    return Vector2.zero;
end;

local function lifeDescriptor(p80: table, p81: number, p82: number) -- Line: 528
    for _, v in { p80.Descriptor, p80.LastDescriptor } do
        if v and (v.CombatantId == p81 and v.Generation == p82) then
            return v;
        end;
    end;

    return nil;
end;

function u1.TakeCorpse(p83: number, p84: number, p85: vector, p86: number) -- Line: 537
    -- upvalues: u15 (copy), u2 (copy), lifeDescriptor (copy), createEntry (copy), CharacterPose (copy), retireToCorpse (copy), u16 (copy), destroyShell (copy), releaseCorpseSource (copy)
    local v87 = u15[p83];

    if v87 == nil or v87.Generation ~= p84 then
        for _, v in u2 do
            local v88 = lifeDescriptor(v, p83, p84);

            if v88 and v.CorpseGeneration ~= p84 then
                local Entry = v.Entry;

                if Entry == nil or Entry.Descriptor.Generation ~= p84 then
                    v.Entry = createEntry(v.Folder, v88, CharacterPose.composeRootCFrame(p85, p86));
                    retireToCorpse(v);
                    v.Entry = Entry;
                else
                    retireToCorpse(v);
                end;

                v87 = u15[p83];
                break;
            end;
        end;
    end;

    if v87 == nil or v87.Generation ~= p84 then
        return nil;
    end;

    u15[p83] = nil;
    local Entry = v87.Entry;
    local v89 = u16[p83];

    if v89 ~= nil then
        u16[p83] = nil;
        destroyShell(v89);
    end;

    u16[p83] = Entry;
    task.delay(30, releaseCorpseSource, p83, Entry);

    return Entry.Shell;
end;

function u1.GetCamera(p90: number, p91: number) -- Line: 572
    -- upvalues: u3 (copy), u4 (copy), CharacterResolver (copy), u1 (copy)
    local v92 = u3[p90];
    local v93;

    if v92 then
        v93 = v92.Entry;
    else
        v93 = nil;
    end;

    local v94 = u4[p90];

    if not (v93 and (v93.Visible and (v94 and v93.Descriptor.Generation == p91))) then
        return nil;
    end;

    local CameraPart = CharacterResolver.getCameraPart(v93.Shell);

    if not CameraPart then
        return nil;
    end;

    local RenderPose = v94.RenderPose;

    if RenderPose == nil then
        return nil;
    end;

    local Recoil = u1.GetRecoil(p90, p91);
    local math_clamp_ret = math.clamp(RenderPose.VerticalLook, -1, 1);
    local math_asin_ret = math.asin(math_clamp_ret);

    return CFrame.new(CameraPart.Position) * CFrame.Angles(0, RenderPose.LookYaw + Recoil.X, 0) * CFrame.Angles(math_asin_ret + Recoil.Y, 0, 0);
end;

local function queueMove(p95: table, p96: any) -- Line: 595
    -- upvalues: RootFrame (copy), CharacterPose (copy), u5 (copy), u6 (copy), u7 (copy), u8 (copy)
    local v97 = p96.VisualRootPosition or RootFrame.simulationToVisualRootPosition(p96.Position, p96.DuckAmount);
    local v98 = CharacterPose.composeRootCFrame(v97, p96.LookYaw);

    if p95.Root.CFrame ~= v98 then
        u5[#u5 + 1] = p95.Root;
        u6[#u6 + 1] = v98;
    end;

    u7[#u7 + 1] = p95;
    u8[#u8 + 1] = p96;
end;

function u1.Present(p99: table) -- Line: 606
    -- upvalues: u1 (copy), u15 (copy), destroyShell (copy), u4 (copy), u5 (copy), u6 (copy), u7 (copy), u8 (copy), u9 (copy), u10 (copy), u2 (copy), BotPresentationState (copy), retireToCorpse (copy), hide (copy), RootFrame (copy), CharacterPose (copy), u11 (ref), u16 (copy), createEntry (copy), poseRootCFrame (copy), syncWeapon (copy), Workspace (copy), CharacterPresentationDescriptor (copy), RuntimeKinematics (copy), u17 (ref)
    u1.Initialize();
    local os_clock_ret = os.clock();

    for i, v in u15 do
        if v.ExpiresAt <= os_clock_ret then
            u15[i] = nil;
            destroyShell(v.Entry);
        end;
    end;

    table.clear(u4);
    table.clear(u5);
    table.clear(u6);
    table.clear(u7);
    table.clear(u8);
    table.clear(u9);
    table.clear(u10);

    for _, v in p99 do
        if v.UserId == 0 then
            u4[v.ActorId] = v;
        end;
    end;

    for _, v in u2 do
        local Descriptor = v.Descriptor;
        local v100;

        if Descriptor == nil then
            v100 = nil;
        else
            v100 = u4[Descriptor.ActorId];
        end;

        local v101 = BotPresentationState.decide(Descriptor, v100);
        v.LastDecision = v101;
        local Entry = v.Entry;

        if v101 == "Destroy" then
            if v.Entry == nil or (Descriptor == nil or not Descriptor.Dead and Descriptor.Health > 0) then
                local Entry2 = v.Entry;

                if Entry2 ~= nil then
                    v.Entry = nil;
                    destroyShell(Entry2);
                end;
            else
                retireToCorpse(v);
            end;
        elseif v101 == "Hide" then
            if Entry ~= nil then
                hide(Entry);
            end;
        elseif v101 == "Present" then
            if Entry ~= nil then
                local RenderPose = v100.RenderPose;
                local v102 = RenderPose.VisualRootPosition or RootFrame.simulationToVisualRootPosition(RenderPose.Position, RenderPose.DuckAmount);
                local v103 = CharacterPose.composeRootCFrame(v102, RenderPose.LookYaw);

                if Entry.Root.CFrame ~= v103 then
                    u5[#u5 + 1] = Entry.Root;
                    u6[#u6 + 1] = v103;
                end;

                u7[#u7 + 1] = Entry;
                u8[#u8 + 1] = RenderPose;
            end;

            if Entry == nil then
                u9[#u9 + 1] = v;
                u10[#u10 + 1] = v100;
            else
                local v104 = Descriptor.WeaponName or "";
                local Weapon = Entry.Weapon;
                local v105;

                if v104 == "" then
                    v105 = Weapon ~= nil;
                else
                    v105 = (Weapon == nil or Weapon.Name ~= v104) and true or Weapon.Revision ~= (Descriptor.WeaponRevision or 0);
                end;

                if v105 then
                    u9[#u9 + 1] = v;
                    u10[#u10 + 1] = v100;
                end;
            end;
        end;
    end;

    local v106 = #u9;

    if v106 > 0 then
        local v107 = u11 % v106;
        local math_min_ret = math.min(2, v106);

        for i = 1, math_min_ret do
            local v108 = (v107 + i - 1) % v106 + 1;
            local v109 = u9[v108];
            local v110 = u10[v108];
            local Descriptor = v109.Descriptor;
            local v111;

            if BotPresentationState.decide(Descriptor, v110) == "Present" and (not Descriptor or v109.CorpseGeneration ~= Descriptor.Generation) then
                local Entry = v109.Entry;
                local v112 = Entry == nil;

                if v112 then
                    local v113 = u16[Descriptor.CombatantId];

                    if v113 and v113.Descriptor.Generation ~= Descriptor.Generation then
                        local CombatantId = Descriptor.CombatantId;
                        local v114 = u16[CombatantId];

                        if v114 ~= nil then
                            u16[CombatantId] = nil;
                            destroyShell(v114);
                        end;
                    end;

                    Entry = createEntry(v109.Folder, Descriptor, poseRootCFrame(v110.RenderPose));
                    v109.Entry = Entry;
                end;

                if Entry == nil then
                    v111 = i;
                else
                    syncWeapon(Entry, Descriptor);

                    if v112 then
                        local RenderPose = v110.RenderPose;
                        local v115 = RenderPose.VisualRootPosition or RootFrame.simulationToVisualRootPosition(RenderPose.Position, RenderPose.DuckAmount);
                        local v116 = CharacterPose.composeRootCFrame(v115, RenderPose.LookYaw);

                        if Entry.Root.CFrame ~= v116 then
                            u5[#u5 + 1] = Entry.Root;
                            u6[#u6 + 1] = v116;
                        end;

                        u7[#u7 + 1] = Entry;
                        u8[#u8 + 1] = RenderPose;
                        v111 = i;
                    else
                        v111 = i;
                    end;
                end;
            else
                v111 = i;
            end;
        end;

        u11 = (v107 + math_min_ret) % v106;
    end;

    if #u5 == 1 then
        u5[1].CFrame = u6[1];
    elseif #u5 > 1 then
        Workspace:BulkMoveTo(u5, u6, Enum.BulkMoveMode.FireCFrameChanged);
    end;

    local os_clock_ret2 = os.clock();

    for i, v in u7 do
        local v117 = u8[i];
        local Visible = v.Visible;

        if not Visible then
            v.ObjectiveAction = nil;
            v.Visible = true;
            v.Shell.Parent = Workspace:FindFirstChild("Characters") or Workspace;
            v.Shell:SetAttribute(CharacterPresentationDescriptor.VisibleAttribute, true);

            if v.Weapon ~= nil then
                v.Animator:setWeapon(v.Weapon.Name, tostring(v.Weapon.Revision), false);
            end;
        end;

        local ObjectiveAction = v.Descriptor.ObjectiveAction;

        if v.ObjectiveAction ~= ObjectiveAction then
            if ObjectiveAction == "Planting" then
                if v.Weapon and v.Weapon.Name == "C4" then
                    v.Animator:playAction("Use");
                    v.ObjectiveAction = ObjectiveAction;
                end;
            else
                if v.ObjectiveAction == "Planting" and (v.Weapon and v.Weapon.Name == "C4") then
                    v.Animator:playAction("Cancel Plant");
                end;

                v.ObjectiveAction = ObjectiveAction;
            end;
        end;

        local v118;

        if v.LastPosition == nil then
            v118 = false;
        else
            v118 = (v117.Position - v.LastPosition).Magnitude > 0.00001;
        end;

        local v119 = not v118 and Vector3.new(0, 0, 0) or v117.Velocity;
        RuntimeKinematics.write(v.Shell, v119, v117.OnGround);
        v.LastPosition = v117.Position;

        if not Visible or os_clock_ret2 - v.LastAnimationAt >= 0.016666666666666666 then
            v.Animator:updateLocomotion(v119, v117.OnGround, v117.DuckAmount > 0.5, v117.MovementMode == "Ladder");

            if v.Joints ~= nil then
                CharacterPose.applyVerticalLook(v.Joints, v117.VerticalLook, 0.003);
            end;

            v.LastAnimationAt = os_clock_ret2;
        end;
    end;

    if next(u17) ~= nil then
        local v120 = u17;
        u17 = {};

        for _, v in v120 do
            u1.PresentCombatEvents({ v });
        end;
    end;
end;

return u1;