-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local CharacterPresentationDescriptor = require(script.Parent.CharacterPresentationDescriptor);
local u1 = {};

local function getBasePart(p2: userdata?, p3: string) -- Line: 20
    local v4;

    if p2 then
        v4 = p2:FindFirstChild(p3);
    else
        v4 = nil;
    end;

    if v4 and v4:IsA("BasePart") then
        return v4;
    end;

    return nil;
end;

function u1.getRootPart(p5: userdata?) -- Line: 25
    local v6;

    if p5 then
        v6 = p5:FindFirstChild("HumanoidRootPart");
    else
        v6 = nil;
    end;

    if v6 and v6:IsA("BasePart") then
        return v6;
    end;

    return nil;
end;

function u1.getHead(p7: userdata?) -- Line: 29
    local v8;

    if p7 then
        v8 = p7:FindFirstChild("Head");
    else
        v8 = nil;
    end;

    if v8 and v8:IsA("BasePart") then
        return v8;
    end;

    return nil;
end;

function u1.pivotCharacter(p9: userdata, p10) -- Line: 40
    -- upvalues: u1 (copy)
    local RootPart = u1.getRootPart(p9);

    if RootPart and p9.PrimaryPart ~= RootPart then
        p9.PrimaryPart = RootPart;
    end;

    p9:PivotTo(p10);
end;

function u1.pivotCharacterTo(p11: userdata, p12: vector) -- Line: 49
    -- upvalues: u1 (copy)
    local RootPart = u1.getRootPart(p11);

    if not RootPart then
        return;
    end;

    u1.pivotCharacter(p11, RootPart.CFrame.Rotation + p12);
end;

function u1.getAnimationController(p13: userdata?) -- Line: 57
    local v14;

    if p13 then
        v14 = p13:FindFirstChild("AnimationController");
    else
        v14 = nil;
    end;

    if v14 and v14:IsA("AnimationController") then
        return v14;
    end;

    return nil;
end;

function u1.getOrCreateAnimator(p15: userdata) -- Line: 62
    -- upvalues: u1 (copy)
    local AnimationController = u1.getAnimationController(p15);

    if not AnimationController then
        AnimationController = Instance.new("AnimationController");
        AnimationController.Name = "AnimationController";
        AnimationController.Parent = p15;
    end;

    local Animator = AnimationController:FindFirstChild("Animator");

    if not Animator then
        local Animator2 = Instance.new("Animator");
        Animator2.Parent = AnimationController;

        return Animator2;
    end;

    local v16 = Animator:IsA("Animator");
    local v17 = `Expected {AnimationController:GetFullName()}.Animator to be an Animator`;
    assert(v16, v17);

    return Animator;
end;

function u1.getAnimator(p18: userdata?) -- Line: 81
    -- upvalues: u1 (copy)
    local AnimationController = u1.getAnimationController(p18);
    local v19;

    if AnimationController then
        v19 = AnimationController:FindFirstChild("Animator");
    else
        v19 = nil;
    end;

    if v19 and v19:IsA("Animator") then
        return v19;
    end;

    return nil;
end;

function u1.getCameraPart(p20: userdata?) -- Line: 87
    local v21;

    if p20 then
        v21 = p20:FindFirstChild("CameraPart");
    else
        v21 = nil;
    end;

    if v21 and v21:IsA("BasePart") then
        return v21;
    end;

    return nil;
end;

function u1.createCameraPart(p22: userdata) -- Line: 91
    -- upvalues: u1 (copy)
    local v23 = not p22:FindFirstChild("CameraPart");
    local v24 = `{p22:GetFullName()} already has a CameraPart`;
    assert(v23, v24);
    local RootPart = u1.getRootPart(p22);
    local v25 = `{p22:GetFullName()} has no HumanoidRootPart`;
    local v26 = assert(RootPart, v25);
    local Head = u1.getHead(p22);
    local v27 = `{p22:GetFullName()} has no Head`;
    local v28 = assert(Head, v27);
    local Part = Instance.new("Part");
    Part.Name = "CameraPart";
    Part.Size = Vector3.new(0.2, 0.2, 0.2);
    Part.Transparency = 1;
    Part.CanCollide = false;
    Part.CanTouch = false;
    Part.CanQuery = false;
    Part.CastShadow = false;
    Part.Massless = true;
    Part.CFrame = CFrame.new(v28.Position);
    Part.Parent = p22;
    local Weld = Instance.new("Weld");
    Weld.Name = "CameraPartWeld";
    Weld.Part0 = v26;
    Weld.Part1 = Part;
    Weld.C0 = CFrame.new(v26.CFrame:PointToObjectSpace(v28.Position));
    Weld.Parent = Part;

    return Part;
end;

function u1.resolve(p29: userdata?) -- Line: 120
    -- upvalues: u1 (copy)
    if not p29 then
        return nil;
    end;

    local RootPart = u1.getRootPart(p29);
    local CameraPart = u1.getCameraPart(p29);

    return RootPart and CameraPart and {
        Character = p29,
        RootPart = RootPart,
        Head = u1.getHead(p29),
        CameraPart = CameraPart,
        AnimationController = u1.getAnimationController(p29),
        Animator = u1.getAnimator(p29)
    } or nil;
end;

function u1.getPlayerFromCharacter(p30: userdata?) -- Line: 141
    -- upvalues: Players (copy), CharacterPresentationDescriptor (copy)
    if p30 == nil then
        return nil;
    end;

    local PlayerFromCharacter = Players:GetPlayerFromCharacter(p30);

    if PlayerFromCharacter ~= nil then
        return PlayerFromCharacter;
    end;

    local Attribute = p30:GetAttribute(CharacterPresentationDescriptor.OwnerUserIdAttribute);

    if typeof(Attribute) == "number" then
        return Players:GetPlayerByUserId(Attribute);
    end;

    return nil;
end;

function u1.getPlayerFromInstance(p31: userdata?) -- Line: 153
    -- upvalues: u1 (copy)
    if p31 == nil then
        return nil;
    end;

    local v32 = p31:FindFirstAncestorOfClass("Model");

    while v32 ~= nil do
        local PlayerFromCharacter = u1.getPlayerFromCharacter(v32);

        if PlayerFromCharacter ~= nil then
            return PlayerFromCharacter;
        end;

        v32 = v32:FindFirstAncestorOfClass("Model");
    end;

    return nil;
end;

function u1.getPlayerCharacter(p33: userdata?) -- Line: 168
    local v34;

    if p33 then
        v34 = p33.Character;
    else
        v34 = nil;
    end;

    if v34 and v34.Parent then
        return v34;
    end;

    return nil;
end;

function u1.getLocalCharacter() -- Line: 173
    -- upvalues: u1 (copy), Players (copy)
    return u1.getPlayerCharacter(Players.LocalPlayer);
end;

function u1.observeCharacter(p35: userdata, u36: function) -- Line: 177
    -- upvalues: u1 (copy)
    local PlayerCharacter = u1.getPlayerCharacter(p35);
    local u37 = u36(PlayerCharacter, nil);
    local u40 = p35.CharacterAdded:Connect(function(p38: userdata?) -- Line: 181, Name: setCharacter
        -- upvalues: PlayerCharacter (ref), u37 (ref), u36 (copy)
        if p38 == PlayerCharacter then
            return;
        end;

        local v39 = PlayerCharacter;
        PlayerCharacter = p38;

        if u37 then
            u37();
        end;

        u37 = u36(p38, v39);
    end);
    local u43 = p35.CharacterRemoving:Connect(function(p41) -- Line: 195
        -- upvalues: PlayerCharacter (ref), u37 (ref), u36 (copy)
        if p41 == PlayerCharacter then
            if PlayerCharacter == nil then
                return;
            end;

            local v42 = PlayerCharacter;
            PlayerCharacter = nil;

            if u37 then
                u37();
            end;

            u37 = u36(nil, v42);
        end;
    end);

    return function() -- Line: 201
        -- upvalues: u40 (copy), u43 (copy), u37 (ref)
        u40:Disconnect();
        u43:Disconnect();

        if u37 then
            u37();
        end;
    end;
end;

function u1.isPlayerCharacter(p44: userdata?) -- Line: 210
    -- upvalues: u1 (copy)
    local v45;

    if p44 == nil or p44:GetAttribute("CharacterType") ~= "PlayerCustomCharacter" then
        v45 = false;
    else
        v45 = u1.getRootPart(p44) ~= nil;
    end;

    return v45;
end;

function u1.isTutorialDummy(p46: userdata?) -- Line: 216
    -- upvalues: u1 (copy)
    local v47;

    if p46 == nil or p46:GetAttribute("TutorialDummy") ~= true then
        v47 = false;
    else
        v47 = u1.getRootPart(p46) ~= nil;
    end;

    return v47;
end;

function u1.isTutorialCutout(p48: userdata?) -- Line: 222
    local v49;

    if p48 == nil then
        v49 = false;
    else
        v49 = p48:GetAttribute("TutorialCutout") == true;
    end;

    return v49;
end;

function u1.getCutoutBoard(p50: userdata?) -- Line: 227
    -- upvalues: u1 (copy)
    if not (p50 and p50:IsA("Model")) and p50 then
        p50 = p50:FindFirstAncestorOfClass("Model");
    end;

    while p50 do
        if u1.isTutorialCutout(p50) then
            return p50.PrimaryPart;
        end;

        p50 = p50:FindFirstAncestorOfClass("Model");
    end;

    return nil;
end;

function u1.isCutoutHeadshot(p51: userdata?, p52: vector?) -- Line: 248
    if p51 and typeof(p52) == "Vector3" then
        return p51.CFrame:PointToObjectSpace(p52).Y >= p51.Size.Y * 0.345;
    end;

    return false;
end;

function u1.getImpactMaterial(p53: userdata?, p54: string?) -- Line: 256
    -- upvalues: u1 (copy)
    if not (p53 and p53:IsA("Model")) and p53 then
        p53 = p53:FindFirstAncestorOfClass("Model");
    end;

    while p53 do
        if u1.isTutorialCutout(p53) then
            return "WoodPlanks";
        end;

        if u1.isPlayerCharacter(p53) or u1.isTutorialDummy(p53) then
            return "Blood Splatter";
        end;

        p53 = p53:FindFirstAncestorOfClass("Model");
    end;

    return p54 or "Plastic";
end;

function u1.getHealth(p55: userdata?) -- Line: 270
    local v56;

    if p55 then
        v56 = p55:GetAttribute("Health");
    else
        v56 = nil;
    end;

    return typeof(v56) ~= "number" and 0 or v56;
end;

function u1.getMaxHealth(p57: userdata?) -- Line: 275
    local v58;

    if p57 then
        v58 = p57:GetAttribute("MaxHealth");
    else
        v58 = nil;
    end;

    return typeof(v58) ~= "number" and 0 or v58;
end;

function u1.isAliveCharacter(p59: userdata?) -- Line: 280
    -- upvalues: u1 (copy)
    local v60;

    if p59 == nil then
        v60 = false;
    else
        v60 = p59:IsDescendantOf(workspace);

        if v60 then
            if p59:GetAttribute("Dead") == false then
                v60 = u1.getHealth(p59) > 0;
            else
                v60 = false;
            end;
        end;
    end;

    return v60;
end;

function u1.isAlivePlayer(p61: userdata?) -- Line: 287
    -- upvalues: Players (copy), CharacterPresentationDescriptor (copy)
    if p61 == nil or (p61.Parent ~= Players or p61:GetAttribute("Dead") ~= false) then
        return false;
    end;

    local Attribute = p61:GetAttribute(CharacterPresentationDescriptor.Attributes.Health);
    local v62;

    if typeof(Attribute) == "number" then
        v62 = Attribute > 0;
    else
        v62 = false;
    end;

    return v62;
end;

return u1;