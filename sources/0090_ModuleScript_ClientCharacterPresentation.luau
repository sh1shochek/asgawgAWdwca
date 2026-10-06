-- Decompiled with Potassium's decompiler.

local HttpService = game:GetService("HttpService");
local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Workspace = game:GetService("Workspace");
local AttachGlovesToCharacter = require(ReplicatedStorage.Database.Components.Common.AttachGlovesToCharacter);
local Skins = require(ReplicatedStorage.Database.Components.Libraries.Skins);
local CharacterGeneration = require(ReplicatedStorage.Components.Common.CharacterGeneration);
local CharacterPresentationDescriptor = require(ReplicatedStorage.Components.Common.CharacterPresentationDescriptor);
local CharacterResolver = require(ReplicatedStorage.Components.Common.CharacterResolver);
local u1 = {};
local Attributes = CharacterPresentationDescriptor.Attributes;
local Characters = ReplicatedStorage:WaitForChild("Assets"):WaitForChild("Characters");
local u2 = {};
local u3 = {};
local u4 = nil;
local u5 = {};
local u6 = {};
local u7 = {};
local u8 = false;
local u9 = 0;

local function getCharactersFolder() -- Line: 32
    -- upvalues: Workspace (copy)
    return Workspace:FindFirstChild("Characters") or Workspace;
end;

local function disconnectCharacter(p10: userdata) -- Line: 36
    -- upvalues: u2 (copy)
    local v11 = u2[p10];

    if v11 ~= nil then
        u2[p10] = nil;
        v11();
    end;
end;

local function setBodyColor(p12: userdata, p13: any) -- Line: 44
    if typeof(p13) ~= "Color3" then
        return;
    end;

    local v14 = p12:FindFirstChild("Body Colors");

    if v14 == nil or not v14:IsA("BodyColors") then
        return;
    end;

    v14.HeadColor3 = p13;
    v14.LeftArmColor3 = p13;
    v14.RightArmColor3 = p13;
    v14.LeftLegColor3 = p13;
    v14.RightLegColor3 = p13;
    v14.TorsoColor3 = p13;
end;

local function attachGloves(u15: userdata, p16: any) -- Line: 60
    -- upvalues: HttpService (copy), Skins (copy), AttachGlovesToCharacter (copy)
    if typeof(p16) ~= "string" or p16 == "" then
        return;
    end;

    local success, result = pcall(HttpService.JSONDecode, HttpService, p16);

    if not success or typeof(result) ~= "table" then
        return;
    end;

    local Name = result.Name;
    local Skin = result.Skin;
    local Float = result.Float;

    if typeof(Name) ~= "string" or (typeof(Skin) ~= "string" or typeof(Float) ~= "number") then
        return;
    end;

    local Gloves = Skins.GetGloves(Name, Skin, Float);
    local CharacterArmor = u15:FindFirstChild("CharacterArmor");

    if Gloves == nil or CharacterArmor == nil then
        return;
    end;

    local success2, result2 = pcall(function() -- Line: 79
        -- upvalues: AttachGlovesToCharacter (ref), Gloves (copy), u15 (copy), CharacterArmor (copy)
        AttachGlovesToCharacter(Gloves:GetChildren(), u15, CharacterArmor, {
            collisionGroup = "Debris"
        });
    end);

    if not success2 then
        warn((`[CharacterPresentation] Failed to attach gloves to {u15.Name}: {result2}`));
    end;
end;

function u1.GetCulledFolder() -- Line: 90
    -- upvalues: u4 (ref), ReplicatedStorage (copy)
    local v17 = u4;

    if v17 == nil or v17.Parent ~= ReplicatedStorage then
        v17 = Instance.new("Folder");
        v17.Name = "_PVS_CulledCharacters";
        v17.Archivable = false;
        v17.Parent = ReplicatedStorage;
        u4 = v17;
    end;

    return v17;
end;

function u1.PrepareRuntimeRig(p18: userdata) -- Line: 103
    -- upvalues: CharacterResolver (copy)
    for _, child in p18:GetChildren() do
        if child:IsA("Humanoid") then
            child:Destroy();
        end;
    end;

    if CharacterResolver.getCameraPart(p18) == nil then
        CharacterResolver.createCameraPart(p18);
    end;

    CharacterResolver.getOrCreateAnimator(p18);

    for _, v in { "WeaponModel", "WeaponAttachments" } do
        local v19 = p18:FindFirstChild(v);

        if v19 ~= nil then
            v19:Destroy();
        end;

        local Folder = Instance.new("Folder");
        Folder.Name = v;
        Folder.Parent = p18;
    end;

    for _, descendant in p18:GetDescendants() do
        if descendant:IsA("BasePart") then
            descendant.CanCollide = false;
            descendant.CanTouch = false;

            if descendant.Name == "HumanoidRootPart" then
                descendant.Anchored = true;
                descendant.AssemblyLinearVelocity = Vector3.new(0, 0, 0);
                descendant.AssemblyAngularVelocity = Vector3.new(0, 0, 0);
            end;
        end;
    end;
end;

local function getRigKey(p20: userdata) -- Line: 136
    -- upvalues: Attributes (copy)
    local Attribute = p20:GetAttribute(Attributes.CharacterName);

    if typeof(Attribute) ~= "string" or Attribute == "" then
        return nil;
    end;

    local Attribute2 = p20:GetAttribute(Attributes.BodyColor);

    return table.concat({ Attribute, tostring(p20:GetAttribute(Attributes.EquippedGloves)), typeof(Attribute2) ~= "Color3" and "" or Attribute2:ToHex() }, "|");
end;

local function buildRig(p21: userdata) -- Line: 150
    -- upvalues: Attributes (copy), Characters (copy), u1 (copy), attachGloves (copy)
    local Attribute = p21:GetAttribute(Attributes.CharacterName);

    if typeof(Attribute) ~= "string" or Attribute == "" then
        return nil;
    end;

    local v22 = Characters:FindFirstChild(Attribute);

    if v22 == nil or not v22:IsA("Model") then
        warn((`[CharacterPresentation] Missing character template {tostring(Attribute)}`));

        return nil;
    end;

    local v23 = v22:Clone();
    v23.Archivable = true;
    v23:SetAttribute("CharacterName", Attribute);
    u1.PrepareRuntimeRig(v23);
    local Attribute2 = p21:GetAttribute(Attributes.EquippedGloves);

    if typeof(Attribute2) == "string" then
        v23:SetAttribute("EquippedGloves", Attribute2);
        attachGloves(v23, Attribute2);
    end;

    local Attribute3 = p21:GetAttribute(Attributes.BodyColor);

    if typeof(Attribute3) ~= "Color3" then
        return v23;
    end;

    local v24 = v23:FindFirstChild("Body Colors");

    if v24 ~= nil then
        if not v24:IsA("BodyColors") then
            return v23;
        end;

        v24.HeadColor3 = Attribute3;
        v24.LeftArmColor3 = Attribute3;
        v24.RightArmColor3 = Attribute3;
        v24.LeftLegColor3 = Attribute3;
        v24.RightLegColor3 = Attribute3;
        v24.TorsoColor3 = Attribute3;
    end;

    return v23;
end;

local function takeSpare(p25: userdata) -- Line: 183
    -- upvalues: u5 (copy), getRigKey (copy)
    local v26 = u5[p25];

    if v26 == nil then
        return nil;
    end;

    u5[p25] = nil;

    if v26.Key == getRigKey(p25) then
        return v26.Rig;
    end;

    v26.Rig:Destroy();

    return nil;
end;

local function runSpareWorker() -- Line: 196
    -- upvalues: u6 (copy), u9 (ref), u7 (copy), Players (copy), getRigKey (copy), u5 (copy), buildRig (copy), u8 (ref)
    while #u6 > 0 do
        local os_clock_ret = os.clock();

        if os_clock_ret - u9 < 1 then
            task.wait(1 - (os_clock_ret - u9));
        else
            local table_remove_ret = table.remove(u6, 1);
            u7[table_remove_ret] = nil;
            local v27;

            if table_remove_ret.Parent == Players then
                v27 = getRigKey(table_remove_ret);
            else
                v27 = nil;
            end;

            local v28 = u5[table_remove_ret];

            if v27 ~= nil and (v28 == nil or v28.Key ~= v27) then
                local v29 = u5[table_remove_ret];

                if v29 ~= nil then
                    u5[table_remove_ret] = nil;
                    v29.Rig:Destroy();
                end;

                local v30 = buildRig(table_remove_ret);

                if v30 ~= nil then
                    u5[table_remove_ret] = {
                        Key = v27,
                        Rig = v30
                    };
                end;

                task.wait(0.1);
            end;
        end;
    end;

    u8 = false;
end;

local function queueSpare(p31: userdata) -- Line: 220
    -- upvalues: u7 (copy), u6 (copy), u8 (ref), runSpareWorker (copy)
    if u7[p31] then
        return;
    end;

    u7[p31] = true;
    table.insert(u6, p31);

    if not u8 then
        u8 = true;
        task.spawn(runSpareWorker);
    end;
end;

function u1.IsOwned(p32: userdata?) -- Line: 232
    -- upvalues: CharacterPresentationDescriptor (copy)
    local v33;

    if p32 == nil then
        v33 = false;
    else
        v33 = p32:GetAttribute(CharacterPresentationDescriptor.OwnedAttribute) == true;
    end;

    return v33;
end;

function u1.Release(p34: userdata, p35: userdata?) -- Line: 236
    -- upvalues: u1 (copy), u3 (copy), u2 (copy)
    if not p35 then
        if u1.IsOwned(p34.Character) then
            p35 = p34.Character;
        else
            p35 = u3[p34];
        end;
    end;

    if not u1.IsOwned(p35) then
        return;
    end;

    local v36 = u2[p35];

    if v36 ~= nil then
        u2[p35] = nil;
        v36();
    end;

    if u3[p34] == p35 then
        u3[p34] = nil;
    end;

    if p34.Character == p35 then
        p34.Character = nil;
    end;

    p35:Destroy();
end;

function u1.Create(u37: userdata, p38: number) -- Line: 253
    -- upvalues: Players (copy), u3 (copy), u1 (copy), CharacterGeneration (copy), u9 (ref), u5 (copy), getRigKey (copy), buildRig (copy), u7 (copy), u6 (copy), u8 (ref), runSpareWorker (copy), CharacterPresentationDescriptor (copy), Attributes (copy), u2 (copy), Workspace (copy)
    if u37.Parent ~= Players or typeof(p38) ~= "number" then
        return nil;
    end;

    local v39 = u3[u37];

    if v39 ~= nil and v39.Parent == nil then
        u3[u37] = nil;
        v39 = nil;
    end;

    local v40;

    if u1.IsOwned(u37.Character) then
        v40 = u37.Character;
    else
        v40 = v39;
    end;

    if v40 ~= nil and (CharacterGeneration.Get(v40) == p38 and v40.Parent ~= nil) then
        if u37.Character ~= v40 then
            u37.Character = v40;
        end;

        return v40;
    end;

    if v40 ~= nil then
        u1.Release(u37, v40);
    end;

    if v39 ~= nil and v39 ~= v40 then
        u1.Release(u37, v39);
    end;

    u9 = os.clock();
    local v41 = u5[u37];
    local v42;

    if v41 == nil then
        v42 = nil;
    else
        u5[u37] = nil;

        if v41.Key == getRigKey(u37) then
            v42 = v41.Rig;
        else
            v41.Rig:Destroy();
            v42 = nil;
        end;
    end;

    local u43 = v42 or buildRig(u37);

    if u43 == nil then
        return nil;
    end;

    if not u7[u37] then
        u7[u37] = true;
        table.insert(u6, u37);

        if not u8 then
            u8 = true;
            task.spawn(runSpareWorker);
        end;
    end;

    u43.Name = u37.Name;
    u43:SetAttribute(CharacterPresentationDescriptor.OwnedAttribute, true);
    u43:SetAttribute(CharacterPresentationDescriptor.OwnerUserIdAttribute, u37.UserId);
    u43:SetAttribute(CharacterPresentationDescriptor.VisibleAttribute, true);
    u43:SetAttribute("CharacterType", "PlayerCustomCharacter");
    CharacterGeneration.Set(u43, p38);

    local function mirrorAttribute(p44: string, p45: string, p46: any) -- Line: 291
        -- upvalues: u37 (copy), u43 (copy)
        local Attribute = u37:GetAttribute(p44);

        if Attribute ~= nil then
            p46 = Attribute;
        end;

        u43:SetAttribute(p45, p46);
    end;

    local Attribute = u37:GetAttribute(Attributes.Health);
    u43:SetAttribute("Health", Attribute == nil and 100 or Attribute);
    local Attribute2 = u37:GetAttribute(Attributes.MaxHealth);
    u43:SetAttribute("MaxHealth", Attribute2 == nil and 100 or Attribute2);
    local Attribute3 = u37:GetAttribute("Dead");

    if Attribute3 == nil then
        Attribute3 = false;
    end;

    u43:SetAttribute("Dead", Attribute3);
    local Attribute4 = u37:GetAttribute("CompetitivePlayerColor");

    if Attribute4 == nil then
        Attribute4 = nil;
    end;

    u43:SetAttribute("CompetitivePlayerColor", Attribute4);
    local Attribute5 = u37:GetAttribute(Attributes.SpawnPosition);
    local Attribute6 = u37:GetAttribute(Attributes.SpawnYaw);

    if typeof(Attribute5) == "Vector3" then
        u43:PivotTo(CFrame.new(Attribute5) * CFrame.Angles(0, typeof(Attribute6) ~= "number" and 0 or Attribute6, 0));
    else
        u43:PivotTo(CFrame.new(0, -1000, 0));
    end;

    local u47 = {};

    local function connect(p48: string, p49: function) -- Line: 311
        -- upvalues: u47 (copy), u37 (copy)
        u47[#u47 + 1] = u37:GetAttributeChangedSignal(p48):Connect(p49);
    end;

    local function v50() -- Line: 314
        -- upvalues: Attributes (ref), u37 (copy), u43 (copy)
        local Attribute7 = u37:GetAttribute(Attributes.Health);
        u43:SetAttribute("Health", Attribute7 == nil and 0 or Attribute7);
    end;

    u47[#u47 + 1] = u37:GetAttributeChangedSignal(Attributes.Health):Connect(v50);

    local function v51() -- Line: 317
        -- upvalues: Attributes (ref), u37 (copy), u43 (copy)
        local Attribute7 = u37:GetAttribute(Attributes.MaxHealth);
        u43:SetAttribute("MaxHealth", Attribute7 == nil and 100 or Attribute7);
    end;

    u47[#u47 + 1] = u37:GetAttributeChangedSignal(Attributes.MaxHealth):Connect(v51);
    u47[#u47 + 1] = u37:GetAttributeChangedSignal("Dead"):Connect(function() -- Line: 320
        -- upvalues: u37 (copy), u43 (copy)
        local Attribute7 = u37:GetAttribute("Dead");

        if Attribute7 == nil then
            Attribute7 = false;
        end;

        u43:SetAttribute("Dead", Attribute7);
    end);
    u47[#u47 + 1] = u37:GetAttributeChangedSignal("CompetitivePlayerColor"):Connect(function() -- Line: 323
        -- upvalues: u37 (copy), u43 (copy)
        local Attribute7 = u37:GetAttribute("CompetitivePlayerColor");

        if Attribute7 == nil then
            Attribute7 = nil;
        end;

        u43:SetAttribute("CompetitivePlayerColor", Attribute7);
    end);

    local function v53() -- Line: 326
        -- upvalues: u43 (copy), u37 (copy), Attributes (ref)
        local Attribute7 = u37:GetAttribute(Attributes.BodyColor);

        if typeof(Attribute7) ~= "Color3" then
            return;
        end;

        local v52 = u43:FindFirstChild("Body Colors");

        if v52 ~= nil then
            if not v52:IsA("BodyColors") then
                return;
            end;

            v52.HeadColor3 = Attribute7;
            v52.LeftArmColor3 = Attribute7;
            v52.RightArmColor3 = Attribute7;
            v52.LeftLegColor3 = Attribute7;
            v52.RightLegColor3 = Attribute7;
            v52.TorsoColor3 = Attribute7;
        end;
    end;

    u47[#u47 + 1] = u37:GetAttributeChangedSignal(Attributes.BodyColor):Connect(v53);

    u2[u43] = function() -- Line: 329
        -- upvalues: u47 (copy)
        for _, v in u47 do
            v:Disconnect();
        end;
    end;

    u47[#u47 + 1] = u43.Destroying:Connect(function() -- Line: 334
        -- upvalues: u43 (copy), u2 (ref), u3 (ref), u37 (copy)
        local v54 = u43;
        local v55 = u2[v54];

        if v55 ~= nil then
            u2[v54] = nil;
            v55();
        end;

        if u3[u37] == u43 then
            u3[u37] = nil;
        end;
    end);
    u43.Parent = Workspace:FindFirstChild("Characters") or Workspace;
    u3[u37] = u43;
    u37.Character = u43;

    return u43;
end;

function u1.ObserveLocalPlayer() -- Line: 347
    -- upvalues: Players (copy), Attributes (copy), u1 (copy)
    local LocalPlayer = Players.LocalPlayer;

    local function refresh() -- Line: 349
        -- upvalues: LocalPlayer (copy), Attributes (ref), u1 (ref)
        local Attribute = LocalPlayer:GetAttribute(Attributes.Generation);

        if typeof(Attribute) == "number" and LocalPlayer:GetAttribute("Dead") ~= true then
            u1.Create(LocalPlayer, Attribute);
        end;
    end;

    local u56 = { LocalPlayer:GetAttributeChangedSignal(Attributes.Generation):Connect(refresh), LocalPlayer:GetAttributeChangedSignal(Attributes.CharacterName):Connect(refresh), LocalPlayer:GetAttributeChangedSignal("Dead"):Connect(refresh) };
    local Attribute = LocalPlayer:GetAttribute(Attributes.Generation);

    if typeof(Attribute) == "number" and LocalPlayer:GetAttribute("Dead") ~= true then
        u1.Create(LocalPlayer, Attribute);
    end;

    return function() -- Line: 361
        -- upvalues: u56 (copy), u1 (ref), LocalPlayer (copy)
        for _, v in u56 do
            v:Disconnect();
        end;

        u1.Release(LocalPlayer, LocalPlayer.Character);
    end;
end;

Players.PlayerRemoving:Connect(function(p57: userdata) -- Line: 175, Name: discardSpare
    -- upvalues: u5 (copy)
    local v58 = u5[p57];

    if v58 ~= nil then
        u5[p57] = nil;
        v58.Rig:Destroy();
    end;
end);

return u1;