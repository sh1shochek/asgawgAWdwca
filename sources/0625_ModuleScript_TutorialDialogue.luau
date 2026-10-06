-- Decompiled with Potassium's decompiler.

local v1 = {};
local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local SoundService = game:GetService("SoundService");
local TweenService = game:GetService("TweenService");
local ContextActionService = game:GetService("ContextActionService");
local ContentProvider = game:GetService("ContentProvider");
local UserInputService = game:GetService("UserInputService");
local LocalPlayer = Players.LocalPlayer;
local IsTutorialMode = require(ReplicatedStorage.Components.Common.IsTutorialMode);
local GameState = require(ReplicatedStorage.Database.Components.GameState);
local DataController = require(ReplicatedStorage.Controllers.DataController);
local Remotes = require(ReplicatedStorage.Database.Security.Remotes);
local Tutorial = require(ReplicatedStorage.Database.Audio.Tutorial);
local Tips = require(ReplicatedStorage.Interface.Screens.Gameplay.Middle.Tips);
local Router = require(ReplicatedStorage.Database.Security.Router);
local u2 = nil;
local u3 = nil;
local u4 = nil;
local u5 = "Hidden";
local u6 = nil;
local u7 = nil;
local u8 = nil;
local u9 = nil;
local Left = Enum.TextXAlignment.Left;
local Color3_fromRGB_ret = Color3.fromRGB(238, 238, 238);
local u10 = {};
local u11 = false;
local u12 = false;
local u13 = 0;
local u14 = 0;
local u15 = 0;
local u16 = 0;
local u17 = nil;
local u18 = nil;
local u19 = false;
local u20 = 0;
local u21 = false;
local u22 = 0;
local u23 = 0;
local u24 = 0;
local u25 = {};
local u26 = nil;
local u27 = nil;
local u28 = nil;
local u29 = nil;
local u30 = false;
local UDim2_fromScale_ret = UDim2.fromScale(0.5, 0.85);
local UDim2_fromScale_ret2 = UDim2.fromScale(0, 0.03);
local Color3_fromRGB_ret2 = Color3.fromRGB(255, 200, 70);
local u31 = nil;

local function findMiddle(p32: userdata?) -- Line: 110
    if p32 then
        p32 = p32:FindFirstChild("Gameplay");
    end;

    if p32 then
        return p32:FindFirstChild("Middle");
    end;

    return nil;
end;

local function findDialogueFrame(p33: userdata?) -- Line: 115
    -- upvalues: u2 (ref)
    if p33 and p33:IsA("GuiObject") and p33.Name == "TutorialDialogue" then
        return p33;
    end;

    local v34 = u2;

    if v34 then
        v34 = v34:FindFirstChild("Gameplay");
    end;

    local v35;

    if v34 then
        v35 = v34:FindFirstChild("Middle");
    else
        v35 = nil;
    end;

    if not v35 then
        if p33 and p33:IsA("GuiObject") then
            return p33;
        end;

        return nil;
    end;

    local TutorialDialogue = v35:FindFirstChild("TutorialDialogue");

    if TutorialDialogue and TutorialDialogue:IsA("GuiObject") then
        return TutorialDialogue;
    end;

    if p33 and p33:IsA("GuiObject") then
        return p33;
    end;

    return nil;
end;

local function findTextLabel(p36: userdata) -- Line: 131
    local Objective = p36:FindFirstChild("Objective");

    if not Objective then
        return nil;
    end;

    if Objective:IsA("TextLabel") then
        return Objective;
    end;

    if Objective:IsA("GuiObject") then
        return Objective:FindFirstChildWhichIsA("TextLabel", true);
    end;

    return nil;
end;

local function findTabLabel(p37: userdata) -- Line: 146
    for _, child in p37:GetChildren() do
        if child:IsA("Frame") and child.Name ~= "Main" then
            local v38 = child:FindFirstChildWhichIsA("TextLabel");

            if v38 then
                return v38;
            end;
        end;
    end;

    return nil;
end;

local function bindDialogue(p39: userdata?) -- Line: 158
    -- upvalues: findDialogueFrame (copy), u3 (ref), u4 (ref), u6 (ref), findTabLabel (copy), Left (ref), Color3_fromRGB_ret (ref), u2 (ref), u7 (ref), u8 (ref), u9 (ref)
    local v40 = findDialogueFrame(p39);

    if not v40 then
        return false;
    end;

    if u3 ~= v40 then
        u3 = v40;
        local Objective = v40:FindFirstChild("Objective");

        if Objective then
            if not Objective:IsA("TextLabel") then
                if Objective:IsA("GuiObject") then
                    Objective = Objective:FindFirstChildWhichIsA("TextLabel", true);
                else
                    Objective = nil;
                end;
            end;
        else
            Objective = nil;
        end;

        u4 = Objective;
        u6 = findTabLabel(v40);

        for _, child in v40:GetChildren() do
            if child:IsA("ImageLabel") then
                child:Destroy();
            end;
        end;

        local v41 = u4;

        if v41 then
            Left = v41.TextXAlignment;
            Color3_fromRGB_ret = v41.TextColor3;
        end;

        local TutorialSkipHint = v40:FindFirstChild("TutorialSkipHint");

        if TutorialSkipHint then
            TutorialSkipHint:Destroy();
        end;

        local Frame = Instance.new("Frame");
        Frame.Name = "TutorialSkipHint";
        Frame.AnchorPoint = Vector2.new(1, 1);
        Frame.Position = UDim2.new(1, 0, 0, -3);
        Frame.Size = UDim2.fromScale(0.5, 0.3);
        Frame.BackgroundTransparency = 1;
        Frame.Visible = false;
        local UIListLayout = Instance.new("UIListLayout");
        UIListLayout.FillDirection = Enum.FillDirection.Horizontal;
        UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right;
        UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Center;
        UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder;
        UIListLayout.Padding = UDim.new(0, 6);
        UIListLayout.Parent = Frame;
        local v42 = u2;

        if v42 then
            v42 = v42:FindFirstChild("Gameplay");
        end;

        local v43;

        if v42 then
            v43 = v42:FindFirstChild("Middle");
        else
            v43 = nil;
        end;

        if v43 then
            v43 = v43:FindFirstChild("Tips");
        end;

        if v43 then
            v43 = v43:FindFirstChildWhichIsA("Frame");
        end;

        local v44;

        if v43 then
            v44 = v43:FindFirstChild("Keybind");
        else
            v44 = v43;
        end;

        if v43 then
            v43 = v43:FindFirstChild("Title");
        end;

        local v45;

        if v44 and v44:IsA("ImageButton") then
            v45 = v44:Clone();
        else
            v45 = Instance.new("ImageButton");
            v45.AutoButtonColor = false;
            v45.Image = "";
            v45.BackgroundColor3 = Color3.new(1, 1, 1);
            local UICorner = Instance.new("UICorner");
            UICorner.CornerRadius = UDim.new(0.15, 0);
            UICorner.Parent = v45;
            local TextLabel = Instance.new("TextLabel");
            TextLabel.Name = "Bind";
            TextLabel.AnchorPoint = Vector2.new(0.5, 0.5);
            TextLabel.Position = UDim2.fromScale(0.5, 0.5);
            TextLabel.Size = UDim2.fromScale(0.9, 0.7);
            TextLabel.BackgroundTransparency = 1;
            TextLabel.TextScaled = true;
            TextLabel.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.ExtraBold);
            TextLabel.TextColor3 = Color3.new(0, 0, 0);
            TextLabel.Parent = v45;
            local ImageLabel = Instance.new("ImageLabel");
            ImageLabel.Name = "Bind";
            ImageLabel.AnchorPoint = Vector2.new(0.5, 0.5);
            ImageLabel.Position = UDim2.fromScale(0.5, 0.5);
            ImageLabel.Size = UDim2.fromScale(0.9, 0.7);
            ImageLabel.BackgroundTransparency = 1;
            ImageLabel.ScaleType = Enum.ScaleType.Fit;
            ImageLabel.Visible = false;
            ImageLabel.Parent = v45;
        end;

        v45.Name = "Keybind";
        v45.Active = false;
        v45.AnchorPoint = Vector2.zero;
        v45.Position = UDim2.new();
        v45.Size = UDim2.fromScale(1, 1);
        v45.SizeConstraint = Enum.SizeConstraint.RelativeYY;
        v45.LayoutOrder = 1;
        v45.Visible = true;
        v45.Parent = Frame;
        local u46;

        if v43 and v43:IsA("TextLabel") then
            u46 = v43:Clone();
        else
            u46 = Instance.new("TextLabel");
            u46.BackgroundTransparency = 1;
            u46.TextColor3 = Color3.new(1, 1, 1);
            u46.TextStrokeTransparency = 0.4;
            u46.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Italic);
        end;

        u46.Name = "Label";
        u46.AnchorPoint = Vector2.zero;
        u46.Position = UDim2.new();
        u46.AutomaticSize = Enum.AutomaticSize.X;
        u46.Size = UDim2.fromScale(0, 1);
        u46.TextScaled = false;
        u46.TextSize = 18;
        u46.TextXAlignment = Enum.TextXAlignment.Left;
        u46.LayoutOrder = 2;
        u46.Parent = Frame;
        Frame:GetPropertyChangedSignal("AbsoluteSize"):Connect(function() -- Line: 268
            -- upvalues: u46 (ref), Frame (copy)
            local math_floor_ret = math.floor(Frame.AbsoluteSize.Y * 0.72);
            u46.TextSize = math.max(math_floor_ret, 8);
        end);
        Frame.Parent = v40;
        u7 = Frame;
        u8 = v45;
        u9 = u46;
    end;

    return u4 ~= nil;
end;

local u47 = false;
local u48 = nil;

local function onSkipAction(p49: string, p50: any) -- Line: 282
    -- upvalues: u48 (ref)
    if p50 == Enum.UserInputState.Begin then
        u48();
    end;

    return Enum.ContextActionResult.Sink;
end;

local function refreshSkipHint() -- Line: 290
    -- upvalues: u8 (ref), u9 (ref), UserInputService (copy), Tips (copy)
    local v51 = u8;
    local v52 = u9;

    if not (v51 and v52) then
        return;
    end;

    local v53 = UserInputService.PreferredInput == Enum.PreferredInput.Touch;
    local v54;

    if Tips.IsGamepadPreferred() then
        v54 = Enum.KeyCode.DPadUp;
    else
        v54 = Enum.KeyCode.E;
    end;

    local v55 = not v53 and Tips.ApplyBindingToKeybind(v51, v54);
    v51.Visible = v55;
    v52.Text = v53 and "Tap here to skip" or "Skip";
end;

local function updateSkipHint() -- Line: 302
    -- upvalues: u7 (ref), u5 (ref), u21 (ref), LocalPlayer (copy), refreshSkipHint (copy), u47 (ref), ContextActionService (copy), onSkipAction (copy)
    local v56 = u7;

    if not v56 then
        return;
    end;

    local v57;

    if u5 == "Commander" then
        v57 = u21 and LocalPlayer:GetAttribute("TutorialStep") ~= "DefuseB";
    else
        v57 = false;
    end;

    v56.Visible = v57;

    if v57 then
        refreshSkipHint();
    end;

    if not v57 or u47 then
        if not v57 and u47 then
            u47 = false;
            ContextActionService:UnbindAction("TutorialSkipDialogue");
        end;

        return;
    end;

    u47 = true;
    ContextActionService:BindActionAtPriority("TutorialSkipDialogue", onSkipAction, false, Enum.ContextActionPriority.High.Value, Enum.KeyCode.E, Enum.KeyCode.DPadUp);
end;

local function setMode(p58: string) -- Line: 329
    -- upvalues: u5 (ref), u10 (copy), updateSkipHint (copy), u6 (ref), u4 (ref), Left (ref), Color3_fromRGB_ret (ref)
    u5 = p58;

    for _, v in u10 do
        v:Cancel();
    end;

    table.clear(u10);

    if p58 == "Hidden" then
        updateSkipHint();

        return;
    end;

    local v59 = p58 == "Objective";

    if u6 then
        u6.Text = v59 and "OBJECTIVE" or "COMMANDER";
    end;

    local v60 = u4;

    if v60 then
        local v61;

        if v59 then
            v61 = Enum.TextXAlignment.Center;
        else
            v61 = Left;
        end;

        v60.TextXAlignment = v61;
        v60.TextColor3 = Color3_fromRGB_ret;
    end;

    updateSkipHint();
end;

local function stopDialogueAudio() -- Line: 351
    -- upvalues: u28 (ref)
    local v62 = u28;
    u28 = nil;

    if v62 then
        v62:Stop();
        v62:Destroy();
    end;
end;

local function createVoiceSound(p63: string, p64) -- Line: 360
    -- upvalues: DataController (copy), LocalPlayer (copy), SoundService (copy)
    local Sound = Instance.new("Sound");
    Sound.Name = "TutorialDialogueVoice";
    Sound.SoundId = p63;
    Sound.Volume = (tonumber(DataController.Get(LocalPlayer, "Settings.Audio.Audio.Master Volume")) or 100) / 100;
    Sound.Looped = false;
    local Gameplay = SoundService:FindFirstChild("Gameplay");

    if Gameplay and Gameplay:IsA("SoundGroup") then
        Sound.SoundGroup = Gameplay;
    end;

    if p64 then
        Sound.PlaybackRegionsEnabled = true;
        Sound.PlaybackRegion = p64;
    end;

    Sound.Parent = SoundService;

    return Sound;
end;

local function isTrailingOff(p65: userdata) -- Line: 379
    local TimeLength = p65.TimeLength;

    if TimeLength <= 0 then
        return false;
    end;

    if p65.PlaybackRegionsEnabled then
        TimeLength = math.min(p65.PlaybackRegion.Max, TimeLength);
    end;

    local v66;

    if TimeLength - p65.TimePosition <= 0.8 then
        v66 = p65.PlaybackLoudness <= 6;
    else
        v66 = false;
    end;

    return v66;
end;

local u67 = false;

local function preloadVoices() -- Line: 391
    -- upvalues: u67 (ref), Tutorial (copy), SoundService (copy), ContentProvider (copy)
    if u67 then
        return;
    end;

    u67 = true;
    local Folder = Instance.new("Folder");
    Folder.Name = "TutorialVoicePreload";
    local v68 = {};
    local u69 = {};

    for _, v in Tutorial do
        local v70;

        if typeof(v) == "table" then
            v70 = v.audioId;
        else
            v70 = nil;
        end;

        if typeof(v70) == "string" and not v68[v70] then
            v68[v70] = true;
            local Sound = Instance.new("Sound");
            Sound.SoundId = v70;
            Sound.Parent = Folder;
            table.insert(u69, Sound);
        end;
    end;

    Folder.Parent = SoundService;
    task.spawn(function() -- Line: 412
        -- upvalues: ContentProvider (ref), u69 (copy)
        pcall(ContentProvider.PreloadAsync, ContentProvider, u69);
    end);
end;

local function waitForVoiceSound(p71: userdata) -- Line: 422
    local v72 = os.clock() + 2;

    while not p71.IsLoaded and os.clock() < v72 do
        task.wait(0.05);
    end;
end;

local function resolveCommanderLine(p73: string) -- Line: 434
    -- upvalues: Tutorial (copy)
    local v74 = Tutorial[p73];

    if typeof(v74) ~= "table" or typeof(v74.text) ~= "string" then
        return { p73 }, nil, nil;
    end;

    local audioId = v74.audioId;

    if typeof(audioId) ~= "string" then
        audioId = nil;
    end;

    local region = v74.region;
    local v75;

    if typeof(region) == "table" then
        v75 = NumberRange.new(region[1], region[2]);
    else
        v75 = nil;
    end;

    local pages = v74.pages;

    if typeof(pages) == "table" and #pages > 0 then
        return table.clone(pages), audioId, v75;
    end;

    return { v74.text }, audioId, v75;
end;

local function reportCommanderIdle() -- Line: 450
    -- upvalues: u22 (ref), u23 (ref), Remotes (copy)
    if u22 <= u23 then
        return;
    end;

    u23 = u22;
    Remotes.Tutorial.ClientEvent.Send((`CommanderIdle:{u22}`));
end;

local function isMenuOpen() -- Line: 458
    -- upvalues: u2 (ref)
    local v76 = u2 and u2:FindFirstChild("Menu");
    local v77;

    if v76 == nil then
        v77 = false;
    else
        v77 = v76:IsA("GuiObject") and v76.Visible;
    end;

    return v77;
end;

local function isGameplayVisible() -- Line: 463
    -- upvalues: u2 (ref)
    local v78 = u2 and u2:FindFirstChild("Gameplay");
    local v79;

    if v78 == nil then
        v79 = false;
    else
        v79 = v78:IsA("GuiObject") and v78.Visible;
    end;

    return v79;
end;

local function hasPlayingTeam() -- Line: 468
    -- upvalues: LocalPlayer (copy)
    local Attribute = LocalPlayer:GetAttribute("Team");

    return Attribute == "Terrorists" and true or Attribute == "Counter-Terrorists";
end;

local function shouldShowDialogue() -- Line: 473
    -- upvalues: IsTutorialMode (copy), u2 (ref), GameState (copy), LocalPlayer (copy)
    if not IsTutorialMode() or workspace:GetAttribute("TutorialActive") ~= true then
        return false;
    end;

    local v80 = u2 and u2:FindFirstChild("Menu");
    local v81;

    if v80 == nil then
        v81 = false;
    else
        v81 = v80:IsA("GuiObject") and v80.Visible;
    end;

    if not v81 then
        local v82 = u2 and u2:FindFirstChild("Gameplay");
        local v83;

        if v82 == nil then
            v83 = false;
        else
            v83 = v82:IsA("GuiObject") and v82.Visible;
        end;

        if v83 then
            local State = GameState.GetState();

            if State == "Game Ending" or State == "Map Voting" then
                return false;
            end;

            local Attribute = LocalPlayer:GetAttribute("Team");

            return Attribute == "Terrorists" and true or Attribute == "Counter-Terrorists";
        end;
    end;

    return false;
end;

local function liftNotifications(p84: boolean) -- Line: 488
    -- upvalues: u2 (ref), u31 (ref), u3 (ref), u6 (ref)
    local v85 = u2;

    if v85 then
        v85 = v85:FindFirstChild("Gameplay");
    end;

    local v86;

    if v85 then
        v86 = v85:FindFirstChild("Middle");
    else
        v86 = nil;
    end;

    if v86 then
        v86 = v86:FindFirstChild("Notification");
    end;

    if not (v86 and v86:IsA("GuiObject")) then
        return;
    end;

    local v87 = u31 or v86.Position;
    u31 = v87;
    v86.Position = v87;
    local v88 = u3;

    if not (p84 and v88) then
        return;
    end;

    local Y = v88.AbsolutePosition.Y;
    local v89 = u6 and u6.Parent;

    if v89 and v89:IsA("GuiObject") then
        Y = math.min(Y, v89.AbsolutePosition.Y);
    end;

    local v90 = v86.AbsolutePosition.Y + v86.AbsoluteSize.Y + 6 - Y;

    if v90 > 0 then
        v86.Position = v87 - UDim2.fromOffset(0, v90);
    end;
end;

local function hideBox() -- Line: 512
    -- upvalues: u5 (ref), u10 (copy), updateSkipHint (copy), u3 (ref), u2 (ref), u31 (ref)
    u5 = "Hidden";

    for _, v in u10 do
        v:Cancel();
    end;

    table.clear(u10);
    updateSkipHint();

    if u3 then
        u3.Visible = false;
    end;

    local v91 = u2;

    if v91 then
        v91 = v91:FindFirstChild("Gameplay");
    end;

    local v92;

    if v91 then
        v92 = v91:FindFirstChild("Middle");
    else
        v92 = nil;
    end;

    if v92 then
        v92 = v92:FindFirstChild("Notification");
    end;

    if v92 then
        if not v92:IsA("GuiObject") then
            return;
        end;

        local v93 = u31 or v92.Position;
        u31 = v93;
        v92.Position = v93;
    end;
end;

local function clearObjective() -- Line: 521
    -- upvalues: u16 (ref), u20 (ref), u19 (ref), u17 (ref), u18 (ref), u5 (ref), u10 (copy), updateSkipHint (copy), u3 (ref), u2 (ref), u31 (ref)
    u16 = u16 + 1;
    u20 = u20 + 1;
    u19 = false;
    u17 = nil;
    u18 = nil;

    if u5 == "Objective" then
        u5 = "Hidden";

        for _, v in u10 do
            v:Cancel();
        end;

        table.clear(u10);
        updateSkipHint();

        if u3 then
            u3.Visible = false;
        end;

        local v94 = u2;

        if v94 then
            v94 = v94:FindFirstChild("Gameplay");
        end;

        local v95;

        if v94 then
            v95 = v94:FindFirstChild("Middle");
        else
            v95 = nil;
        end;

        if v95 then
            v95 = v95:FindFirstChild("Notification");
        end;

        if v95 then
            if not v95:IsA("GuiObject") then
                return;
            end;

            local v96 = u31 or v95.Position;
            u31 = v96;
            v95.Position = v96;
        end;
    end;
end;

local function hideDialogue() -- Line: 533
    -- upvalues: u15 (ref), u21 (ref), u25 (copy), u26 (ref), u27 (ref), u28 (ref), u11 (ref), u12 (ref), u13 (ref), u16 (ref), u20 (ref), u19 (ref), u17 (ref), u18 (ref), u5 (ref), u10 (copy), updateSkipHint (copy), u3 (ref), u2 (ref), u31 (ref)
    u15 = u15 + 1;

    if u21 or #u25 > 0 then
        local v97 = {};

        if u26 then
            table.insert(v97, u26);
        end;

        table.move(u25, 1, #u25, #v97 + 1, v97);

        if #v97 > 0 then
            u27 = v97;
        end;
    end;

    local v98 = u28;
    u28 = nil;

    if v98 then
        v98:Stop();
        v98:Destroy();
    end;

    u26 = nil;
    u21 = false;
    u11 = false;
    u12 = false;
    u13 = u13 + 1;
    table.clear(u25);
    u16 = u16 + 1;
    u20 = u20 + 1;
    u19 = false;
    u17 = nil;
    u18 = nil;

    if u5 == "Objective" then
        u5 = "Hidden";

        for _, v in u10 do
            v:Cancel();
        end;

        table.clear(u10);
        updateSkipHint();

        if u3 then
            u3.Visible = false;
        end;

        local v99 = u2;

        if v99 then
            v99 = v99:FindFirstChild("Gameplay");
        end;

        local v100;

        if v99 then
            v100 = v99:FindFirstChild("Middle");
        else
            v100 = nil;
        end;

        if v100 then
            v100 = v100:FindFirstChild("Notification");
        end;

        if v100 and v100:IsA("GuiObject") then
            local v101 = u31 or v100.Position;
            u31 = v101;
            v100.Position = v101;
        end;
    end;

    u5 = "Hidden";

    for _, v in u10 do
        v:Cancel();
    end;

    table.clear(u10);
    updateSkipHint();

    if u3 then
        u3.Visible = false;
    end;

    local v102 = u2;

    if v102 then
        v102 = v102:FindFirstChild("Gameplay");
    end;

    local v103;

    if v102 then
        v103 = v102:FindFirstChild("Middle");
    else
        v103 = nil;
    end;

    if v103 then
        v103 = v103:FindFirstChild("Notification");
    end;

    if v103 then
        if not v103:IsA("GuiObject") then
            return;
        end;

        local v104 = u31 or v103.Position;
        u31 = v104;
        v103.Position = v104;
    end;
end;

local function findBuyMenu() -- Line: 557
    -- upvalues: u2 (ref)
    local v105 = u2;

    if v105 then
        v105 = v105:FindFirstChild("Gameplay");
    end;

    local v106;

    if v105 then
        v106 = v105:FindFirstChild("Middle");
    else
        v106 = nil;
    end;

    if v106 then
        v106 = v106:FindFirstChild("BuyMenu");
    end;

    if v106 and v106:IsA("GuiObject") then
        return v106;
    end;

    return nil;
end;

local function restPosition() -- Line: 563
    -- upvalues: u2 (ref), UDim2_fromScale_ret (copy), UDim2_fromScale_ret2 (copy)
    local v107 = u2;

    if v107 then
        v107 = v107:FindFirstChild("Gameplay");
    end;

    local v108;

    if v107 then
        v108 = v107:FindFirstChild("Middle");
    else
        v108 = nil;
    end;

    if v108 then
        v108 = v108:FindFirstChild("BuyMenu");
    end;

    if not (v108 and v108:IsA("GuiObject")) then
        v108 = nil;
    end;

    if v108 and v108.Visible then
        return UDim2_fromScale_ret + UDim2_fromScale_ret2;
    end;

    return UDim2_fromScale_ret;
end;

local function showDialogue() -- Line: 571
    -- upvalues: shouldShowDialogue (copy), hideDialogue (copy), u3 (ref), u2 (ref), UDim2_fromScale_ret (copy), UDim2_fromScale_ret2 (copy), liftNotifications (copy)
    if shouldShowDialogue() then
        if u3 then
            local v109 = u2;

            if v109 then
                v109 = v109:FindFirstChild("Gameplay");
            end;

            local v110;

            if v109 then
                v110 = v109:FindFirstChild("Middle");
            else
                v110 = nil;
            end;

            if v110 then
                v110 = v110:FindFirstChild("BuyMenu");
            end;

            if not (v110 and v110:IsA("GuiObject")) then
                v110 = nil;
            end;

            local v111;

            if v110 and v110.Visible then
                v111 = UDim2_fromScale_ret + UDim2_fromScale_ret2;
            else
                v111 = UDim2_fromScale_ret;
            end;

            u3.Position = v111;
            u3.Visible = true;
            liftNotifications(true);
        end;

        return;
    end;

    hideDialogue();
end;

function v1.IsDialogueName(p112: string) -- Line: 106
    return p112 == "TutorialDialogue";
end;

function v1.IsActive() -- Line: 585
    -- upvalues: u21 (ref)
    return u21;
end;

local function utf8Len(p113: string) -- Line: 589
    local success, result = pcall(utf8.len, p113);

    return (not success or typeof(result) ~= "number") and #p113 or result;
end;

local u114 = nil;
local u115 = nil;
local u116 = nil;

local function returnToObjective() -- Line: 603
    -- upvalues: u19 (ref), u12 (ref), u17 (ref), shouldShowDialogue (copy), u115 (ref), u5 (ref), u10 (copy), updateSkipHint (copy), u3 (ref), u2 (ref), u31 (ref)
    if u19 or u12 then
        return;
    end;

    if u17 and shouldShowDialogue() then
        u115(false);

        return;
    end;

    u5 = "Hidden";

    for _, v in u10 do
        v:Cancel();
    end;

    table.clear(u10);
    updateSkipHint();

    if u3 then
        u3.Visible = false;
    end;

    local v117 = u2;

    if v117 then
        v117 = v117:FindFirstChild("Gameplay");
    end;

    local v118;

    if v117 then
        v118 = v117:FindFirstChild("Middle");
    else
        v118 = nil;
    end;

    if v118 then
        v118 = v118:FindFirstChild("Notification");
    end;

    if v118 then
        if not v118:IsA("GuiObject") then
            return;
        end;

        local v119 = u31 or v118.Position;
        u31 = v119;
        v118.Position = v119;
    end;
end;

local function finishCommander(p120: number) -- Line: 616
    -- upvalues: u26 (ref), u21 (ref), updateSkipHint (copy), u22 (ref), u23 (ref), Remotes (copy), LocalPlayer (copy), u19 (ref), u116 (ref), u11 (ref), u14 (ref), u15 (ref), u12 (ref), u17 (ref), shouldShowDialogue (copy), u115 (ref), u5 (ref), u10 (copy), u3 (ref), u2 (ref), u31 (ref)
    u26 = nil;
    u21 = false;
    updateSkipHint();

    if u22 > u23 then
        u23 = u22;
        Remotes.Tutorial.ClientEvent.Send((`CommanderIdle:{u22}`));
    end;

    local Attribute = LocalPlayer:GetAttribute("TutorialCommanderId");

    if u19 and (typeof(Attribute) ~= "number" or Attribute == u22) then
        u116();

        return;
    end;

    u11 = true;
    u14 = u14 + 1;
    task.wait(0.25);

    if u14 == u14 then
        u11 = false;
    end;

    if p120 == u15 and not (u21 or u19) then
        if u12 then
            return;
        end;

        if u17 and shouldShowDialogue() then
            u115(false);

            return;
        end;

        u5 = "Hidden";

        for _, v in u10 do
            v:Cancel();
        end;

        table.clear(u10);
        updateSkipHint();

        if u3 then
            u3.Visible = false;
        end;

        local v121 = u2;

        if v121 then
            v121 = v121:FindFirstChild("Gameplay");
        end;

        local v122;

        if v121 then
            v122 = v121:FindFirstChild("Middle");
        else
            v122 = nil;
        end;

        if v122 then
            v122 = v122:FindFirstChild("Notification");
        end;

        if v122 then
            if not v122:IsA("GuiObject") then
                return;
            end;

            local v123 = u31 or v122.Position;
            u31 = v123;
            v122.Position = v123;
        end;
    end;
end;

local function playTypewriter(p124: string, p125: table?) -- Line: 639
    -- upvalues: bindDialogue (copy), u3 (ref), u4 (ref), u15 (ref), u21 (ref), u11 (ref), u12 (ref), u13 (ref), u16 (ref), setMode (copy), shouldShowDialogue (copy), hideDialogue (copy), u2 (ref), UDim2_fromScale_ret (copy), UDim2_fromScale_ret2 (copy), liftNotifications (copy), playTypewriter (copy), u28 (ref), u25 (copy), u114 (ref), finishCommander (copy)
    if not bindDialogue(u3) then
        return;
    end;

    local v126 = u4;

    if not (u3 and v126) then
        return;
    end;

    u15 = u15 + 1;
    local v127 = u15;
    u21 = true;
    u11 = false;
    u12 = false;
    u13 = u13 + 1;
    u16 = u16 + 1;
    setMode("Commander");

    if shouldShowDialogue() then
        if u3 then
            local v128 = u2;

            if v128 then
                v128 = v128:FindFirstChild("Gameplay");
            end;

            local v129;

            if v128 then
                v129 = v128:FindFirstChild("Middle");
            else
                v129 = nil;
            end;

            if v129 then
                v129 = v129:FindFirstChild("BuyMenu");
            end;

            if not (v129 and v129:IsA("GuiObject")) then
                v129 = nil;
            end;

            local v130;

            if v129 and v129.Visible then
                v130 = UDim2_fromScale_ret + UDim2_fromScale_ret2;
            else
                v130 = UDim2_fromScale_ret;
            end;

            u3.Position = v130;
            u3.Visible = true;
            liftNotifications(true);
        end;
    else
        hideDialogue();
    end;

    v126.Text = p124;
    v126.MaxVisibleGraphemes = 0;
    local success, result = pcall(utf8.len, p124);

    for i = 1, (not success or typeof(result) ~= "number") and #p124 or result do
        if v127 ~= u15 then
            return;
        end;

        v126.MaxVisibleGraphemes = i;
        task.wait(0.035);
        local _ = i;
    end;

    if v127 ~= u15 then
        return;
    end;

    v126.MaxVisibleGraphemes = -1;

    if p125 and #p125 > 0 then
        local table_remove_ret = table.remove(p125, 1);
        task.wait(1.25);

        if v127 ~= u15 or typeof(table_remove_ret) ~= "string" then
            return;
        end;

        playTypewriter(table_remove_ret, p125);

        return;
    end;

    local v131 = nil;

    while v127 == u15 do
        local v132 = u28;

        if not (v132 and v132.IsPlaying) then
            break;
        end;

        local TimeLength = v132.TimeLength;
        local v133;

        if TimeLength <= 0 then
            v133 = false;
        else
            if v132.PlaybackRegionsEnabled then
                TimeLength = math.min(v132.PlaybackRegion.Max, TimeLength);
            end;

            if TimeLength - v132.TimePosition <= 0.8 then
                v133 = v132.PlaybackLoudness <= 6;
            else
                v133 = false;
            end;
        end;

        if v133 then
            v131 = v131 or os.clock();

            if os.clock() - v131 >= 0.2 then
                break;
            end;
        else
            v131 = nil;
        end;

        task.wait(0.03);
    end;

    if v127 ~= u15 then
        return;
    end;

    if #u25 > 0 then
        u114();

        return;
    end;

    finishCommander(v127);
end;

u114 = function() -- Line: 718
    -- upvalues: u25 (copy), u26 (ref), resolveCommanderLine (copy), u15 (ref), u21 (ref), u28 (ref), u29 (ref), u30 (ref), playTypewriter (copy), createVoiceSound (copy), waitForVoiceSound (copy)
    local table_remove_ret = table.remove(u25, 1);

    if typeof(table_remove_ret) ~= "string" or table_remove_ret == "" then
        return;
    end;

    u26 = table_remove_ret;
    local v134, v135, v136 = resolveCommanderLine(table_remove_ret);
    local table_remove_ret2 = table.remove(v134, 1);

    if typeof(table_remove_ret2) ~= "string" then
        return;
    end;

    u15 = u15 + 1;
    local v137 = u15;
    u21 = true;
    local v138 = u28;
    u28 = nil;

    if v138 then
        v138:Stop();
        v138:Destroy();
    end;

    if u29 and not u30 then
        u29:Stop();
    end;

    local v139 = os.clock() + 6;

    while u29 and (u29.IsPlaying and os.clock() < v139) do
        task.wait(0.05);
    end;

    if v137 ~= u15 then
        return;
    end;

    if typeof(v135) ~= "string" or v135 == "" then
        playTypewriter(table_remove_ret2, v134);

        return;
    end;

    local u140 = createVoiceSound(v135, v136);
    waitForVoiceSound(u140);

    if v137 ~= u15 then
        u140:Destroy();

        return;
    end;

    u28 = u140;
    u140:Play();
    u140.Ended:Once(function() -- Line: 765
        -- upvalues: u28 (ref), u140 (copy)
        if u28 == u140 then
            u28 = nil;
            u140:Destroy();
        end;
    end);
    playTypewriter(table_remove_ret2, v134);
end;

u48 = function() -- Line: 775
    -- upvalues: u21 (ref), shouldShowDialogue (copy), u28 (ref), u15 (ref), u25 (copy), u114 (ref), u26 (ref), u11 (ref), u22 (ref), u23 (ref), Remotes (copy), u19 (ref), u12 (ref), u17 (ref), u115 (ref), u5 (ref), u10 (copy), updateSkipHint (copy), u3 (ref), u2 (ref), u31 (ref)
    if not (u21 and shouldShowDialogue()) then
        return;
    end;

    local v141 = u28;
    u28 = nil;

    if v141 then
        v141:Stop();
        v141:Destroy();
    end;

    u15 = u15 + 1;

    if #u25 > 0 then
        task.spawn(u114);

        return;
    end;

    u26 = nil;
    u21 = false;
    u11 = false;

    if u22 > u23 then
        u23 = u22;
        Remotes.Tutorial.ClientEvent.Send((`CommanderIdle:{u22}`));
    end;

    if not u19 then
        if u12 then
            return;
        end;

        if u17 and shouldShowDialogue() then
            u115(false);

            return;
        end;

        u5 = "Hidden";

        for _, v in u10 do
            v:Cancel();
        end;

        table.clear(u10);
        updateSkipHint();

        if u3 then
            u3.Visible = false;
        end;

        local v142 = u2;

        if v142 then
            v142 = v142:FindFirstChild("Gameplay");
        end;

        local v143;

        if v142 then
            v143 = v142:FindFirstChild("Middle");
        else
            v143 = nil;
        end;

        if v143 then
            v143 = v143:FindFirstChild("Notification");
        end;

        if v143 then
            if not v143:IsA("GuiObject") then
                return;
            end;

            local v144 = u31 or v143.Position;
            u31 = v144;
            v143.Position = v144;
        end;
    end;
end;

local function flashObjective() -- Line: 793
    -- upvalues: u4 (ref), Color3_fromRGB_ret2 (copy), TweenService (copy), Color3_fromRGB_ret (ref), u10 (copy)
    local v145 = u4;

    if not v145 then
        return;
    end;

    local TweenInfo_new_ret = TweenInfo.new(1.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out);
    v145.TextColor3 = Color3_fromRGB_ret2;
    local v146 = TweenService:Create(v145, TweenInfo_new_ret, {
        TextColor3 = Color3_fromRGB_ret
    });
    table.insert(u10, v146);
    v146:Play();
end;

local function typeObjective(p147: string) -- Line: 805
    -- upvalues: u4 (ref), u16 (ref), flashObjective (copy), u5 (ref)
    local v148 = u4;

    if not v148 then
        return;
    end;

    u16 = u16 + 1;
    local v149 = u16;
    v148.Text = p147;
    v148.MaxVisibleGraphemes = 0;
    flashObjective();
    local success, result = pcall(utf8.len, p147);

    for i = 1, (not success or typeof(result) ~= "number") and #p147 or result do
        if v149 ~= u16 or u5 ~= "Objective" then
            return;
        end;

        v148.MaxVisibleGraphemes = i;
        task.wait(0.0175);
        local _ = i;
    end;

    if v149 == u16 and u5 == "Objective" then
        v148.MaxVisibleGraphemes = -1;
    end;
end;

u115 = function(p150: boolean) -- Line: 828
    -- upvalues: u17 (ref), u4 (ref), u19 (ref), u21 (ref), u11 (ref), u12 (ref), shouldShowDialogue (copy), setMode (copy), hideDialogue (copy), u3 (ref), u2 (ref), UDim2_fromScale_ret (copy), UDim2_fromScale_ret2 (copy), liftNotifications (copy), typeObjective (copy), u16 (ref)
    local v151 = u17;
    local v152 = u4;

    if not (v151 and (v152 and not (u19 or (u21 or (u11 or u12))))) then
        return;
    end;

    if not shouldShowDialogue() then
        return;
    end;

    setMode("Objective");

    if shouldShowDialogue() then
        if u3 then
            local v153 = u2;

            if v153 then
                v153 = v153:FindFirstChild("Gameplay");
            end;

            local v154;

            if v153 then
                v154 = v153:FindFirstChild("Middle");
            else
                v154 = nil;
            end;

            if v154 then
                v154 = v154:FindFirstChild("BuyMenu");
            end;

            if not (v154 and v154:IsA("GuiObject")) then
                v154 = nil;
            end;

            local v155;

            if v154 and v154.Visible then
                v155 = UDim2_fromScale_ret + UDim2_fromScale_ret2;
            else
                v155 = UDim2_fromScale_ret;
            end;

            u3.Position = v155;
            u3.Visible = true;
            liftNotifications(true);
        end;
    else
        hideDialogue();
    end;

    if p150 then
        task.spawn(typeObjective, v151);

        return;
    end;

    u16 = u16 + 1;
    v152.Text = v151;
    v152.MaxVisibleGraphemes = -1;
end;

local function isCommanderBusy() -- Line: 849
    -- upvalues: LocalPlayer (copy), u21 (ref), u11 (ref), u12 (ref), u25 (copy), u22 (ref)
    local Attribute = LocalPlayer:GetAttribute("TutorialCommanderId");
    local v156 = u21 or (u11 or u12);

    if not v156 then
        if #u25 > 0 then
            v156 = true;
        elseif typeof(Attribute) == "number" then
            v156 = Attribute ~= u22;
        else
            v156 = false;
        end;
    end;

    return v156;
end;

local function showTip(p157: string) -- Line: 859
    -- upvalues: u4 (ref), u21 (ref), shouldShowDialogue (copy), u13 (ref), u12 (ref), u16 (ref), setMode (copy), hideDialogue (copy), u3 (ref), u2 (ref), UDim2_fromScale_ret (copy), UDim2_fromScale_ret2 (copy), liftNotifications (copy), u19 (ref), u17 (ref), u115 (ref), u5 (ref), u10 (copy), updateSkipHint (copy), u31 (ref)
    local v158 = u4;

    if not (v158 and (not u21 and shouldShowDialogue())) then
        return;
    end;

    u13 = u13 + 1;
    local v159 = u13;
    u12 = true;
    u16 = u16 + 1;
    setMode("Commander");

    if shouldShowDialogue() then
        if u3 then
            local v160 = u2;

            if v160 then
                v160 = v160:FindFirstChild("Gameplay");
            end;

            local v161;

            if v160 then
                v161 = v160:FindFirstChild("Middle");
            else
                v161 = nil;
            end;

            if v161 then
                v161 = v161:FindFirstChild("BuyMenu");
            end;

            if not (v161 and v161:IsA("GuiObject")) then
                v161 = nil;
            end;

            local v162;

            if v161 and v161.Visible then
                v162 = UDim2_fromScale_ret + UDim2_fromScale_ret2;
            else
                v162 = UDim2_fromScale_ret;
            end;

            u3.Position = v162;
            u3.Visible = true;
            liftNotifications(true);
        end;
    else
        hideDialogue();
    end;

    v158.Text = p157;
    v158.MaxVisibleGraphemes = 0;
    local os_clock_ret = os.clock();
    local success, result = pcall(utf8.len, p157);

    for i = 1, (not success or typeof(result) ~= "number") and #p157 or result do
        if v159 ~= u13 then
            return;
        end;

        v158.MaxVisibleGraphemes = i;
        task.wait(0.035);
        local _ = i;
    end;

    if v159 ~= u13 then
        return;
    end;

    v158.MaxVisibleGraphemes = -1;
    local task_wait = task.wait;
    local v163 = 4 - (os.clock() - os_clock_ret);
    task_wait((math.max(v163, 0)));

    if v159 == u13 then
        u12 = false;

        if not u19 then
            if u12 then
                return;
            end;

            if u17 and shouldShowDialogue() then
                u115(false);

                return;
            end;

            u5 = "Hidden";

            for _, v in u10 do
                v:Cancel();
            end;

            table.clear(u10);
            updateSkipHint();

            if u3 then
                u3.Visible = false;
            end;

            local v164 = u2;

            if v164 then
                v164 = v164:FindFirstChild("Gameplay");
            end;

            local v165;

            if v164 then
                v165 = v164:FindFirstChild("Middle");
            else
                v165 = nil;
            end;

            if v165 then
                v165 = v165:FindFirstChild("Notification");
            end;

            if v165 then
                if not v165:IsA("GuiObject") then
                    return;
                end;

                local v166 = u31 or v165.Position;
                u31 = v166;
                v165.Position = v166;
            end;
        end;
    end;
end;

local function holdObjective() -- Line: 892
    -- upvalues: u19 (ref), u20 (ref), u16 (ref), u5 (ref), u10 (copy), updateSkipHint (copy), u3 (ref), u2 (ref), u31 (ref), LocalPlayer (copy), u21 (ref), u11 (ref), u12 (ref), u25 (copy), u22 (ref), u115 (ref)
    u19 = true;
    u20 = u20 + 1;
    local u167 = u20;
    u16 = u16 + 1;

    if u5 == "Objective" then
        u5 = "Hidden";

        for _, v in u10 do
            v:Cancel();
        end;

        table.clear(u10);
        updateSkipHint();

        if u3 then
            u3.Visible = false;
        end;

        local v168 = u2;

        if v168 then
            v168 = v168:FindFirstChild("Gameplay");
        end;

        local v169;

        if v168 then
            v169 = v168:FindFirstChild("Middle");
        else
            v169 = nil;
        end;

        if v169 then
            v169 = v169:FindFirstChild("Notification");
        end;

        if v169 and v169:IsA("GuiObject") then
            local v170 = u31 or v169.Position;
            u31 = v170;
            v169.Position = v170;
        end;
    end;

    local os_clock_ret = os.clock();
    task.spawn(function() -- Line: 902
        -- upvalues: u167 (copy), u20 (ref), LocalPlayer (ref), u21 (ref), u11 (ref), u12 (ref), u25 (ref), u22 (ref), os_clock_ret (copy), u19 (ref), u115 (ref)
        task.wait(0.3);

        while u167 == u20 do
            local Attribute = LocalPlayer:GetAttribute("TutorialCommanderId");
            local v171 = u21 or (u11 or u12);

            if not v171 then
                if #u25 > 0 then
                    v171 = true;
                elseif typeof(Attribute) == "number" then
                    v171 = Attribute ~= u22;
                else
                    v171 = false;
                end;
            end;

            if not v171 or os.clock() - os_clock_ret > 45 then
                u19 = false;
                u115(true);

                return;
            end;

            task.wait(0.1);
        end;
    end);
end;

local function syncObjective() -- Line: 916
    -- upvalues: shouldShowDialogue (copy), hideDialogue (copy), bindDialogue (copy), u3 (ref), LocalPlayer (copy), u16 (ref), u20 (ref), u19 (ref), u17 (ref), u18 (ref), u5 (ref), u10 (copy), updateSkipHint (copy), u2 (ref), u31 (ref), u115 (ref), holdObjective (copy)
    if not shouldShowDialogue() then
        hideDialogue();

        return;
    end;

    if not bindDialogue(u3) then
        return;
    end;

    local Attribute = LocalPlayer:GetAttribute("TutorialObjective");
    local Attribute2 = LocalPlayer:GetAttribute("TutorialStep");

    if typeof(Attribute) ~= "string" or Attribute == "" then
        u16 = u16 + 1;
        u20 = u20 + 1;
        u19 = false;
        u17 = nil;
        u18 = nil;

        if u5 == "Objective" then
            u5 = "Hidden";

            for _, v in u10 do
                v:Cancel();
            end;

            table.clear(u10);
            updateSkipHint();

            if u3 then
                u3.Visible = false;
            end;

            local v172 = u2;

            if v172 then
                v172 = v172:FindFirstChild("Gameplay");
            end;

            local v173;

            if v172 then
                v173 = v172:FindFirstChild("Middle");
            else
                v173 = nil;
            end;

            if v173 then
                v173 = v173:FindFirstChild("Notification");
            end;

            if v173 then
                if not v173:IsA("GuiObject") then
                    return;
                end;

                local v174 = u31 or v173.Position;
                u31 = v174;
                v173.Position = v174;
            end;
        end;

        return;
    end;

    local v175 = typeof(Attribute2) ~= "string" and "" or Attribute2;

    if Attribute == u17 then
        if u5 == "Hidden" then
            u115(false);
        end;

        return;
    end;

    local v176 = v175 ~= u18;
    local v177 = string.gsub(Attribute, "%d", "") ~= string.gsub(u17 or "", "%d", "");
    u17 = Attribute;
    u18 = v175;

    if v176 then
        holdObjective();

        return;
    end;

    if u19 or u5 == "Commander" then
        return;
    end;

    u115(v177);
end;

u116 = function() -- Line: 957
    -- upvalues: LocalPlayer (copy), u21 (ref), u25 (copy), u12 (ref), u17 (ref), u18 (ref), u11 (ref), u14 (ref), u19 (ref), u20 (ref), u115 (ref)
    local Attribute = LocalPlayer:GetAttribute("TutorialObjective");
    local Attribute2 = LocalPlayer:GetAttribute("TutorialStep");

    if typeof(Attribute) ~= "string" or (Attribute == "" or (u21 or (#u25 > 0 or u12))) then
        return;
    end;

    u17 = Attribute;
    u18 = typeof(Attribute2) ~= "string" and "" or Attribute2;
    u11 = false;
    u14 = u14 + 1;
    u19 = false;
    u20 = u20 + 1;
    u115(true);
end;

local u178 = false;
local u179 = nil;

local function scheduleCommanderRetry() -- Line: 985
    -- upvalues: u178 (ref), LocalPlayer (copy), u22 (ref), shouldShowDialogue (copy), u179 (ref)
    if u178 then
        return;
    end;

    local Attribute = LocalPlayer:GetAttribute("TutorialCommanderId");

    if typeof(Attribute) ~= "number" or Attribute == u22 then
        return;
    end;

    u178 = true;
    task.spawn(function() -- Line: 995
        -- upvalues: LocalPlayer (ref), u22 (ref), shouldShowDialogue (ref), u178 (ref), u179 (ref)
        local v180 = os.clock() + 30;

        while os.clock() < v180 do
            task.wait(0.25);
            local Attribute2 = LocalPlayer:GetAttribute("TutorialCommanderId");

            if typeof(Attribute2) ~= "number" or Attribute2 == u22 then
                break;
            end;

            if shouldShowDialogue() then
                u178 = false;
                u179();

                return;
            end;
        end;

        u178 = false;
    end);
end;

u179 = function() -- Line: 1018
    -- upvalues: shouldShowDialogue (copy), hideDialogue (copy), scheduleCommanderRetry (copy), LocalPlayer (copy), u22 (ref), u27 (ref), u21 (ref), u25 (copy), u114 (ref)
    if not shouldShowDialogue() then
        hideDialogue();
        scheduleCommanderRetry();

        return;
    end;

    local Attribute = LocalPlayer:GetAttribute("TutorialCommander");
    local Attribute2 = LocalPlayer:GetAttribute("TutorialCommanderId");
    local v181;

    if typeof(Attribute) == "string" and (Attribute ~= "" and typeof(Attribute2) == "number") then
        v181 = Attribute2 ~= u22;
    else
        v181 = false;
    end;

    if not v181 then
        local v182 = u27;

        if v182 and not u21 then
            u27 = nil;
            table.move(v182, 1, #v182, #u25 + 1, u25);
            task.spawn(u114);
        end;

        return;
    end;

    u27 = nil;
    u22 = Attribute2;
    table.clear(u25);

    for _, v in string.split(Attribute, "\n") do
        if v ~= "" then
            table.insert(u25, v);
        end;
    end;

    if not u21 then
        task.spawn(u114);
    end;
end;

local function syncCommanderVoice() -- Line: 1059
    -- upvalues: LocalPlayer (copy), u24 (ref), shouldShowDialogue (copy), u21 (ref), u25 (copy), u29 (ref), u30 (ref), resolveCommanderLine (copy), showTip (copy), u116 (ref), createVoiceSound (copy)
    local Attribute = LocalPlayer:GetAttribute("TutorialCommanderVoice");
    local Attribute2 = LocalPlayer:GetAttribute("TutorialCommanderVoiceId");

    if typeof(Attribute) ~= "string" or Attribute == "" then
        return;
    end;

    if typeof(Attribute2) ~= "number" or Attribute2 == u24 then
        return;
    end;

    if not shouldShowDialogue() then
        return;
    end;

    u24 = Attribute2;
    local Attribute3 = LocalPlayer:GetAttribute("TutorialCommanderVoiceStep");
    local v183 = LocalPlayer:GetAttribute("TutorialCommanderVoicePriority") == true;

    if u21 or #u25 > 0 then
        if not v183 then
            return;
        end;

        local v184 = os.clock() + 30;

        while u21 or #u25 > 0 do
            if u24 ~= Attribute2 or v184 <= os.clock() then
                return;
            end;

            task.wait(0.05);
        end;

        if not shouldShowDialogue() then
            return;
        end;
    end;

    if typeof(Attribute3) == "string" and LocalPlayer:GetAttribute("TutorialStep") ~= Attribute3 then
        return;
    end;

    if not v183 and (u29 and u30) then
        return;
    end;

    local v185, v186, v187 = resolveCommanderLine(Attribute);

    if not v186 then
        return;
    end;

    if v183 then
        local table_concat_ret = table.concat(v185, " ");
        local Attribute4 = LocalPlayer:GetAttribute("TutorialObjective");

        local function bare(p188: string) -- Line: 1118
            return string.gsub(string.lower(p188), "[^%w]", "");
        end;

        if typeof(Attribute4) == "string" and string.gsub(string.lower(Attribute4), "[^%w]", "") == string.gsub(string.lower(table_concat_ret), "[^%w]", "") then
            u116();
        else
            task.spawn(showTip, table_concat_ret);
        end;
    end;

    local v189 = u29;
    u29 = nil;
    u30 = false;

    if v189 then
        v189:Stop();
        v189:Destroy();
    end;

    local u190 = createVoiceSound(v186, v187);
    u190:Play();
    u29 = u190;
    u30 = v183;

    local function release() -- Line: 1142
        -- upvalues: u29 (ref), u190 (copy), u30 (ref)
        if u29 == u190 then
            u29 = nil;
            u30 = false;
            u190:Destroy();
        end;
    end;

    u190.Ended:Once(release);
    u190.Stopped:Once(release);

    if v183 then
        task.delay(15, function() -- Line: 1156
            -- upvalues: u29 (ref), u190 (copy), u30 (ref)
            if u29 == u190 then
                u30 = false;
            end;
        end);
    end;
end;

local function syncDialogue() -- Line: 1168
    -- upvalues: IsTutorialMode (copy), preloadVoices (copy), u179 (ref), syncObjective (copy), syncCommanderVoice (copy)
    if IsTutorialMode() then
        preloadVoices();
    end;

    u179();
    syncObjective();
    task.spawn(syncCommanderVoice);
end;

function v1.Initialize(p191: userdata, p192: userdata) -- Line: 1179
    -- upvalues: u2 (ref), bindDialogue (copy), u3 (ref), setMode (copy), u5 (ref), u4 (ref)
    u2 = p191;
    bindDialogue(p192);

    if u3 then
        u3.Visible = false;
        setMode("Commander");
        u5 = "Hidden";
    end;

    if u4 then
        u4.Text = "";
        u4.MaxVisibleGraphemes = 0;
    end;

    local v193 = u3 and u3.Parent and u3.Parent:FindFirstChild("TutorialObjective");

    if v193 then
        v193:Destroy();
    end;
end;

function v1.Start() -- Line: 1198
    -- upvalues: bindDialogue (copy), u3 (ref), u4 (ref), LocalPlayer (copy), syncObjective (copy), updateSkipHint (copy), u179 (ref), syncCommanderVoice (copy), syncDialogue (copy), IsTutorialMode (copy), Router (copy), GameState (copy), preloadVoices (copy), u2 (ref), hideDialogue (copy), UDim2_fromScale_ret (copy), UDim2_fromScale_ret2 (copy), liftNotifications (copy), u48 (ref), UserInputService (copy)
    bindDialogue(u3);

    if not (u3 and u4) then
        return;
    end;

    LocalPlayer:GetAttributeChangedSignal("TutorialObjective"):Connect(syncObjective);
    LocalPlayer:GetAttributeChangedSignal("TutorialStep"):Connect(syncObjective);
    LocalPlayer:GetAttributeChangedSignal("TutorialStep"):Connect(updateSkipHint);
    LocalPlayer:GetAttributeChangedSignal("TutorialCommander"):Connect(u179);
    LocalPlayer:GetAttributeChangedSignal("TutorialCommanderId"):Connect(u179);
    LocalPlayer:GetAttributeChangedSignal("TutorialCommanderVoice"):Connect(syncCommanderVoice);
    LocalPlayer:GetAttributeChangedSignal("TutorialCommanderVoiceId"):Connect(syncCommanderVoice);
    LocalPlayer:GetAttributeChangedSignal("Team"):Connect(syncDialogue);
    local Attribute = LocalPlayer:GetAttribute("Team");
    LocalPlayer:GetAttributeChangedSignal("Team"):Connect(function() -- Line: 1216
        -- upvalues: LocalPlayer (ref), IsTutorialMode (ref), Attribute (ref), Router (ref)
        local Attribute2 = LocalPlayer:GetAttribute("Team");

        if IsTutorialMode() and (Attribute == "Terrorists" and Attribute2 == "Counter-Terrorists") then
            Router.broadcastRouter(
                "CreateNotification",
                "Team Changed",
                "You are now a Counter-Terrorist. The players in this room are your teammates",
                6
            );
        end;

        Attribute = Attribute2;
    end);
    workspace:GetAttributeChangedSignal("ServerGamemode"):Connect(syncDialogue);
    workspace:GetAttributeChangedSignal("Gamemode"):Connect(syncDialogue);
    workspace:GetAttributeChangedSignal("TutorialActive"):Connect(syncDialogue);
    GameState.ListenToState(function() -- Line: 1226
        -- upvalues: IsTutorialMode (ref), preloadVoices (ref), u179 (ref), syncObjective (ref), syncCommanderVoice (ref)
        if IsTutorialMode() then
            preloadVoices();
        end;

        u179();
        syncObjective();
        task.spawn(syncCommanderVoice);
    end);
    local u194 = u2 and u2:FindFirstChild("Menu");

    if u194 and u194:IsA("GuiObject") then
        u194:GetPropertyChangedSignal("Visible"):Connect(function() -- Line: 1232
            -- upvalues: u194 (copy), hideDialogue (ref), IsTutorialMode (ref), preloadVoices (ref), u179 (ref), syncObjective (ref), syncCommanderVoice (ref)
            if u194.Visible then
                hideDialogue();

                return;
            end;

            if IsTutorialMode() then
                preloadVoices();
            end;

            u179();
            syncObjective();
            task.spawn(syncCommanderVoice);
        end);
    end;

    local v195 = u2;

    if v195 then
        v195 = v195:FindFirstChild("Gameplay");
    end;

    local v196;

    if v195 then
        v196 = v195:FindFirstChild("Middle");
    else
        v196 = nil;
    end;

    if v196 then
        v196 = v196:FindFirstChild("BuyMenu");
    end;

    if not (v196 and v196:IsA("GuiObject")) then
        v196 = nil;
    end;

    if v196 then
        v196:GetPropertyChangedSignal("Visible"):Connect(function() -- Line: 1244
            -- upvalues: u3 (ref), u2 (ref), UDim2_fromScale_ret (ref), UDim2_fromScale_ret2 (ref), liftNotifications (ref)
            if u3 and u3.Visible then
                local v197 = u2;

                if v197 then
                    v197 = v197:FindFirstChild("Gameplay");
                end;

                local v198;

                if v197 then
                    v198 = v197:FindFirstChild("Middle");
                else
                    v198 = nil;
                end;

                if v198 then
                    v198 = v198:FindFirstChild("BuyMenu");
                end;

                if not (v198 and v198:IsA("GuiObject")) then
                    v198 = nil;
                end;

                local v199;

                if v198 and v198.Visible then
                    v199 = UDim2_fromScale_ret + UDim2_fromScale_ret2;
                else
                    v199 = UDim2_fromScale_ret;
                end;

                u3.Position = v199;
                liftNotifications(true);
            end;
        end);
    end;

    local u200 = u2 and u2:FindFirstChild("Gameplay");

    if u200 and u200:IsA("GuiObject") then
        u200:GetPropertyChangedSignal("Visible"):Connect(function() -- Line: 1254
            -- upvalues: u200 (copy), hideDialogue (ref), IsTutorialMode (ref), preloadVoices (ref), u179 (ref), syncObjective (ref), syncCommanderVoice (ref)
            if not u200.Visible then
                hideDialogue();

                return;
            end;

            if IsTutorialMode() then
                preloadVoices();
            end;

            u179();
            syncObjective();
            task.spawn(syncCommanderVoice);
        end);
    end;

    u3.InputBegan:Connect(function(p201) -- Line: 1264
        -- upvalues: LocalPlayer (ref), u48 (ref)
        if p201.UserInputType ~= Enum.UserInputType.Touch then
            return;
        end;

        if LocalPlayer:GetAttribute("TutorialStep") == "DefuseB" then
            return;
        end;

        u48();
    end);
    UserInputService.LastInputTypeChanged:Connect(updateSkipHint);
    UserInputService:GetPropertyChangedSignal("PreferredInput"):Connect(updateSkipHint);

    if IsTutorialMode() then
        preloadVoices();
    end;

    u179();
    syncObjective();
    task.spawn(syncCommanderVoice);
end;

return v1;