-- Decompiled with Potassium's decompiler.

local u1 = {};
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local UserInputService = game:GetService("UserInputService");
local GuiService = game:GetService("GuiService");
local Players = game:GetService("Players");
local CollectionService = game:GetService("CollectionService");
require(script:WaitForChild("Types"));
local LocalPlayer = Players.LocalPlayer;
local InventoryController = require(ReplicatedStorage.Controllers.InventoryController);
local CameraController = require(ReplicatedStorage.Controllers.CameraController);
local CharacterGeneration = require(ReplicatedStorage.Components.Common.CharacterGeneration);
local ClientCharacterPresentation = require(ReplicatedStorage.Components.Common.ClientCharacterPresentation);
local CharacterResolver = require(ReplicatedStorage.Components.Common.CharacterResolver);
local Participants = require(ReplicatedStorage.Components.Common.Participants);
local RemoteCharacters = require(ReplicatedStorage.Controllers.CharacterController.RemoteCharacters);
local IsPlayingTeam = require(ReplicatedStorage.Components.Common.IsPlayingTeam);
local CharacterActions = require(ReplicatedStorage.Database.Components.CharacterActions);
local RunServiceController = require(ReplicatedStorage.Controllers.RunServiceController);
local BlackMarketSceneController = require(ReplicatedStorage.Controllers.BlackMarketSceneController);
local MenuState = require(ReplicatedStorage.Interface.MenuState);
local Spectate = require(ReplicatedStorage.Classes.Spectate);
local Freecam = require(ReplicatedStorage.Classes.Freecam);
local Ragdoll = require(ReplicatedStorage.Classes.Ragdoll);
local Observers = require(ReplicatedStorage.Packages.Observers);
local Promise = require(ReplicatedStorage.Shared.Promise);
local Signal = require(ReplicatedStorage.Packages.Signal);
local Remotes = require(ReplicatedStorage.Database.Security.Remotes);
local Router = require(ReplicatedStorage.Database.Security.Router);
local workspace_CurrentCamera = workspace.CurrentCamera;
local u2 = Signal.new();
u1.ListenToSpectate = u2;
local u3 = Signal.new();
u1.ListenToFreecam = u3;
local Constants = require(ReplicatedStorage.Database.Custom.Constants);
local u4 = { "TeamSelection", "BuyMenu", "Leaderboard", "Votekick" };
local u5 = "First-Person";
local u6 = {};
local u7 = 0;
local u8 = false;
local u9 = 1;
local u10 = 1;
local u11 = 0;
local u12 = 0;
local u13 = nil;
local u14 = 0;
local u15 = nil;
local u16 = nil;
local u17 = { "First-Person", "Third-Person", "Free-Cam" };
local u18 = nil;
local u19 = nil;

local function GetCurrentGamemode() -- Line: 99
    local Attribute = workspace:GetAttribute("ServerGamemode");

    return Attribute ~= "Competitive" and Attribute ~= "Deathmatch" and "Casual" or Attribute;
end;

local function IsOnPlayingTeam(p20: userdata) -- Line: 109
    -- upvalues: IsPlayingTeam (copy)
    return IsPlayingTeam(p20:GetAttribute("Team"));
end;

local function HasAliveCharacterReplicated(p21: userdata) -- Line: 115
    -- upvalues: Participants (copy), CharacterResolver (copy)
    if Participants.IsBot(p21) then
        return Participants.IsAlive(p21);
    end;

    return CharacterResolver.isAlivePlayer(p21);
end;

local function IsCharacterAlive(p22: userdata) -- Line: 126
    -- upvalues: IsPlayingTeam (copy), LocalPlayer (copy), u8 (ref), HasAliveCharacterReplicated (copy)
    if not IsPlayingTeam(p22:GetAttribute("Team")) then
        return false;
    end;

    if p22 == LocalPlayer and u8 then
        return false;
    end;

    return HasAliveCharacterReplicated(p22);
end;

local function IsCompetitiveRestrictedLocalSpectate() -- Line: 139
    -- upvalues: LocalPlayer (copy), IsPlayingTeam (copy), u8 (ref), Participants (copy), CharacterResolver (copy)
    local Attribute = workspace:GetAttribute("ServerGamemode");
    local v23;

    if (Attribute ~= "Competitive" and Attribute ~= "Deathmatch" and "Casual" or Attribute) == "Competitive" then
        v23 = IsPlayingTeam(LocalPlayer:GetAttribute("Team"));

        if v23 then
            local v24 = LocalPlayer;
            local v25;

            if IsPlayingTeam(v24:GetAttribute("Team")) and (v24 ~= LocalPlayer or not u8) then
                if Participants.IsBot(v24) then
                    v25 = Participants.IsAlive(v24);
                else
                    v25 = CharacterResolver.isAlivePlayer(v24);
                end;
            else
                v25 = false;
            end;

            v23 = not v25;
        end;
    else
        v23 = false;
    end;

    return v23;
end;

local function DestroyFreecam() -- Line: 145
    -- upvalues: u19 (ref)
    if u19 then
        u19:Destroy();
        u19 = nil;
    end;
end;

local function ResetSpectatePerspective() -- Line: 154
    -- upvalues: u5 (ref), u9 (ref)
    u5 = "First-Person";
    u9 = 1;
end;

local function EnforceCompetitiveSpectatePerspective() -- Line: 161
    -- upvalues: LocalPlayer (copy), IsPlayingTeam (copy), u8 (ref), Participants (copy), CharacterResolver (copy), u5 (ref), u9 (ref), u18 (ref), u19 (ref)
    local Attribute = workspace:GetAttribute("ServerGamemode");
    local v26;

    if (Attribute ~= "Competitive" and Attribute ~= "Deathmatch" and "Casual" or Attribute) == "Competitive" then
        v26 = IsPlayingTeam(LocalPlayer:GetAttribute("Team"));

        if v26 then
            local v27 = LocalPlayer;
            local v28;

            if IsPlayingTeam(v27:GetAttribute("Team")) and (v27 ~= LocalPlayer or not u8) then
                if Participants.IsBot(v27) then
                    v28 = Participants.IsAlive(v27);
                else
                    v28 = CharacterResolver.isAlivePlayer(v27);
                end;
            else
                v28 = false;
            end;

            v26 = not v28;
        end;
    else
        v26 = false;
    end;

    if not v26 then
        return;
    end;

    u5 = "First-Person";
    u9 = 1;

    if u18 and u18.PerspectiveState ~= "First-Person" then
        u18:Switch("First-Person");
    end;

    if u19 then
        u19:Destroy();
        u19 = nil;
    end;
end;

local function IsValidSpectateTargetForLocalPlayer(p29: userdata) -- Line: 175
    -- upvalues: LocalPlayer (copy), IsPlayingTeam (copy), u8 (ref), Participants (copy), CharacterResolver (copy)
    if p29 ~= LocalPlayer then
        local v30;

        if IsPlayingTeam(p29:GetAttribute("Team")) and (p29 ~= LocalPlayer or not u8) then
            if Participants.IsBot(p29) then
                v30 = Participants.IsAlive(p29);
            else
                v30 = CharacterResolver.isAlivePlayer(p29);
            end;
        else
            v30 = false;
        end;

        if v30 then
            local Attribute = workspace:GetAttribute("ServerGamemode");
            local v31;

            if (Attribute ~= "Competitive" and Attribute ~= "Deathmatch" and "Casual" or Attribute) == "Competitive" then
                v31 = IsPlayingTeam(LocalPlayer:GetAttribute("Team"));

                if v31 then
                    local v32 = LocalPlayer;
                    local v33;

                    if IsPlayingTeam(v32:GetAttribute("Team")) and (v32 ~= LocalPlayer or not u8) then
                        if Participants.IsBot(v32) then
                            v33 = Participants.IsAlive(v32);
                        else
                            v33 = CharacterResolver.isAlivePlayer(v32);
                        end;
                    else
                        v33 = false;
                    end;

                    v31 = not v33;
                end;
            else
                v31 = false;
            end;

            return not v31 or LocalPlayer:GetAttribute("Team") == p29:GetAttribute("Team");
        end;
    end;

    return false;
end;

local function GetSpectateBombModel() -- Line: 185
    -- upvalues: CollectionService (copy)
    for _, v in ipairs(CollectionService:GetTagged("Bomb")) do
        if v:IsA("Model") and (v.PrimaryPart and v:IsDescendantOf(workspace)) then
            return v;
        end;
    end;

    return nil;
end;

local function StopBombSpectate() -- Line: 197
    -- upvalues: u16 (ref), LocalPlayer (copy), u15 (ref)
    if u16 and LocalPlayer.ReplicationFocus == u16 then
        LocalPlayer.ReplicationFocus = nil;
    end;

    u15 = nil;
    u16 = nil;
end;

local function RenderBombSpectate() -- Line: 208
    -- upvalues: u15 (ref), u16 (ref), LocalPlayer (copy), workspace_CurrentCamera (copy)
    local v34 = u15;

    if not (v34 and v34.Parent) then
        return false;
    end;

    local PrimaryPart = v34.PrimaryPart;

    if not PrimaryPart then
        return false;
    end;

    if u16 ~= PrimaryPart then
        u16 = PrimaryPart;
        LocalPlayer.ReplicationFocus = PrimaryPart;
    end;

    workspace_CurrentCamera.CameraType = Enum.CameraType.Follow;
    workspace_CurrentCamera.CameraSubject = PrimaryPart;

    return true;
end;

local function GetKillerPlayer() -- Line: 233
    -- upvalues: LocalPlayer (copy), Participants (copy), IsPlayingTeam (copy), u8 (ref), CharacterResolver (copy)
    local Attribute = LocalPlayer:GetAttribute("LastKiller");
    local Attribute2 = LocalPlayer:GetAttribute("LastKillerKey");

    if Attribute or Attribute2 then
        LocalPlayer:SetAttribute("LastKiller", nil);
        LocalPlayer:SetAttribute("LastKillerKey", nil);
        local v35 = Participants.FromKey(Attribute2);

        if v35 then
            Attribute = v35;
        elseif Attribute then
            Attribute = Participants.FromName(Attribute);
        end;

        if Attribute then
            local v36;

            if Attribute == LocalPlayer then
                v36 = false;
            else
                local v37;

                if IsPlayingTeam(Attribute:GetAttribute("Team")) and (Attribute ~= LocalPlayer or not u8) then
                    if Participants.IsBot(Attribute) then
                        v37 = Participants.IsAlive(Attribute);
                    else
                        v37 = CharacterResolver.isAlivePlayer(Attribute);
                    end;
                else
                    v37 = false;
                end;

                if v37 then
                    local Attribute3 = workspace:GetAttribute("ServerGamemode");
                    local v38;

                    if (Attribute3 ~= "Competitive" and Attribute3 ~= "Deathmatch" and "Casual" or Attribute3) == "Competitive" then
                        v38 = IsPlayingTeam(LocalPlayer:GetAttribute("Team"));

                        if v38 then
                            local v39 = LocalPlayer;
                            local v40;

                            if IsPlayingTeam(v39:GetAttribute("Team")) and (v39 ~= LocalPlayer or not u8) then
                                if Participants.IsBot(v39) then
                                    v40 = Participants.IsAlive(v39);
                                else
                                    v40 = CharacterResolver.isAlivePlayer(v39);
                                end;
                            else
                                v40 = false;
                            end;

                            v38 = not v40;
                        end;
                    else
                        v38 = false;
                    end;

                    v36 = not v38 or LocalPlayer:GetAttribute("Team") == Attribute:GetAttribute("Team");
                else
                    v36 = false;
                end;
            end;

            if v36 then
                return Attribute;
            end;
        end;
    end;

    return nil;
end;

local function IsReturningToMainMenu() -- Line: 252
    -- upvalues: MenuState (copy)
    if not MenuState.WantsMainMenu() then
        return false;
    end;

    local MenuFrame = MenuState.GetMenuFrame();
    local v41;

    if MenuFrame == nil then
        v41 = false;
    else
        v41 = MenuFrame.Visible == true;
    end;

    return v41;
end;

local function ShouldBeSpectating() -- Line: 261
    -- upvalues: MenuState (copy), ReplicatedStorage (copy), LocalPlayer (copy), IsPlayingTeam (copy), u8 (ref), Participants (copy), CharacterResolver (copy)
    if not MenuState.IsCaseSceneActive() then
        local v42;

        if MenuState.WantsMainMenu() then
            local MenuFrame = MenuState.GetMenuFrame();

            if MenuFrame == nil then
                v42 = false;
            else
                v42 = MenuFrame.Visible == true;
            end;
        else
            v42 = false;
        end;

        if not v42 then
            if require(ReplicatedStorage.Controllers.EndScreenController).IsActive() then
                return false;
            end;

            local v43 = LocalPlayer;
            local v44;

            if IsPlayingTeam(v43:GetAttribute("Team")) and (v43 ~= LocalPlayer or not u8) then
                if Participants.IsBot(v43) then
                    v44 = Participants.IsAlive(v43);
                else
                    v44 = CharacterResolver.isAlivePlayer(v43);
                end;
            else
                v44 = false;
            end;

            if v44 or not IsPlayingTeam(LocalPlayer:GetAttribute("Team")) then
                return false;
            end;

            local State = require(ReplicatedStorage.Database.Components.GameState).GetState();
            local v45;

            if State == "Game Ending" then
                v45 = false;
            else
                v45 = State ~= "Map Voting";
            end;

            return v45;
        end;
    end;

    return false;
end;

local function SpectateKillerOrNext() -- Line: 283
    -- upvalues: GetKillerPlayer (copy), u1 (copy)
    local v46 = GetKillerPlayer();

    if v46 then
        u1.SetNextPlayer(v46);

        return;
    end;

    u1.Next();
end;

local function StartSpectatingOnDeath() -- Line: 293
    -- upvalues: ShouldBeSpectating (copy), CharacterResolver (copy), Ragdoll (copy), u18 (ref), u19 (ref), CameraController (copy), Constants (copy), GetKillerPlayer (copy), u1 (copy)
    if not ShouldBeSpectating() then
        return;
    end;

    local LocalCharacter = CharacterResolver.getLocalCharacter();

    if LocalCharacter then
        Ragdoll.HideCharacterLocally(LocalCharacter);
    end;

    if u18 or u19 then
        return;
    end;

    CameraController.updateCameraFOV(Constants.DEFAULT_CAMERA_FOV);
    CameraController.setPerspective(true, false);
    local v47 = GetKillerPlayer();

    if v47 then
        u1.SetNextPlayer(v47);

        return;
    end;

    u1.Next();
end;

local function UpdateCharacters() -- Line: 314
    -- upvalues: LocalPlayer (copy), u6 (copy), Participants (copy), IsPlayingTeam (copy), u8 (ref), CharacterResolver (copy)
    local Attribute = workspace:GetAttribute("ServerGamemode");
    local v48 = (Attribute ~= "Competitive" and Attribute ~= "Deathmatch" and "Casual" or Attribute) == "Competitive";
    local Attribute2 = LocalPlayer:GetAttribute("Team");
    table.clear(u6);

    for _, v in ipairs((Participants.GetAll())) do
        if (not v48 or (Attribute2 == "Spectators" and true or v:GetAttribute("Team") == Attribute2)) and v ~= LocalPlayer then
            local v49;

            if IsPlayingTeam(v:GetAttribute("Team")) and (v ~= LocalPlayer or not u8) then
                if Participants.IsBot(v) then
                    v49 = Participants.IsAlive(v);
                else
                    v49 = CharacterResolver.isAlivePlayer(v);
                end;
            else
                v49 = false;
            end;

            if v49 then
                table.insert(u6, v);
            end;
        end;
    end;
end;

local function IncrementSpectateIndex(p50: number) -- Line: 331
    -- upvalues: UpdateCharacters (copy), u6 (copy), u13 (ref), u18 (ref), u10 (ref)
    UpdateCharacters();

    if #u6 > 0 then
        local v51 = u13 or u18 and u18.Player;

        if v51 then
            v51 = table.find(u6, v51);
        end;

        if v51 then
            u10 = v51;
        end;

        u10 = u10 + p50;

        if u10 <= 0 then
            u10 = #u6;

            return;
        end;

        if u10 > #u6 then
            u10 = 1;
        end;
    end;
end;

local function IsSpectateInputBlockedByUi() -- Line: 352
    -- upvalues: GuiService (copy), UserInputService (copy), MenuState (copy), u4 (copy)
    if GuiService.MenuIsOpen then
        return true;
    end;

    if UserInputService:GetFocusedTextBox() ~= nil then
        return true;
    end;

    local MenuFrame = MenuState.GetMenuFrame();

    if MenuFrame and MenuFrame.Visible then
        return true;
    end;

    local MainGui = MenuState.GetMainGui();

    if not MainGui then
        return false;
    end;

    local Gameplay = MainGui:FindFirstChild("Gameplay");

    if Gameplay then
        Gameplay = Gameplay:FindFirstChild("Middle");
    end;

    if not Gameplay then
        return false;
    end;

    for _, v in u4 do
        local v52 = Gameplay:FindFirstChild(v);

        if v52 and (v52:IsA("GuiObject") and v52.Visible) then
            return true;
        end;
    end;

    return false;
end;

local function ReleaseMenuMouseLock() -- Line: 391
    -- upvalues: IsSpectateInputBlockedByUi (copy), MenuState (copy), CameraController (copy)
    if IsSpectateInputBlockedByUi() or (MenuState.IsCaseSceneActive() or MenuState.IsInspectActive()) then
        return;
    end;

    CameraController.resetForceLockOverride();
end;

function u1.GetCurrentSpectateInstance() -- Line: 402
    -- upvalues: u18 (ref)
    return u18;
end;

function u1.IsLocalPlayerDead() -- Line: 409
    -- upvalues: u8 (ref)
    return u8;
end;

function u1.IsTakingOverCamera() -- Line: 416
    -- upvalues: MenuState (copy), ShouldBeSpectating (copy), LocalPlayer (copy)
    local v53;

    if MenuState.WantsMainMenu() then
        local MenuFrame = MenuState.GetMenuFrame();

        if MenuFrame == nil then
            v53 = false;
        else
            v53 = MenuFrame.Visible == true;
        end;
    else
        v53 = false;
    end;

    if v53 then
        return false;
    end;

    return ShouldBeSpectating() or LocalPlayer:GetAttribute("IsSpectating") == true;
end;

function u1.IsFreecamActive() -- Line: 426
    -- upvalues: u19 (ref), u18 (ref)
    local v54;

    if u19 == nil then
        if u18 == nil then
            v54 = false;
        else
            v54 = u18.FreecamInstance ~= nil;
        end;
    else
        v54 = true;
    end;

    return v54;
end;

function u1.CanSwitchPerspective() -- Line: 433
    -- upvalues: u18 (ref), LocalPlayer (copy), IsPlayingTeam (copy), u8 (ref), Participants (copy), CharacterResolver (copy)
    local v55;

    if u18 == nil then
        v55 = false;
    else
        local Attribute = workspace:GetAttribute("ServerGamemode");
        local v56;

        if (Attribute ~= "Competitive" and Attribute ~= "Deathmatch" and "Casual" or Attribute) == "Competitive" then
            v56 = IsPlayingTeam(LocalPlayer:GetAttribute("Team"));

            if v56 then
                local v57 = LocalPlayer;
                local v58;

                if IsPlayingTeam(v57:GetAttribute("Team")) and (v57 ~= LocalPlayer or not u8) then
                    if Participants.IsBot(v57) then
                        v58 = Participants.IsAlive(v57);
                    else
                        v58 = CharacterResolver.isAlivePlayer(v57);
                    end;
                else
                    v58 = false;
                end;

                v56 = not v58;
            end;
        else
            v56 = false;
        end;

        v55 = not v56;
    end;

    return v55;
end;

function u1.IsSpectatingNow() -- Line: 440
    -- upvalues: u18 (ref), u19 (ref), LocalPlayer (copy)
    return (u18 ~= nil or u19 ~= nil) and true or LocalPlayer:GetAttribute("IsSpectating") == true;
end;

function u1.GetPlayer() -- Line: 447
    -- upvalues: LocalPlayer (copy), IsPlayingTeam (copy), u8 (ref), Participants (copy), CharacterResolver (copy), u18 (ref)
    local v59 = LocalPlayer;
    local v60;

    if IsPlayingTeam(v59:GetAttribute("Team")) and (v59 ~= LocalPlayer or not u8) then
        if Participants.IsBot(v59) then
            v60 = Participants.IsAlive(v59);
        else
            v60 = CharacterResolver.isAlivePlayer(v59);
        end;
    else
        v60 = false;
    end;

    if v60 then
        return LocalPlayer;
    end;

    if u18 then
        return u18.Player;
    end;

    return nil;
end;

function u1.SetNextPlayer(p61: userdata) -- Line: 456
    -- upvalues: u18 (ref), u13 (ref), LocalPlayer (copy), IsPlayingTeam (copy), u8 (ref), Participants (copy), CharacterResolver (copy), u1 (copy), Remotes (copy), u14 (ref), RemoteCharacters (copy), CharacterGeneration (copy), ClientCharacterPresentation (copy), u5 (ref), Spectate (copy)
    local v62 = u18 and u18.Player;
    u13 = nil;
    local v63;

    if p61 == LocalPlayer then
        v63 = false;
    else
        local v64;

        if IsPlayingTeam(p61:GetAttribute("Team")) and (p61 ~= LocalPlayer or not u8) then
            if Participants.IsBot(p61) then
                v64 = Participants.IsAlive(p61);
            else
                v64 = CharacterResolver.isAlivePlayer(p61);
            end;
        else
            v64 = false;
        end;

        if v64 then
            local Attribute = workspace:GetAttribute("ServerGamemode");
            local v65;

            if (Attribute ~= "Competitive" and Attribute ~= "Deathmatch" and "Casual" or Attribute) == "Competitive" then
                v65 = IsPlayingTeam(LocalPlayer:GetAttribute("Team"));

                if v65 then
                    local v66 = LocalPlayer;
                    local v67;

                    if IsPlayingTeam(v66:GetAttribute("Team")) and (v66 ~= LocalPlayer or not u8) then
                        if Participants.IsBot(v66) then
                            v67 = Participants.IsAlive(v66);
                        else
                            v67 = CharacterResolver.isAlivePlayer(v66);
                        end;
                    else
                        v67 = false;
                    end;

                    v65 = not v67;
                end;
            else
                v65 = false;
            end;

            v63 = not v65 or LocalPlayer:GetAttribute("Team") == p61:GetAttribute("Team");
        else
            v63 = false;
        end;
    end;

    if not v63 then
        u1.Next();

        return;
    end;

    local v68 = Participants.IsBot(p61);
    local Send = Remotes.Spectate.SpectatePlayer.Send;
    local v69;

    if v68 then
        v69 = tostring(Participants.Key(p61));
    else
        v69 = p61.Name;
    end;

    Send(v69);
    local v70;

    if v68 then
        v70 = Participants.Character(p61);
    else
        v70 = CharacterResolver.getPlayerCharacter(p61);
    end;

    if v68 and not CharacterResolver.isAliveCharacter(v70) then
        u13 = p61;
        u14 = os.clock();

        return;
    end;

    local v71 = u18 and u18.Character == v70;
    local v72;

    if IsPlayingTeam(p61:GetAttribute("Team")) and (p61 ~= LocalPlayer or not u8) then
        if Participants.IsBot(p61) then
            v72 = Participants.IsAlive(p61);
        else
            v72 = CharacterResolver.isAlivePlayer(p61);
        end;
    else
        v72 = false;
    end;

    if v62 == p61 and (v71 and v72) then
        if not v68 then
            RemoteCharacters.SetPinnedPlayer(p61);
        end;

        return;
    end;

    u1.Stop(false, true);

    if not v68 then
        RemoteCharacters.SetPinnedPlayer(p61);
        local Attribute = p61:GetAttribute(CharacterGeneration.AttributeName);

        if typeof(Attribute) == "number" then
            ClientCharacterPresentation.Create(p61, Attribute);
        end;

        v70 = CharacterResolver.getPlayerCharacter(p61);
    end;

    if not (v70 and (v72 and CharacterResolver.resolve(v70))) then
        RemoteCharacters.SetPinnedPlayer(nil);
        u1.Next();

        return;
    end;

    local Attribute = workspace:GetAttribute("ServerGamemode");
    local v73;

    if (Attribute ~= "Competitive" and Attribute ~= "Deathmatch" and "Casual" or Attribute) == "Competitive" then
        v73 = IsPlayingTeam(LocalPlayer:GetAttribute("Team"));

        if v73 then
            local v74 = LocalPlayer;
            local v75;

            if IsPlayingTeam(v74:GetAttribute("Team")) and (v74 ~= LocalPlayer or not u8) then
                if Participants.IsBot(v74) then
                    v75 = Participants.IsAlive(v74);
                else
                    v75 = CharacterResolver.isAlivePlayer(v74);
                end;
            else
                v75 = false;
            end;

            v73 = not v75;
        end;
    else
        v73 = false;
    end;

    local v76 = v73 and "First-Person" or u5;
    local v77;

    if v68 then
        v77 = Spectate.newBot(p61, v70, v76);
    else
        v77 = Spectate.new(p61, v70, v76);
    end;

    u18 = v77;

    if u5 ~= "First-Person" then
        v77:Switch(u5);
    end;

    u1.ListenToSpectate:Fire(p61);
    v77.StopSpectating:Once(function() -- Line: 506
        -- upvalues: u1 (ref)
        u1.Stop(false, true);
        u1.Next();
    end);
end;

function u1.Switch() -- Line: 522
    -- upvalues: LocalPlayer (copy), IsPlayingTeam (copy), u8 (ref), Participants (copy), CharacterResolver (copy), u5 (ref), u9 (ref), u18 (ref), u19 (ref), u17 (copy)
    local Attribute = workspace:GetAttribute("ServerGamemode");
    local v78;

    if (Attribute ~= "Competitive" and Attribute ~= "Deathmatch" and "Casual" or Attribute) == "Competitive" then
        v78 = IsPlayingTeam(LocalPlayer:GetAttribute("Team"));

        if v78 then
            local v79 = LocalPlayer;
            local v80;

            if IsPlayingTeam(v79:GetAttribute("Team")) and (v79 ~= LocalPlayer or not u8) then
                if Participants.IsBot(v79) then
                    v80 = Participants.IsAlive(v79);
                else
                    v80 = CharacterResolver.isAlivePlayer(v79);
                end;
            else
                v80 = false;
            end;

            v78 = not v80;
        end;
    else
        v78 = false;
    end;

    if not v78 then
        u9 = u9 + 1 > #u17 and 1 or u9 + 1;
        u5 = u17[u9];

        if u18 then
            u18:Switch(u5);
        end;

        return;
    end;

    u5 = "First-Person";
    u9 = 1;

    if u18 then
        u18:Switch("First-Person");
    end;

    if u19 then
        u19:Destroy();
        u19 = nil;
    end;
end;

function u1.UpdateIndex(p81: number) -- Line: 541
    -- upvalues: UpdateCharacters (copy), u6 (copy), u13 (ref), u18 (ref), u10 (ref), Promise (copy), IsPlayingTeam (copy), LocalPlayer (copy), u8 (ref), Participants (copy), CharacterResolver (copy), u1 (copy)
    UpdateCharacters();

    if #u6 > 0 then
        local v82 = u13 or u18 and u18.Player;

        if v82 then
            v82 = table.find(u6, v82);
        end;

        if v82 then
            u10 = v82;
        end;

        u10 = u10 + p81;

        if u10 <= 0 then
            u10 = #u6;
        elseif u10 > #u6 then
            u10 = 1;
        end;
    end;

    return Promise.new(function(p83: function, p84: function) -- Line: 544
        -- upvalues: u6 (ref), u10 (ref), IsPlayingTeam (ref), LocalPlayer (ref), u8 (ref), Participants (ref), CharacterResolver (ref), UpdateCharacters (ref), u1 (ref)
        local v85 = u6[u10];

        if v85 then
            local v86;

            if IsPlayingTeam(v85:GetAttribute("Team")) and (v85 ~= LocalPlayer or not u8) then
                if Participants.IsBot(v85) then
                    v86 = Participants.IsAlive(v85);
                else
                    v86 = CharacterResolver.isAlivePlayer(v85);
                end;
            else
                v86 = false;
            end;

            if v86 then
                p83(v85);

                return;
            end;
        end;

        UpdateCharacters();

        if #u6 > 0 then
            u10 = 1;
            p83(u6[1]);

            return;
        end;

        u1.Stop(false, false);
        p84("No players alive to spectate");
    end);
end;

local function SpectateByOffset(p87: number) -- Line: 564
    -- upvalues: u1 (copy)
    return u1.UpdateIndex(p87):andThen(function(p88: userdata) -- Line: 566
        -- upvalues: u1 (ref)
        u1.SetNextPlayer(p88);
    end):catch(function() -- Line: 569
    end);
end;

function u1.Next() -- Line: 574
    -- upvalues: SpectateByOffset (copy)
    return SpectateByOffset(1);
end;

function u1.Previous() -- Line: 578
    -- upvalues: SpectateByOffset (copy)
    return SpectateByOffset(-1);
end;

function u1.IsControllerPress(p89: userdata) -- Line: 589
    -- upvalues: UserInputService (copy)
    if string.match(p89.UserInputType.Name, "^Gamepad%d+$") then
        return true;
    end;

    for _, v in UserInputService:GetConnectedGamepads() do
        for _, v2 in UserInputService:GetGamepadState(v) do
            if (v2.KeyCode == Enum.KeyCode.ButtonR2 and true or v2.KeyCode == Enum.KeyCode.ButtonL2) and v2.Position.Z > 0.1 then
                return true;
            end;
        end;
    end;

    return false;
end;

function u1.RequestSwitch(p90: number) -- Line: 607
    -- upvalues: u1 (copy), LocalPlayer (copy), IsPlayingTeam (copy), u8 (ref), Participants (copy), CharacterResolver (copy), u18 (ref), u19 (ref), u12 (ref)
    if not u1.IsSpectatingNow() then
        return;
    end;

    local v91 = LocalPlayer;
    local v92;

    if IsPlayingTeam(v91:GetAttribute("Team")) and (v91 ~= LocalPlayer or not u8) then
        if Participants.IsBot(v91) then
            v92 = Participants.IsAlive(v91);
        else
            v92 = CharacterResolver.isAlivePlayer(v91);
        end;
    else
        v92 = false;
    end;

    if v92 and (u18 == nil and u19 == nil) then
        return;
    end;

    local os_clock_ret = os.clock();

    if os_clock_ret - u12 < 0.15 then
        return;
    end;

    u12 = os_clock_ret;

    if p90 < 0 then
        u1.Previous();

        return;
    end;

    u1.Next();
end;

function u1.Stop(p93: boolean, p94: boolean) -- Line: 632
    -- upvalues: u16 (ref), LocalPlayer (copy), u15 (ref), RemoteCharacters (copy), u13 (ref), u18 (ref), Remotes (copy), u19 (ref), u2 (copy)
    if u16 and LocalPlayer.ReplicationFocus == u16 then
        LocalPlayer.ReplicationFocus = nil;
    end;

    u15 = nil;
    u16 = nil;
    RemoteCharacters.SetPinnedPlayer(nil);
    u13 = nil;

    if u18 then
        u18:Destroy();
        u18 = nil;
    end;

    if p93 and LocalPlayer:GetAttribute("IsSpectating") then
        Remotes.Spectate.StopSpectating.Send();
    end;

    if p94 and u19 then
        u19:Destroy();
        u19 = nil;
    end;

    u2:Fire();
end;

function u1.Broadcast() -- Line: 656
    -- upvalues: LocalPlayer (copy), u11 (ref), InventoryController (copy), MenuState (copy), BlackMarketSceneController (copy), Remotes (copy), workspace_CurrentCamera (copy)
    local Attribute = LocalPlayer:GetAttribute("Spectators");
    local v95 = Attribute and Attribute > 0 and 0.016666666666666666 or 0.2;

    if v95 <= u11 then
        local CurrentEquipped = InventoryController.getCurrentEquipped();
        u11 = u11 - v95;

        if CurrentEquipped then
            local v96 = LocalPlayer.PlayerGui:FindFirstChild("MainGui") and LocalPlayer.PlayerGui.MainGui:FindFirstChild("Menu");

            if v96 then
                v96 = v96:FindFirstChild("Inspect");
            end;

            if v96 and v96.Visible or (MenuState.IsCaseSceneActive() or BlackMarketSceneController.IsActive()) then
                return;
            end;

            Remotes.Spectate.UpdateCameraCFrame.Send({
                CameraCFrame = workspace_CurrentCamera.CFrame,
                UserId = LocalPlayer.UserId
            });
        end;
    end;
end;

local function UpdatePendingBotTarget() -- Line: 685
    -- upvalues: u13 (ref), CharacterResolver (copy), Participants (copy), u1 (copy), LocalPlayer (copy), IsPlayingTeam (copy), u8 (ref), u14 (ref), u18 (ref)
    local v97 = u13;

    if not v97 then
        return;
    end;

    if CharacterResolver.isAliveCharacter(Participants.Character(v97)) then
        u1.SetNextPlayer(v97);

        return;
    end;

    local v98;

    if v97 == LocalPlayer then
        v98 = false;
    else
        local v99;

        if IsPlayingTeam(v97:GetAttribute("Team")) and (v97 ~= LocalPlayer or not u8) then
            if Participants.IsBot(v97) then
                v99 = Participants.IsAlive(v97);
            else
                v99 = CharacterResolver.isAlivePlayer(v97);
            end;
        else
            v99 = false;
        end;

        if v99 then
            local Attribute = workspace:GetAttribute("ServerGamemode");
            local v100;

            if (Attribute ~= "Competitive" and Attribute ~= "Deathmatch" and "Casual" or Attribute) == "Competitive" then
                v100 = IsPlayingTeam(LocalPlayer:GetAttribute("Team"));

                if v100 then
                    local v101 = LocalPlayer;
                    local v102;

                    if IsPlayingTeam(v101:GetAttribute("Team")) and (v101 ~= LocalPlayer or not u8) then
                        if Participants.IsBot(v101) then
                            v102 = Participants.IsAlive(v101);
                        else
                            v102 = CharacterResolver.isAlivePlayer(v101);
                        end;
                    else
                        v102 = false;
                    end;

                    v100 = not v102;
                end;
            else
                v100 = false;
            end;

            v98 = not v100 or LocalPlayer:GetAttribute("Team") == v97:GetAttribute("Team");
        else
            v98 = false;
        end;
    end;

    if not v98 or os.clock() - u14 > 1.5 then
        u13 = nil;

        if u18 then
            u1.SetNextPlayer(u18.Player);
        end;
    end;
end;

function u1.Render(p103: number) -- Line: 707
    -- upvalues: u7 (ref), u11 (ref), LocalPlayer (copy), IsPlayingTeam (copy), u8 (ref), Participants (copy), CharacterResolver (copy), u5 (ref), u9 (ref), u18 (ref), u19 (ref), u1 (copy), u16 (ref), u15 (ref), BlackMarketSceneController (copy), workspace_CurrentCamera (copy), CameraController (copy), ShouldBeSpectating (copy), MenuState (copy), UserInputService (copy), IsSpectateInputBlockedByUi (copy), UpdatePendingBotTarget (copy), Router (copy), UpdateCharacters (copy), u6 (copy), u13 (ref), u10 (ref), GetSpectateBombModel (copy), Constants (copy), Freecam (copy), u3 (copy)
    u7 = u7 + p103;
    u11 = u11 + p103;
    local Attribute = workspace:GetAttribute("ServerGamemode");
    local v104;

    if (Attribute ~= "Competitive" and Attribute ~= "Deathmatch" and "Casual" or Attribute) == "Competitive" then
        v104 = IsPlayingTeam(LocalPlayer:GetAttribute("Team"));

        if v104 then
            local v105 = LocalPlayer;
            local v106;

            if IsPlayingTeam(v105:GetAttribute("Team")) and (v105 ~= LocalPlayer or not u8) then
                if Participants.IsBot(v105) then
                    v106 = Participants.IsAlive(v105);
                else
                    v106 = CharacterResolver.isAlivePlayer(v105);
                end;
            else
                v106 = false;
            end;

            v104 = not v106;
        end;
    else
        v104 = false;
    end;

    if v104 then
        local Attribute2 = workspace:GetAttribute("ServerGamemode");
        local v107;

        if (Attribute2 ~= "Competitive" and Attribute2 ~= "Deathmatch" and "Casual" or Attribute2) == "Competitive" then
            v107 = IsPlayingTeam(LocalPlayer:GetAttribute("Team"));

            if v107 then
                local v108 = LocalPlayer;
                local v109;

                if IsPlayingTeam(v108:GetAttribute("Team")) and (v108 ~= LocalPlayer or not u8) then
                    if Participants.IsBot(v108) then
                        v109 = Participants.IsAlive(v108);
                    else
                        v109 = CharacterResolver.isAlivePlayer(v108);
                    end;
                else
                    v109 = false;
                end;

                v107 = not v109;
            end;
        else
            v107 = false;
        end;

        if v107 then
            u5 = "First-Person";
            u9 = 1;

            if u18 and u18.PerspectiveState ~= "First-Person" then
                u18:Switch("First-Person");
            end;

            if u19 then
                u19:Destroy();
                u19 = nil;
            end;
        end;
    end;

    if u8 then
        local v110 = LocalPlayer;
        local v111;

        if Participants.IsBot(v110) then
            v111 = Participants.IsAlive(v110);
        else
            v111 = CharacterResolver.isAlivePlayer(v110);
        end;

        if v111 then
            u8 = false;
        end;
    end;

    local v112 = LocalPlayer;
    local v113;

    if IsPlayingTeam(v112:GetAttribute("Team")) and (v112 ~= LocalPlayer or not u8) then
        if Participants.IsBot(v112) then
            v113 = Participants.IsAlive(v112);
        else
            v113 = CharacterResolver.isAlivePlayer(v112);
        end;
    else
        v113 = false;
    end;

    if v113 then
        u1.Broadcast();

        if u16 and LocalPlayer.ReplicationFocus == u16 then
            LocalPlayer.ReplicationFocus = nil;
        end;

        u15 = nil;
        u16 = nil;

        if u18 then
            u1.Stop(true, true);
        end;

        if u19 then
            u19:Destroy();
            u19 = nil;
        end;

        local v114 = LocalPlayer;
        local v115;

        if IsPlayingTeam(v114:GetAttribute("Team")) and (v114 ~= LocalPlayer or not u8) then
            if Participants.IsBot(v114) then
                v115 = Participants.IsAlive(v114);
            else
                v115 = CharacterResolver.isAlivePlayer(v114);
            end;
        else
            v115 = false;
        end;

        if v115 and not BlackMarketSceneController.IsActive() then
            local LocalCharacter = CharacterResolver.getLocalCharacter();
            local v116 = CharacterResolver.getCameraPart(LocalCharacter) or CharacterResolver.getRootPart(LocalCharacter);

            if v116 then
                workspace_CurrentCamera.CameraType = Enum.CameraType.Custom;
                workspace_CurrentCamera.CameraSubject = v116;
            end;

            CameraController.setPerspective(true, false);
        end;
    elseif ShouldBeSpectating() or LocalPlayer:GetAttribute("IsSpectating") then
        local v117;

        if MenuState.WantsMainMenu() then
            local MenuFrame = MenuState.GetMenuFrame();

            if MenuFrame == nil then
                v117 = false;
            else
                v117 = MenuFrame.Visible == true;
            end;
        else
            v117 = false;
        end;

        if v117 then
            if u18 then
                u1.Stop(false, true);

                return;
            end;

            if u16 and LocalPlayer.ReplicationFocus == u16 then
                LocalPlayer.ReplicationFocus = nil;
            end;

            u15 = nil;
            u16 = nil;
        else
            if MenuState.IsCaseSceneActive() or BlackMarketSceneController.IsActive() then
                return;
            end;

            if UserInputService.MouseBehavior ~= Enum.MouseBehavior.LockCenter and not (IsSpectateInputBlockedByUi() or (MenuState.IsCaseSceneActive() or MenuState.IsInspectActive())) then
                CameraController.resetForceLockOverride();
            end;

            UpdatePendingBotTarget();

            if u18 then
                if u16 and LocalPlayer.ReplicationFocus == u16 then
                    LocalPlayer.ReplicationFocus = nil;
                end;

                u15 = nil;
                u16 = nil;

                if Router.broadcastRouter("IsInspectActive") then
                    return;
                end;

                u18:Render(p103);

                if u19 then
                    u19:Destroy();
                    u19 = nil;
                end;
            else
                if u7 >= 0.2 then
                    u7 = 0;
                    UpdateCharacters();

                    if #u6 > 0 then
                        local v118 = u13 or u18 and u18.Player;

                        if v118 then
                            v118 = table.find(u6, v118);
                        end;

                        if v118 then
                            u10 = v118;
                        end;

                        u10 = u10 + 1;

                        if u10 <= 0 then
                            u10 = #u6;
                        elseif u10 > #u6 then
                            u10 = 1;
                        end;
                    end;
                end;

                if u13 then
                    return;
                end;

                if u6[u10] then
                    if u16 and LocalPlayer.ReplicationFocus == u16 then
                        LocalPlayer.ReplicationFocus = nil;
                    end;

                    u15 = nil;
                    u16 = nil;
                    u1.Next();

                    return;
                end;

                if v104 then
                    u15 = not (u15 and u15.Parent) and GetSpectateBombModel();

                    if u15 then
                        CameraController.setPerspective(false, false);
                        CameraController.updateCameraFOV(Constants.DEFAULT_CAMERA_FOV);
                    end;

                    if u15 then
                        local v119 = u15;
                        local v120;

                        if v119 and v119.Parent then
                            local PrimaryPart = v119.PrimaryPart;

                            if PrimaryPart then
                                if u16 ~= PrimaryPart then
                                    u16 = PrimaryPart;
                                    LocalPlayer.ReplicationFocus = PrimaryPart;
                                end;

                                workspace_CurrentCamera.CameraType = Enum.CameraType.Follow;
                                workspace_CurrentCamera.CameraSubject = PrimaryPart;
                                v120 = true;
                            else
                                v120 = false;
                            end;
                        else
                            v120 = false;
                        end;

                        if not v120 then
                            if u16 and LocalPlayer.ReplicationFocus == u16 then
                                LocalPlayer.ReplicationFocus = nil;
                            end;

                            u15 = nil;
                            u16 = nil;
                        end;
                    else
                        if u16 and LocalPlayer.ReplicationFocus == u16 then
                            LocalPlayer.ReplicationFocus = nil;
                        end;

                        u15 = nil;
                        u16 = nil;
                    end;

                    if u19 then
                        u19:Destroy();
                        u19 = nil;
                    end;

                    return;
                end;

                if u16 and LocalPlayer.ReplicationFocus == u16 then
                    LocalPlayer.ReplicationFocus = nil;
                end;

                u15 = nil;
                u16 = nil;

                if not u19 then
                    local v121 = Freecam.new();
                    u19 = v121;
                    v121:Start();
                    u3:Fire(true);
                end;
            end;
        end;
    else
        if u18 then
            u1.Stop(false, true);

            return;
        end;

        if u16 and LocalPlayer.ReplicationFocus == u16 then
            LocalPlayer.ReplicationFocus = nil;
        end;

        u15 = nil;
        u16 = nil;
    end;
end;

function u1.Initialize() -- Line: 814
    -- upvalues: Observers (copy), LocalPlayer (copy), MenuState (copy), IsSpectateInputBlockedByUi (copy), CameraController (copy), Constants (copy), u18 (ref), GetKillerPlayer (copy), u1 (copy), Remotes (copy), Participants (copy), CharacterResolver (copy), u8 (ref), StartSpectatingOnDeath (copy), IsPlayingTeam (copy), u5 (ref), u9 (ref), ReplicatedStorage (copy), RunServiceController (copy)
    Observers.observeAttribute(LocalPlayer, "IsSpectating", function(p122) -- Line: 816
        -- upvalues: LocalPlayer (ref), MenuState (ref), IsSpectateInputBlockedByUi (ref), CameraController (ref), Constants (ref), u18 (ref), GetKillerPlayer (ref), u1 (ref)
        if p122 then
            LocalPlayer:SetAttribute("PendingSpectateRequestAt", nil);

            if not MenuState.IsCaseSceneActive() then
                local v123;

                if MenuState.WantsMainMenu() then
                    local MenuFrame = MenuState.GetMenuFrame();

                    if MenuFrame == nil then
                        v123 = false;
                    else
                        v123 = MenuFrame.Visible == true;
                    end;
                else
                    v123 = false;
                end;

                if not v123 then
                    if not (IsSpectateInputBlockedByUi() or (MenuState.IsCaseSceneActive() or MenuState.IsInspectActive())) then
                        CameraController.resetForceLockOverride();
                    end;

                    CameraController.updateCameraFOV(Constants.DEFAULT_CAMERA_FOV);
                    CameraController.setPerspective(true, false);

                    if not u18 then
                        local v124 = GetKillerPlayer();

                        if v124 then
                            u1.SetNextPlayer(v124);
                        else
                            u1.Next();
                        end;
                    end;
                end;
            end;
        end;

        return function() -- Line: 831
            -- upvalues: u1 (ref)
            u1.Stop(false, true);
        end;
    end);
    Remotes.Character.CharacterDied.Listen(function() -- Line: 837
        -- upvalues: LocalPlayer (ref), Participants (ref), CharacterResolver (ref), u8 (ref), StartSpectatingOnDeath (ref)
        local v125 = LocalPlayer;
        local v126;

        if Participants.IsBot(v125) then
            v126 = Participants.IsAlive(v125);
        else
            v126 = CharacterResolver.isAlivePlayer(v125);
        end;

        if v126 then
            u8 = false;

            return;
        end;

        u8 = true;
        StartSpectatingOnDeath();
    end);
    LocalPlayer.CharacterAdded:Connect(function(u127) -- Line: 848
        -- upvalues: u8 (ref), LocalPlayer (ref), IsPlayingTeam (ref), CharacterResolver (ref), MenuState (ref), u5 (ref), u9 (ref), u1 (ref), Remotes (ref), u18 (ref), Participants (ref), StartSpectatingOnDeath (ref)
        u8 = false;
        local v128 = IsPlayingTeam(LocalPlayer:GetAttribute("Team"));
        local v129 = CharacterResolver.isAliveCharacter(u127);
        local Attribute = LocalPlayer:GetAttribute("PendingSpectateRequestAt");
        local v130;

        if Attribute == nil then
            v130 = false;
        else
            v130 = os.clock() - Attribute < 3;
        end;

        if v128 and v129 then
            MenuState.SetWantsMainMenu(false);
            u5 = "First-Person";
            u9 = 1;
            u1.Stop(not v130, true);

            if not v130 and LocalPlayer:GetAttribute("IsSpectating") then
                Remotes.Spectate.StopSpectating.Send();
            end;
        elseif u18 and u18.Player then
            local Send = Remotes.Spectate.SpectatePlayer.Send;
            local v131;

            if u18.IsBot then
                v131 = tostring(Participants.Key(u18.Player));
            else
                v131 = u18.Player.Name;
            end;

            Send(v131);
        end;

        local u132 = u127:GetAttributeChangedSignal("Dead"):Connect(function() -- Line: 875
            -- upvalues: u127 (copy), StartSpectatingOnDeath (ref)
            if u127:GetAttribute("Dead") then
                StartSpectatingOnDeath();
            end;
        end);
        local u133 = nil;
        u133 = u127.AncestryChanged:Connect(function(p134, p135) -- Line: 881
            -- upvalues: u132 (copy), u133 (ref)
            if not p135 then
                u132:Disconnect();
                u133:Disconnect();
            end;
        end);
    end);
    require(ReplicatedStorage.Database.Components.GameState).ListenToState(function(p136, p137) -- Line: 890
        -- upvalues: u1 (ref)
        if p137 == "Game Ending" or p137 == "Map Voting" then
            u1.Stop(false, true);
        end;
    end);
    RunServiceController.BindToRenderStep("SpectateController.Render", function(p138: number) -- Line: 896
        -- upvalues: u1 (ref)
        u1.Render(p138);
    end);
end;

function u1.Start() -- Line: 901
    -- upvalues: Remotes (copy), u18 (ref), Players (copy), CharacterGeneration (copy), CharacterActions (copy), UserInputService (copy), LocalPlayer (copy), u1 (copy), IsSpectateInputBlockedByUi (copy), GuiService (copy), workspace_CurrentCamera (copy)
    Remotes.Character.Action.Listen(function(p139) -- Line: 903
        -- upvalues: u18 (ref), Players (ref), CharacterGeneration (ref), CharacterActions (ref)
        if not u18 or typeof(p139) ~= "table" then
            return;
        end;

        local v140;

        if typeof(p139.UserId) == "number" then
            v140 = Players:GetPlayerByUserId(p139.UserId);
        else
            v140 = nil;
        end;

        if not v140 or v140 ~= u18.Player then
            return;
        end;

        if CharacterGeneration.Get(v140.Character) ~= p139.Generation then
            return;
        end;

        local v141 = CharacterActions.ToName(p139.ActionId);

        if v141 then
            u18:AddSpectateEvent(v141);
        end;
    end);
    UserInputService.InputBegan:Connect(function(p142: userdata) -- Line: 922
        -- upvalues: LocalPlayer (ref), u1 (ref), IsSpectateInputBlockedByUi (ref), GuiService (ref)
        if LocalPlayer:GetAttribute("IsPlayerChatting") or not u1.IsSpectatingNow() then
            return;
        end;

        if p142.KeyCode == Enum.KeyCode.Space then
            u1.Switch();

            return;
        end;

        if p142.KeyCode == Enum.KeyCode.ButtonA then
            if not IsSpectateInputBlockedByUi() and GuiService.SelectedObject == nil then
                u1.Switch();
            end;

            return;
        end;

        local v143 = p142.KeyCode == Enum.KeyCode.ButtonL1;

        if v143 or p142.KeyCode == Enum.KeyCode.ButtonR1 then
            if not IsSpectateInputBlockedByUi() then
                u1.RequestSwitch(v143 and -1 or 1);
            end;

            return;
        end;

        local v144 = p142.UserInputType == Enum.UserInputType.MouseButton1;

        if not v144 and p142.UserInputType ~= Enum.UserInputType.MouseButton2 then
            return;
        end;

        if IsSpectateInputBlockedByUi() or u1.IsControllerPress(p142) then
            return;
        end;

        u1.RequestSwitch(v144 and -1 or 1);
    end);

    if UserInputService.TouchEnabled then
        UserInputService.TouchStarted:Connect(function(p145: userdata, p146: boolean) -- Line: 965
            -- upvalues: LocalPlayer (ref), u1 (ref), workspace_CurrentCamera (ref)
            if p146 or LocalPlayer:GetAttribute("IsPlayerChatting") then
                return;
            end;

            u1.RequestSwitch(p145.Position.X < workspace_CurrentCamera.ViewportSize.X / 2 and -1 or 1);
        end);
    end;
end;

return u1;