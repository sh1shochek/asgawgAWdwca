-- ReplicatedStorage.Components.Common.CharacterResolver
-- Script path: ReplicatedStorage.Components.Common.CharacterResolver
-- Decompile time: 4.02 ms

local Players = game:GetService("Players")
local CharacterPresentationDescriptor = require(script.Parent.CharacterPresentationDescriptor)
local u10 = {}

local function getBasePart(a1, a2) -- Line: 20 -- types: a1: userdata?, a2: string
    local v1 = if not a1 then nil else a1:FindFirstChild(a2)
    if v1 and v1:IsA("BasePart") then
        return v1
    end
    return nil
end

function u10.getRootPart(a1) -- Line: 25 -- types: a1: userdata?
    local HumanoidRootPart = if not a1 then nil else a1:FindFirstChild("HumanoidRootPart")
    if HumanoidRootPart and HumanoidRootPart:IsA("BasePart") then
        return HumanoidRootPart
    end
    return nil
end

function u10.getHead(a1) -- Line: 29 -- types: a1: userdata?
    local Head = if not a1 then nil else a1:FindFirstChild("Head")
    if Head and Head:IsA("BasePart") then
        return Head
    end
    return nil
end

function u10.pivotCharacter(a1, a2) -- Line: 40 -- upvalues: u10 (val) -- types: a1: userdata, a2: userdata
    local v1 = u10.getRootPart(a1)
    if v1 and a1.PrimaryPart ~= v1 then
        a1.PrimaryPart = v1
    end
    a1:PivotTo(a2)
end

function u10.pivotCharacterTo(a1, a2) -- Line: 49 -- upvalues: u10 (val) -- types: a1: userdata, a2: vector
    local v1 = u10.getRootPart(a1)
    if not v1 then
        return
    end
    u10.pivotCharacter(a1, v1.CFrame.Rotation + a2)
end

function u10.getAnimationController(a1) -- Line: 57 -- types: a1: userdata?
    local AnimationController = if not a1 then nil else a1:FindFirstChild("AnimationController")
    if AnimationController and AnimationController:IsA("AnimationController") then
        return AnimationController
    end
    return nil
end

function u10.getOrCreateAnimator(a1) -- Line: 62 -- upvalues: u10 (val) -- types: a1: userdata
    local v1 = u10.getAnimationController(a1)
    if not v1 then
        v1 = Instance.new("AnimationController")
        v1.Name = "AnimationController"
        v1.Parent = a1
    end
    local Animator = v1:FindFirstChild("Animator")
    if Animator then
        assert(Animator:IsA("Animator"), (("Expected %*.Animator to be an Animator"):format((v1:GetFullName()))))
        return Animator
    end
    local Animator_2 = Instance.new("Animator")
    Animator_2.Parent = v1
    return Animator_2
end

function u10.getAnimator(a1) -- Line: 81 -- upvalues: u10 (val) -- types: a1: userdata?
    local v1 = u10.getAnimationController(a1)
    local Animator = if not v1 then nil else v1:FindFirstChild("Animator")
    if Animator and Animator:IsA("Animator") then
        return Animator
    end
    return nil
end

function u10.getCameraPart(a1) -- Line: 87 -- types: a1: userdata?
    local CameraPart = if not a1 then nil else a1:FindFirstChild("CameraPart")
    if CameraPart and CameraPart:IsA("BasePart") then
        return CameraPart
    end
    return nil
end

function u10.createCameraPart(a1) -- Line: 91 -- upvalues: u10 (val) -- types: a1: userdata
    local v1 = ("%* already has a CameraPart"):format((a1:GetFullName()))
    assert(not a1:FindFirstChild("CameraPart"), v1)
    local v2 = assert(u10.getRootPart(a1), (("%* has no HumanoidRootPart"):format((a1:GetFullName()))))
    local v3 = assert(u10.getHead(a1), (("%* has no Head"):format((a1:GetFullName()))))
    local Part = Instance.new("Part")
    Part.Name = "CameraPart"
    Part.Size = Vector3.new(0.20000000298023224, 0.20000000298023224, 0.20000000298023224)
    Part.Transparency = 1
    Part.CanCollide = false
    Part.CanTouch = false
    Part.CanQuery = false
    Part.CastShadow = false
    Part.Massless = true
    Part.CFrame = CFrame.new(v3.Position)
    Part.Parent = a1
    local Weld = Instance.new("Weld")
    Weld.Name = "CameraPartWeld"
    Weld.Part0 = v2
    Weld.Part1 = Part
    Weld.C0 = CFrame.new(v2.CFrame:PointToObjectSpace(v3.Position))
    Weld.Parent = Part
    return Part
end

function u10.resolve(a1) -- Line: 120 -- upvalues: u10 (val) -- types: a1: userdata?
    if not a1 then
        return nil
    end
    local v1 = u10.getRootPart(a1)
    local v2 = u10.getCameraPart(a1)
    if v1 and v2 then
        return {
            Character = a1,
            RootPart = v1,
            Head = u10.getHead(a1),
            CameraPart = v2,
            AnimationController = u10.getAnimationController(a1),
            Animator = u10.getAnimator(a1),
        }
    end
    return nil
end

function u10.getPlayerFromCharacter(a1) -- Line: 141
    -- upvalues: Players (val), CharacterPresentationDescriptor (val)
    if a1 == nil then
        return nil
    end
    local PlayerFromCharacter = Players:GetPlayerFromCharacter(a1)
    if PlayerFromCharacter ~= nil then
        return PlayerFromCharacter
    end
    local Attribute = a1:GetAttribute(CharacterPresentationDescriptor.OwnerUserIdAttribute)
    if typeof(Attribute) == "number" then
        return (Players:GetPlayerByUserId(Attribute))
    end
    return nil
end

function u10.getPlayerFromInstance(a1) -- Line: 153 -- upvalues: u10 (val) -- types: a1: userdata?
    local v1
    if a1 == nil then
        return nil
    end
    local v2 = a1:FindFirstAncestorOfClass("Model")
    while v2 ~= nil do
        v1 = u10.getPlayerFromCharacter(v2)
        if v1 ~= nil then
            return v1
        end
        v2 = v2:FindFirstAncestorOfClass("Model")
    end
    return nil
end

function u10.getPlayerCharacter(a1) -- Line: 168 -- types: a1: userdata?
    local Character = if not a1 then nil else a1.Character
    if Character and Character.Parent then
        return Character
    end
    return nil
end

function u10.getLocalCharacter() -- Line: 173 -- upvalues: u10 (val), Players (val)
    return u10.getPlayerCharacter(Players.LocalPlayer)
end

function u10.observeCharacter(a1, a2) -- Line: 177 -- upvalues: u10 (val) -- types: a1: userdata, a2: function
    local u5 = u10.getPlayerCharacter(a1)
    local u9 = a2(u5, nil)
    local u15 = a1.CharacterAdded:Connect(function(a1) -- Line: 181 -- upvalues: u5 (ref), u9 (ref), a2 (val) -- types: a1: userdata?
        if a1 == u5 then
            return
        end
        local v1 = u5
        u5 = a1
        if u9 then
            u9()
        end
        u9 = a2(a1, v1)
    end)
    local u20 = a1.CharacterRemoving:Connect(function(a1) -- Line: 195 -- upvalues: u5 (ref), u9 (ref), a2 (val)
        if a1 == u5 then
            if u5 == nil then
                return
            end
            local v1 = u5
            u5 = nil
            if u9 then
                u9()
            end
            u9 = a2(nil, v1)
        end
    end)
    return function() -- Line: 201 -- upvalues: u15 (val), u20 (val), u9 (ref)
        u15:Disconnect()
        u20:Disconnect()
        if u9 then
            u9()
        end
    end
end

function u10.isPlayerCharacter(a1) -- Line: 210 -- upvalues: u10 (val) -- types: a1: userdata?
    local v1 = false
    if a1 ~= nil then
        v1 = false
        if a1:GetAttribute("CharacterType") == "PlayerCustomCharacter" then
            v1 = u10.getRootPart(a1) ~= nil
        end
    end
    return v1
end

function u10.isTutorialDummy(a1) -- Line: 216 -- upvalues: u10 (val) -- types: a1: userdata?
    local v1 = false
    if a1 ~= nil then
        v1 = false
        if a1:GetAttribute("TutorialDummy") == true then
            v1 = u10.getRootPart(a1) ~= nil
        end
    end
    return v1
end

function u10.isTutorialCutout(a1) -- Line: 222 -- types: a1: userdata?
    local v1 = false
    if a1 ~= nil then
        v1 = a1:GetAttribute("TutorialCutout") == true
    end
    return v1
end

function u10.getCutoutBoard(a1) -- Line: 227 -- upvalues: u10 (val) -- types: a1: userdata?
    local v1 = if not a1 then a1 and a1:FindFirstAncestorOfClass("Model") else if not a1:IsA("Model") then a1 and a1:FindFirstAncestorOfClass("Model") else a1
    while v1 do
        if u10.isTutorialCutout(v1) then
            return v1.PrimaryPart
        end
        v1 = v1:FindFirstAncestorOfClass("Model")
    end
    return nil
end

function u10.isCutoutHeadshot(a1, a2) -- Line: 248 -- types: a1: userdata?, a2: vector?
    if a1 and typeof(a2) == "Vector3" then
        local Y = (a1.CFrame:PointToObjectSpace(a2)).Y
        return a1.Size.Y * 0.345 <= Y
    end
    return false
end

function u10.getImpactMaterial(a1, a2) -- Line: 256 -- upvalues: u10 (val) -- types: a1: userdata?, a2: string?
    local v1 = if not a1 then a1 and a1:FindFirstAncestorOfClass("Model") else if not a1:IsA("Model") then a1 and a1:FindFirstAncestorOfClass("Model") else a1
    while v1 do
        if u10.isTutorialCutout(v1) then
            return "WoodPlanks"
        end
        if not u10.isPlayerCharacter(v1) and not u10.isTutorialDummy(v1) then
            v1 = v1:FindFirstAncestorOfClass("Model")
            continue
        end
        return "Blood Splatter"
    end
    return a2 or "Plastic"
end

function u10.getHealth(a1) -- Line: 270 -- types: a1: userdata?
    local Attribute = if not a1 then nil else a1:GetAttribute("Health")
    if typeof(Attribute) == "number" then
        return Attribute
    end
    return 0
end

function u10.getMaxHealth(a1) -- Line: 275 -- types: a1: userdata?
    local Attribute = if not a1 then nil else a1:GetAttribute("MaxHealth")
    if typeof(Attribute) == "number" then
        return Attribute
    end
    return 0
end

function u10.isAliveCharacter(a1) -- Line: 280 -- upvalues: u10 (val) -- types: a1: userdata?
    local v1 = false
    if a1 ~= nil then
        v1 = a1:IsDescendantOf(workspace)
        if v1 then
            v1 = false
            if a1:GetAttribute("Dead") == false then
                v1 = 0 < (u10.getHealth(a1))
            end
        end
    end
    return v1
end

function u10.isAlivePlayer(a1) -- Line: 287
    -- upvalues: Players (val), CharacterPresentationDescriptor (val)
    if a1 ~= nil and a1.Parent == Players and a1:GetAttribute("Dead") == false then
        local Attribute = a1:GetAttribute(CharacterPresentationDescriptor.Attributes.Health)
        local v1 = false
        if typeof(Attribute) == "number" then
            v1 = Attribute > 0
        end
        return v1
    end
    return false
end

return u10