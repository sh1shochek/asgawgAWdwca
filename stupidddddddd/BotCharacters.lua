-- ReplicatedStorage.Controllers.CharacterController.BotCharacters
-- Script path: ReplicatedStorage.Controllers.CharacterController.BotCharacters
-- Decompile time: 21.68 ms

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local HttpService = game:GetService("HttpService")
local Common = ReplicatedStorage.Components.Common
local BotPresentationState = require(Common.BotPresentationState)
local BotWeaponModel = require(Common.BotWeaponModel)
local BotWeaponEffects = require(Common.BotWeaponEffects)
local BotWeaponRecoil = require(Common.BotWeaponRecoil)
local CharacterGeneration = require(Common.CharacterGeneration)
local CharacterPose = require(Common.CharacterPose)
local CharacterResolver = require(Common.CharacterResolver)
local ClientCharacterPresentation = require(Common.ClientCharacterPresentation)
local CharacterPresentationDescriptor = require(Common.CharacterPresentationDescriptor)
local CharacterAnimator = require(ReplicatedStorage.Classes.Character.Classes.CharacterAnimator)
local RootFrame = require(ReplicatedStorage.MovementV2.RootFrame)
local RuntimeKinematics = require(ReplicatedStorage.MovementV2.RuntimeKinematics)
local BotCombatCodec = require(ReplicatedStorage.MovementV2.BotCombatCodec)
local Transport = require(ReplicatedStorage.MovementV2.Transport)
local Janitor = require(ReplicatedStorage.Shared.Janitor)
local Signal = require(ReplicatedStorage.Packages.Signal)
local Defuser = require(ReplicatedStorage.Controllers.Observers.Character.Components.Defuser)
local Ragdoll = require(ReplicatedStorage.Classes.Ragdoll)
local u85 = {}
u85.CombatEvent = Signal.new()
local u88 = {}
local u89 = {}
local u90 = {}
local u91 = {}
local u92 = {}
local u93 = {}
local u94 = {}
local u95 = {}
local u96 = {}
local u97 = 0
local u98 = false
local u99 = nil
local u100 = nil
local u101 = {}
local u102 = {}
local u103 = {}

local function destroyShell(a1) -- Line: 83
    -- upvalues: BotWeaponModel (val), RuntimeKinematics (val)
    BotWeaponModel.destroy(a1.Weapon)
    BotWeaponModel.clear(a1.Shell)
    RuntimeKinematics.clear(a1.Shell)
    if a1.Defuser then
        a1.Defuser:Destroy()
    end
    a1.Animator:destroy()
    a1.Shell:Destroy()
end

local function releaseCorpseSource(a1, a2) -- Line: 95
    -- upvalues: u102 (val), destroyShell (val)
    local v1 = u102[a1]
    if v1 == nil then
        return
    end
    if a2 ~= nil and v1 ~= a2 then
        return
    end
    u102[a1] = nil
    destroyShell(v1)
end

local function destroyEntry(a1) -- Line: 104 -- upvalues: destroyShell (val) -- types: a1: table
    local Entry = a1.Entry
    if Entry ~= nil then
        a1.Entry = nil
        destroyShell(Entry)
    end
end

local function hide(a1) -- Line: 112
    -- upvalues: CharacterPresentationDescriptor (val), RuntimeKinematics (val), ClientCharacterPresentation (val)
    if a1.Visible then
        a1.Visible = false
        a1.Shell:SetAttribute(CharacterPresentationDescriptor.VisibleAttribute, false)
        a1.Animator:stopAnimations(0)
        RuntimeKinematics.clear(a1.Shell)
        a1.LastPosition = nil
    end
    a1.Shell.Parent = ClientCharacterPresentation.GetCulledFolder()
end

local function cullCorpseShell(a1) -- Line: 124 -- upvalues: BotWeaponModel (val), hide (val) -- types: a1: table
    BotWeaponModel.destroy(a1.Weapon)
    BotWeaponModel.clear(a1.Shell)
    a1.Weapon = nil
    if a1.Defuser then
        a1.Defuser:Destroy()
        a1.Defuser = nil
    end
    hide(a1)
end

local function retireToCorpse(a1) -- Line: 137
    -- upvalues: CharacterPresentationDescriptor (val), RuntimeKinematics (val), BotWeaponModel (val), hide (val)
    -- upvalues: u101 (val), destroyShell (val)
    local Entry = a1.Entry
    if Entry == nil then
        return
    end
    a1.Entry = nil
    a1.CorpseGeneration = Entry.Descriptor.Generation
    Entry.Shell:SetAttribute("Health", 0)
    Entry.Shell:SetAttribute("Dead", true)
    if not Entry.Visible then
        BotWeaponModel.destroy(Entry.Weapon)
        BotWeaponModel.clear(Entry.Shell)
        Entry.Weapon = nil
        if Entry.Defuser then
            Entry.Defuser:Destroy()
            Entry.Defuser = nil
        end
        hide(Entry)
    else
        Entry.Shell:SetAttribute(CharacterPresentationDescriptor.VisibleAttribute, false)
        Entry.Animator:freezeAnimations()
        RuntimeKinematics.clear(Entry.Shell)
        for i, j in Entry.Shell:GetDescendants() do
            if j:IsA("BasePart") then
                j.CanQuery = false
            end
        end
        task.delay(1.5, function() -- Line: 156 -- upvalues: Entry (val), BotWeaponModel (upval), hide (upval)
            if Entry.Shell.Parent ~= nil then
                local v1 = Entry
                BotWeaponModel.destroy(v1.Weapon)
                BotWeaponModel.clear(v1.Shell)
                v1.Weapon = nil
                if v1.Defuser then
                    v1.Defuser:Destroy()
                    v1.Defuser = nil
                end
                hide(v1)
            end
        end)
    end
    local v1 = u101[Entry.Descriptor.CombatantId]
    if v1 then
        destroyShell(v1.Entry)
    end
    u101[Entry.Descriptor.CombatantId] = {
        Entry = Entry,
        Generation = Entry.Descriptor.Generation,
        ExpiresAt = os.clock() + 1.5,
    }
end

local function releaseEntry(a1, a2) -- Line: 175
    -- upvalues: retireToCorpse (val), destroyShell (val)
    local Entry
    if a1.Entry ~= nil and a2 ~= nil then
        if not a2.Dead and not (a2.Health <= 0) then
            Entry = a1.Entry
            if Entry ~= nil then
                a1.Entry = nil
                destroyShell(Entry)
            end
            return
        end
        retireToCorpse(a1)
        return
    end
    Entry = a1.Entry
    if Entry ~= nil then
        a1.Entry = nil
        destroyShell(Entry)
    end
end

local function readDescriptor(a1) -- Line: 184 -- upvalues: BotPresentationState (val) -- types: a1: userdata
    local Attribute = a1:GetAttribute("WeaponName")
    local Attribute_2 = a1:GetAttribute("WeaponRevision")
    local Attribute_3 = a1:GetAttribute("ObjectiveAction")
    local v1 = {
        BotLoadout = a1:GetAttribute("BotLoadout"),
        CombatantId = a1:GetAttribute("CombatantId"),
        ActorId = a1:GetAttribute("ActorId"),
        Generation = a1:GetAttribute("Generation"),
        DisplayName = a1:GetAttribute("DisplayName"),
        Team = a1:GetAttribute("Team"),
        CharacterName = a1:GetAttribute("CharacterName"),
        Health = a1:GetAttribute("Health"),
        MaxHealth = a1:GetAttribute("MaxHealth"),
        Dead = a1:GetAttribute("Dead"),
    }
    v1.ObjectiveAction = if Attribute_3 == "Planting" then Attribute_3 else if Attribute_3 ~= "Defusing" then nil else Attribute_3
    v1.WeaponName = if type(Attribute) ~= "string" then "" else if not (#Attribute <= 48) then "" else Attribute
    v1.WeaponRevision = if type(Attribute_2) ~= "number" then 0 else if not (Attribute_2 >= 0) then 0 else if not (Attribute_2 <= 4294967295) then 0 else if Attribute_2 % 1 ~= 0 then 0 else Attribute_2
    if BotPresentationState.validate(v1) and a1.Name == tostring(v1.CombatantId) then
        return v1
    end
    return nil
end

local function refresh(a1, a2) -- Line: 215
    -- upvalues: readDescriptor (val), u89 (val), BotPresentationState (val), retireToCorpse (val), destroyShell (val)
    local v1 = readDescriptor(a1)
    local Descriptor = a2.Descriptor
    if Descriptor ~= nil and u89[Descriptor.ActorId] == a2 then
        u89[Descriptor.ActorId] = nil
    end
    if v1 ~= nil then
        u89[v1.ActorId] = a2
        if Descriptor == nil or not BotPresentationState.sameLife(Descriptor, v1) then
            a2.LastEventSequence = nil
        end
    end
    local Entry = a2.Entry
    if Entry ~= nil then
        local Entry_2
        if v1 == nil
            or not BotPresentationState.sameLife(Entry.Descriptor, v1)
            or Entry.Descriptor.CharacterName ~= v1.CharacterName
            or Entry.Descriptor.BotLoadout ~= v1.BotLoadout then
            if a2.Entry == nil or v1 == nil then
                Entry_2 = a2.Entry
                if Entry_2 ~= nil then
                    a2.Entry = nil
                    destroyShell(Entry_2)
                end
            elseif v1.Dead then
                retireToCorpse(a2)
            elseif not (v1.Health <= 0) then
                Entry_2 = a2.Entry
                if Entry_2 ~= nil then
                    a2.Entry = nil
                    destroyShell(Entry_2)
                end
            else
                retireToCorpse(a2)
            end
        elseif BotPresentationState.decide(v1, nil) ~= "Destroy" then
            Entry.Descriptor = v1
            Entry.Shell.Name = v1.DisplayName
            Entry.Shell:SetAttribute("Team", v1.Team)
            Entry.Shell:SetAttribute("Health", v1.Health)
            Entry.Shell:SetAttribute("MaxHealth", v1.MaxHealth)
        elseif a2.Entry == nil or v1 == nil then
            Entry_2 = a2.Entry
            if Entry_2 ~= nil then
                a2.Entry = nil
                destroyShell(Entry_2)
            end
        elseif v1.Dead then
            retireToCorpse(a2)
        elseif not (v1.Health <= 0) then
            Entry_2 = a2.Entry
            if Entry_2 ~= nil then
                a2.Entry = nil
                destroyShell(Entry_2)
            end
        else
            retireToCorpse(a2)
        end
    end
    if Descriptor ~= nil then
        if v1 == nil or not BotPresentationState.sameLife(Descriptor, v1) then
            a2.LastDescriptor = Descriptor
        end
    end
    a2.Descriptor = v1
end

local function untrack(a1) -- Line: 251 -- upvalues: u88 (val), u89 (val), destroyShell (val) -- types: a1: userdata
    local v1 = u88[a1]
    if v1 == nil then
        return
    end
    u88[a1] = nil
    local Descriptor = v1.Descriptor
    if Descriptor ~= nil and u89[Descriptor.ActorId] == v1 then
        u89[Descriptor.ActorId] = nil
    end
    v1.Descriptor = nil
    v1.Janitor:Destroy()
    local Entry = v1.Entry
    if Entry ~= nil then
        v1.Entry = nil
        destroyShell(Entry)
    end
end

local function track(a1) -- Line: 266 -- upvalues: u88 (val), Janitor (val), refresh (val) -- types: a1: userdata
    if a1:IsA("Folder") and u88[a1] == nil then
        local u7 = {Folder = a1}
        u7.Janitor = Janitor.new()
        u88[a1] = u7
        u7.Janitor:Add((a1.AttributeChanged:Connect(function() -- Line: 273 -- upvalues: refresh (upval), a1 (val), u7 (val)
            refresh(a1, u7)
        end)))
        refresh(a1, u7)
        return
    end
end

local function bindFolder(a1) -- Line: 279
    -- upvalues: u100 (ref), u99 (ref), u88 (val), u89 (val), destroyShell (val), Janitor (val), track (val)
    -- upvalues: untrack (val), ReplicatedStorage (val)
    if a1 ~= u100 and a1:IsA("Folder") then
        local Descriptor, Entry, v1
        if u99 ~= nil then
            u99:Destroy()
        end
        local v2 = nil
        local v3 = nil
        for i in u88, v2, v3 do
            v1 = u88[i]
            if v1 ~= nil then
                u88[i] = nil
                Descriptor = v1.Descriptor
                if Descriptor ~= nil and u89[Descriptor.ActorId] == v1 then
                    u89[Descriptor.ActorId] = nil
                end
                v1.Descriptor = nil
                v1.Janitor:Destroy()
                Entry = v1.Entry
                if Entry ~= nil then
                    v1.Entry = nil
                    destroyShell(Entry)
                end
            end
        end
        u100 = a1
        u99 = Janitor.new()
        u99:Add((a1.ChildAdded:Connect(track)))
        u99:Add((a1.ChildRemoved:Connect(untrack)))
        u99:Add((a1.AncestryChanged:Connect(function() -- Line: 293
            -- upvalues: a1 (val), ReplicatedStorage (upval), u88 (upval), u89 (upval), destroyShell (upval)
            -- upvalues: u100 (upval), u99 (upval)
            if a1.Parent ~= ReplicatedStorage then
                local Descriptor, Entry, v1
                local v2 = nil
                local v3 = nil
                for i in u88, v2, v3 do
                    v1 = u88[i]
                    if v1 ~= nil then
                        u88[i] = nil
                        Descriptor = v1.Descriptor
                        if Descriptor ~= nil and u89[Descriptor.ActorId] == v1 then
                            u89[Descriptor.ActorId] = nil
                        end
                        v1.Descriptor = nil
                        v1.Janitor:Destroy()
                        Entry = v1.Entry
                        if Entry ~= nil then
                            v1.Entry = nil
                            destroyShell(Entry)
                        end
                    end
                end
                u100 = nil
                u99:Destroy()
                u99 = nil
            end
        end)))
        for j, k in a1:GetChildren() do
            track(k)
        end
        return
    end
end

function u85.Initialize() -- Line: 308
    -- upvalues: u98 (ref), Transport (val), BotCombatCodec (val), u85 (val), ReplicatedStorage (val), bindFolder (val)
    if u98 then
        return
    end
    u98 = true
    ;(Transport.getClientChannels()).BotCombat.OnClientEvent:Connect(function(a1) -- Line: 313 -- upvalues: BotCombatCodec (upval), u85 (upval)
        local v1 = BotCombatCodec.decode(a1)
        if v1 ~= nil then
            u85.PresentCombatEvents(v1)
        end
    end)
    ReplicatedStorage.ChildAdded:Connect(function(a1) -- Line: 319 -- upvalues: bindFolder (upval)
        if a1.Name == "Combatants" then
            bindFolder(a1)
        end
    end)
    local Combatants = ReplicatedStorage:FindFirstChild("Combatants")
    if Combatants ~= nil then
        bindFolder(Combatants)
    end
end

local function poseRootCFrame(a1) -- Line: 330 -- upvalues: RootFrame (val), CharacterPose (val)
    return CharacterPose.composeRootCFrame(
        a1.VisualRootPosition or RootFrame.simulationToVisualRootPosition(a1.Position, a1.DuckAmount),
        a1.LookYaw
    )
end

local function createEntry(a1, a2, a3) -- Line: 336
    -- upvalues: ReplicatedStorage (val), CharacterPresentationDescriptor (val), CharacterGeneration (val)
    -- upvalues: ClientCharacterPresentation (val), HttpService (val), CharacterResolver (val), Workspace (val)
    -- upvalues: Ragdoll (val), CharacterPose (val), CharacterAnimator (val), Defuser (val)
    local Assets = ReplicatedStorage:FindFirstChild("Assets")
    local Characters = if Assets == nil then nil else Assets:FindFirstChild("Characters")
    local v1 = if Characters == nil then nil else Characters:FindFirstChild(a2.CharacterName)
    if v1 ~= nil and v1:IsA("Model") then
        local v2
        local u27 = v1:Clone()
        u27.Name = a2.DisplayName
        u27:SetAttribute("CharacterType", "PlayerCustomCharacter")
        u27:SetAttribute("CharacterName", a2.CharacterName)
        u27:SetAttribute("Bot", true)
        u27:SetAttribute("CombatantId", a2.CombatantId)
        u27:SetAttribute("ActorId", a2.ActorId)
        u27:SetAttribute("Team", a2.Team)
        u27:SetAttribute("Health", a2.Health)
        u27:SetAttribute("MaxHealth", a2.MaxHealth)
        u27:SetAttribute("Dead", false)
        u27:SetAttribute(CharacterPresentationDescriptor.OwnedAttribute, true)
        u27:SetAttribute(CharacterPresentationDescriptor.VisibleAttribute, true)
        CharacterGeneration.Set(u27, a2.Generation)
        ClientCharacterPresentation.PrepareRuntimeRig(u27)
        if a2.BotLoadout then
            v2 = HttpService:JSONDecode(a2.BotLoadout)
            u27:SetAttribute("BotLoadout", a2.BotLoadout)
            if v2.Gloves then
                local Gloves = v2.Gloves
                u27:SetAttribute("EquippedGloves", (HttpService:JSONEncode(Gloves)))
                local v3 = require(ReplicatedStorage.Database.Components.Libraries.Skins).GetGloves(Gloves.Name, Gloves.Skin, Gloves.Float)
                if v3 then
                    require(ReplicatedStorage.Database.Components.Common.AttachGlovesToCharacter)(
                        v3:GetChildren(),
                        u27,
                        u27:FindFirstChild("CharacterArmor") or u27
                    )
                    v3:Destroy()
                end
            end
        end
        v2 = CharacterResolver.resolve(u27)
        if v2 == nil then
            u27:Destroy()
            return nil
        end
        u27:PivotTo(a3 * (v2.RootPart.CFrame:ToObjectSpace((u27:GetPivot()))))
        local Characters_2 = Workspace:FindFirstChild("Characters") or Workspace
        u27.Parent = Characters_2
        task.spawn(function() -- Line: 381 -- upvalues: u27 (val), Ragdoll (upval), a2 (val)
            if u27:IsDescendantOf(game) and u27:GetAttribute("Dead") ~= true then
                local success, result = pcall(Ragdoll.PrepareCharacter, u27)
                if not success then
                    warn((("[BotCharacters] Ragdoll preparation failed for %*: %*"):format(a2.DisplayName, result)))
                end
            end
        end)
        return {
            Visible = true,
            LastAnimationAt = (-1 / 0),
            Descriptor = a2,
            Shell = u27,
            Root = v2.RootPart,
            Joints = CharacterPose.getJoints(u27),
            Animator = CharacterAnimator.new(u27),
            Defuser = Defuser.new(a1, u27),
        }
    end
    return nil
end

local function needsWeapon(a1, a2) -- Line: 404 -- types: a1: table
    local v1 = a2.WeaponName or ""
    local Weapon = a1.Weapon
    if v1 == "" then
        return Weapon ~= nil
    end
    local v2 = true
    if Weapon ~= nil then
        v2 = true
        if Weapon.Name == v1 then
            v2 = Weapon.Revision ~= (a2.WeaponRevision or 0)
        end
    end
    return v2
end

local function syncWeapon(a1, a2) -- Line: 412
    -- upvalues: BotWeaponModel (val), BotWeaponRecoil (val)
    local v1
    local v2 = a2.WeaponName or ""
    local Weapon = a1.Weapon
    if v2 ~= "" then
        v1 = true
        if Weapon ~= nil then
            v1 = true
            if Weapon.Name == v2 then
                v1 = Weapon.Revision ~= (a2.WeaponRevision or 0)
            end
        end
    else
        v1 = Weapon ~= nil
    end
    if not v1 then
        return
    end
    v1 = a2.WeaponName or ""
    v2 = false
    if a1.Weapon ~= nil then
        v2 = a1.Weapon.Name ~= v1
    end
    BotWeaponModel.stow(a1.Shell, a1.Weapon)
    a1.Weapon = nil
    a1.Recoil = nil
    a1.Animator:setWeapon(nil, nil, false)
    if v1 == "" then
        return
    end
    local v3 = BotWeaponModel.attach(a1.Shell, v1, a2.WeaponRevision or 0)
    if v3 ~= nil then
        a1.Weapon = v3
        a1.Recoil = BotWeaponRecoil.new(v1)
        a1.Animator:setWeapon(v1, tostring(v3.Revision), v2)
    end
end

function u85.PresentCombatEvents(a1) -- Line: 433
    -- upvalues: Workspace (val), u89 (val), BotCombatCodec (val), u103 (ref), BotPresentationState (val)
    -- upvalues: CharacterGeneration (val), u85 (val), BotWeaponEffects (val)
    local Descriptor, Entry, Weapon, v1, v2, v3, v4
    local ServerTimeNow = Workspace:GetServerTimeNow()
    local v5 = nil
    local v6 = nil
    for i, j in a1, v5, v6 do
        v4 = u89[j.ActorId]
        Entry = if not v4 then nil else v4.Entry
        Descriptor = if not v4 then nil else v4.Descriptor
        if v4 ~= nil and Entry ~= nil and Descriptor ~= nil then
            Weapon = Entry.Weapon
            v1 = false
            if Descriptor.WeaponName == j.WeaponName then
                v1 = false
                if Descriptor.WeaponRevision == j.WeaponRevision then
                    v1 = false
                    if Weapon ~= nil then
                        v1 = false
                        if Weapon.Name == j.WeaponName then
                            v1 = Weapon.Revision == j.WeaponRevision
                        end
                    end
                end
            end
            v2 = true
            v3 = j.WeaponRevision or 0
            if not ((Descriptor.WeaponRevision or 0) < v3) then
                v2 = false
                if Descriptor.WeaponName == j.WeaponName then
                    v2 = Descriptor.WeaponRevision == j.WeaponRevision
                end
            end
            if v1 or not v2 or j.ActorId ~= Descriptor.ActorId or j.Generation ~= Descriptor.Generation then
                if v1
                    and BotCombatCodec.canPresent(j, Descriptor, Entry.Visible, v4.LastEventSequence, ServerTimeNow)
                    and Entry.Shell:IsDescendantOf(Workspace)
                    and BotPresentationState.sameLife(Entry.Descriptor, Descriptor)
                    and (CharacterGeneration.Get(Entry.Shell)) == j.Generation then
                    v4.LastEventSequence = j.Sequence
                    u85.CombatEvent:Fire(j)
                    Entry.Animator:playAction(j.Kind)
                    if j.Kind ~= "Shoot" then
                        if j.Kind == "Reload" then
                            BotWeaponEffects.reloadSound(Weapon, Entry.Root, Entry.Shell:GetAttribute("SpectatedFirstPerson") == true)
                        end
                    elseif j.Target ~= nil then
                        if Entry.Recoil then
                            Entry.Recoil:OnShot(ServerTimeNow)
                        end
                        BotWeaponEffects.shoot(Weapon, j.Target, j.Sequence, Entry.Shell:GetAttribute("SpectatedFirstPerson") == true)
                    elseif j.Kind == "Reload" then
                        BotWeaponEffects.reloadSound(Weapon, Entry.Root, Entry.Shell:GetAttribute("SpectatedFirstPerson") == true)
                    end
                end
            elseif ServerTimeNow - j.ServerTime <= BotCombatCodec.MaxEventAgeSeconds then
                u103[v4] = j
            elseif v1
                and BotCombatCodec.canPresent(j, Descriptor, Entry.Visible, v4.LastEventSequence, ServerTimeNow)
                and Entry.Shell:IsDescendantOf(Workspace)
                and BotPresentationState.sameLife(Entry.Descriptor, Descriptor)
                and (CharacterGeneration.Get(Entry.Shell)) == j.Generation then
                v4.LastEventSequence = j.Sequence
                u85.CombatEvent:Fire(j)
                Entry.Animator:playAction(j.Kind)
                if j.Kind ~= "Shoot" then
                    if j.Kind == "Reload" then
                        BotWeaponEffects.reloadSound(Weapon, Entry.Root, Entry.Shell:GetAttribute("SpectatedFirstPerson") == true)
                    end
                elseif j.Target ~= nil then
                    if Entry.Recoil then
                        Entry.Recoil:OnShot(ServerTimeNow)
                    end
                    BotWeaponEffects.shoot(Weapon, j.Target, j.Sequence, Entry.Shell:GetAttribute("SpectatedFirstPerson") == true)
                elseif j.Kind == "Reload" then
                    BotWeaponEffects.reloadSound(Weapon, Entry.Root, Entry.Shell:GetAttribute("SpectatedFirstPerson") == true)
                end
            end
        end
    end
end

function u85.GetEquipment(a1, a2) -- Line: 491
    -- upvalues: u89 (val), HttpService (val)
    local v1 = u89[a1]
    local Entry = if not v1 then nil else v1.Entry
    if Entry and Entry.Visible and Entry.Descriptor.Generation == a2 then
        local Weapon = Entry.Weapon
        if not Weapon then
            return nil
        end
        local BotLoadout = Entry.Descriptor.BotLoadout and HttpService:JSONDecode(Entry.Descriptor.BotLoadout)
        local v2 = BotLoadout and BotLoadout.Weapons[Weapon.Name]
        return {
            Name = Weapon.Name,
            Revision = Weapon.Revision,
            Skin = if not v2 then "Stock" else v2.Skin,
            Float = if not v2 then 0 else v2.Float,
        }
    end
    return nil
end

function u85.GetRecoil(a1, a2) -- Line: 511 -- upvalues: u89 (val), Workspace (val) -- types: a1: number, a2: number
    local v1 = u89[a1]
    local Entry = if not v1 then nil else v1.Entry
    if Entry and Entry.Visible and Entry.Weapon and Entry.Recoil and Entry.Descriptor.Generation == a2 then
        return Entry.Recoil:Step((Workspace:GetServerTimeNow()))
    end
    return Vector2.zero
end

local function lifeDescriptor(a1, a2, a3) -- Line: 528 -- types: a1: table, a2: number, a3: number
    for i, j in {a1.Descriptor, a1.LastDescriptor} do
        if j and j.CombatantId == a2 and j.Generation == a3 then
            return j
        end
    end
    return nil
end

function u85.TakeCorpse(a1, a2, a3, a4) -- Line: 537
    -- upvalues: u101 (val), u88 (val), lifeDescriptor (val), createEntry (val), CharacterPose (val)
    -- upvalues: retireToCorpse (val), u102 (val), destroyShell (val), releaseCorpseSource (val)
    local Entry, v1
    local v2 = u101[a1]
    if v2 == nil then
        for i, j in u88 do
            v1 = lifeDescriptor(j, a1, a2)
            if v1 and j.CorpseGeneration ~= a2 then
                Entry = j.Entry
                if Entry == nil then
                    j.Entry = createEntry(j.Folder, v1, CharacterPose.composeRootCFrame(a3, a4))
                    retireToCorpse(j)
                    j.Entry = Entry
                elseif Entry.Descriptor.Generation == a2 then
                    retireToCorpse(j)
                else
                    j.Entry = createEntry(j.Folder, v1, CharacterPose.composeRootCFrame(a3, a4))
                    retireToCorpse(j)
                    j.Entry = Entry
                end
                v2 = u101[a1]
                break
            end
        end
    elseif v2.Generation ~= a2 then
        for k, n in u88 do
            v1 = lifeDescriptor(n, a1, a2)
            if v1 and n.CorpseGeneration ~= a2 then
                Entry = n.Entry
                if Entry == nil then
                    n.Entry = createEntry(n.Folder, v1, CharacterPose.composeRootCFrame(a3, a4))
                    retireToCorpse(n)
                    n.Entry = Entry
                elseif Entry.Descriptor.Generation == a2 then
                    retireToCorpse(n)
                else
                    n.Entry = createEntry(n.Folder, v1, CharacterPose.composeRootCFrame(a3, a4))
                    retireToCorpse(n)
                    n.Entry = Entry
                end
                v2 = u101[a1]
                break
            end
        end
    end
    if v2 ~= nil and v2.Generation == a2 then
        u101[a1] = nil
        local Entry_2 = v2.Entry
        local v3 = u102[a1]
        if v3 ~= nil then
            u102[a1] = nil
            destroyShell(v3)
        end
        u102[a1] = Entry_2
        task.delay(30, releaseCorpseSource, a1, Entry_2)
        return Entry_2.Shell
    end
    return nil
end

function u85.GetCamera(a1, a2) -- Line: 572
    -- upvalues: u89 (val), u90 (val), CharacterResolver (val), u85 (val)
    local v1 = u89[a1]
    local Entry = if not v1 then nil else v1.Entry
    local v2 = u90[a1]
    if Entry and Entry.Visible and v2 and Entry.Descriptor.Generation == a2 then
        local v3 = CharacterResolver.getCameraPart(Entry.Shell)
        if not v3 then
            return nil
        end
        local RenderPose = v2.RenderPose
        if RenderPose == nil then
            return nil
        end
        local v4 = u85.GetRecoil(a1, a2)
        local v5 = math.asin((math.clamp(RenderPose.VerticalLook, -1, 1)))
        return (CFrame.new(v3.Position)) * CFrame.Angles(0, RenderPose.LookYaw + v4.X, 0) * CFrame.Angles(v5 + v4.Y, 0, 0)
    end
    return nil
end

local function queueMove(a1, a2) -- Line: 595
    -- upvalues: RootFrame (val), CharacterPose (val), u91 (val), u92 (val), u93 (val), u94 (val)
    local v1 = CharacterPose.composeRootCFrame(
        a2.VisualRootPosition or RootFrame.simulationToVisualRootPosition(a2.Position, a2.DuckAmount),
        a2.LookYaw
    )
    if a1.Root.CFrame ~= v1 then
        local v2 = u91
        local v3 = #u91 + 1
        v2[v3] = a1.Root
        u92[#u92 + 1] = v1
    end
    u93[#u93 + 1] = a1
    u94[#u94 + 1] = a2
end

function u85.Present(a1) -- Line: 606
    -- upvalues: u85 (val), u101 (val), destroyShell (val), u90 (val), u91 (val), u92 (val), u93 (val), u94 (val)
    -- upvalues: u95 (val), u96 (val), u88 (val), BotPresentationState (val), retireToCorpse (val), hide (val)
    -- upvalues: RootFrame (val), CharacterPose (val), u97 (ref), u102 (val), createEntry (val), poseRootCFrame (val)
    -- upvalues: syncWeapon (val), Workspace (val), CharacterPresentationDescriptor (val), RuntimeKinematics (val)
    -- upvalues: u103 (ref)
    local Characters, Descriptor_2, Entry_2, Entry_3, ObjectiveAction, RenderPose_2, Shell, Velocity, Visible, Weapon_3, v1, v2, v3, v4, v5, v6
    u85.Initialize()
    local v7 = os.clock()
    for i, j in u101 do
        if j.ExpiresAt <= v7 then
            u101[i] = nil
            destroyShell(j.Entry)
        end
    end
    table.clear(u90)
    table.clear(u91)
    table.clear(u92)
    table.clear(u93)
    table.clear(u94)
    table.clear(u95)
    table.clear(u96)
    for k, n in a1 do
        if n.UserId == 0 then
            u90[n.ActorId] = n
        end
    end
    local v8 = nil
    local v9 = nil
    for m, i5 in u88, v8, v9 do
        Descriptor_2 = i5.Descriptor
        v6 = BotPresentationState.decide(Descriptor_2, if Descriptor_2 == nil then nil else u90[Descriptor_2.ActorId])
        i5.LastDecision = v6
        Entry_2 = i5.Entry
        if v6 ~= "Destroy" then
            if v6 ~= "Hide" then
                if v6 == "Present" then
                    if Entry_2 ~= nil then
                        RenderPose_2 = v5.RenderPose
                        v2 = CharacterPose.composeRootCFrame(
                            RenderPose_2.VisualRootPosition or RootFrame.simulationToVisualRootPosition(RenderPose_2.Position, RenderPose_2.DuckAmount),
                            RenderPose_2.LookYaw
                        )
                        if Entry_2.Root.CFrame ~= v2 then
                            v3 = u91
                            v4 = #u91 + 1
                            v3[v4] = Entry_2.Root
                            u92[#u92 + 1] = v2
                        end
                        u93[#u93 + 1] = Entry_2
                        u94[#u94 + 1] = RenderPose_2
                    end
                    if Entry_2 == nil then
                        u95[#u95 + 1] = i5
                        u96[#u96 + 1] = v5
                    else
                        v2 = Descriptor_2.WeaponName or ""
                        Weapon_3 = Entry_2.Weapon
                        if v2 ~= "" then
                            v1 = true
                            if Weapon_3 ~= nil then
                                v1 = true
                                if Weapon_3.Name == v2 then
                                    v1 = Weapon_3.Revision ~= (Descriptor_2.WeaponRevision or 0)
                                end
                            end
                        else
                            v1 = Weapon_3 ~= nil
                        end
                        if v1 then
                            u95[#u95 + 1] = i5
                            u96[#u96 + 1] = v5
                        end
                    end
                end
            elseif Entry_2 ~= nil then
                hide(Entry_2)
            end
        elseif i5.Entry == nil or Descriptor_2 == nil then
            Entry_3 = i5.Entry
            if Entry_3 ~= nil then
                i5.Entry = nil
                destroyShell(Entry_3)
            end
        elseif Descriptor_2.Dead then
            retireToCorpse(i5)
        elseif not (Descriptor_2.Health <= 0) then
            Entry_3 = i5.Entry
            if Entry_3 ~= nil then
                i5.Entry = nil
                destroyShell(Entry_3)
            end
        else
            retireToCorpse(i5)
        end
    end
    local v10 = #u95
    if v10 > 0 then
        local CombatantId, Descriptor, Entry, RenderPose, v11, v12, v13, v14
        v8 = u97 % v10
        v9 = math.min(2, v10)
        for i6 = 1, v9 do
            v5 = (v8 + i6 - 1) % v10 + 1
            v6 = u95[v5]
            v11 = u96[v5]
            Descriptor = v6.Descriptor
            if BotPresentationState.decide(Descriptor, v11) == "Present" then
                if not Descriptor or v6.CorpseGeneration ~= Descriptor.Generation then
                    Entry = v6.Entry
                    if Entry == nil then
                        v4 = u102[Descriptor.CombatantId]
                        if v4 and v4.Descriptor.Generation ~= Descriptor.Generation then
                            CombatantId = Descriptor.CombatantId
                            v12 = u102[CombatantId]
                            if v12 ~= nil then
                                u102[CombatantId] = nil
                                destroyShell(v12)
                            end
                        end
                        v6.Entry = (createEntry(v6.Folder, Descriptor, poseRootCFrame(v11.RenderPose)))
                    end
                    if Entry ~= nil then
                        syncWeapon(Entry, Descriptor)
                        if v3 then
                            RenderPose = v11.RenderPose
                            v12 = CharacterPose.composeRootCFrame(
                                RenderPose.VisualRootPosition or RootFrame.simulationToVisualRootPosition(RenderPose.Position, RenderPose.DuckAmount),
                                RenderPose.LookYaw
                            )
                            if Entry.Root.CFrame ~= v12 then
                                v13 = u91
                                v14 = #u91 + 1
                                v13[v14] = Entry.Root
                                u92[#u92 + 1] = v12
                            end
                            u93[#u93 + 1] = Entry
                            u94[#u94 + 1] = RenderPose
                        end
                    end
                end
            end
        end
        u97 = (v8 + v9) % v10
    end
    if #u91 == 1 then
        u91[1].CFrame = u92[1]
    elseif #u91 > 1 then
        Workspace:BulkMoveTo(u91, u92, Enum.BulkMoveMode.FireCFrameChanged)
    end
    v8 = os.clock()
    v9 = u93
    local v15 = nil
    local v16 = nil
    for i7, i8 in v9, v15, v16 do
        v6 = u94[i7]
        Visible = i8.Visible
        if not Visible then
            i8.ObjectiveAction = nil
            i8.Visible = true
            Shell = i8.Shell
            Characters = Workspace:FindFirstChild("Characters") or Workspace
            Shell.Parent = Characters
            i8.Shell:SetAttribute(CharacterPresentationDescriptor.VisibleAttribute, true)
            if i8.Weapon ~= nil then
                i8.Animator:setWeapon(i8.Weapon.Name, tostring(i8.Weapon.Revision), false)
            end
        end
        ObjectiveAction = i8.Descriptor.ObjectiveAction
        if i8.ObjectiveAction ~= ObjectiveAction then
            if ObjectiveAction ~= "Planting" then
                if i8.ObjectiveAction == "Planting" and i8.Weapon and i8.Weapon.Name == "C4" then
                    i8.Animator:playAction("Cancel Plant")
                end
                i8.ObjectiveAction = ObjectiveAction
            elseif i8.Weapon and i8.Weapon.Name == "C4" then
                i8.Animator:playAction("Use")
                i8.ObjectiveAction = ObjectiveAction
            end
        end
        v2 = false
        if i8.LastPosition ~= nil then
            v2 = 1e-05 < (v6.Position - i8.LastPosition).Magnitude
        end
        Velocity = if not v2 then Vector3.new(0, 0, 0) else v6.Velocity
        RuntimeKinematics.write(i8.Shell, Velocity, v6.OnGround)
        i8.LastPosition = v6.Position
        if not Visible or 0.016666666666666666 <= v8 - i8.LastAnimationAt then
            i8.Animator:updateLocomotion(Velocity, v6.OnGround, 0.5 < v6.DuckAmount, v6.MovementMode == "Ladder")
            if i8.Joints ~= nil then
                CharacterPose.applyVerticalLook(i8.Joints, v6.VerticalLook, 0.003)
            end
            i8.LastAnimationAt = v8
        end
    end
    if next(u103) ~= nil then
        v9 = u103
        u103 = {}
        for i9, i10 in v9 do
            u85.PresentCombatEvents({i10})
        end
    end
end

return u85