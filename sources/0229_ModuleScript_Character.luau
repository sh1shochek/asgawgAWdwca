-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local HttpService = game:GetService("HttpService");
local Players = game:GetService("Players");
require(ReplicatedStorage.Database.Custom.Types);
local LocalPlayer = Players.LocalPlayer;
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui");
local SpectateController = require(ReplicatedStorage.Controllers.SpectateController);
local CameraController = require(ReplicatedStorage.Controllers.CameraController);
local InputController = require(ReplicatedStorage.Controllers.InputController);
local BlackMarketSceneController = require(ReplicatedStorage.Controllers.BlackMarketSceneController);
local Observers = require(ReplicatedStorage.Packages.Observers);
local Janitor = require(ReplicatedStorage.Shared.Janitor);
local CharacterHighlight = require(ReplicatedStorage.Classes.CharacterHighlight);
local GetWeaponProperties = require(ReplicatedStorage.Components.Common.GetWeaponProperties);
local CharacterResolver = require(ReplicatedStorage.Components.Common.CharacterResolver);
local Participants = require(ReplicatedStorage.Components.Common.Participants);
local CharacterController = require(ReplicatedStorage.Controllers.CharacterController);
local Defuser = require(script.Components.Defuser);
local u1 = {
    ["Counter-Terrorists"] = Color3.fromRGB(25, 80, 170),
    Terrorists = Color3.fromRGB(255, 215, 70)
};
local u2 = {};
local u3 = {};
local u4 = {};

local function AreNameTagsVisible() -- Line: 54
    -- upvalues: SpectateController (copy), LocalPlayer (copy), BlackMarketSceneController (copy)
    local Player = SpectateController.GetPlayer();
    local v5;

    if Player == nil or Player == LocalPlayer then
        v5 = not BlackMarketSceneController.IsActive();
    else
        v5 = false;
    end;

    return v5;
end;

local function GetNameTagDisplayColor(p6: userdata?, p7) -- Line: 62
    return p6 and p6:GetAttribute("CompetitivePlayerColor") or p7;
end;

local function ApplyNameTagTextColor(p8: userdata, p9) -- Line: 74
    for _, descendant in ipairs(p8:GetDescendants()) do
        if descendant:IsA("TextLabel") or (descendant:IsA("TextButton") or descendant:IsA("TextBox")) then
            descendant.TextColor3 = p9;
        end;
    end;
end;

local function RefreshNameTagArrowColors() -- Line: 84
    -- upvalues: u4 (copy), u1 (copy), Participants (copy), ApplyNameTagTextColor (copy)
    for i, v in pairs(u4) do
        local Attribute = i:GetAttribute("Team");
        local v10;

        if Attribute then
            v10 = u1[Attribute];
        else
            v10 = nil;
        end;

        if v10 then
            local v11 = Participants.Character(i);

            if v11 then
                v10 = v11:GetAttribute("CompetitivePlayerColor") or v10;
            end;

            if v.Arrow.Parent then
                v.Arrow.Arrow.ImageColor3 = v10;
            end;

            if v.NameTag.Parent then
                ApplyNameTagTextColor(v.NameTag, v10);
            end;
        end;
    end;
end;

workspace:GetAttributeChangedSignal("ServerGamemode"):Connect(RefreshNameTagArrowColors);

local function CleanupNameTagJanitor(p12: userdata) -- Line: 104
    -- upvalues: u3 (copy), RefreshNameTagArrowColors (copy)
    if u3[p12] then
        u3[p12]:Destroy();
        u3[p12] = nil;
        RefreshNameTagArrowColors();
    end;
end;

local function GetParticipantCharacter(p13: userdata) -- Line: 115
    -- upvalues: CharacterResolver (copy), Participants (copy)
    if p13:IsA("Player") then
        return CharacterResolver.getPlayerCharacter(p13);
    end;

    return Participants.Character(p13);
end;

local function getCharacterHealthText(p14: userdata) -- Line: 124
    -- upvalues: CharacterResolver (copy)
    local Health = CharacterResolver.getHealth(p14);
    local MaxHealth = CharacterResolver.getMaxHealth(p14);
    local math_max_ret = math.max(MaxHealth, 1);

    return `{math.ceil(Health / math_max_ret * 100)}%`;
end;

local function CreateNameTag(u15: userdata, u16: userdata, p17: any) -- Line: 132
    -- upvalues: u1 (copy), CharacterResolver (copy), u3 (copy), RefreshNameTagArrowColors (copy), Janitor (copy), ReplicatedStorage (copy), PlayerGui (copy), Participants (copy), ApplyNameTagTextColor (copy), HttpService (copy), Observers (copy), GetWeaponProperties (copy), u4 (copy), SpectateController (copy), LocalPlayer (copy), BlackMarketSceneController (copy)
    local u18 = u1[p17];

    if not u18 then
        return nil;
    end;

    local Head = CharacterResolver.getHead(u16);

    if not (Head and u16:IsDescendantOf(workspace)) then
        return nil;
    end;

    if u3[u15] then
        u3[u15]:Destroy();
        u3[u15] = nil;
        RefreshNameTagArrowColors();
    end;

    local v19 = Janitor.new();
    local u20 = v19:Add(ReplicatedStorage.Assets.Other.Character.Arrow:Clone());
    local v21;

    if u16 then
        v21 = u16:GetAttribute("CompetitivePlayerColor") or u18;
    else
        v21 = u18;
    end;

    u20.Arrow.ImageColor3 = v21;
    u20.Adornee = Head;
    u20.Parent = PlayerGui;
    local u22 = v19:Add(ReplicatedStorage.Assets.Other.Character.NameTag:Clone());
    u22.Info.PlayerName.Text = `{Participants.DisplayName(u15)}`;
    u22.Info.Weapons.Bomb.Visible = false;
    u22.Adornee = Head;
    u22.Parent = PlayerGui;
    local Health = u22.Info.Health;
    local Health2 = CharacterResolver.getHealth(u16);
    local MaxHealth = CharacterResolver.getMaxHealth(u16);
    local math_max_ret = math.max(MaxHealth, 1);
    Health.Text = `{math.ceil(Health2 / math_max_ret * 100)}%`;
    ApplyNameTagTextColor(u22, v21);
    v19:Add(u16:GetAttributeChangedSignal("CompetitivePlayerColor"):Connect(function() -- Line: 167
        -- upvalues: u16 (copy), u18 (copy), u20 (copy), u22 (copy), ApplyNameTagTextColor (ref)
        local v23 = u16;
        local v24 = u18;

        if v23 then
            v24 = v23:GetAttribute("CompetitivePlayerColor") or v24;
        end;

        if u20.Parent and u20:FindFirstChild("Arrow") then
            u20.Arrow.ImageColor3 = v24;
        end;

        if u22.Parent then
            ApplyNameTagTextColor(u22, v24);
        end;
    end));

    local function updateHealthText() -- Line: 177
        -- upvalues: u22 (copy), u16 (copy), CharacterResolver (ref)
        if u22.Parent and u22:FindFirstChild("Info") then
            local Health3 = u22.Info.Health;
            local v25 = u16;
            local Health4 = CharacterResolver.getHealth(v25);
            local MaxHealth2 = CharacterResolver.getMaxHealth(v25);
            local math_max_ret2 = math.max(MaxHealth2, 1);
            Health3.Text = `{math.ceil(Health4 / math_max_ret2 * 100)}%`;
        end;
    end;

    v19:Add(u16:GetAttributeChangedSignal("Health"):Connect(updateHealthText));
    v19:Add(u16:GetAttributeChangedSignal("MaxHealth"):Connect(updateHealthText));

    local function updateBombIcon(p26, p27) -- Line: 186
        -- upvalues: u22 (copy)
        local v28;

        if p27 == nil then
            v28 = false;
        else
            v28 = p27.Weapon == "C4";
        end;

        local v29;

        if p26 == nil then
            v29 = false;
        else
            v29 = p26.Name == "C4";
        end;

        if v28 then
            v28 = not v29;
        end;

        u22.Info.Weapons.Bomb.Visible = v28;
    end;

    local function decodeAttribute(p30: string) -- Line: 192
        -- upvalues: u15 (copy), HttpService (ref)
        local Attribute = u15:GetAttribute(p30);

        if Attribute then
            return HttpService:JSONDecode(Attribute);
        end;

        return nil;
    end;

    v19:Add(Observers.observeAttribute(u15, "CurrentEquipped", function(p31) -- Line: 197
        -- upvalues: u22 (copy), HttpService (ref), GetWeaponProperties (ref), u15 (copy)
        if not (u22.Parent and u22:FindFirstChild("Info")) then
            return function() -- Line: 199
            end;
        end;

        local v32 = HttpService:JSONDecode(p31 or "[]");
        local Gun = u22.Info.Weapons.Gun;

        if v32 and v32.Name then
            local v33 = GetWeaponProperties(v32.Name);
            Gun.Image = v33 and (v33.Icon or "") or "";
            Gun.Visible = v33 or false;
        else
            Gun.Visible = false;
        end;

        local Attribute = u15:GetAttribute("Slot5");
        local v34;

        if Attribute then
            v34 = HttpService:JSONDecode(Attribute);
        else
            v34 = nil;
        end;

        local v35;

        if v34 == nil then
            v35 = false;
        else
            v35 = v34.Weapon == "C4";
        end;

        local v36;

        if v32 == nil then
            v36 = false;
        else
            v36 = v32.Name == "C4";
        end;

        if v35 then
            v35 = not v36;
        end;

        u22.Info.Weapons.Bomb.Visible = v35;

        return function() -- Line: 213
            -- upvalues: u22 (ref)
            if u22:FindFirstChild("Info") then
                u22.Info.Weapons.Gun.Visible = false;
            end;
        end;
    end));
    v19:Add(Observers.observeAttribute(u15, "Slot5", function(p37) -- Line: 220
        -- upvalues: u22 (copy), u15 (copy), HttpService (ref)
        if not (u22.Parent and u22:FindFirstChild("Info")) then
            return function() -- Line: 222
            end;
        end;

        local Attribute = u15:GetAttribute("CurrentEquipped");
        local v38;

        if Attribute then
            v38 = HttpService:JSONDecode(Attribute);
        else
            v38 = nil;
        end;

        local v39 = HttpService:JSONDecode(p37 or "[]");
        local v40;

        if v39 == nil then
            v40 = false;
        else
            v40 = v39.Weapon == "C4";
        end;

        local v41;

        if v38 == nil then
            v41 = false;
        else
            v41 = v38.Name == "C4";
        end;

        if v40 then
            v40 = not v41;
        end;

        u22.Info.Weapons.Bomb.Visible = v40;

        return function() -- Line: 227
            -- upvalues: u22 (ref)
            if u22:FindFirstChild("Info") then
                u22.Info.Weapons.Bomb.Visible = false;
            end;
        end;
    end));
    u3[u15] = v19;
    u4[u15] = {
        Arrow = u20,
        NameTag = u22
    };
    local Player = SpectateController.GetPlayer();
    local v42;

    if Player == nil or Player == LocalPlayer then
        v42 = not BlackMarketSceneController.IsActive();
    else
        v42 = false;
    end;

    u20.Enabled = v42;
    u22.Enabled = v42;
    v19:Add(function() -- Line: 243
        -- upvalues: u4 (ref), u15 (copy)
        u4[u15] = nil;
    end);

    local function cleanupIfCharacterBecameStale() -- Line: 247
        -- upvalues: u15 (copy), CharacterResolver (ref), Participants (ref), u16 (copy), u3 (ref), RefreshNameTagArrowColors (ref)
        local v43 = true;
        local v44 = u15;
        local v45;

        if v44:IsA("Player") then
            v45 = CharacterResolver.getPlayerCharacter(v44);
        else
            v45 = Participants.Character(v44);
        end;

        if v45 == u16 then
            v43 = not (u16:IsDescendantOf(workspace) and CharacterResolver.isAliveCharacter(u16));
        end;

        if v43 then
            local v46 = u15;

            if u3[v46] then
                u3[v46]:Destroy();
                u3[v46] = nil;
                RefreshNameTagArrowColors();
            end;
        end;
    end;

    v19:Add(u16:GetAttributeChangedSignal("Dead"):Connect(cleanupIfCharacterBecameStale));
    v19:Add(u16:GetAttributeChangedSignal("Health"):Connect(cleanupIfCharacterBecameStale));
    v19:Add(u16.AncestryChanged:Connect(cleanupIfCharacterBecameStale));
    RefreshNameTagArrowColors();

    return v19;
end;

local function ReleaseCameraToMenu() -- Line: 267
    -- upvalues: SpectateController (copy), CameraController (copy)
    if SpectateController.IsTakingOverCamera() then
        return;
    end;

    CameraController.setPerspective(false, true);
end;

local function characterAdded(p47) -- Line: 277
    -- upvalues: CameraController (copy), ReleaseCameraToMenu (copy), BlackMarketSceneController (copy), InputController (copy)
    CameraController.setPerspective(true, false);
    p47:Add(ReleaseCameraToMenu);

    if not BlackMarketSceneController.IsActive() then
        InputController.enableGroup("Gameplay");
    end;

    p47:Add(function() -- Line: 285
        -- upvalues: InputController (ref)
        InputController.disableGroup("Gameplay");
    end);
end;

local function RefreshNameTagVisibility() -- Line: 292
    -- upvalues: SpectateController (copy), LocalPlayer (copy), BlackMarketSceneController (copy), u4 (copy)
    local Player = SpectateController.GetPlayer();
    local v48;

    if Player == nil or Player == LocalPlayer then
        v48 = not BlackMarketSceneController.IsActive();
    else
        v48 = false;
    end;

    for _, v in pairs(u4) do
        v.Arrow.Enabled = v48;
        v.NameTag.Enabled = v48;
    end;
end;

SpectateController.ListenToSpectate:Connect(RefreshNameTagVisibility);
BlackMarketSceneController.OnActiveChanged:Connect(RefreshNameTagVisibility);

local function observeRemoteCharacter(u49: userdata, u50: userdata, p51: any) -- Line: 306
    -- upvalues: CharacterController (copy), Janitor (copy), u3 (copy), RefreshNameTagArrowColors (copy), CharacterResolver (copy), Defuser (copy), CharacterHighlight (copy), LocalPlayer (copy), SpectateController (copy), BlackMarketSceneController (copy), Observers (copy), CreateNameTag (copy)
    local u52 = not u49:IsA("Player");
    local Attribute = u49:GetAttribute("Team");
    local u53 = Attribute == "Counter-Terrorists" and Color3.fromRGB(0, 75, 200) or (Attribute == "Terrorists" and Color3.fromRGB(255, 220, 50) or Color3.fromRGB(255, 255, 255));

    if not u52 then
        CharacterController.TrackCharacter(u49, u50);
        p51:Add(function() -- Line: 318
            -- upvalues: CharacterController (ref), u49 (copy), u50 (copy)
            CharacterController.UntrackCharacter(u49, u50);
        end);
    end;

    local Attribute2 = workspace:GetAttribute("Gamemode");
    local u54 = Attribute == "Terrorists" and true or Attribute == "Counter-Terrorists";
    local u55;

    if u54 then
        u55 = Attribute2 ~= "Deathmatch";
    else
        u55 = u54;
    end;

    local u56 = Janitor.new();
    p51:Add(function() -- Line: 327
        -- upvalues: u56 (ref), u49 (copy), u3 (ref), RefreshNameTagArrowColors (ref)
        u56:Destroy();
        local v57 = u49;

        if u3[v57] then
            u3[v57]:Destroy();
            u3[v57] = nil;
            RefreshNameTagArrowColors();
        end;
    end);

    local function rebuildRemoteVisuals() -- Line: 332
        -- upvalues: u56 (ref), Janitor (ref), u50 (copy), CharacterResolver (ref), u49 (copy), u3 (ref), RefreshNameTagArrowColors (ref), u52 (copy), Defuser (ref), u54 (copy), Attribute2 (copy), CharacterHighlight (ref), u53 (copy), LocalPlayer (ref), SpectateController (ref), BlackMarketSceneController (ref), Observers (ref), Attribute (copy), u55 (copy), CreateNameTag (ref)
        u56:Destroy();
        u56 = Janitor.new();

        if u50:GetAttribute("Dead") == true or not CharacterResolver.isAliveCharacter(u50) then
            local v58 = u49;

            if u3[v58] then
                u3[v58]:Destroy();
                u3[v58] = nil;
                RefreshNameTagArrowColors();
            end;

            return;
        end;

        if not u52 then
            local u59 = Defuser.new(u49, u50);
            u56:Add(function() -- Line: 343
                -- upvalues: u59 (copy)
                u59:Destroy();
            end);
        end;

        if u54 then
            local v60;

            if Attribute2 == "Deathmatch" then
                v60 = Enum.HighlightDepthMode.Occluded;
            else
                v60 = Enum.HighlightDepthMode.AlwaysOnTop;
            end;

            local u61 = u56:Add(CharacterHighlight.new(u50, {
                OutlineTransparency = 0.4,
                FillTransparency = 0.7,
                DepthMode = v60,
                FillColor = Color3.fromRGB(255, 255, 255),
                OutlineColor = u53
            }));

            local function updateHighlightVisible() -- Line: 360
                -- upvalues: u50 (ref), u49 (ref), LocalPlayer (ref), SpectateController (ref), u61 (copy), BlackMarketSceneController (ref)
                if not u50.Parent then
                    return;
                end;

                local Attribute3 = workspace:GetAttribute("Gamemode");
                local Attribute4 = workspace:GetAttribute("GameState");
                local Attribute5 = u49:GetAttribute("Team");
                local v62 = u50:GetAttribute("Dead") == true;
                local v63 = u49:GetAttribute("Invincible") == true;
                local v64 = LocalPlayer:GetAttribute("IsSpectating") == true;
                local Player = SpectateController.GetPlayer();
                local v65;

                if Player then
                    v65 = Player:GetAttribute("Team");
                else
                    v65 = Player;
                end;

                local CurrentSpectateInstance = SpectateController.GetCurrentSpectateInstance();
                local v66;

                if CurrentSpectateInstance == nil then
                    v66 = false;
                else
                    v66 = CurrentSpectateInstance.PerspectiveState == "First-Person";
                end;

                local v67 = Player == u49;
                local v68 = LocalPlayer:GetAttribute("Team") == Attribute5;

                if v64 then
                    if not v66 then
                        v67 = v66;
                    end;
                else
                    v67 = v64;
                end;

                local v69;

                if Attribute3 == "Deathmatch" then
                    v69 = false;
                elseif v64 then
                    if v65 == Attribute5 then
                        v69 = not v67;
                    else
                        v69 = false;
                    end;
                else
                    v69 = v64;
                end;

                if v68 then
                    v64 = v68;
                elseif v64 then
                    v64 = v65 == Attribute5;
                end;

                local v70 = v63 and not v67 and (Attribute3 == "Deathmatch" and true or (Attribute4 == "Warmup" and true or v64));
                local v71;

                if v70 and Attribute4 == "Warmup" then
                    v71 = Enum.HighlightDepthMode.Occluded;
                elseif Attribute3 == "Deathmatch" then
                    v71 = Enum.HighlightDepthMode.Occluded;
                else
                    v71 = Enum.HighlightDepthMode.AlwaysOnTop;
                end;

                if u61.Highlight and u61.Highlight.Parent then
                    u61.Highlight.DepthMode = v71;
                end;

                if v62 or BlackMarketSceneController.IsActive() then
                    u61.OutlineOnly = false;
                    u61:UpdateState(false);

                    return;
                end;

                local v72;

                if v69 then
                    v72 = not v70;
                else
                    v72 = v69;
                end;

                u61.OutlineOnly = v72;
                u61:UpdateState(v70 or v69);
            end;

            updateHighlightVisible();
            u56:Add(u49:GetAttributeChangedSignal("Invincible"):Connect(updateHighlightVisible));
            u56:Add(SpectateController.ListenToSpectate:Connect(function() -- Line: 408
                -- upvalues: updateHighlightVisible (copy)
                updateHighlightVisible();
            end));
            u56:Add(BlackMarketSceneController.OnActiveChanged:Connect(function() -- Line: 411
                -- upvalues: updateHighlightVisible (copy)
                updateHighlightVisible();
            end));

            local function onHighlightInputChanged() -- Line: 415
                -- upvalues: updateHighlightVisible (copy)
                updateHighlightVisible();

                return function() -- Line: 417
                end;
            end;

            for _, v in {
                { LocalPlayer, "IsSpectating" },
                { LocalPlayer, "SpectatePerspective" },
                { LocalPlayer, "Team" },
                { u49, "Team" },
                { workspace, "GameState" }
            } do
                u56:Add(Observers.observeAttribute(v[1], v[2], onHighlightInputChanged));
            end;
        end;

        if LocalPlayer:GetAttribute("Team") == Attribute and u55 then
            CreateNameTag(u49, u50, Attribute);
            u56:Add(function() -- Line: 434
                -- upvalues: u49 (ref), u3 (ref), RefreshNameTagArrowColors (ref)
                local v73 = u49;

                if u3[v73] then
                    u3[v73]:Destroy();
                    u3[v73] = nil;
                    RefreshNameTagArrowColors();
                end;
            end);
        end;
    end;

    rebuildRemoteVisuals();
    p51:Add(u50:GetAttributeChangedSignal("Dead"):Connect(rebuildRemoteVisuals));
    local u74 = u50:IsDescendantOf(workspace);
    p51:Add(u50.AncestryChanged:Connect(function() -- Line: 448
        -- upvalues: u50 (copy), u74 (ref), rebuildRemoteVisuals (copy)
        local v75 = u50:IsDescendantOf(workspace);

        if v75 ~= u74 then
            u74 = v75;
            rebuildRemoteVisuals();
        end;
    end));

    if LocalPlayer:GetAttribute("IsSpectating") and not SpectateController.GetCurrentSpectateInstance() then
        SpectateController.Next();
    end;
end;

local u76 = {};

local function GetBotDescriptor(p77: userdata) -- Line: 469
    -- upvalues: ReplicatedStorage (copy)
    local Combatants = ReplicatedStorage:FindFirstChild("Combatants");
    local Attribute = p77:GetAttribute("CombatantId");

    if Combatants and Attribute ~= nil then
        return Combatants:FindFirstChild((tostring(Attribute)));
    end;

    return nil;
end;

local function BotShellRemoved(p78: userdata) -- Line: 475
    -- upvalues: u76 (copy)
    local v79 = u76[p78];

    if v79 then
        u76[p78] = nil;
        v79:Destroy();
    end;
end;

local function BotShellAdded(p80: userdata) -- Line: 483
    -- upvalues: ReplicatedStorage (copy), u76 (copy), u2 (copy), Janitor (copy), u3 (copy), RefreshNameTagArrowColors (copy), observeRemoteCharacter (copy)
    if not p80:IsA("Model") or p80:GetAttribute("Bot") ~= true then
        return;
    end;

    local Combatants = ReplicatedStorage:FindFirstChild("Combatants");
    local Attribute = p80:GetAttribute("CombatantId");
    local u81;

    if Combatants and Attribute ~= nil then
        u81 = Combatants:FindFirstChild((tostring(Attribute)));
    else
        u81 = nil;
    end;

    if not u81 then
        return;
    end;

    local v82 = u76[p80];

    if v82 then
        u76[p80] = nil;
        v82:Destroy();
    end;

    if u2[u81] then
        u2[u81]:Destroy();
    end;

    local u83 = Janitor.new();
    u76[p80] = u83;
    u2[u81] = u83;
    u83:Add(function() -- Line: 500
        -- upvalues: u2 (ref), u81 (copy), u83 (copy)
        if u2[u81] == u83 then
            u2[u81] = nil;
        end;
    end);

    if u3[u81] then
        u3[u81]:Destroy();
        u3[u81] = nil;
        RefreshNameTagArrowColors();
    end;

    observeRemoteCharacter(u81, p80, u83);
end;

local u84 = false;

local function BindBotCharacters(p85: userdata) -- Line: 511
    -- upvalues: u84 (ref), BotShellAdded (copy), BotShellRemoved (copy)
    if u84 then
        return;
    end;

    u84 = true;
    p85.ChildAdded:Connect(BotShellAdded);
    p85.ChildRemoved:Connect(BotShellRemoved);

    for _, child in p85:GetChildren() do
        task.spawn(BotShellAdded, child);
    end;
end;

local Characters = workspace:FindFirstChild("Characters");

if Characters then
    BindBotCharacters(Characters);
else
    local u86 = nil;
    u86 = workspace.ChildAdded:Connect(function(p87) -- Line: 528
        -- upvalues: BindBotCharacters (copy), u86 (ref)
        if p87.Name == "Characters" then
            BindBotCharacters(p87);

            if u86 then
                u86:Disconnect();
            end;
        end;
    end);
end;

return Observers.observeCharacter(function(p88, u89) -- Line: 541
    -- upvalues: u2 (copy), Janitor (copy), u3 (copy), RefreshNameTagArrowColors (copy), LocalPlayer (copy), characterAdded (copy), SpectateController (copy), CameraController (copy), InputController (copy), Participants (copy), CreateNameTag (copy), observeRemoteCharacter (copy)
    if u2[p88] then
        u2[p88]:Destroy();
        u2[p88] = nil;
    end;

    local u90 = Janitor.new();
    u2[p88] = u90;

    if u3[p88] then
        u3[p88]:Destroy();
        u3[p88] = nil;
        RefreshNameTagArrowColors();
    end;

    if LocalPlayer == p88 then
        characterAdded(u90);
        u90:Add(u89:GetAttributeChangedSignal("Dead"):Connect(function() -- Line: 555
            -- upvalues: u89 (copy), SpectateController (ref), CameraController (ref), InputController (ref)
            if u89:GetAttribute("Dead") == true then
                if not SpectateController.IsTakingOverCamera() then
                    CameraController.setPerspective(false, true);
                end;

                InputController.disableGroup("Gameplay");
            end;
        end));

        for i in pairs(u3) do
            if u3[i] then
                u3[i]:Destroy();
                u3[i] = nil;
                RefreshNameTagArrowColors();
            end;
        end;

        for _, v in ipairs(Participants.GetAll()) do
            if v ~= LocalPlayer then
                local v91 = Participants.Character(v);

                if v91 and v91:IsDescendantOf(workspace) then
                    local Attribute = LocalPlayer:GetAttribute("Team");
                    local Attribute2 = v:GetAttribute("Team");

                    if Attribute == Attribute2 and (Attribute2 == "Terrorists" or Attribute2 == "Counter-Terrorists") and workspace:GetAttribute("Gamemode") ~= "Deathmatch" then
                        CreateNameTag(v, v91, Attribute2);

                        if u2[v] then
                            u2[v]:Add(function() -- Line: 582
                                -- upvalues: v (copy), u3 (ref), RefreshNameTagArrowColors (ref)
                                local v92 = v;

                                if u3[v92] then
                                    u3[v92]:Destroy();
                                    u3[v92] = nil;
                                    RefreshNameTagArrowColors();
                                end;
                            end);
                        end;
                    end;
                end;
            end;
        end;
    else
        observeRemoteCharacter(p88, u89, u90);
    end;

    return function() -- Line: 593
        -- upvalues: u90 (copy)
        u90:Destroy();
    end;
end);