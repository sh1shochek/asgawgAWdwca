-- Character (ModuleScript)
-- full path: ReplicatedStorage.Controllers.Observers.Character

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
local IsSurvivalMode = require(ReplicatedStorage.Components.Common.IsSurvivalMode);
local CharacterController = require(ReplicatedStorage.Controllers.CharacterController);
local Defuser = require(script.Components.Defuser);
local u1 = {
    ["Counter-Terrorists"] = Color3.fromRGB(25, 80, 170),
    Terrorists = Color3.fromRGB(255, 215, 70)
};
local u2 = {};
local u3 = {};
local u4 = {};

local function AreNameTagsVisible() -- Line: 55
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

local function ShowsNameTagFor(p6: string?) -- Line: 63
    -- upvalues: LocalPlayer (copy), IsSurvivalMode (copy)
    if (p6 == "Terrorists" and true or p6 == "Counter-Terrorists") and workspace:GetAttribute("Gamemode") ~= "Deathmatch" then
        return LocalPlayer:GetAttribute("Team") == p6 and true or IsSurvivalMode();
    end;

    return false;
end;

local function GetNameTagDisplayColor(p7: userdata?, p8) -- Line: 73
    return p7 and p7:GetAttribute("CompetitivePlayerColor") or p8;
end;

local function ApplyNameTagTextColor(p9: userdata, p10) -- Line: 85
    for _, descendant in ipairs(p9:GetDescendants()) do
        if descendant:IsA("TextLabel") or (descendant:IsA("TextButton") or descendant:IsA("TextBox")) then
            descendant.TextColor3 = p10;
        end;
    end;
end;

local function RefreshNameTagArrowColors() -- Line: 95
    -- upvalues: u4 (copy), u1 (copy), Participants (copy), ApplyNameTagTextColor (copy)
    for i, v in pairs(u4) do
        local Attribute = i:GetAttribute("Team");
        local v11;

        if Attribute then
            v11 = u1[Attribute];
        else
            v11 = nil;
        end;

        if v11 then
            local v12 = Participants.Character(i);

            if v12 then
                v11 = v12:GetAttribute("CompetitivePlayerColor") or v11;
            end;

            if v.Arrow.Parent then
                v.Arrow.Arrow.ImageColor3 = v11;
            end;

            if v.NameTag.Parent then
                ApplyNameTagTextColor(v.NameTag, v11);
            end;
        end;
    end;
end;

workspace:GetAttributeChangedSignal("ServerGamemode"):Connect(RefreshNameTagArrowColors);

local function CleanupNameTagJanitor(p13: userdata) -- Line: 115
    -- upvalues: u3 (copy), RefreshNameTagArrowColors (copy)
    if u3[p13] then
        u3[p13]:Destroy();
        u3[p13] = nil;
        RefreshNameTagArrowColors();
    end;
end;

local function GetParticipantCharacter(p14: userdata) -- Line: 126
    -- upvalues: CharacterResolver (copy), Participants (copy)
    if p14:IsA("Player") then
        return CharacterResolver.getPlayerCharacter(p14);
    end;

    return Participants.Character(p14);
end;

local function getCharacterHealthText(p15: userdata) -- Line: 135
    -- upvalues: CharacterResolver (copy)
    local Health = CharacterResolver.getHealth(p15);
    local MaxHealth = CharacterResolver.getMaxHealth(p15);
    local math_max_ret = math.max(MaxHealth, 1);

    return `{math.ceil(Health / math_max_ret * 100)}%`;
end;

local function CreateNameTag(u16: userdata, u17: userdata, p18: any) -- Line: 143
    -- upvalues: u1 (copy), CharacterResolver (copy), u3 (copy), RefreshNameTagArrowColors (copy), Janitor (copy), ReplicatedStorage (copy), PlayerGui (copy), Participants (copy), ApplyNameTagTextColor (copy), HttpService (copy), Observers (copy), GetWeaponProperties (copy), u4 (copy), SpectateController (copy), LocalPlayer (copy), BlackMarketSceneController (copy)
    local u19 = u1[p18];

    if not u19 then
        return nil;
    end;

    local Head = CharacterResolver.getHead(u17);

    if not (Head and u17:IsDescendantOf(workspace)) then
        return nil;
    end;

    if u3[u16] then
        u3[u16]:Destroy();
        u3[u16] = nil;
        RefreshNameTagArrowColors();
    end;

    local v20 = Janitor.new();
    local u21 = v20:Add(ReplicatedStorage.Assets.Other.Character.Arrow:Clone());
    local v22;

    if u17 then
        v22 = u17:GetAttribute("CompetitivePlayerColor") or u19;
    else
        v22 = u19;
    end;

    u21.Arrow.ImageColor3 = v22;
    u21.Adornee = Head;
    u21.Parent = PlayerGui;
    local u23 = v20:Add(ReplicatedStorage.Assets.Other.Character.NameTag:Clone());
    u23.Info.PlayerName.Text = `{Participants.DisplayName(u16)}`;
    u23.Info.Weapons.Bomb.Visible = false;
    u23.Adornee = Head;
    u23.Parent = PlayerGui;
    local Health = u23.Info.Health;
    local Health2 = CharacterResolver.getHealth(u17);
    local MaxHealth = CharacterResolver.getMaxHealth(u17);
    local math_max_ret = math.max(MaxHealth, 1);
    Health.Text = `{math.ceil(Health2 / math_max_ret * 100)}%`;
    ApplyNameTagTextColor(u23, v22);
    v20:Add(u17:GetAttributeChangedSignal("CompetitivePlayerColor"):Connect(function() -- Line: 178
        -- upvalues: u17 (copy), u19 (copy), u21 (copy), u23 (copy), ApplyNameTagTextColor (ref)
        local v24 = u17;
        local v25 = u19;

        if v24 then
            v25 = v24:GetAttribute("CompetitivePlayerColor") or v25;
        end;

        if u21.Parent and u21:FindFirstChild("Arrow") then
            u21.Arrow.ImageColor3 = v25;
        end;

        if u23.Parent then
            ApplyNameTagTextColor(u23, v25);
        end;
    end));

    local function updateHealthText() -- Line: 188
        -- upvalues: u23 (copy), u17 (copy), CharacterResolver (ref)
        if u23.Parent and u23:FindFirstChild("Info") then
            local Health3 = u23.Info.Health;
            local v26 = u17;
            local Health4 = CharacterResolver.getHealth(v26);
            local MaxHealth2 = CharacterResolver.getMaxHealth(v26);
            local math_max_ret2 = math.max(MaxHealth2, 1);
            Health3.Text = `{math.ceil(Health4 / math_max_ret2 * 100)}%`;
        end;
    end;

    v20:Add(u17:GetAttributeChangedSignal("Health"):Connect(updateHealthText));
    v20:Add(u17:GetAttributeChangedSignal("MaxHealth"):Connect(updateHealthText));

    local function updateBombIcon(p27, p28) -- Line: 197
        -- upvalues: u23 (copy)
        local v29;

        if p28 == nil then
            v29 = false;
        else
            v29 = p28.Weapon == "C4";
        end;

        local v30;

        if p27 == nil then
            v30 = false;
        else
            v30 = p27.Name == "C4";
        end;

        if v29 then
            v29 = not v30;
        end;

        u23.Info.Weapons.Bomb.Visible = v29;
    end;

    local function decodeAttribute(p31: string) -- Line: 203
        -- upvalues: u16 (copy), HttpService (ref)
        local Attribute = u16:GetAttribute(p31);

        if Attribute then
            return HttpService:JSONDecode(Attribute);
        end;

        return nil;
    end;

    v20:Add(Observers.observeAttribute(u16, "CurrentEquipped", function(p32) -- Line: 208
        -- upvalues: u23 (copy), HttpService (ref), GetWeaponProperties (ref), u16 (copy)
        if not (u23.Parent and u23:FindFirstChild("Info")) then
            return function() -- Line: 210
            end;
        end;

        local v33 = HttpService:JSONDecode(p32 or "[]");
        local Gun = u23.Info.Weapons.Gun;

        if v33 and v33.Name then
            local v34 = GetWeaponProperties(v33.Name);
            Gun.Image = v34 and (v34.Icon or "") or "";
            Gun.Visible = v34 or false;
        else
            Gun.Visible = false;
        end;

        local Attribute = u16:GetAttribute("Slot5");
        local v35;

        if Attribute then
            v35 = HttpService:JSONDecode(Attribute);
        else
            v35 = nil;
        end;

        local v36;

        if v35 == nil then
            v36 = false;
        else
            v36 = v35.Weapon == "C4";
        end;

        local v37;

        if v33 == nil then
            v37 = false;
        else
            v37 = v33.Name == "C4";
        end;

        if v36 then
            v36 = not v37;
        end;

        u23.Info.Weapons.Bomb.Visible = v36;

        return function() -- Line: 224
            -- upvalues: u23 (ref)
            if u23:FindFirstChild("Info") then
                u23.Info.Weapons.Gun.Visible = false;
            end;
        end;
    end));
    v20:Add(Observers.observeAttribute(u16, "Slot5", function(p38) -- Line: 231
        -- upvalues: u23 (copy), u16 (copy), HttpService (ref)
        if not (u23.Parent and u23:FindFirstChild("Info")) then
            return function() -- Line: 233
            end;
        end;

        local Attribute = u16:GetAttribute("CurrentEquipped");
        local v39;

        if Attribute then
            v39 = HttpService:JSONDecode(Attribute);
        else
            v39 = nil;
        end;

        local v40 = HttpService:JSONDecode(p38 or "[]");
        local v41;

        if v40 == nil then
            v41 = false;
        else
            v41 = v40.Weapon == "C4";
        end;

        local v42;

        if v39 == nil then
            v42 = false;
        else
            v42 = v39.Name == "C4";
        end;

        if v41 then
            v41 = not v42;
        end;

        u23.Info.Weapons.Bomb.Visible = v41;

        return function() -- Line: 238
            -- upvalues: u23 (ref)
            if u23:FindFirstChild("Info") then
                u23.Info.Weapons.Bomb.Visible = false;
            end;
        end;
    end));
    u3[u16] = v20;
    u4[u16] = {
        Arrow = u21,
        NameTag = u23
    };
    local Player = SpectateController.GetPlayer();
    local v43;

    if Player == nil or Player == LocalPlayer then
        v43 = not BlackMarketSceneController.IsActive();
    else
        v43 = false;
    end;

    u21.Enabled = v43;
    u23.Enabled = v43;
    v20:Add(function() -- Line: 254
        -- upvalues: u4 (ref), u16 (copy)
        u4[u16] = nil;
    end);

    local function cleanupIfCharacterBecameStale() -- Line: 258
        -- upvalues: u16 (copy), CharacterResolver (ref), Participants (ref), u17 (copy), u3 (ref), RefreshNameTagArrowColors (ref)
        local v44 = true;
        local v45 = u16;
        local v46;

        if v45:IsA("Player") then
            v46 = CharacterResolver.getPlayerCharacter(v45);
        else
            v46 = Participants.Character(v45);
        end;

        if v46 == u17 then
            v44 = not (u17:IsDescendantOf(workspace) and CharacterResolver.isAliveCharacter(u17));
        end;

        if v44 then
            local v47 = u16;

            if u3[v47] then
                u3[v47]:Destroy();
                u3[v47] = nil;
                RefreshNameTagArrowColors();
            end;
        end;
    end;

    v20:Add(u17:GetAttributeChangedSignal("Dead"):Connect(cleanupIfCharacterBecameStale));
    v20:Add(u17:GetAttributeChangedSignal("Health"):Connect(cleanupIfCharacterBecameStale));
    v20:Add(u17.AncestryChanged:Connect(cleanupIfCharacterBecameStale));
    RefreshNameTagArrowColors();

    return v20;
end;

local function ReleaseCameraToMenu() -- Line: 278
    -- upvalues: SpectateController (copy), CameraController (copy)
    if SpectateController.IsTakingOverCamera() then
        return;
    end;

    CameraController.setPerspective(false, true);
end;

local function characterAdded(p48) -- Line: 288
    -- upvalues: CameraController (copy), ReleaseCameraToMenu (copy), BlackMarketSceneController (copy), InputController (copy)
    CameraController.setPerspective(true, false);
    p48:Add(ReleaseCameraToMenu);

    if not BlackMarketSceneController.IsActive() then
        InputController.enableGroup("Gameplay");
    end;

    p48:Add(function() -- Line: 296
        -- upvalues: InputController (ref)
        InputController.disableGroup("Gameplay");
    end);
end;

local function RefreshNameTagVisibility() -- Line: 303
    -- upvalues: SpectateController (copy), LocalPlayer (copy), BlackMarketSceneController (copy), u4 (copy)
    local Player = SpectateController.GetPlayer();
    local v49;

    if Player == nil or Player == LocalPlayer then
        v49 = not BlackMarketSceneController.IsActive();
    else
        v49 = false;
    end;

    for _, v in pairs(u4) do
        v.Arrow.Enabled = v49;
        v.NameTag.Enabled = v49;
    end;
end;

SpectateController.ListenToSpectate:Connect(RefreshNameTagVisibility);
BlackMarketSceneController.OnActiveChanged:Connect(RefreshNameTagVisibility);

local function observeRemoteCharacter(u50: userdata, u51: userdata, p52: any) -- Line: 317
    -- upvalues: CharacterController (copy), Janitor (copy), u3 (copy), RefreshNameTagArrowColors (copy), CharacterResolver (copy), Defuser (copy), CharacterHighlight (copy), LocalPlayer (copy), SpectateController (copy), BlackMarketSceneController (copy), Observers (copy), IsSurvivalMode (copy), CreateNameTag (copy)
    local u53 = not u50:IsA("Player");
    local Attribute = u50:GetAttribute("Team");
    local u54 = Attribute == "Counter-Terrorists" and Color3.fromRGB(0, 75, 200) or (Attribute == "Terrorists" and Color3.fromRGB(255, 220, 50) or Color3.fromRGB(255, 255, 255));

    if not u53 then
        CharacterController.TrackCharacter(u50, u51);
        p52:Add(function() -- Line: 329
            -- upvalues: CharacterController (ref), u50 (copy), u51 (copy)
            CharacterController.UntrackCharacter(u50, u51);
        end);
    end;

    local Attribute2 = workspace:GetAttribute("Gamemode");
    local u55 = Attribute == "Terrorists" and true or Attribute == "Counter-Terrorists";
    local u56 = Janitor.new();
    p52:Add(function() -- Line: 337
        -- upvalues: u56 (ref), u50 (copy), u3 (ref), RefreshNameTagArrowColors (ref)
        u56:Destroy();
        local v57 = u50;

        if u3[v57] then
            u3[v57]:Destroy();
            u3[v57] = nil;
            RefreshNameTagArrowColors();
        end;
    end);

    local function rebuildRemoteVisuals() -- Line: 342
        -- upvalues: u56 (ref), Janitor (ref), u51 (copy), CharacterResolver (ref), u50 (copy), u3 (ref), RefreshNameTagArrowColors (ref), u53 (copy), Defuser (ref), u55 (copy), Attribute2 (copy), CharacterHighlight (ref), u54 (copy), LocalPlayer (ref), SpectateController (ref), BlackMarketSceneController (ref), Observers (ref), Attribute (copy), IsSurvivalMode (ref), CreateNameTag (ref)
        u56:Destroy();
        u56 = Janitor.new();

        if u51:GetAttribute("Dead") == true or not CharacterResolver.isAliveCharacter(u51) then
            local v58 = u50;

            if u3[v58] then
                u3[v58]:Destroy();
                u3[v58] = nil;
                RefreshNameTagArrowColors();
            end;

            return;
        end;

        if not u53 then
            local u59 = Defuser.new(u50, u51);
            u56:Add(function() -- Line: 353
                -- upvalues: u59 (copy)
                u59:Destroy();
            end);
        end;

        if u55 then
            local v60;

            if Attribute2 == "Deathmatch" then
                v60 = Enum.HighlightDepthMode.Occluded;
            else
                v60 = Enum.HighlightDepthMode.AlwaysOnTop;
            end;

            local u61 = u56:Add(CharacterHighlight.new(u51, {
                OutlineTransparency = 0.4,
                FillTransparency = 0.7,
                DepthMode = v60,
                FillColor = Color3.fromRGB(255, 255, 255),
                OutlineColor = u54
            }));

            local function updateHighlightVisible() -- Line: 370
                -- upvalues: u51 (ref), u50 (ref), LocalPlayer (ref), SpectateController (ref), u61 (copy), BlackMarketSceneController (ref)
                if not u51.Parent then
                    return;
                end;

                local Attribute3 = workspace:GetAttribute("Gamemode");
                local Attribute4 = workspace:GetAttribute("GameState");
                local Attribute5 = u50:GetAttribute("Team");
                local v62 = u51:GetAttribute("Dead") == true;
                local v63 = u50:GetAttribute("Invincible") == true;
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

                local v67 = Player == u50;
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
            u56:Add(u50:GetAttributeChangedSignal("Invincible"):Connect(updateHighlightVisible));
            u56:Add(SpectateController.ListenToSpectate:Connect(function() -- Line: 418
                -- upvalues: updateHighlightVisible (copy)
                updateHighlightVisible();
            end));
            u56:Add(BlackMarketSceneController.OnActiveChanged:Connect(function() -- Line: 421
                -- upvalues: updateHighlightVisible (copy)
                updateHighlightVisible();
            end));

            local function onHighlightInputChanged() -- Line: 425
                -- upvalues: updateHighlightVisible (copy)
                updateHighlightVisible();

                return function() -- Line: 427
                end;
            end;

            for _, v in {
                { LocalPlayer, "IsSpectating" },
                { LocalPlayer, "SpectatePerspective" },
                { LocalPlayer, "Team" },
                { u50, "Team" },
                { workspace, "GameState" }
            } do
                u56:Add(Observers.observeAttribute(v[1], v[2], onHighlightInputChanged));
            end;
        end;

        local v73 = Attribute;
        local v74;

        if (v73 == "Terrorists" and true or v73 == "Counter-Terrorists") and workspace:GetAttribute("Gamemode") ~= "Deathmatch" then
            v74 = LocalPlayer:GetAttribute("Team") == v73 and true or IsSurvivalMode();
        else
            v74 = false;
        end;

        if v74 then
            CreateNameTag(u50, u51, Attribute);
            u56:Add(function() -- Line: 443
                -- upvalues: u50 (ref), u3 (ref), RefreshNameTagArrowColors (ref)
                local v75 = u50;

                if u3[v75] then
                    u3[v75]:Destroy();
                    u3[v75] = nil;
                    RefreshNameTagArrowColors();
                end;
            end);
        end;
    end;

    rebuildRemoteVisuals();
    p52:Add(u51:GetAttributeChangedSignal("Dead"):Connect(rebuildRemoteVisuals));
    local u76 = u51:IsDescendantOf(workspace);
    p52:Add(u51.AncestryChanged:Connect(function() -- Line: 457
        -- upvalues: u51 (copy), u76 (ref), rebuildRemoteVisuals (copy)
        local v77 = u51:IsDescendantOf(workspace);

        if v77 ~= u76 then
            u76 = v77;
            rebuildRemoteVisuals();
        end;
    end));

    if LocalPlayer:GetAttribute("IsSpectating") and not SpectateController.GetCurrentSpectateInstance() then
        SpectateController.Next();
    end;
end;

local u78 = {};

local function GetBotDescriptor(p79: userdata) -- Line: 478
    -- upvalues: ReplicatedStorage (copy)
    local Combatants = ReplicatedStorage:FindFirstChild("Combatants");
    local Attribute = p79:GetAttribute("CombatantId");

    if Combatants and Attribute ~= nil then
        return Combatants:FindFirstChild((tostring(Attribute)));
    end;

    return nil;
end;

local function BotShellRemoved(p80: userdata) -- Line: 484
    -- upvalues: u78 (copy)
    local v81 = u78[p80];

    if v81 then
        u78[p80] = nil;
        v81:Destroy();
    end;
end;

local function BotShellAdded(p82: userdata) -- Line: 492
    -- upvalues: ReplicatedStorage (copy), u78 (copy), u2 (copy), Janitor (copy), u3 (copy), RefreshNameTagArrowColors (copy), observeRemoteCharacter (copy)
    if not p82:IsA("Model") or p82:GetAttribute("Bot") ~= true then
        return;
    end;

    local Combatants = ReplicatedStorage:FindFirstChild("Combatants");
    local Attribute = p82:GetAttribute("CombatantId");
    local u83;

    if Combatants and Attribute ~= nil then
        u83 = Combatants:FindFirstChild((tostring(Attribute)));
    else
        u83 = nil;
    end;

    if not u83 then
        return;
    end;

    local v84 = u78[p82];

    if v84 then
        u78[p82] = nil;
        v84:Destroy();
    end;

    if u2[u83] then
        u2[u83]:Destroy();
    end;

    local u85 = Janitor.new();
    u78[p82] = u85;
    u2[u83] = u85;
    u85:Add(function() -- Line: 509
        -- upvalues: u2 (ref), u83 (copy), u85 (copy)
        if u2[u83] == u85 then
            u2[u83] = nil;
        end;
    end);

    if u3[u83] then
        u3[u83]:Destroy();
        u3[u83] = nil;
        RefreshNameTagArrowColors();
    end;

    observeRemoteCharacter(u83, p82, u85);
end;

local u86 = false;

local function BindBotCharacters(p87: userdata) -- Line: 520
    -- upvalues: u86 (ref), BotShellAdded (copy), BotShellRemoved (copy)
    if u86 then
        return;
    end;

    u86 = true;
    p87.ChildAdded:Connect(BotShellAdded);
    p87.ChildRemoved:Connect(BotShellRemoved);

    for _, child in p87:GetChildren() do
        task.spawn(BotShellAdded, child);
    end;
end;

local Characters = workspace:FindFirstChild("Characters");

if Characters then
    BindBotCharacters(Characters);
else
    local u88 = nil;
    u88 = workspace.ChildAdded:Connect(function(p89) -- Line: 537
        -- upvalues: BindBotCharacters (copy), u88 (ref)
        if p89.Name == "Characters" then
            BindBotCharacters(p89);

            if u88 then
                u88:Disconnect();
            end;
        end;
    end);
end;

return Observers.observeCharacter(function(p90, u91) -- Line: 550
    -- upvalues: u2 (copy), Janitor (copy), u3 (copy), RefreshNameTagArrowColors (copy), LocalPlayer (copy), characterAdded (copy), SpectateController (copy), CameraController (copy), InputController (copy), Participants (copy), IsSurvivalMode (copy), CreateNameTag (copy), observeRemoteCharacter (copy)
    if u2[p90] then
        u2[p90]:Destroy();
        u2[p90] = nil;
    end;

    local u92 = Janitor.new();
    u2[p90] = u92;

    if u3[p90] then
        u3[p90]:Destroy();
        u3[p90] = nil;
        RefreshNameTagArrowColors();
    end;

    if LocalPlayer == p90 then
        characterAdded(u92);
        u92:Add(u91:GetAttributeChangedSignal("Dead"):Connect(function() -- Line: 564
            -- upvalues: u91 (copy), SpectateController (ref), CameraController (ref), InputController (ref)
            if u91:GetAttribute("Dead") == true then
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
                local v93 = Participants.Character(v);

                if v93 and v93:IsDescendantOf(workspace) then
                    local Attribute = v:GetAttribute("Team");
                    local v94;

                    if (Attribute == "Terrorists" and true or Attribute == "Counter-Terrorists") and workspace:GetAttribute("Gamemode") ~= "Deathmatch" then
                        v94 = LocalPlayer:GetAttribute("Team") == Attribute and true or IsSurvivalMode();
                    else
                        v94 = false;
                    end;

                    if v94 then
                        CreateNameTag(v, v93, Attribute);

                        if u2[v] then
                            u2[v]:Add(function() -- Line: 585
                                -- upvalues: v (copy), u3 (ref), RefreshNameTagArrowColors (ref)
                                local v95 = v;

                                if u3[v95] then
                                    u3[v95]:Destroy();
                                    u3[v95] = nil;
                                    RefreshNameTagArrowColors();
                                end;
                            end);
                        end;
                    end;
                end;
            end;
        end;
    else
        observeRemoteCharacter(p90, u91, u92);
    end;

    return function() -- Line: 596
        -- upvalues: u92 (copy)
        u92:Destroy();
    end;
end);