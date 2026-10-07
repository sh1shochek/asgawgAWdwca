-- ReplicatedStorage.Controllers.CharacterController.RemoteCharacters
-- Script path: ReplicatedStorage.Controllers.CharacterController.RemoteCharacters
-- Decompile time: 17.68 ms

local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local CharacterAnimator = require(ReplicatedStorage.Classes.Character.Classes.CharacterAnimator)
local Ragdoll = require(ReplicatedStorage.Classes.Ragdoll)
local CharacterActions = require(ReplicatedStorage.Database.Components.CharacterActions)
local Remotes = require(ReplicatedStorage.Database.Security.Remotes)
local CharacterGeneration = require(ReplicatedStorage.Components.Common.CharacterGeneration)
local ClientCharacterPresentation = require(ReplicatedStorage.Components.Common.ClientCharacterPresentation)
local CharacterPresentationDescriptor = require(ReplicatedStorage.Components.Common.CharacterPresentationDescriptor)
local CharacterPose = require(ReplicatedStorage.Components.Common.CharacterPose)
local CharacterResolver = require(ReplicatedStorage.Components.Common.CharacterResolver)
local RootFrame = require(ReplicatedStorage.MovementV2.RootFrame)
local RuntimeKinematics = require(ReplicatedStorage.MovementV2.RuntimeKinematics)
local Janitor = require(ReplicatedStorage.Shared.Janitor)
local BotCharacters = require(script.Parent.BotCharacters)
local LocalPlayer = Players.LocalPlayer
local u83 = {}
local u84 = {}
local u85 = {}
local u86 = {}
local u87 = false
local u88 = 0
local u89 = {}
local u90 = {}
local u91 = {}
local u92 = {}
local u93 = nil
local u97 = setmetatable({}, {__mode = "k"})

local function restoreEntryParent(a1) -- Line: 68
    -- upvalues: ClientCharacterPresentation (val), Workspace (val)
    if a1.Shell.Parent ~= ClientCharacterPresentation.GetCulledFolder() then
        return
    end
    local VisibleParent = a1.VisibleParent
    if VisibleParent == nil or not VisibleParent:IsDescendantOf(game) then
        a1.VisibleParent = Workspace:FindFirstChild("Characters") or Workspace
    end
    a1.Shell.Parent = VisibleParent
end

local function cullEntryFromWorkspace(a1) -- Line: 81 -- upvalues: ClientCharacterPresentation (val) -- types: a1: table
    local v1 = ClientCharacterPresentation.GetCulledFolder()
    local Parent = a1.Shell.Parent
    if Parent ~= nil and Parent ~= v1 then
        a1.VisibleParent = Parent
    end
    if a1.Shell.Parent ~= v1 then
        a1.Shell.Parent = v1
    end
end

local function decodeCurrentEquipped(a1) -- Line: 93 -- upvalues: HttpService (val) -- types: a1: userdata
    local Attribute = a1:GetAttribute("CurrentEquipped")
    if typeof(Attribute) == "string" and Attribute ~= "" then
        local success, result = pcall(HttpService.JSONDecode, HttpService, Attribute)
        if success and typeof(result) == "table" then
            local Name_2 = if typeof(result.Name) ~= "string" then nil else result.Name
            if typeof(result.Identifier) == "string" then
                return Name_2, result.Identifier
            end
            return Name_2, nil
        end
        return nil, nil
    end
    return nil, nil
end

local function syncEquippedWeapon(a1, a2) -- Line: 107
    -- upvalues: decodeCurrentEquipped (val)
    if not a1.Visible then
        return
    end
    local v1, v2 = decodeCurrentEquipped(a1.Player)
    a1.Animator:setWeapon(v1, v2, a2)
end

local function setEntryVisible(a1, a2) -- Line: 116
    -- upvalues: u93 (ref), RuntimeKinematics (val), ClientCharacterPresentation (val), Workspace (val)
    -- upvalues: CharacterPresentationDescriptor (val), decodeCurrentEquipped (val)
    local v1, v2
    if a1.Player == u93 and a1.Visible and a1.Shell:GetAttribute("Dead") ~= true then
        a2 = true
    end
    if a1.Visible == a2 then
        if a2 then
            if a1.Shell.Parent ~= ClientCharacterPresentation.GetCulledFolder() then
                return
            end
            local VisibleParent = a1.VisibleParent
            if VisibleParent == nil or not VisibleParent:IsDescendantOf(game) then
                a1.VisibleParent = Workspace:FindFirstChild("Characters") or Workspace
            end
            a1.Shell.Parent = VisibleParent
            return
        end
        RuntimeKinematics.clear(a1.Shell)
        v1 = ClientCharacterPresentation.GetCulledFolder()
        local Parent = a1.Shell.Parent
        if Parent ~= nil and Parent ~= v1 then
            a1.VisibleParent = Parent
        end
        if a1.Shell.Parent == v1 then
            return
        end
        a1.Shell.Parent = v1
        return
    end
    a1.Visible = a2
    if not a2 then
        a1.Shell:SetAttribute(CharacterPresentationDescriptor.VisibleAttribute, false)
        a1.Animator:stopAnimations(0)
        RuntimeKinematics.clear(a1.Shell)
        v1 = ClientCharacterPresentation.GetCulledFolder()
        local Parent_2 = a1.Shell.Parent
        if Parent_2 ~= nil and Parent_2 ~= v1 then
            a1.VisibleParent = Parent_2
        end
        if a1.Shell.Parent ~= v1 then
            a1.Shell.Parent = v1
        end
        return
    end
    if a1.Shell.Parent == ClientCharacterPresentation.GetCulledFolder() then
        local VisibleParent_2 = a1.VisibleParent
        if VisibleParent_2 == nil or not VisibleParent_2:IsDescendantOf(game) then
            a1.VisibleParent = Workspace:FindFirstChild("Characters") or Workspace
        end
        a1.Shell.Parent = VisibleParent_2
    end
    a1.Shell:SetAttribute(CharacterPresentationDescriptor.VisibleAttribute, true)
    if not a1.Visible then
        return
    end
    v1, v2 = decodeCurrentEquipped(a1.Player)
    a1.Animator:setWeapon(v1, v2, false)
end

function u83.SetPinnedPlayer(a1) -- Line: 146 -- upvalues: u93 (ref) -- types: a1: userdata?
    u93 = a1
end

function u83.GetCamera(a1) -- Line: 151 -- upvalues: u84 (val), CharacterResolver (val) -- types: a1: userdata
    local v1 = u84[a1]
    if v1 ~= nil and v1.Visible and v1.LookYaw ~= nil then
        local v2 = CharacterResolver.getCameraPart(v1.Shell)
        if v2 == nil then
            return nil
        end
        local v3 = math.asin((math.clamp(v1.VerticalLook or 0, -1, 1)))
        return (CFrame.new(v2.Position)) * CFrame.Angles(0, v1.LookYaw, 0) * CFrame.Angles(v3, 0, 0)
    end
    return nil
end

local function destroyPending(a1) -- Line: 164 -- upvalues: u86 (val) -- types: a1: userdata
    local v1 = u86[a1]
    if v1 == nil then
        return
    end
    u86[a1] = nil
    v1.Janitor:Destroy()
end

local function destroyEntry(a1, a2) -- Line: 173
    -- upvalues: u84 (val), u85 (val), setEntryVisible (val), RuntimeKinematics (val)
    local v1 = u84[a1]
    if v1 == nil then
        return
    end
    u84[a1] = nil
    if u85[a1.UserId] == v1 then
        u85[a1.UserId] = nil
    end
    if a2 ~= false
        and v1.Shell.Parent ~= nil
        and v1.Shell:GetAttribute("Dead") ~= true
        and a1.Character == v1.Shell then
        setEntryVisible(v1, true)
    end
    RuntimeKinematics.clear(v1.Shell)
    v1.Janitor:Destroy()
end

local function releaseHeldShell(a1) -- Line: 195 -- upvalues: u97 (val) -- types: a1: userdata
    local v1 = u97[a1]
    if v1 then
        u97[a1] = nil
        v1:destroy()
    end
end

local function retireDeadEntry(a1) -- Line: 204
    -- upvalues: setEntryVisible (val), u84 (val), u85 (val), RuntimeKinematics (val)
    -- upvalues: CharacterPresentationDescriptor (val), u97 (val), ClientCharacterPresentation (val)
    local Player = a1.Player
    local Shell = a1.Shell
    if a1.Visible and Shell.Parent ~= nil then
        local Animator = a1.Animator
        Animator:freezeAnimations()
        RuntimeKinematics.clear(Shell)
        Shell:SetAttribute(CharacterPresentationDescriptor.VisibleAttribute, false)
        for i, j in Shell:GetDescendants() do
            if j:IsA("BasePart") then
                j.CanQuery = false
            end
        end
        u97[Shell] = Animator
        a1.RetainAnimator = true
        local v1 = u84[Player]
        if v1 ~= nil then
            u84[Player] = nil
            if u85[Player.UserId] == v1 then
                u85[Player.UserId] = nil
            end
            RuntimeKinematics.clear(v1.Shell)
            v1.Janitor:Destroy()
        end
        task.delay(1.5, function() -- Line: 228 -- upvalues: u97 (upval), Shell (val), Animator (val), ClientCharacterPresentation (upval)
            if u97[Shell] ~= Animator then
                return
            end
            local v1 = Shell
            local v2 = u97[v1]
            if v2 then
                u97[v1] = nil
                v2:destroy()
            end
            if Shell.Parent then
                Shell.Parent = ClientCharacterPresentation.GetCulledFolder()
            end
        end)
        return
    end
    setEntryVisible(a1, false)
    local v2 = u84[Player]
    if v2 == nil then
        return
    end
    u84[Player] = nil
    if u85[Player.UserId] == v2 then
        u85[Player.UserId] = nil
    end
    RuntimeKinematics.clear(v2.Shell)
    v2.Janitor:Destroy()
end

local function tryBind(a1, a2) -- Line: 239
    -- upvalues: LocalPlayer (val), Players (val), u86 (val), u97 (val), CharacterPresentationDescriptor (val)
    -- upvalues: ClientCharacterPresentation (val), CharacterGeneration (val), CharacterResolver (val), u84 (val)
    -- upvalues: u85 (val), setEntryVisible (val), RuntimeKinematics (val), Janitor (val), CharacterAnimator (val)
    -- upvalues: CharacterPose (val), decodeCurrentEquipped (val), u83 (val), retireDeadEntry (val), Ragdoll (val)
    local v1
    if a1 ~= LocalPlayer and a1.Parent == Players and a1.Character == a2 and a2.Parent ~= nil then
        if a2:GetAttribute("Dead") == true then
            if u97[a2] then
                v1 = u86[a1]
                if v1 ~= nil then
                    u86[a1] = nil
                    v1.Janitor:Destroy()
                end
                return true
            end
            a2:SetAttribute(CharacterPresentationDescriptor.VisibleAttribute, false)
            a2.Parent = ClientCharacterPresentation.GetCulledFolder()
            v1 = u86[a1]
            if v1 ~= nil then
                u86[a1] = nil
                v1.Janitor:Destroy()
            end
            return true
        end
        v1 = CharacterGeneration.Get(a2)
        local v2 = CharacterResolver.resolve(a2)
        if v1 ~= nil and v2 ~= nil and v2.Animator ~= nil then
            local v3 = u84[a1]
            if v3 ~= nil then
                u84[a1] = nil
                if u85[a1.UserId] == v3 then
                    u85[a1.UserId] = nil
                end
                if v3.Shell.Parent ~= nil and v3.Shell:GetAttribute("Dead") ~= true and a1.Character == v3.Shell then
                    setEntryVisible(v3, true)
                end
                RuntimeKinematics.clear(v3.Shell)
                v3.Janitor:Destroy()
            end
            v3 = u97[a2]
            if v3 then
                u97[a2] = nil
                v3:destroy()
            end
            v3 = Janitor.new()
            local u100 = CharacterAnimator.new(a2)
            u100.Player = a1
            local u104 = {
                Visible = true,
                LastAnimationUpdateAt = (-1 / 0),
                PresentedFrame = 0,
                RetainAnimator = false,
                Player = a1,
                Shell = a2,
                Generation = v1,
                RootPart = v2.RootPart,
            }
            u104.Joints = CharacterPose.getJoints(a2)
            u104.Animator = u100
            u104.VisibleParent = a2.Parent
            u104.Janitor = v3
            u84[a1] = u104
            u85[a1.UserId] = u104
            local v4 = u86[a1]
            if v4 ~= nil then
                u86[a1] = nil
                v4.Janitor:Destroy()
            end
            v2.RootPart.Anchored = true
            v2.RootPart.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
            v2.RootPart.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
            v3:Add(function() -- Line: 291 -- upvalues: u104 (val), u100 (val)
                if not u104.RetainAnimator then
                    u100:destroy()
                end
            end)
            v3:Add(((a1:GetAttributeChangedSignal("CurrentEquipped")):Connect(function() -- Line: 296 -- upvalues: u84 (upval), a1 (val), u104 (val), decodeCurrentEquipped (upval)
                local v1 = u84[a1]
                if v1 == u104 then
                    v1 = u104
                    if not v1.Visible then
                        return
                    end
                    local v2, v3 = decodeCurrentEquipped(v1.Player)
                    v1.Animator:setWeapon(v2, v3, true)
                end
            end)))
            v3:Add((a2.DescendantAdded:Connect(function() -- Line: 301 -- upvalues: u104 (val), CharacterPose (upval), a2 (val)
                if u104.Joints == nil then
                    u104.Joints = CharacterPose.getJoints(a2)
                end
            end)))
            v3:Add((a2.DescendantRemoving:Connect(function(a1_2) -- Line: 306
                -- upvalues: u104 (val), u84 (upval), a1 (val), u85 (upval), setEntryVisible (upval)
                -- upvalues: RuntimeKinematics (upval), a2 (val), u83 (upval)
                local Joints = u104.Joints
                if Joints ~= nil then
                    if a1_2 == Joints.RightShoulder
                        or a1_2 == Joints.LeftShoulder
                        or a1_2 == Joints.Waist
                        or a1_2 == Joints.Neck then
                        u104.Joints = nil
                    end
                end
                if a1_2 == u104.RootPart or a1_2 == u104.Animator.Animator then
                    task.defer(function() -- Line: 320
                        -- upvalues: u84 (upval), a1 (upval), u104 (upval), u85 (upval), setEntryVisible (upval)
                        -- upvalues: RuntimeKinematics (upval), a2 (upval), u83 (upval)
                        local v1 = u84[a1]
                        if v1 == u104 then
                            v1 = a1
                            local v2 = u84[v1]
                            if v2 ~= nil then
                                u84[v1] = nil
                                if u85[v1.UserId] == v2 then
                                    u85[v1.UserId] = nil
                                end
                                if v2.Shell.Parent ~= nil
                                    and v2.Shell:GetAttribute("Dead") ~= true
                                    and v1.Character == v2.Shell then
                                    setEntryVisible(v2, true)
                                end
                                RuntimeKinematics.clear(v2.Shell)
                                v2.Janitor:Destroy()
                            end
                            if a1.Character == a2 and a2.Parent ~= nil then
                                u83.Track(a1, a2)
                            end
                        end
                    end)
                end
            end)))
            v3:Add((a2.AncestryChanged:Connect(function(a1_2, a2) -- Line: 330
                -- upvalues: u84 (upval), a1 (val), u104 (val), u85 (upval), RuntimeKinematics (upval)
                -- upvalues: ClientCharacterPresentation (upval)
                if a2 == nil then
                    local v1 = u84[a1]
                    if v1 == u104 then
                        v1 = a1
                        local v2 = u84[v1]
                        if v2 == nil then
                            return
                        end
                        u84[v1] = nil
                        if u85[v1.UserId] == v2 then
                            u85[v1.UserId] = nil
                        end
                        RuntimeKinematics.clear(v2.Shell)
                        v2.Janitor:Destroy()
                        return
                    end
                end
                if a2 ~= nil
                    and u84[a1] == u104
                    and not u104.Visible
                    and a2 ~= ClientCharacterPresentation.GetCulledFolder() then
                    task.defer(function() -- Line: 340 -- upvalues: u84 (upval), a1 (upval), u104 (upval), ClientCharacterPresentation (upval)
                        local v1 = u84[a1]
                        if v1 == u104
                            and not u104.Visible
                            and u104.Shell.Parent ~= ClientCharacterPresentation.GetCulledFolder() then
                            v1 = u104
                            local v2 = ClientCharacterPresentation.GetCulledFolder()
                            local Parent = v1.Shell.Parent
                            if Parent ~= nil and Parent ~= v2 then
                                v1.VisibleParent = Parent
                            end
                            if v1.Shell.Parent ~= v2 then
                                v1.Shell.Parent = v2
                            end
                        end
                    end)
                end
            end)))
            v3:Add(((a2:GetAttributeChangedSignal("Dead")):Connect(function() -- Line: 351 -- upvalues: a2 (val), u84 (upval), a1 (val), u104 (val), retireDeadEntry (upval)
                if a2:GetAttribute("Dead") == true and u84[a1] == u104 then
                    retireDeadEntry(u104)
                end
            end)))
            v3:Add(((a2:GetAttributeChangedSignal(CharacterGeneration.AttributeName)):Connect(function() -- Line: 356
                -- upvalues: CharacterGeneration (upval), a2 (val), u104 (val), u84 (upval), a1 (val), u83 (upval)
                if (CharacterGeneration.Get(a2)) ~= u104.Generation and u84[a1] == u104 then
                    u83.Track(a1, a2)
                end
            end)))
            if u104.Visible then
                local v5
                v4, v5 = decodeCurrentEquipped(u104.Player)
                u104.Animator:setWeapon(v4, v5, false)
            end
            setEntryVisible(u104, false)
            task.spawn(function() -- Line: 365 -- upvalues: a2 (val), Ragdoll (upval), a1 (val)
                if a2:IsDescendantOf(game) and a2:GetAttribute("Dead") ~= true then
                    local success, result = pcall(Ragdoll.PrepareCharacter, a2)
                    if not success then
                        warn((("[RemoteCharacters] Ragdoll preparation failed for %*: %*"):format(a1.Name, result)))
                    end
                end
            end)
            return true
        end
        return false
    end
    v1 = u86[a1]
    if v1 ~= nil then
        u86[a1] = nil
        v1.Janitor:Destroy()
    end
    return false
end

function u83.Track(a1, a2) -- Line: 376
    -- upvalues: LocalPlayer (val), u84 (val), CharacterGeneration (val), u85 (val), setEntryVisible (val)
    -- upvalues: RuntimeKinematics (val), u86 (val), tryBind (val), Janitor (val)
    if a1 ~= LocalPlayer and a1.Character == a2 then
        local v1 = u84[a1]
        if v1 ~= nil
            and a2:GetAttribute("Dead") ~= true
            and v1.Shell == a2
            and v1.Generation == CharacterGeneration.Get(a2) then
            return
        end
        local v2 = u84[a1]
        if v2 ~= nil then
            u84[a1] = nil
            if u85[a1.UserId] == v2 then
                u85[a1.UserId] = nil
            end
            if v2.Shell.Parent ~= nil and v2.Shell:GetAttribute("Dead") ~= true and a1.Character == v2.Shell then
                setEntryVisible(v2, true)
            end
            RuntimeKinematics.clear(v2.Shell)
            v2.Janitor:Destroy()
        end
        v2 = u86[a1]
        if v2 ~= nil and v2.Shell == a2 then
            tryBind(a1, a2)
            return
        end
        local v3 = u86[a1]
        if v3 ~= nil then
            u86[a1] = nil
            v3.Janitor:Destroy()
        end
        v3 = Janitor.new()
        u86[a1] = {Shell = a2, Janitor = v3}

        local function retry() -- Line: 400 -- upvalues: u86 (upval), a1 (val), tryBind (upval), a2 (val)
            if u86[a1] ~= nil then
                tryBind(a1, a2)
            end
        end

        v3:Add((a2.DescendantAdded:Connect(retry)))
        v3:Add(((a2:GetAttributeChangedSignal("CharacterType")):Connect(retry)))
        v3:Add(((a2:GetAttributeChangedSignal("Dead")):Connect(retry)))
        v3:Add(((a2:GetAttributeChangedSignal(CharacterGeneration.AttributeName)):Connect(retry)))
        v3:Add((a2.AncestryChanged:Connect(function() -- Line: 409 -- upvalues: a2 (val), a1 (val), u86 (upval), tryBind (upval)
            if a2.Parent ~= nil then
                if u86[a1] ~= nil then
                    tryBind(a1, a2)
                end
                return
            end
            local v1 = a1
            local v2 = u86[v1]
            if v2 == nil then
                return
            end
            u86[v1] = nil
            v2.Janitor:Destroy()
        end)))
        if u86[a1] ~= nil then
            tryBind(a1, a2)
        end
        return
    end
end

function u83.Untrack(a1, a2) -- Line: 419
    -- upvalues: u84 (val), u85 (val), setEntryVisible (val), RuntimeKinematics (val), u86 (val)
    local v1
    local v2 = u84[a1]
    if v2 ~= nil then
        if a2 == nil or v2.Shell == a2 then
            v1 = u84[a1]
            if v1 ~= nil then
                u84[a1] = nil
                if u85[a1.UserId] == v1 then
                    u85[a1.UserId] = nil
                end
                if v1.Shell.Parent ~= nil and v1.Shell:GetAttribute("Dead") ~= true and a1.Character == v1.Shell then
                    setEntryVisible(v1, true)
                end
                RuntimeKinematics.clear(v1.Shell)
                v1.Janitor:Destroy()
            end
        end
    end
    v1 = u86[a1]
    if v1 ~= nil then
        if a2 ~= nil and v1.Shell ~= a2 then
            return
        end
        local v3 = u86[a1]
        if v3 == nil then
            return
        end
        u86[a1] = nil
        v3.Janitor:Destroy()
    end
end

function u83.Present(a1, a2) -- Line: 430
    -- upvalues: BotCharacters (val), u88 (ref), u89 (val), u90 (val), u91 (val), u92 (val), u85 (val), Players (val)
    -- upvalues: LocalPlayer (val), CharacterGeneration (val), u84 (val), ClientCharacterPresentation (val), u83 (val)
    -- upvalues: RootFrame (val), CharacterPose (val), Workspace (val), setEntryVisible (val), RuntimeKinematics (val)
    -- upvalues: retireDeadEntry (val)
    local Character, LastPosePosition, Player, RenderPose, Shell, Velocity, Visible, v1, v2, v3, v4, v5, v6, v7, v8, v9
    BotCharacters.Present(a1)
    u88 = u88 + 1
    table.clear(u89)
    table.clear(u90)
    table.clear(u91)
    table.clear(u92)
    local v10 = nil
    local v11 = nil
    for i, j in a1, v10, v11 do
        if j.UserId ~= 0 then
            v7 = u85[j.UserId]
            Player = if v7 == nil then Players:GetPlayerByUserId(j.UserId) else v7.Player
            if Player ~= nil and Player ~= LocalPlayer then
                if v7 ~= nil
                    and v7.Generation == j.Generation
                    and (CharacterGeneration.Get(v7.Shell)) == j.Generation then
                    v7.PresentedFrame = u88
                end
                RenderPose = j.RenderPose
                if RenderPose ~= nil then
                    v7 = u84[Player]
                    Character = Player.Character
                    if not ClientCharacterPresentation.IsOwned(Character)
                        or Character == nil
                        or (CharacterGeneration.Get(Character)) ~= RenderPose.Generation then
                        Character = ClientCharacterPresentation.Create(Player, RenderPose.Generation)
                    end
                    if Character ~= nil then
                        if v7 == nil or v7.Shell ~= Character or v7.Generation ~= RenderPose.Generation then
                            u83.Track(Player, Character)
                            v7 = u84[Player]
                        end
                    end
                    if v7 ~= nil
                        and Character ~= nil
                        and v7.Shell == Character
                        and v7.Shell.Parent ~= nil
                        and v7.Shell:GetAttribute("Dead") ~= true
                        and v7.Generation == RenderPose.Generation
                        and (CharacterGeneration.Get(v7.Shell)) == RenderPose.Generation then
                        v7.PresentedFrame = u88
                        v2 = CharacterPose.composeRootCFrame(
                            RenderPose.VisualRootPosition or RootFrame.simulationToVisualRootPosition(RenderPose.Position, RenderPose.DuckAmount),
                            RenderPose.LookYaw
                        )
                        if v7.RootPart.CFrame ~= v2 then
                            v3 = u89
                            v4 = #u89 + 1
                            v3[v4] = v7.RootPart
                            u90[#u90 + 1] = v2
                        end
                        u91[#u91 + 1] = v7
                        u92[#u92 + 1] = RenderPose
                    end
                end
            end
        end
    end
    if #u89 == 1 then
        u89[1].CFrame = u90[1]
    elseif #u89 > 1 then
        Workspace:BulkMoveTo(u89, u90, Enum.BulkMoveMode.FireCFrameChanged)
    end
    local v12 = os.clock()
    v11 = nil
    local v13 = nil
    for k, n in u91, v11, v13 do
        v8 = u92[k]
        Visible = n.Visible
        setEntryVisible(n, true)
        LastPosePosition = n.LastPosePosition
        v1 = false
        if LastPosePosition ~= nil then
            v1 = 1e-05 < (v8.Position - LastPosePosition).Magnitude
        end
        Velocity = if not v1 then Vector3.new(0, 0, 0) else v8.Velocity
        RuntimeKinematics.write(n.Shell, Velocity, v8.OnGround)
        n.LastPosePosition = v8.Position
        n.LookYaw = v8.LookYaw
        n.VerticalLook = v8.VerticalLook
        v3 = v12 - n.LastAnimationUpdateAt
        if not Visible or v3 >= 0.016666666666666666 then
            v4 = 0.5 < v8.DuckAmount
            v5 = v8.MovementMode == "Ladder"
            n.Animator:updateLocomotion(Velocity, v8.OnGround, v4, v5)
            if n.Joints ~= nil then
                CharacterPose.applyVerticalLook(n.Joints, v8.VerticalLook, 0.003)
            end
            v6 = if v3 ~= (1 / 0) then n.LastAnimationUpdateAt + math.floor(v3 / 0.016666666666666666) * 0.016666666666666666 else v12
            n.LastAnimationUpdateAt = v6
        end
    end
    v11 = nil
    v13 = nil
    for m, i5 in u84, v11, v13 do
        if i5.PresentedFrame ~= u88 then
            if m.Parent ~= Players or m.Character ~= i5.Shell or i5.Shell.Parent == nil then
                v8 = u84[m]
                if v8 ~= nil then
                    u84[m] = nil
                    if u85[m.UserId] == v8 then
                        u85[m.UserId] = nil
                    end
                    RuntimeKinematics.clear(v8.Shell)
                    v8.Janitor:Destroy()
                end
            elseif i5.Shell:GetAttribute("Dead") == true then
                retireDeadEntry(i5)
            elseif (CharacterGeneration.Get(i5.Shell)) == i5.Generation then
                setEntryVisible(i5, false)
            else
                Shell = i5.Shell
                v9 = u84[m]
                if v9 ~= nil then
                    u84[m] = nil
                    if u85[m.UserId] == v9 then
                        u85[m.UserId] = nil
                    end
                    RuntimeKinematics.clear(v9.Shell)
                    v9.Janitor:Destroy()
                end
                ClientCharacterPresentation.Release(m, Shell)
            end
        end
    end
end

function u83.Initialize() -- Line: 554
    -- upvalues: u87 (ref), BotCharacters (val), Remotes (val), Players (val), LocalPlayer (val), u84 (val)
    -- upvalues: CharacterActions (val), CharacterGeneration (val), u93 (ref), u85 (val), RuntimeKinematics (val)
    -- upvalues: u86 (val), ClientCharacterPresentation (val)
    if u87 then
        return
    end
    u87 = true
    BotCharacters.Initialize()
    Remotes.Character.Action.Listen(function(a1) -- Line: 561
        -- upvalues: Players (upval), LocalPlayer (upval), u84 (upval), CharacterActions (upval)
        -- upvalues: CharacterGeneration (upval)
        local PlayerByUserId = Players:GetPlayerByUserId(a1.UserId)
        if PlayerByUserId ~= nil and PlayerByUserId ~= LocalPlayer then
            local v1 = u84[PlayerByUserId]
            local v2 = CharacterActions.ToName(a1.ActionId)
            if v1 ~= nil
                and v1.Visible
                and v1.Generation == a1.Generation
                and (CharacterGeneration.Get(v1.Shell)) == a1.Generation
                and PlayerByUserId.Character == v1.Shell
                and v1.Shell:GetAttribute("Dead") ~= true
                and v2 ~= nil then
                v1.Animator:playAction(v2)
            end
            return
        end
    end)
    Players.PlayerRemoving:Connect(function(a1) -- Line: 580
        -- upvalues: u93 (upval), u84 (upval), u85 (upval), RuntimeKinematics (upval), u86 (upval)
        -- upvalues: ClientCharacterPresentation (upval)
        if u93 == a1 then
            u93 = nil
        end
        local Character = a1.Character
        local v1 = u84[a1]
        if v1 ~= nil then
            u84[a1] = nil
            if u85[a1.UserId] == v1 then
                u85[a1.UserId] = nil
            end
            RuntimeKinematics.clear(v1.Shell)
            v1.Janitor:Destroy()
        end
        v1 = u86[a1]
        if v1 ~= nil then
            u86[a1] = nil
            v1.Janitor:Destroy()
        end
        ClientCharacterPresentation.Release(a1, Character)
    end)
end

return u83