-- ReplicatedStorage.GameClient.Gui.MainMenu.Utils.Inspect
-- Script path: ReplicatedStorage.GameClient.Gui.MainMenu.Utils.Inspect
-- Decompile time: 94.56 ms

-- Decompiled with Potassium's decompiler.

local u1 = {};
local TweenService = game:GetService("TweenService");
local TextService = game:GetService("TextService");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Workspace = game:GetService("Workspace");
local Players = game:GetService("Players");
local RunService = game:GetService("RunService");
local UserInputService = game:GetService("UserInputService");
local Lighting = game:GetService("Lighting");
local u2 = nil;
local u3 = nil;
local u4 = nil;
local u5 = nil;
local u6 = nil;
local u7 = nil;
local u8 = nil;
local u9 = nil;
local u10 = nil;
local u11 = nil;
local u12 = nil;
local u13 = nil;
local u14 = nil;
local u15 = nil;
local u16 = nil;
local u17 = nil;
local u18 = nil;
local u19 = nil;
local u20 = nil;
local u21 = nil;
local u22 = nil;
local u23 = nil;
local TweenInfo_new_ret = TweenInfo.new(0.25);
TweenInfo.new(0.5);
local u24 = nil;
local LocalPlayer = Players.LocalPlayer;
local _ = workspace.CurrentCamera;
local u25 = nil;
local u26 = false;
local u27 = false;
local u28 = false;
local u29 = false;
local u30 = false;
local u31 = nil;
local u32 = nil;
local u33 = setmetatable({}, {
    __mode = "k"
});
local u34 = nil;
local u35 = 0;
local u36 = nil;
local u37 = 0;
local u38 = false;
local Assets = ReplicatedStorage.Assets;
local Idle = Assets.Idle;
local KillTrack = Assets:WaitForChild("KillTrack");
local u39 = {};
local u40 = nil;
local u41 = nil;
local u42 = nil;
local u43 = {};
local u44 = nil;
local u45 = 2;
local u46 = nil;
local u47 = nil;
local u48 = {};
Color3.fromRGB(207, 106, 50);
local u49 = nil;
local u50 = nil;
local u51 = nil;
local u52 = nil;
local u53 = nil;
local u54 = nil;
local u55 = {};
local u56 = nil;
local u57 = {};
local u58 = nil;
local TweenInfo_new_ret2 = TweenInfo.new(0.6, Enum.EasingStyle.Quint, Enum.EasingDirection.Out);
local u59 = {
    [Enum.NormalId.Front] = Enum.NormalId.Back,
    [Enum.NormalId.Back] = Enum.NormalId.Front,
    [Enum.NormalId.Left] = Enum.NormalId.Right,
    [Enum.NormalId.Right] = Enum.NormalId.Left,
    [Enum.NormalId.Top] = Enum.NormalId.Bottom,
    [Enum.NormalId.Bottom] = Enum.NormalId.Top
};

local function getModelCenter(p60: userdata) -- Line: 112
    local BoundingBox, _ = p60:GetBoundingBox();

    return BoundingBox;
end;

local function ResetRigNeck(p61) -- Line: 117
    if not p61 then
        return;
    end;

    local Rig = p61:FindFirstChild("Rig");

    if Rig then
        Rig = Rig:FindFirstChild("Rig");
    end;

    if Rig then
        Rig = Rig:FindFirstChild("Torso");
    end;

    if Rig then
        Rig = Rig:FindFirstChild("Neck");
    end;

    if not Rig then
        return;
    end;

    Rig.C0 = Rig:GetAttribute("OriginalC0") or CFrame.new(0, 1, 0, -1, 0, 0, 0, 0, 1, 0, 1, 0);
end;

local function ProjectSticker(p62: userdata, p63: table, p64: any, p65: string, p66: number) -- Line: 135
    -- upvalues: u18 (ref), u15 (ref), u39 (copy)
    local v67 = {};

    for _, v in u18.ProjectSticker(p63, p64, u15.GetItem("Stickers", p65), p66) do
        if p62.Parent then
            v.meshPart.Parent = p62;
            table.insert(u39, v);
            table.insert(v67, v.meshPart);
        else
            v.meshPart:Destroy();
            v.editableMesh:Destroy();
        end;
    end;

    return v67;
end;

local function ClearStickers() -- Line: 153
    -- upvalues: u39 (copy)
    for _, v in u39 do
        v.editableMesh:Destroy();
    end;

    table.clear(u39);
end;

local function StageExtent(p68: userdata, p69: table) -- Line: 161
    if not p69[p68] then
        local v70 = Vector3.new(1, 1, 1) * (1 / 0);
        local v71 = Vector3.new(-1, -1, -1) * (1 / 0);

        for _, v in p68:QueryDescendants("BasePart") do
            v70 = v70:Min(v.Position);
            v71 = v71:Max(v.Position);
        end;

        p69[p68] = (v71 - v70).Magnitude;
    end;

    return p69[p68];
end;

local function StageOwner(p72: userdata, p73: userdata, p74: table) -- Line: 175
    -- upvalues: StageExtent (copy)
    local Parent = p72.Parent;

    while Parent ~= p73 and StageExtent(Parent, p74) < 12 do
        p72 = Parent;
        Parent = Parent.Parent;
    end;

    return p72;
end;

local function StageTrack(p75: userdata, p76: string, p77: boolean) -- Line: 185
    local Animation = Instance.new("Animation");
    Animation.AnimationId = p76;
    local v78 = p75:LoadAnimation(Animation);
    v78.Priority = Enum.AnimationPriority.Action;
    v78.Looped = p77;

    return v78;
end;

local function StageAgent(p79: string) -- Line: 196
    -- upvalues: u23 (ref)
    local v80 = u23.GetLoadoutData()[p79]["15"];

    return v80 and v80.SkinName or `{p79} Agent`;
end;

local function StageWeapons(p81: string) -- Line: 202
    -- upvalues: u23 (ref), u22 (ref), u7 (ref)
    local v82 = u23.GetLoadoutData()[p81];
    local v83 = {};
    local v84 = {};

    for i = 0, 14 do
        local v85 = v82[tostring(i)];
        local v86;

        if u22.AnimationIds[u22.GetWeaponClass(v85.WeaponName)] then
            local v87 = u7.Get(v85.WeaponName).DisplayName or v85.WeaponName;
            table.insert(v83, v87);
            v84[v87] = v85;
            v86 = i;
        else
            v86 = i;
        end;
    end;

    return v83, v84;
end;

local function SetPicker(p88: string, p89: table, p90: string, p91: function) -- Line: 220
    -- upvalues: u4 (ref), u57 (copy), u58 (ref), u56 (ref)
    local Picker = u4.Main.DownBar.LeftHolder.Picker;
    table.clear(u57);
    table.move(p89, 1, #p89, 1, u57);
    u58 = p91;
    Picker.TextLabel.Text = p88;
    u56.SetValue(p90, true);
    Picker.Visible = #p89 > 1;
end;

local function PoseStage(p92: string, p93: string) -- Line: 232
    -- upvalues: u52 (ref), u22 (ref)
    local Animator = u52.Rig.Humanoid.Animator;
    local v94 = u22.AnimationIds[u22.GetWeaponClass(p92)];
    u22.AddWeapon(u52.Rig, p92, p93);

    for _, v in Animator:GetPlayingAnimationTracks() do
        v:Stop(0.3);
    end;

    local Match_End_Begin = v94.Match_End_Begin;
    local Animation = Instance.new("Animation");
    Animation.AnimationId = Match_End_Begin;
    local u95 = Animator:LoadAnimation(Animation);
    u95.Priority = Enum.AnimationPriority.Action;
    u95.Looped = false;
    local Match_End_Idle = v94.Match_End_Idle;
    local Animation2 = Instance.new("Animation");
    Animation2.AnimationId = Match_End_Idle;
    local u96 = Animator:LoadAnimation(Animation2);
    u96.Priority = Enum.AnimationPriority.Action;
    u96.Looped = true;
    u52.Begin = u95;
    u95:Play(0.3);
    u95.Stopped:Once(function() -- Line: 248
        -- upvalues: u52 (ref), u95 (copy), u96 (copy)
        if u52 and u52.Begin == u95 then
            u96:Play(0.3);
        end;
    end);
end;

local function ClearStage() -- Line: 255
    -- upvalues: u52 (ref)
    if not u52 then
        return;
    end;

    for i in u52.Hidden do
        i.LocalTransparencyModifier = 0;
    end;

    u52.Rig:Destroy();
    u52 = nil;
end;

local function TweenStage(p97: userdata, p98, p99: number) -- Line: 268
    -- upvalues: u55 (ref), TweenService (copy), TweenInfo_new_ret2 (copy), Lighting (copy)
    for _, v in u55 do
        v:Cancel();
    end;

    u55 = { TweenService:Create(p97, TweenInfo_new_ret2, {
            CFrame = p98
        }), TweenService:Create(Lighting["1"], TweenInfo_new_ret2, {
            FocusDistance = p99
        }) };

    for _, v in u55 do
        v:Play();
    end;
end;

local function CloseStage(p100: boolean?) -- Line: 283
    -- upvalues: u4 (ref), u9 (ref), u52 (ref), u55 (ref), u53 (ref), Workspace (copy), Lighting (copy), u54 (ref), TweenStage (copy)
    local Picker = u4.Main.DownBar.LeftHolder.Picker;
    u9.DropDeactive(Picker.DownHold);
    Picker.Visible = false;

    if not u52 then
        return;
    end;

    if p100 then
        for _, v in u55 do
            v:Cancel();
        end;

        u52.Camera.CFrame = u53;
        Workspace.CurrentCamera.CFrame = u53;
        Lighting["1"].FocusDistance = u54;
    else
        TweenStage(u52.Camera, u53, u54);
    end;

    if not u52 then
        return;
    end;

    for i in u52.Hidden do
        i.LocalTransparencyModifier = 0;
    end;

    u52.Rig:Destroy();
    u52 = nil;
end;

local function OpenStage(u101: userdata, p102: string, p103: string, p104: string, p105: string) -- Line: 308
    -- upvalues: u52 (ref), u53 (ref), u2 (ref), u54 (ref), Lighting (copy), Workspace (copy), StageOwner (copy), u23 (ref), u22 (ref), TweenStage (copy), PoseStage (copy)
    if u52 then
        for i in u52.Hidden do
            i.LocalTransparencyModifier = 0;
        end;

        u52.Rig:Destroy();
        u52 = nil;
    end;

    u53 = u53 or u2.GetComponent("MainMenu").GetCameraCFrame();
    u54 = u54 or Lighting["1"].FocusDistance;
    local u106 = u53;
    local Unit = (u106.LookVector * Vector3.new(1, 0, 1)).Unit;
    local Position = u101.Root.Position;
    local OverlapParams_new_ret = OverlapParams.new();
    OverlapParams_new_ret.FilterType = Enum.RaycastFilterType.Include;
    OverlapParams_new_ret.FilterDescendantsInstances = { u101 };
    local u107 = {};
    local u108 = {};

    local function Clear(p109: number, p110: number, p111: number) -- Line: 325
        -- upvalues: Position (copy), u106 (copy), Unit (copy), Workspace (ref), OverlapParams_new_ret (copy), u107 (copy), StageOwner (ref), u101 (copy), u108 (copy)
        local v112 = Position.Y + 1 - p109;
        local v113 = Vector3.new(u106.X, p109 + v112 / 2, u106.Z) + Unit * 6.25;

        for _, v in Workspace:GetPartBoundsInBox(CFrame.lookAt(v113, v113 + Unit), Vector3.new(p110, v112, 12.5), OverlapParams_new_ret) do
            if v.Size.Magnitude <= 8 or v.Position.Y - v.Size.Y / 2 >= p111 + 0.5 then
                u107[StageOwner(v, u101, u108)] = true;
            end;
        end;
    end;

    Clear(Position.Y - 4, 5, Position.Y - 4);
    local v114 = u106.Position + Unit * 11;
    local RaycastParams_new_ret = RaycastParams.new();
    RaycastParams_new_ret.FilterType = Enum.RaycastFilterType.Include;
    RaycastParams_new_ret.FilterDescendantsInstances = { u101 };
    local v115 = Workspace:Raycast(Vector3.new(v114.X, Position.Y + 1, v114.Z), Vector3.new(0, -12, 0), RaycastParams_new_ret);
    local v116 = {};

    while u107[StageOwner(v115.Instance, u101, u108)] do
        v115 = Workspace:Raycast(v115.Position - Vector3.new(0, 0.01, 0), Vector3.new(0, -12, 0), RaycastParams_new_ret);
    end;

    local Vector3_new_ret = Vector3.new(v114.X, v115.Position.Y, v114.Z);
    Clear(Vector3_new_ret.Y + 0.25, 9, Vector3_new_ret.Y);
    local v117 = {};

    for i in u107 do
        table.insert(v117, i);
    end;

    while #v117 > 0 do
        local table_remove_ret = table.remove(v117);

        if table_remove_ret:IsA("BasePart") then
            for _, v in Workspace:GetPartBoundsInBox(table_remove_ret.CFrame, table_remove_ret.Size + Vector3.new(0.2, 0.2, 0.2), OverlapParams_new_ret) do
                local v118 = StageOwner(v, u101, u108);

                if not (u107[v118] or (v.Size.Magnitude >= 8 or (((v.Position - Position) * Vector3.new(1, 0, 1)).Magnitude >= 9 or v.Position.Y - v.Size.Y / 2 <= Vector3_new_ret.Y + 0.25))) then
                    u107[v118] = true;
                    table.insert(v117, v118);
                end;
            end;
        end;
    end;

    for i in u107 do
        local v119 = i:QueryDescendants("BasePart, Decal");

        if i:IsA("BasePart") then
            table.insert(v119, i);
        end;

        for _, v in v119 do
            v.LocalTransparencyModifier = 1;
            v116[v] = true;
        end;
    end;

    local Vector3_new_ret2 = Vector3.new(u106.X, Vector3_new_ret.Y + 3.3, u106.Z);
    local v120 = u23.GetLoadoutData()[p102]["16"];
    local v121 = u22.new({
        Name = "InspectAgent",
        Agent = p103,
        Gloves = {
            WeaponName = v120 and v120.WeaponName or `{p102} Gloves`,
            SkinName = v120 and v120.SkinName or "Stock"
        },
        Parent = u101.Rig
    });
    u52 = {
        Rig = v121,
        Hidden = v116,
        Camera = u101.Camera,
        Base = CFrame.lookAt(Vector3_new_ret + Vector3.new(0, 3, 0), (Vector3.new(Vector3_new_ret2.X, Vector3_new_ret.Y + 3, Vector3_new_ret2.Z)))
    };
    v121:PivotTo(u52.Base);
    local v122 = Vector3_new_ret + Vector3.new(0, 2.2, 0);
    TweenStage(u101.Camera, CFrame.lookAt(Vector3_new_ret2, v122), (v122 - Vector3_new_ret2).Magnitude);
    PoseStage(p104, p105);
end;

function u1.HoverSize(p123: userdata) -- Line: 421
    -- upvalues: TextService (copy)
    local v124 = TextService:GetTextSize(p123.HoverText.Text, 20, Enum.Font.Gotham, Vector2.new((1 / 0), 0)).X / p123.Parent.AbsoluteSize.X;
    p123.Size = UDim2.new(v124, 0, 0.926, 0);
    p123.Position = UDim2.new(0.5, 0, -1.20416, 0);
end;

function u1.CreateButton(p125: string, p126: number, u127: any, p128: string) -- Line: 436
    -- upvalues: u1 (copy), u4 (ref), u3 (ref), TweenService (copy), TweenInfo_new_ret (copy), u24 (ref), u48 (copy)
    local u129 = u1.newButton();
    u129.Parent = u4.Main.DownBar.LeftHolder;
    u129.HoverFrame.HoverText.Text = p125;
    u129.IconBT.Image = `rbxassetid://{p126}`;
    u1.HoverSize(u129.HoverFrame);
    u3:Add(`{p128}_MouseEnter`, u129.MouseEnter:Connect(function() -- Line: 444
        -- upvalues: TweenService (ref), u129 (copy), TweenInfo_new_ret (ref)
        TweenService:Create(u129.HoverFrame, TweenInfo_new_ret, {
            GroupTransparency = 0
        }):Play();
        TweenService:Create(u129, TweenInfo_new_ret, {
            BackgroundTransparency = 0.7
        }):Play();
    end));
    u3:Add(`{p128}_MouseLeave`, u129.MouseLeave:Connect(function() -- Line: 450
        -- upvalues: TweenService (ref), u129 (copy), TweenInfo_new_ret (ref), u24 (ref)
        TweenService:Create(u129.HoverFrame, TweenInfo_new_ret, {
            GroupTransparency = 1
        }):Play();

        if u24 == u129 then
            TweenService:Create(u129, TweenInfo_new_ret, {
                BackgroundTransparency = 0
            }):Play();

            return;
        end;

        TweenService:Create(u129, TweenInfo_new_ret, {
            BackgroundTransparency = 1
        }):Play();
    end));
    u3:Add(`{p128}_Click`, u129.MouseButton1Click:Connect(function() -- Line: 461
        -- upvalues: u24 (ref), u129 (copy), TweenService (ref), TweenInfo_new_ret (ref), u127 (copy)
        if u24 == u129 then
            return;
        end;

        if u24 ~= nil then
            TweenService:Create(u24, TweenInfo_new_ret, {
                BackgroundTransparency = 1
            }):Play();
            TweenService:Create(u24.IconBT, TweenInfo_new_ret, {
                ImageColor3 = Color3.fromRGB(255, 255, 255)
            }):Play();
        end;

        TweenService:Create(u129, TweenInfo_new_ret, {
            BackgroundTransparency = 0
        }):Play();
        TweenService:Create(u129.IconBT, TweenInfo_new_ret, {
            ImageColor3 = Color3.fromRGB(0, 0, 0)
        }):Play();
        u24 = u129;
        u127();
    end));
    table.insert(u48, u129);

    return u129;
end;

function u1.CreateClose() -- Line: 483
    -- upvalues: u4 (ref), TweenService (copy), TweenInfo_new_ret (copy), u1 (copy)
    local CloseButton = u4.Main.DownBar.RightDown.CloseButton;
    CloseButton.MouseEnter:Connect(function() -- Line: 486
        -- upvalues: TweenService (ref), CloseButton (copy), TweenInfo_new_ret (ref)
        TweenService:Create(CloseButton, TweenInfo_new_ret, {
            BackgroundTransparency = 0.9
        }):Play();
    end);
    CloseButton.MouseLeave:Connect(function() -- Line: 490
        -- upvalues: TweenService (ref), CloseButton (copy), TweenInfo_new_ret (ref)
        TweenService:Create(CloseButton, TweenInfo_new_ret, {
            BackgroundTransparency = 1
        }):Play();
    end);
    CloseButton.MouseButton1Click:Connect(function() -- Line: 494
        -- upvalues: u1 (ref)
        u1.Close();
    end);
    CloseButton.MouseButton2Click:Connect(function() -- Line: 498
        -- upvalues: u1 (ref)
        u1.Close();
    end);
end;

function u1.IsOpen() -- Line: 509
    -- upvalues: u4 (ref), u28 (ref), u29 (ref)
    return (u4 and u4.Visible or u28) and not u29;
end;

function u1.StickerMode() -- Line: 513
    -- upvalues: u44 (ref)
    return u44;
end;

function u1.IsBusy() -- Line: 517
    -- upvalues: u28 (ref), u29 (ref)
    return u28 or u29;
end;

function u1.Clean() -- Line: 521
    -- upvalues: u4 (ref), u29 (ref), u28 (ref), ResetRigNeck (copy), u25 (ref), u3 (ref), CloseStage (copy), u53 (ref), u54 (ref), u32 (ref), u39 (copy), u51 (ref), u50 (ref), u49 (ref), TweenInfo_new_ret (copy)
    if not (u4 and u4.Visible) then
        return;
    end;

    u29 = false;
    u28 = false;
    ResetRigNeck(u25);
    u3:Cleanup();
    CloseStage();
    u53 = nil;
    u54 = nil;

    if u32 then
        u32:Destroy();
        u32 = nil;
    end;

    if u25 then
        local v130 = u25:FindFirstChildOfClass("Model");

        if v130 then
            v130:Destroy();
        end;

        u25 = nil;
    end;

    for _, v in u39 do
        v.editableMesh:Destroy();
    end;

    table.clear(u39);

    if u51 then
        u51.Destroy();
        u51 = nil;
    end;

    if u50 then
        u50.Visible = false;
    end;

    u49 = nil;

    if CurrentAnimation then
        CurrentAnimation:Stop(TweenInfo_new_ret.Time);
    end;
end;

function u1.Close(p131) -- Line: 566
    -- upvalues: u29 (ref), u4 (ref), ResetRigNeck (copy), u2 (ref), TweenService (copy), u3 (ref), CloseStage (copy), u53 (ref), u54 (ref), u48 (copy), u31 (ref), u18 (ref), u32 (ref), u25 (ref), u39 (copy), TweenInfo_new_ret (copy), u26 (ref), u27 (ref), Lighting (copy), u13 (ref), u20 (ref), u6 (ref), u50 (ref), u51 (ref), u49 (ref)
    if u29 or not (u4 and u4.Visible) then
        return;
    end;

    u29 = true;
    local Scene = workspace:FindFirstChild("Scene");

    if Scene then
        ResetRigNeck(Scene);
    end;

    if not p131 then
        u2.Handler.Fade.Position = UDim2.fromScale(2, 0.5);
        TweenService:Create(u2.Handler.Fade, TweenInfo.new(1, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
            Position = UDim2.fromScale(-1, 0.5)
        }):Play();
    end;

    u3:Cleanup();
    CloseStage();
    u53 = nil;
    u54 = nil;

    for _, v in ipairs(u48) do
        u3:Removes(
            "First_MouseEnter",
            "First_MouseLeave",
            "First_Click",
            "Second_MouseEnter",
            "Second_MouseLeave",
            "Second_Click",
            "Third_MouseEnter",
            "Third_MouseLeave",
            "Third_Click"
        );
        v:Destroy();
    end;

    table.clear(u48);

    if u31 ~= nil then
        u18.Destroy(u31);
        u31 = nil;
    end;

    if u32 then
        u32:Destroy();
        u32 = nil;
    end;

    if u25 then
        local v132 = u25:FindFirstChildOfClass("Model");

        if v132 then
            v132:Destroy();
        end;

        u25 = nil;
    end;

    for _, v in u39 do
        v.editableMesh:Destroy();
    end;

    table.clear(u39);

    if not p131 then
        task.delay(TweenInfo_new_ret.Time + 0.15 - 0.125, function() -- Line: 633
            -- upvalues: u29 (ref), ResetRigNeck (ref), u26 (ref), u27 (ref), u2 (ref), Lighting (ref), u13 (ref), u20 (ref), u6 (ref), u4 (ref), u50 (ref), u51 (ref), u3 (ref), u49 (ref)
            if CurrentAnimation then
                CurrentAnimation:Stop();
            end;

            u29 = false;
            local Scene2 = workspace:FindFirstChild("Scene");

            if Scene2 then
                ResetRigNeck(Scene2);
            end;

            if u26 then
                if u27 then
                    u2.Handler.MainMenu.Visible = true;
                    u2.Handler.DOTS.Visible = true;

                    if Lighting:FindFirstChild("UI_Blur") then
                        Lighting.UI_Blur.Size = 72;
                    end;

                    if Lighting:FindFirstChild("2") then
                        Lighting["2"].Enabled = true;
                    end;

                    if Lighting:FindFirstChild("1") then
                        Lighting["1"].Enabled = false;
                    end;

                    if Scene2 then
                        u13.PlaceRig(Scene2, true);
                    end;

                    u27 = false;
                else
                    u13.SetModelVisible(true);
                    u20.Enabled("CaseInspect", true);

                    if Lighting:FindFirstChild("2") then
                        Lighting["2"].Enabled = true;
                    end;

                    if Lighting:FindFirstChild("1") then
                        Lighting["1"].Enabled = false;
                    end;

                    u2.Handler.CaseInspect.Visible = true;
                end;

                u26 = false;
            else
                u2.Handler.MainMenu.Visible = true;
                u2.Handler.DOTS.Visible = true;

                if Lighting:FindFirstChild("UI_Blur") then
                    Lighting.UI_Blur.Size = 72;
                end;

                if Lighting:FindFirstChild("2") then
                    Lighting["2"].Enabled = true;
                end;

                if Lighting:FindFirstChild("1") then
                    Lighting["1"].Enabled = false;
                end;
            end;

            u6.SetFOVAmount(65);

            if u4 then
                u4.Main.NameTagTextBox.Visible = false;
                u4.Main.NameTagViewport.Visible = false;
                u4.Main.DownBar.RightDown.ApplyNameTag.Visible = false;
                u4.Main.DownBar.RightDown.ApplyKillTrack.Visible = false;

                if u4.Main.DownBar.RightDown:FindFirstChild("ApplyKillTrackColor") then
                    u4.Main.DownBar.RightDown.ApplyKillTrackColor.Visible = false;
                end;

                if u50 then
                    u50.Visible = false;
                end;

                if u51 then
                    u51.Destroy();
                    u51 = nil;
                end;

                if u4.Main.DownBar.RightDown:FindFirstChild("RemoveNameTag") then
                    u4.Main.DownBar.RightDown.RemoveNameTag.Visible = false;
                end;

                if u4.Main.DownBar.RightDown:FindFirstChild("RemoveKillTrack") then
                    u4.Main.DownBar.RightDown.RemoveKillTrack.Visible = false;
                end;

                u4.Visible = false;
            end;

            u3:Removes(
                "NameTagInspectBtnApply",
                "NameTagInspectBtnRemove",
                "KillTrackInspectBtnApply",
                "KillTrackInspectBtnRemove",
                "KillTrackColorInspectBtnApply",
                "KillTrackColorApplyClick",
                "NameTagApplyClick",
                "NameTagTextChange"
            );
            u49 = nil;
            local v133 = u2 and u2.GetComponent and u2.GetComponent("MainMenu");

            if v133 and v133.CheckSceneUpdate then
                v133.CheckSceneUpdate();
            end;
        end);

        return;
    end;

    if CurrentAnimation then
        CurrentAnimation:Stop(TweenInfo_new_ret.Time);
    end;

    u26 = false;
    u27 = false;
    u29 = false;

    if u4 then
        u4.Visible = false;
    end;
end;

local function Teardown() -- Line: 750
    -- upvalues: u3 (ref), CloseStage (copy), u48 (copy), u31 (ref), u18 (ref), u32 (ref), u25 (ref), u39 (copy), TweenInfo_new_ret (copy)
    u3:Cleanup();
    CloseStage();

    for _, v in u48 do
        v:Destroy();
    end;

    table.clear(u48);

    if u31 ~= nil then
        u18.Destroy(u31);
        u31 = nil;
    end;

    if u32 then
        u32:Destroy();
        u32 = nil;
    end;

    local v134 = u25 and u25:FindFirstChildOfClass("Model");

    if v134 then
        v134:Destroy();
    end;

    for _, v in u39 do
        v.editableMesh:Destroy();
    end;

    table.clear(u39);

    if CurrentAnimation then
        CurrentAnimation:Stop(TweenInfo_new_ret.Time);
    end;
end;

function u1.Register(p135: userdata, p136: any) -- Line: 782
    -- upvalues: u33 (copy)
    u33[p135] = p136;
end;

function u1.Browse(p137: userdata, p138: table?) -- Line: 786
    -- upvalues: u33 (copy), u36 (ref), u37 (ref), u1 (copy)
    if not (p138 and table.find(p138, p137)) then
        local u139 = {};
        p138 = {};

        for i, child in p137.Parent:GetChildren() do
            if u33[child] then
                u139[child] = i;
                table.insert(p138, child);
            end;
        end;

        table.sort(p138, function(p140, p141) -- Line: 798
            -- upvalues: u139 (copy)
            if p140.LayoutOrder == p141.LayoutOrder then
                return u139[p140] < u139[p141];
            end;

            return p140.LayoutOrder < p141.LayoutOrder;
        end);
    end;

    local v142 = {};
    local v143 = 1;

    for _, v in p138 do
        if v.Visible and u33[v] then
            table.insert(v142, u33[v]);

            if v == p137 then
                v143 = #v142;
            end;
        end;
    end;

    local v144 = u33[p137]();
    u36 = v142;
    u37 = v143;
    u1.Item(table.unpack(v144, 1, v144.n));
end;

function u1.CanBrowse() -- Line: 825
    -- upvalues: u4 (ref), u29 (ref), u28 (ref), u34 (ref)
    local v145 = u4.Visible and not (u29 or u28);

    if v145 then
        if u34 == nil then
            v145 = false;
        else
            v145 = #u34 > 1;
        end;
    end;

    return v145;
end;

function u1.Step(p146: number) -- Line: 829
    -- upvalues: u1 (copy), u34 (ref), u35 (ref), u10 (ref), Teardown (copy), u38 (ref), u36 (ref), u37 (ref)
    if not u1.CanBrowse() then
        return;
    end;

    local v147 = u34;
    local v148 = (u35 - 1 + p146) % #v147 + 1;
    local v149 = v147[v148]();
    u10.Play("UI.submenu_click");
    Teardown();
    u38 = true;
    u36 = v147;
    u37 = v148;
    u1.Item(table.unpack(v149, 1, v149.n));
    u38 = false;
end;

function u1.FitTitle() -- Line: 847
    -- upvalues: u4 (ref), TweenService (copy), TweenInfo_new_ret (copy)
    local NoCollectionFrame = u4.Main.NoCollectionFrame;
    local X = NoCollectionFrame.WeaponSkin.TextBounds.X;
    local v150 = NoCollectionFrame.AbsoluteSize.Y * 0.35;
    TweenService:Create(NoCollectionFrame.Rarity, TweenInfo_new_ret, {
        Size = UDim2.new(0, X + 4, 0.116, 2)
    }):Play();
    TweenService:Create(NoCollectionFrame.Previous, TweenInfo_new_ret, {
        Position = UDim2.new(0.5, -(X / 2 + v150), 0.55, 0)
    }):Play();
    TweenService:Create(NoCollectionFrame.Next, TweenInfo_new_ret, {
        Position = UDim2.new(0.5, X / 2 + v150, 0.55, 0)
    }):Play();
end;

function u1.SetTransparency(p151: userdata, p152: boolean) -- Line: 857
    for _, descendant in ipairs(p151:GetDescendants()) do
        if descendant:IsA("BasePart") or (descendant:IsA("Decal") or descendant:IsA("Texture")) then
            if p152 then
                if descendant:GetAttribute("_OriginalTransparency") == nil then
                    descendant:SetAttribute("_OriginalTransparency", descendant.Transparency);
                end;

                descendant.Transparency = 1;
            else
                local Attribute = descendant:GetAttribute("_OriginalTransparency");

                if Attribute ~= nil then
                    descendant.Transparency = Attribute;
                    descendant:SetAttribute("_OriginalTransparency", nil);
                end;
            end;
        end;
    end;
end;

function u1.GlovesModel(p153, p154, p155) -- Line: 879
    -- upvalues: Assets (copy)
    local v156 = Assets.GlovesArms:Clone();
    local v157 = p153.Model:Clone();

    for _, v in { "GloveL", "GloveR" } do
        local v158 = v156:FindFirstChild(v, true);
        local v159 = v157[v];

        for _, v2 in v156:QueryDescendants("Motor6D, Weld") do
            if v2.Part0 == v158 then
                v2.Part0 = v159;
            end;

            if v2.Part1 == v158 then
                v2.Part1 = v159;
            end;
        end;

        for _, child in v158:GetChildren() do
            if child:IsA("JointInstance") then
                child.Parent = v159;
            end;
        end;

        p154.Assets[v]:Clone().Parent = v159;
        v159.CFrame = v158.CFrame;
        v159.Parent = v158.Parent;
        v158:Destroy();
    end;

    v157:Destroy();
    local v160 = {};
    local v161 = {};
    local v162 = nil;

    for _, v in v156:QueryDescendants("Motor6D, Weld") do
        v160[v.Part1] = true;
        v161[v.Part0] = true;
    end;

    for _, v in v156:QueryDescendants("BasePart") do
        v.Anchored = not v160[v];
        v.CanCollide = false;

        if not (v160[v] or v162 and (not v161[v] or v161[v162])) then
            v162 = v;
        end;
    end;

    v162.Transparency = 1;
    v156.Parent = p155;
    local Animation = Instance.new("Animation");
    Animation.AnimationId = "rbxassetid://76691750515745";
    local v163 = v156:FindFirstChildWhichIsA("Animator", true):LoadAnimation(Animation);
    v163.Looped = true;
    v163:Play();

    return v156, v162;
end;

function u1.Item(u164: string, u165: string, u166: string, u167: string, u168: any, p169: boolean, p170: any, u171: string?, u172: string?, u173: number?, u174: any) -- Line: 942
    -- upvalues: u36 (ref), u37 (ref), u29 (ref), u28 (ref), u4 (ref), u38 (ref), u34 (ref), u35 (ref), u25 (ref), u49 (ref), u15 (ref), u7 (ref), u17 (ref), u5 (ref), u44 (ref), u50 (ref), u51 (ref), u3 (ref), u26 (ref), u2 (ref), u10 (ref), Teardown (copy), u1 (copy), u11 (ref), ResetRigNeck (copy), Idle (copy), Assets (copy), u59 (copy), u18 (ref), KillTrack (copy), u40 (ref), u41 (ref), u42 (ref), u43 (ref), ProjectSticker (copy), Workspace (copy), u30 (ref), UserInputService (copy), RunService (copy), u32 (ref), u52 (ref), u6 (ref), u31 (ref), u19 (ref), u23 (ref), StageWeapons (copy), u22 (ref), OpenStage (copy), SetPicker (copy), PoseStage (copy), CloseStage (copy), LocalPlayer (copy), u24 (ref), u13 (ref), u27 (ref), TweenService (copy), Lighting (copy), u20 (ref)
    local v175 = u36;
    u36 = nil;

    if u29 or (u28 or u4.Visible and not u38) then
        return;
    end;

    u28 = true;
    u34 = v175;
    u35 = u37;
    local NoCollectionFrame = u4.Main.NoCollectionFrame;
    local u176 = workspace:FindFirstChild("Scene") or workspace:WaitForChild("Scene", 5);

    if not u176 then
        u28 = false;

        return;
    end;

    u25 = u176;
    u49 = nil;
    local u177 = u15.GetCategory(u164) or u7.Get(u164);
    local u178 = u15.GetItem(u164, u165) or u17.GetWeaponSkin(u164, u165);
    local v179;

    if u177 then
        v179 = u177.DisplayName or u164;
    else
        v179 = u164;
    end;

    local v180;

    if u178 then
        v180 = u178.DisplayName or u165;
    else
        v180 = u165;
    end;

    if u171 and u171 ~= "" then
        NoCollectionFrame.WeaponSkin.Text = `{v179} | {v180} (''{u171}'')`;
        u4.Main.DownBar.Description.Text = `Name Tag: ''{u171}''\n\n{u167}`;
    else
        NoCollectionFrame.WeaponSkin.Text = `{v179} | {v180}`;
        u4.Main.DownBar.Description.Text = u167;
    end;

    if u173 then
        NoCollectionFrame.WeaponSkin.Text = `KillTrackᴷ⁺ {NoCollectionFrame.WeaponSkin.Text}`;
        u4.Main.DownBar.Description.Text = `KillTrack Confirmed Kills: {u173}\n\n{u4.Main.DownBar.Description.Text}`;
    end;

    NoCollectionFrame.Rarity.Frame.BackgroundColor3 = u5[u166] or Color3.fromRGB(188, 203, 219);
    NoCollectionFrame.Visible = true;
    local v181;

    if v175 == nil then
        v181 = false;
    else
        v181 = #v175 > 1;
    end;

    NoCollectionFrame.Previous.Visible = v181;
    NoCollectionFrame.Next.Visible = NoCollectionFrame.Previous.Visible;
    u44 = nil;
    u4.Main.DownBar.RightDown.ApplySticker.Visible = false;
    u4.Main.DownBar.RightDown.RemoveSticker.Visible = false;
    u4.Main.DownBar.RightDown.ApplyNameTag.Visible = false;
    u4.Main.DownBar.RightDown.ApplyKillTrack.Visible = false;
    u4.Main.DownBar.RightDown.ViewGlow.Visible = false;

    if u4.Main.DownBar.RightDown:FindFirstChild("ApplyKillTrackColor") then
        u4.Main.DownBar.RightDown.ApplyKillTrackColor.Visible = false;
    end;

    if u4.Main.DownBar.RightDown:FindFirstChild("RemoveNameTag") then
        u4.Main.DownBar.RightDown.RemoveNameTag.Visible = false;
    end;

    if u4.Main.DownBar.RightDown:FindFirstChild("RemoveKillTrack") then
        u4.Main.DownBar.RightDown.RemoveKillTrack.Visible = false;
    end;

    if u50 then
        u50.Visible = false;
    end;

    if u51 then
        u51.Destroy();
        u51 = nil;
    end;

    u4.Main.NameTagTextBox.Visible = false;
    u4.Main.NameTagViewport.Visible = false;
    u4.Main.DownBar.Description.Visible = true;
    u4.Main.StickerApplying.Visible = false;
    u4.Main.StickerThing.Visible = false;
    u4.Main.Stickers.Visible = false;
    u3:Removes(
        "NameTagInspectBtnApply",
        "NameTagInspectBtnRemove",
        "KillTrackInspectBtnApply",
        "KillTrackInspectBtnRemove",
        "KillTrackColorInspectBtnApply",
        "KillTrackColorApplyClick",
        "GlowInspectBtn"
    );

    if u177 and (u177.Class == "Stickers" and (not p169 and (u26 or u2.Handler.CaseInspect.Visible))) then
        local v182 = u165:sub(-5) == " Holo";
        local u183 = v182 and u165:sub(1, -6) or `{u165} Holo`;

        if u15.GetItem(u164, u183) then
            local ViewGlow = u4.Main.DownBar.RightDown.ViewGlow;
            ViewGlow.TextLabel.Text = v182 and "VIEW NORMAL" or "VIEW GLOW";
            ViewGlow.Visible = true;
            u3:Add("GlowInspectBtn", ViewGlow.MouseButton1Click:Connect(function() -- Line: 1036
                -- upvalues: u28 (ref), u29 (ref), u34 (ref), u35 (ref), u10 (ref), Teardown (ref), u38 (ref), u36 (ref), u37 (ref), u1 (ref), u164 (copy), u183 (copy), u166 (copy), u167 (copy)
                if u28 or u29 then
                    return;
                end;

                u10.Play("UI.submenu_click");
                Teardown();
                u38 = true;
                u36 = u34;
                u37 = u35;
                u1.Item(u164, u183, u166, u167);
                u38 = false;
            end));
        end;
    end;

    if u172 and not (p169 or u2.Handler and (u2.Handler:FindFirstChild("CaseInspect") and u2.Handler.CaseInspect.Visible)) and (u177 and (u177.Class ~= "Containers" and (u177.Class ~= "Name Tags" and u177.Class ~= "KillTracks"))) then
        local v184 = u11 and u11.Get();

        if v184 then
            v184 = v184["Graphic Art"];
        end;

        local v185;

        if v184 then
            v185 = v184["Name Tags"] or v184.NameTags;
        end;

        if v184 then
            v184 = v184.KillTracks;
        end;

        local v186 = false;
        local v187 = false;
        local v188 = false;
        local v189 = false;
        local v190 = u177 and u177.Data and u177.Data.Type == "Bomb";

        if v185 then
            for _, v in v185 do
                if v and next(v) then
                    v186 = true;
                    break;
                end;
            end;
        end;

        if v184 then
            for i, v in v184 do
                if i ~= "KillTrack Painter" and (i ~= "KillTrack Remover" and (v and next(v))) then
                    v187 = true;
                end;
            end;

            v188 = v184["KillTrack Painter"] and next(v184["KillTrack Painter"]) and true or v188;

            if v184["KillTrack Remover"] and next(v184["KillTrack Remover"]) then
                v189 = true;
            end;
        end;

        if v186 then
            u4.Main.DownBar.RightDown.ApplyNameTag.Visible = true;
            u4.Main.DownBar.RightDown.ApplyNameTag.TextLabel.Text = u171 and u171 ~= "" and "RENAME" or "APPLY NAME TAG";
            u3:Add("NameTagInspectBtnApply", u4.Main.DownBar.RightDown.ApplyNameTag.MouseButton1Click:Connect(function() -- Line: 1093
                -- upvalues: u1 (ref), u164 (copy), u165 (copy), u172 (copy), u171 (copy), u173 (copy)
                u1.NameTagApply(u164, u165, u172, u171, u173);
            end));
        end;

        if u171 and (u171 ~= "" and u4.Main.DownBar.RightDown:FindFirstChild("RemoveNameTag")) then
            u4.Main.DownBar.RightDown.RemoveNameTag.Visible = true;
            u3:Add("NameTagInspectBtnRemove", u4.Main.DownBar.RightDown.RemoveNameTag.MouseButton1Click:Connect(function() -- Line: 1101
                -- upvalues: u1 (ref), u164 (copy), u165 (copy), u172 (copy)
                u1.NameTagRemove(u164, u165, u172);
            end));
        end;

        if v187 and (u173 == nil and not v190) then
            u4.Main.DownBar.RightDown.ApplyKillTrack.Visible = true;
            u3:Add("KillTrackInspectBtnApply", u4.Main.DownBar.RightDown.ApplyKillTrack.MouseButton1Click:Connect(function() -- Line: 1109
                -- upvalues: u1 (ref), u164 (copy), u165 (copy), u172 (copy)
                u1.KillTrackApply(u164, u165, u172);
            end));
        end;

        if v188 and (u173 ~= nil and u4.Main.DownBar.RightDown:FindFirstChild("ApplyKillTrackColor")) then
            u4.Main.DownBar.RightDown.ApplyKillTrackColor.Visible = true;
            u4.Main.DownBar.RightDown.ApplyKillTrackColor.TextLabel.Text = "COLOR KILLTRACK";
            u3:Add("KillTrackColorInspectBtnApply", u4.Main.DownBar.RightDown.ApplyKillTrackColor.MouseButton1Click:Connect(function() -- Line: 1117
                -- upvalues: u1 (ref), u164 (copy), u165 (copy), u172 (copy), u171 (copy), u173 (copy), u174 (copy)
                u1.KillTrackColorApply(u164, u165, u172, u171, u173, u174);
            end));
        end;

        if v189 and (u173 ~= nil and u4.Main.DownBar.RightDown:FindFirstChild("RemoveKillTrack")) then
            u4.Main.DownBar.RightDown.RemoveKillTrack.Visible = true;
            u3:Add("KillTrackInspectBtnRemove", u4.Main.DownBar.RightDown.RemoveKillTrack.MouseButton1Click:Connect(function() -- Line: 1124
                -- upvalues: u1 (ref), u164 (copy), u165 (copy), u172 (copy)
                u1.KillTrackRemove(u164, u165, u172);
            end));
        end;
    end;

    ResetRigNeck(u176);

    if u176:FindFirstChild("Rig") and (u176.Rig:FindFirstChild("Rig") and u176.Rig.Rig:FindFirstChild("AnimationController")) then
        local AnimationController = u176.Rig.Rig.AnimationController;
        local v191 = AnimationController:FindFirstChildOfClass("Animator") or AnimationController:FindFirstChild("Animator");

        if v191 then
            Idle.AnimationId = "rbxassetid://109748583063372";
            CurrentAnimation = v191:LoadAnimation(Idle);
            CurrentAnimation.Priority = Enum.AnimationPriority.Action3;
            CurrentAnimation.Looped = true;
            CurrentAnimation:Play();
        end;
    end;

    local u192;

    if u164 == "Name Tags" or u177 and u177.Class == "Name Tags" or u178 and u178.ModelName == "Name Tags" then
        u192 = Assets.InspectNameTag:Clone();
    elseif u177.Class == "Badges" or u177.Class == "Stickers" then
        u192 = Assets.InspectPlate:Clone();
        local v193 = u192.Plate:FindFirstChildOfClass("Decal");
        v193.Texture = u178.Asset;
        v193.Face = u59[v193.Face];

        if u178.SurfaceAppereance then
            local v194 = u192.Plate:Clone();
            v194.Name = "Sticker";
            v194.SurfaceAppearance:Destroy();
            v194:FindFirstChildOfClass("Decal"):Destroy();
            v194.CFrame = u192.Plate.CFrame * CFrame.new(-0.002, 0, 0);
            v194.CanCollide = false;
            u178.SurfaceAppereance:Clone().Parent = v194;
            local WeldConstraint = Instance.new("WeldConstraint");
            WeldConstraint.Part0 = u192.Plate;
            WeldConstraint.Part1 = v194;
            WeldConstraint.Parent = v194;
            v194.Parent = u192;
            v193:Destroy();
        end;

        if u177.Class == "Stickers" then
            u192.Plate.Transparency = 1;
        end;

        u192:ScaleTo(u192:GetScale() * 3.5);
    elseif u177.Class == "Agent" then
        u192 = Instance.new("Model");
    else
        u192 = u177.Assets.InspectModel:Clone();
    end;

    local PrimaryPart = u192.PrimaryPart;
    local BoundingBox, _ = u192:GetBoundingBox();
    u192.PrimaryPart = nil;
    u192.WorldPivot = BoundingBox;

    if u178.Assets then
        for i, v in u178.Assets do
            local v195 = u192:FindFirstChild(i);

            if v195 then
                local v196 = v:Clone();

                if p170 then
                    v196.EmissiveTint = p170.Tint;
                    v196.EmissiveStrength = p170.Strength or 1;
                end;

                if u178.AnimatedTint then
                    u18.ApplyAnimatedTint(v196, u178.AnimatedTint, "MenuInspect");
                end;

                v196.Parent = v195;
            end;
        end;
    end;

    local v197 = u173 ~= nil and u192:FindFirstChild("KillTrack");

    if v197 then
        local v198 = u177 and u177.Data and u177.Data.Type == "Melee";
        local v199 = KillTrack:FindFirstChild(v198 and "Melee" or "Weapon"):Clone();
        v199:PivotTo(v197.CFrame * (v198 and CFrame.Angles(0, -1.5707963267948966, 0) or CFrame.identity));
        v199.Parent = v197;
        local Foreground = v199.Track.Text.SurfaceGui.Foreground;
        u49 = Foreground;

        if v198 then
            Foreground.Text = (`{math.clamp(u173, 0, 999999)}`):gsub("0", "O");
            Foreground.TextTransparency = 0.8;
        else
            local function zfill(p200: string, p201: number) -- Line: 1240
                return string.rep("0", (math.max(0, p201 - #p200))) .. p200;
            end;

            local v202 = `{math.clamp(u173, 0, 999999)}`;
            Foreground.Text = string.rep("0", (math.max(0, 6 - #v202))) .. v202;
        end;

        local v203 = v198 and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(255, 102, 0);

        if u174 then
            Foreground.TextColor3 = Color3.fromRGB(u174[1], u174[2], u174[3]);
        else
            Foreground.TextColor3 = v203;
        end;
    end;

    local v204 = u171 and u171 ~= "" and u192:FindFirstChild("NameTag");

    if v204 then
        local v205 = Assets:FindFirstChild("WeaponNameTag"):Clone();
        v205:PivotTo(v204.CFrame);
        v205.Parent = v204;
        v205.Tag.Text.SurfaceGui.Foreground.Text = u171;
    end;

    local u206 = nil;

    for _, v in u192:QueryDescendants("BasePart") do
        v.Anchored = true;
        v.CanCollide = false;
    end;

    if u176:FindFirstChild("Root") then
        u192:PivotTo(u176.Root.CFrame);
    end;

    u192.Parent = u176;
    local u207 = u18.StickerTargets(u192);
    local u208 = {};
    local v209;

    if u168 then
        v209 = next(u168);
    end;

    local u210 = not v209;
    u40 = u192;
    u41 = PrimaryPart;
    u42 = u207;
    u43 = u208;

    if not u210 then
        local u211 = #u168;

        for i, v in u168 do
            task.spawn(function() -- Line: 1294
                -- upvalues: u208 (copy), i (copy), ProjectSticker (ref), u192 (ref), u207 (copy), u18 (ref), PrimaryPart (copy), v (copy), u211 (ref), u210 (ref)
                u208[i] = ProjectSticker(u192, u207, u18.StickerProjector(PrimaryPart, 1, Vector3.new(unpack(v.Position)), v.Rotation, v.Size), v.StickerName, i - 1);
                u211 = u211 - 1;
                u210 = u211 == 0;
            end);
        end;
    end;

    local Vector2_new_ret = Vector2.new();
    local u212 = 0;
    local u213 = 0;
    local CFrame_Angles_ret = CFrame.Angles(0, 0, 0);
    local CFrame_Angles_ret2 = CFrame.Angles(0, 0, 0);
    local u214 = false;
    local u215 = 5;
    local u216 = u38 and Vector3.new(0, -0.35, 0) or Vector3.new();
    local Vector3_new_ret = Vector3.new();
    local u217 = u38 and Workspace.Camera.FieldOfView or 70;
    local u218 = u217;
    local u219 = false;
    local Vector2_zero = Vector2.zero;
    local u220 = 0;
    local u221 = 0;
    local u222 = nil;
    local u223 = nil;

    local function Rotate(p224) -- Line: 1325
        -- upvalues: u30 (ref), CFrame_Angles_ret2 (ref), u212 (ref), u213 (ref)
        if u30 then
            CFrame_Angles_ret2 = CFrame.Angles(0, math.rad(p224.X * 0.17), 0) * CFrame.Angles(0, 0, (math.rad(p224.Y * 0.17))) * CFrame_Angles_ret2;

            return;
        end;

        local math_rad_ret = math.rad(p224.X * 0.17);
        local math_rad_ret2 = math.rad(p224.Y * 0.17);
        CFrame_Angles_ret2 = CFrame.Angles(0, math_rad_ret, 0) * CFrame.Angles(0, 0, math_rad_ret2) * CFrame_Angles_ret2;
        local _, v225, v226 = CFrame_Angles_ret2:ToEulerAnglesYXZ();
        u212 = v225;
        u213 = math.clamp(v226, -1.5707963267948966, 1.5707963267948966);
        CFrame_Angles_ret2 = CFrame.Angles(0, u212, 0) * CFrame.Angles(0, 0, u213);
    end;

    u3:Add("InpectInputBegan", UserInputService.InputBegan:Connect(function(p227) -- Line: 1343
        -- upvalues: u50 (ref), u222 (ref), u214 (ref), u210 (ref), Vector2_new_ret (ref)
        if u50 and u50.Visible then
            return;
        end;

        if p227.UserInputType == Enum.UserInputType.Touch then
            if u222 then
                u214 = false;

                return;
            end;

            u222 = p227;
        end;

        if (p227.UserInputType == Enum.UserInputType.MouseButton1 or p227.UserInputType == Enum.UserInputType.Touch) and u210 then
            u214 = true;
            Vector2_new_ret = p227.Position;
        end;
    end));
    u3:Add("InpectInputEnded", UserInputService.InputEnded:Connect(function(p228) -- Line: 1362
        -- upvalues: u222 (ref), u214 (ref), u210 (ref), Vector2_new_ret (ref), u220 (ref), u221 (ref)
        if p228.UserInputType == Enum.UserInputType.MouseButton1 or p228 == u222 then
            u214 = false;
            u222 = nil;
        elseif p228.UserInputType == Enum.UserInputType.Touch and (u222 and u210) then
            u214 = true;
            Vector2_new_ret = u222.Position;
        end;

        if p228.KeyCode == Enum.KeyCode.ButtonR2 then
            u220 = 0;

            return;
        end;

        if p228.KeyCode == Enum.KeyCode.ButtonL2 then
            u221 = 0;
        end;
    end));
    u3:Add("InpectInputChanged", UserInputService.InputChanged:Connect(function(p229) -- Line: 1378
        -- upvalues: u50 (ref), u214 (ref), u222 (ref), Vector2_new_ret (ref), Rotate (copy), u215 (ref), u219 (ref), u218 (ref), Vector2_zero (ref), u220 (ref), u221 (ref)
        if u50 and u50.Visible then
            u214 = false;
        end;

        if u214 and (p229.UserInputType == Enum.UserInputType.MouseMovement or p229 == u222) then
            local v230 = p229.Position - Vector2_new_ret;
            Vector2_new_ret = p229.Position;
            Rotate(v230);
            u215 = os.clock();
        end;

        if p229.UserInputType == Enum.UserInputType.MouseWheel and not u219 then
            u218 = math.clamp(u218 - p229.Position.Z * 2, 30, 70);
        end;

        if p229.KeyCode == Enum.KeyCode.Thumbstick2 then
            Vector2_zero = Vector2.new(p229.Position.X, -p229.Position.Y);

            return;
        end;

        if p229.KeyCode == Enum.KeyCode.ButtonR2 then
            u220 = p229.Position.Z;

            return;
        end;

        if p229.KeyCode == Enum.KeyCode.ButtonL2 then
            u221 = p229.Position.Z;
        end;
    end));
    u3:Add("InpectPinch", UserInputService.TouchPinch:Connect(function(p231, p232, p233, p234) -- Line: 1406
        -- upvalues: u219 (ref), u223 (ref), u218 (ref), u215 (ref)
        if u219 then
            return;
        end;

        if p234 == Enum.UserInputState.Begin then
            u223 = u218;

            return;
        end;

        if u223 and p234 == Enum.UserInputState.Change then
            u218 = math.clamp(u223 / p232, 30, 70);
            u215 = os.clock();
        end;
    end));
    local u235 = 0;
    u3:Add("InpectInputAfk", RunService.PostSimulation:Connect(function(p236) -- Line: 1424
        -- upvalues: u192 (ref), u176 (copy), Vector2_zero (ref), u50 (ref), Rotate (copy), u215 (ref), u219 (ref), u220 (ref), u221 (ref), u218 (ref), Vector3_new_ret (ref), u216 (ref), u32 (ref), u206 (ref), u210 (ref), u52 (ref), u214 (ref), u235 (ref), CFrame_Angles_ret (ref), CFrame_Angles_ret2 (ref), u212 (ref), u213 (ref), u217 (ref), u6 (ref), Workspace (ref)
        if not (u192 and (u192.Parent and (u176 and (u176.Parent and u176:FindFirstChild("Root"))))) then
            return;
        end;

        if Vector2_zero.Magnitude > 0.2 and not (u50 and u50.Visible) then
            Rotate(Vector2_zero * p236 * 420);
            u215 = os.clock();
        end;

        if not u219 and u220 ~= u221 then
            u218 = math.clamp(u218 - (u220 - u221) * p236 * 60, 30, 70);
        end;

        if Vector3_new_ret == Vector3.new(-0.8, -5.5, 0) then
            u216 = Vector3_new_ret;
        else
            u216 = u216:Lerp(Vector3_new_ret, (math.clamp(p236 * 6, 0, 1)));
        end;

        if u32 then
            u32:PivotTo(workspace.CurrentCamera.CFrame * u206.CFrame:ToObjectSpace(u32:GetPivot()));
        end;

        if u210 then
            if u52 or (u214 or u50 and u50.Visible) or os.clock() - u215 <= 5 then
                CFrame_Angles_ret = CFrame_Angles_ret:Lerp(CFrame_Angles_ret2, (math.clamp(p236 * (u52 and 8 or 20), 0, 1)));
            else
                u235 = u235 + p236 * 1.5;
                local v237 = (math.sin(u235 * 0.3) * 0.06981317007977318 + 0.005235987755982988) * p236;
                local v238 = math.sin(u235 * 0.5) * 0.004363323129985824 * p236;
                local v239 = math.sin(u235) * 0.03490658503988659 * p236;
                local CFrame_Angles_ret3 = CFrame.Angles(v238, 0, 0);
                local CFrame_Angles_ret4 = CFrame.Angles(0, v237, 0);
                local CFrame_Angles_ret5 = CFrame.Angles(0, 0, v239);
                CFrame_Angles_ret = CFrame_Angles_ret3 * CFrame_Angles_ret4 * CFrame_Angles_ret5 * CFrame_Angles_ret;
                CFrame_Angles_ret2 = CFrame_Angles_ret;
                local _, v240, v241 = CFrame_Angles_ret:ToEulerAnglesYXZ();
                u212 = v240;
                u213 = v241;
            end;

            if u176:FindFirstChild("Root") then
                u192:PivotTo(u176.Root.CFrame * CFrame_Angles_ret + u216);
            end;
        end;

        if u52 then
            if u52.Begin.IsPlaying then
                CFrame_Angles_ret2 = CFrame.identity;
            end;

            local _, v242 = CFrame_Angles_ret:ToEulerAnglesYXZ();
            u52.Rig:PivotTo(u52.Base * CFrame.Angles(0, v242, 0));
        end;

        u217 = u217 + (u218 - u217) * math.clamp(p236 * 15, 0, 1);

        if u6.IsLockedToScene() then
            Workspace.Camera.FieldOfView = u217;
        end;
    end));
    local u243 = 0;

    local function ClearFirstPerson() -- Line: 1501
        -- upvalues: u31 (ref), u3 (ref), u18 (ref), u32 (ref)
        if u31 ~= nil then
            u3:Remove("RenderStep");
            u18.Destroy(u31);
            u31 = nil;
        end;

        if u32 then
            u32:Destroy();
            u32 = nil;
        end;
    end;

    local function FirstPerson(p244, p245) -- Line: 1514
        -- upvalues: u31 (ref), u18 (ref), u19 (ref), u3 (ref), RunService (ref), Vector3_new_ret (ref)
        u31 = u18.new(p244, p245);
        local u246 = u31;
        local v247 = u19.PickVariant(u246.Animators, "Equip");
        local u248 = u19.PickVariant(u246.Animators, "Inspect");
        local u249 = u246.Animators[v247];
        u249.Track.Alpha = 0;
        u249.Direction = 1;
        u249:Play();
        u18.PlayAnimatedTint(u31, v247);
        task.spawn(function() -- Line: 1526
            -- upvalues: u249 (copy), u31 (ref), u246 (copy), u248 (copy), u18 (ref)
            repeat
                task.wait();
            until not u249.Playing;

            if u31 ~= u246 then
                return;
            end;

            u246.Animators[u248]:Play();
            u18.PlayAnimatedTint(u246, u248);
        end);
        u3:Add("RenderStep", RunService.RenderStepped:Connect(function() -- Line: 1539
            -- upvalues: Vector3_new_ret (ref), u18 (ref), u31 (ref)
            Vector3_new_ret = Vector3.new(-0.8, -5.5, 0);
            u18.SolveAnimation(u31);
        end));
    end;

    local v250;

    if u177.Class == "Agent" then
        local Sides = u178.Sides;
        local v251 = u23.GetLoadoutData().T["15"];
        local u252 = Sides.CT and not (Sides.T and (v251 and v251.SkinName == u165)) and "CT" or "T";
        local u253, u254 = StageWeapons(u252);
        local u255 = u253[1];

        for _, v in u253 do
            if u22.GetWeaponClass(u254[v].WeaponName) == "Rifle" then
                u255 = v;
                break;
            end;
        end;

        local function ShowAgent() -- Line: 1561
            -- upvalues: OpenStage (ref), u176 (copy), u252 (copy), u165 (copy), u254 (copy), u255 (ref), SetPicker (ref), u253 (copy), PoseStage (ref)
            OpenStage(u176, u252, u165, u254[u255].WeaponName, u254[u255].SkinName);
            SetPicker("", u253, u255, function(p256) -- Line: 1564
                -- upvalues: u255 (ref), PoseStage (ref), u254 (ref)
                u255 = p256;
                PoseStage(u254[p256].WeaponName, u254[p256].SkinName);
            end);
        end;

        local function ShowArms() -- Line: 1570
            -- upvalues: u254 (copy), u255 (ref), u11 (ref), u31 (ref), u3 (ref), u18 (ref), u32 (ref), FirstPerson (copy), u7 (ref), u252 (copy), u165 (copy), u23 (ref)
            local v257 = u254[u255];
            local v258 = u11.Get().Equipment[v257.WeaponName][v257.SkinName][v257.SkinId];

            if u31 ~= nil then
                u3:Remove("RenderStep");
                u18.Destroy(u31);
                u31 = nil;
            end;

            if u32 then
                u32:Destroy();
                u32 = nil;
            end;

            FirstPerson({
                Name = v257.WeaponName,
                Skin = v257.SkinName,
                Mode = 1,
                KillTrack = v258.KillTrack,
                KillTrackColor = v258.KillTrackColor,
                NameTag = v258.NameTag,
                Stickers = v258.Stickers,
                Data = u7.Get(v257.WeaponName).Data,
                SilentEvents = true
            }, {
                Scale = 1,
                CFrame = workspace.CurrentCamera.CFrame,
                Parent = workspace,
                Team = u252,
                Agent = u165,
                Gloves = u23.GetLoadoutData()[u252]["16"]
            });
        end;

        v250 = u1.CreateButton("Inspect agent", 119770067780750, function() -- Line: 1596
            -- upvalues: u243 (ref), u31 (ref), u3 (ref), u18 (ref), u32 (ref), Vector3_new_ret (ref), u219 (ref), u4 (ref), OpenStage (ref), u176 (copy), u252 (copy), u165 (copy), u254 (copy), u255 (ref), SetPicker (ref), u253 (copy), PoseStage (ref), u217 (ref), u218 (ref)
            u243 = u243 + 1;
            local v259 = u243;

            if u31 ~= nil then
                u3:Remove("RenderStep");
                u18.Destroy(u31);
                u31 = nil;
            end;

            if u32 then
                u32:Destroy();
                u32 = nil;
            end;

            Vector3_new_ret = Vector3.new();
            u219 = false;
            u4.Main.DownBar.Description.Visible = true;
            OpenStage(u176, u252, u165, u254[u255].WeaponName, u254[u255].SkinName);
            SetPicker("", u253, u255, function(p260) -- Line: 1564
                -- upvalues: u255 (ref), PoseStage (ref), u254 (ref)
                u255 = p260;
                PoseStage(u254[p260].WeaponName, u254[p260].SkinName);
            end);

            for i = 1, 50 do
                u217 = u217 - (u217 - 50) * 0.05;
                u218 = u218 - (u218 - 50) * 0.05;
                task.wait(0.003);

                if u243 ~= v259 then
                    return;
                end;

                local _ = i;
            end;
        end, "First");
        u1.CreateButton("Inspect agent arms", 127723829978984, function() -- Line: 1619
            -- upvalues: u243 (ref), CloseStage (ref), Vector3_new_ret (ref), u219 (ref), u4 (ref), ShowArms (copy), SetPicker (ref), u253 (copy), u255 (ref), u217 (ref), u218 (ref)
            u243 = u243 + 1;
            local v261 = u243;
            CloseStage(true);
            Vector3_new_ret = Vector3.new(-0.8, -5.5, 0);
            u219 = true;
            u4.Main.DownBar.Description.Visible = false;
            ShowArms();
            SetPicker("", u253, u255, function(p262) -- Line: 1631
                -- upvalues: u255 (ref), ShowArms (ref)
                u255 = p262;
                ShowArms();
            end);

            for i = 1, 70 do
                u217 = u217 - (u217 - 70) * 0.05;
                u218 = u218 - (u218 - 70) * 0.05;
                task.wait(0.003);

                if u243 ~= v261 then
                    return;
                end;

                local _ = i;
            end;
        end, "Second");
        OpenStage(u176, u252, u165, u254[u255].WeaponName, u254[u255].SkinName);
        SetPicker("", u253, u255, function(p263) -- Line: 1564
            -- upvalues: u255 (ref), PoseStage (ref), u254 (copy)
            u255 = p263;
            PoseStage(u254[p263].WeaponName, u254[p263].SkinName);
        end);
    else
        v250 = u1.CreateButton("Inspect weapon model", 1784890670, function() -- Line: 1649
            -- upvalues: u243 (ref), u31 (ref), u3 (ref), u18 (ref), u32 (ref), CloseStage (ref), u4 (ref), u217 (ref), u218 (ref), Vector3_new_ret (ref), u219 (ref), u1 (ref), u192 (ref)
            u243 = u243 + 1;
            local v264 = u243;

            if u31 ~= nil then
                u3:Remove("RenderStep");
                u18.Destroy(u31);
                u31 = nil;
            end;

            if u32 then
                u32:Destroy();
                u32 = nil;
            end;

            CloseStage();
            u4.Main.DownBar.Description.Visible = true;

            for i = 1, 50 do
                u217 = u217 - (u217 - 50) * 0.05;
                u218 = u218 - (u218 - 50) * 0.05;
                task.wait(0.003);

                if u243 ~= v264 then
                    return;
                end;

                local _ = i;
            end;

            task.spawn(function() -- Line: 1668
                -- upvalues: Vector3_new_ret (ref)
                Vector3_new_ret = Vector3.new(0, 0, 0);
            end);
            u219 = false;
            u1.SetTransparency(u192, false);
        end, "First");
    end;

    if u177.Class ~= "Badges" and (u177.Class ~= "Stickers" and u177.Class ~= "Agent") then
        u1.CreateButton("First person inspect animation", 127723829978984, function() -- Line: 1678
            -- upvalues: u243 (ref), CloseStage (ref), Vector3_new_ret (ref), u219 (ref), u1 (ref), u192 (ref), u177 (copy), u32 (ref), u206 (ref), u178 (copy), u176 (copy), FirstPerson (copy), u164 (copy), u165 (copy), u173 (copy), u174 (copy), u171 (copy), u168 (copy), u4 (ref), u217 (ref), u218 (ref)
            u243 = u243 + 1;
            local v265 = u243;
            CloseStage(true);
            Vector3_new_ret = Vector3.new(-0.8, -5.5, 0);
            u219 = true;
            u1.SetTransparency(u192, true);

            if u177.Class == "Gloves" then
                local v266, v267 = u1.GlovesModel(u177, u178, u176);
                u32 = v266;
                u206 = v267;
            else
                FirstPerson({
                    Name = u164,
                    Skin = u165,
                    Mode = 1,
                    KillTrack = u173,
                    KillTrackColor = u174,
                    NameTag = u171,
                    Stickers = u168,
                    Data = u177.Data,
                    SilentEvents = true
                }, {
                    Scale = 1,
                    CFrame = workspace.CurrentCamera.CFrame,
                    Parent = workspace
                });
            end;

            u4.Main.DownBar.Description.Visible = false;

            for i = 1, 70 do
                u217 = u217 - (u217 - 70) * 0.05;
                u218 = u218 - (u218 - 70) * 0.05;
                task.wait(0.003);

                if u243 ~= v265 then
                    return;
                end;

                local _ = i;
            end;
        end, "Second");
    end;

    if u22.AnimationIds[u22.GetWeaponClass(u164)] then
        local v268 = u178.Sides or u177.GuiInformation.Sides;
        local u269 = {};

        for _, v in { "CT", "T" } do
            if v268[v] then
                table.insert(u269, v);
            end;
        end;

        local Attribute = LocalPlayer:GetAttribute("Team");
        local u270 = table.find(u269, Attribute) and Attribute and Attribute or u269[1];

        local function ShowTeam(p271: string) -- Line: 1735
            -- upvalues: OpenStage (ref), u176 (copy), u23 (ref), u164 (copy), u165 (copy)
            local v272 = u23.GetLoadoutData()[p271]["15"];
            OpenStage(u176, p271, v272 and v272.SkinName or `{p271} Agent`, u164, u165);
        end;

        u1.CreateButton("Inspect in agent hands", 119770067780750, function() -- Line: 1739
            -- upvalues: u243 (ref), u31 (ref), u3 (ref), u18 (ref), u32 (ref), Vector3_new_ret (ref), CFrame_Angles_ret (ref), CFrame_Angles_ret2 (ref), u219 (ref), u1 (ref), u192 (ref), u4 (ref), u270 (copy), OpenStage (ref), u176 (copy), u23 (ref), u164 (copy), u165 (copy), SetPicker (ref), u269 (copy), ShowTeam (copy), u217 (ref), u218 (ref)
            u243 = u243 + 1;
            local v273 = u243;

            if u31 ~= nil then
                u3:Remove("RenderStep");
                u18.Destroy(u31);
                u31 = nil;
            end;

            if u32 then
                u32:Destroy();
                u32 = nil;
            end;

            Vector3_new_ret = Vector3.new();
            CFrame_Angles_ret = CFrame.identity;
            CFrame_Angles_ret2 = CFrame.identity;
            u219 = false;
            u1.SetTransparency(u192, true);
            u4.Main.DownBar.Description.Visible = true;
            local v274 = u270;
            local v275 = u23.GetLoadoutData()[v274]["15"];
            OpenStage(u176, v274, v275 and v275.SkinName or `{v274} Agent`, u164, u165);
            SetPicker("TEAM", u269, u270, ShowTeam);

            for i = 1, 50 do
                u217 = u217 - (u217 - 50) * 0.05;
                u218 = u218 - (u218 - 50) * 0.05;
                task.wait(0.003);

                if u243 ~= v273 then
                    return;
                end;

                local _ = i;
            end;
        end, "Third");
    end;

    u24 = v250;
    v250.BackgroundTransparency = 0;
    v250.IconBT.ImageColor3 = Color3.fromRGB(0, 0, 0);

    if u38 then
        u28 = false;
        task.spawn(function() -- Line: 1776
            -- upvalues: u218 (ref)
            for i = 1, 50 do
                u218 = u218 - (u218 - 50) * 0.05;
                task.wait(0.02);
                local _ = i;
            end;
        end);

        return;
    end;

    if u2.Handler.CaseInspect.Visible then
        u2.Handler.CaseInspect.Visible = false;
        u26 = true;
        u13.SetModelVisible(false);
    end;

    u27 = p169;
    u2.Handler.Fade.Position = UDim2.fromScale(2, 0.5);
    TweenService:Create(u2.Handler.Fade, TweenInfo.new(0.75, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
        Position = UDim2.fromScale(-1, 0.5)
    }):Play();
    task.delay(0.07, function() -- Line: 1798
        -- upvalues: u4 (ref), u28 (ref), ResetRigNeck (ref), Lighting (ref), u20 (ref), u2 (ref), u217 (ref), u218 (ref)
        if not (u4 and u4.Parent) then
            u28 = false;

            return;
        end;

        local Scene = workspace:FindFirstChild("Scene");

        if Scene then
            ResetRigNeck(Scene);
        end;

        if Lighting:FindFirstChild("2") then
            Lighting["2"].Enabled = false;
        end;

        if Lighting:FindFirstChild("1") then
            Lighting["1"].Enabled = true;
        end;

        u20.Enabled("CaseInspect", false);

        if Lighting:FindFirstChild("UI_Blur") then
            Lighting.UI_Blur.Size = 0;
        end;

        u2.Handler.MainMenu.Visible = false;
        u2.Handler.DOTS.Visible = false;
        u4.Visible = true;
        u28 = false;

        for i = 1, 50 do
            u217 = u217 - (u217 - 50) * 0.05;
            u218 = u218 - (u218 - 50) * 0.05;
            task.wait(0.02);
            local _ = i;
        end;
    end);
end;

local function EnterStickerMode(p276: string) -- Line: 1833
    -- upvalues: u44 (ref), u3 (ref), u48 (copy), u4 (ref), u42 (ref), TweenService (copy), u6 (ref), Workspace (copy)
    u44 = p276;
    u3:Removes(
        "InpectInputBegan",
        "InpectInputEnded",
        "InpectInputChanged",
        "InpectPinch",
        "InpectInputAfk",
        "First_MouseEnter",
        "First_MouseLeave",
        "First_Click",
        "Second_MouseEnter",
        "Second_MouseLeave",
        "Second_Click",
        "Third_MouseEnter",
        "Third_MouseLeave",
        "Third_Click",
        "NameTagInspectBtnApply",
        "NameTagInspectBtnRemove",
        "KillTrackInspectBtnApply",
        "KillTrackInspectBtnRemove",
        "KillTrackColorInspectBtnApply"
    );

    for _, v in u48 do
        v:Destroy();
    end;

    table.clear(u48);

    for _, child in u4.Main.DownBar.RightDown:GetChildren() do
        if child:IsA("GuiButton") and child.Name ~= "CloseButton" then
            child.Visible = false;
        end;
    end;

    for _, v in u42 do
        v.CanQuery = true;
    end;

    u4.Main.DownBar.Description.Visible = false;
    u4.Main.NoCollectionFrame.Visible = false;
    u4.Main.StickerApplying.Visible = true;
    TweenService:Create(u4.Main.StickerApplying.Title, TweenInfo.new(0.2), {
        TextTransparency = 0
    }):Play();

    if u6.IsLockedToScene() then
        Workspace.Camera.FieldOfView = 40;
    end;
end;

function u1.StickerApply(u277: string, u278: string, u279: string, u280: string) -- Line: 1866
    -- upvalues: u7 (ref), u17 (ref), u11 (ref), u15 (ref), u40 (ref), u1 (copy), EnterStickerMode (copy), u41 (ref), u42 (ref), Workspace (copy), u4 (ref), u45 (ref), u47 (ref), u46 (ref), TweenService (copy), u8 (ref), u39 (copy), u21 (ref), LocalPlayer (copy), u3 (ref), UserInputService (copy), RunService (copy), u6 (ref), u18 (ref), u14 (ref)
    local v281 = u7.Get(u277);
    local WeaponSkin = u17.GetWeaponSkin(u277, u278);
    local u282 = u11.Get().Equipment[u277][u278][u279];
    local Item = u15.GetItem("Stickers", u280);
    u1.Item(u277, u278, WeaponSkin.Rarity, WeaponSkin.Description or v281.GuiInformation.Description, u282.Stickers, nil, nil, u282.NameTag, u279, u282.KillTrack, u282.KillTrackColor);

    if u40 == u40 then
        return;
    end;

    EnterStickerMode("Apply");
    local v283 = u40;
    local u284 = u41;
    local u285 = u42;
    local CurrentCamera = Workspace.CurrentCamera;
    local StickerApplying = u4.Main.StickerApplying;
    local StickerThing = u4.Main.StickerThing;
    local ApplySticker = u4.Main.DownBar.RightDown.ApplySticker;
    local ApplySticker2 = StickerThing.ApplySticker;
    local Cancel = StickerThing.Cancel;
    StickerApplying.UseOn.Text = `<font weight="medium">Use on</font> {v281.DisplayName or u277} | {WeaponSkin.DisplayName or u278}`;
    StickerApplying.Title.Text = "Loading Sticker...";
    StickerApplying.Title.TextTransparency = 0;
    StickerApplying.Null.Visible = true;
    StickerThing.ImageLabel.Image = Item.Asset;
    StickerThing.ImageLabel.Rotation = 0;
    StickerThing.RotationText.Text = "0°";
    StickerThing.Visible = false;
    u45 = 2;
    u47.SetValue(u45, true);
    u46.Scroll.Interactable = true;
    TweenService:Create(StickerApplying.Title, TweenInfo.new(0.6, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), {
        TextTransparency = 0.5
    }):Play();
    ApplySticker2.BackgroundColor3 = Color3.fromRGB(15, 158, 87);
    ApplySticker2.TextLabel.TextTransparency = 0;
    Cancel.BackgroundTransparency = 0.8;
    Cancel.UIStroke.Transparency = 0.5;
    Cancel.TextLabel.TextTransparency = 0.5;
    ApplySticker.BackgroundColor3 = Color3.fromRGB(11, 121, 66);
    ApplySticker.TextLabel.TextTransparency = 0.5;
    ApplySticker.Visible = true;
    local RaycastParams_new_ret = RaycastParams.new();
    RaycastParams_new_ret.FilterType = Enum.RaycastFilterType.Include;
    RaycastParams_new_ret.FilterDescendantsInstances = u285;
    local v286 = CurrentCamera:WorldToScreenPoint(u284.Position);
    local Vector2_new_ret = Vector2.new(v286.X, v286.Y);
    local Position = u284.Position;
    local u287 = 0;
    local Display = v283:FindFirstChild("Display");
    local u288 = not Display and {} or Display:QueryDescendants("BasePart");

    local function Free(p289: vector) -- Line: 1928
        -- upvalues: u288 (ref)
        for _, v in u288 do
            local v290 = v.CFrame:PointToObjectSpace(p289);
            local v291 = v.Size / 2 + Vector3.new(0.25, 0.25, 0.25);

            if math.abs(v290.X) <= v291.X and (math.abs(v290.Y) <= v291.Y and math.abs(v290.Z) <= v291.Z) then
                return false;
            end;
        end;

        return true;
    end;

    local function Aim() -- Line: 1941
        -- upvalues: CurrentCamera (copy), Vector2_new_ret (ref), Workspace (ref), RaycastParams_new_ret (copy), Free (copy), Position (ref)
        local v292 = CurrentCamera:ScreenPointToRay(Vector2_new_ret.X, Vector2_new_ret.Y);
        local v293 = Workspace:Raycast(v292.Origin, v292.Direction * 100, RaycastParams_new_ret);

        if v293 and Free(v293.Position) then
            Position = v293.Position;
        end;
    end;

    local v294 = CurrentCamera:ScreenPointToRay(Vector2_new_ret.X, Vector2_new_ret.Y);
    local v295 = Workspace:Raycast(v294.Origin, v294.Direction * 100, RaycastParams_new_ret);

    if v295 and Free(v295.Position) then
        Position = v295.Position;
    end;

    local u296 = u8:CreateEditMeshPart();

    if not u296 then
        warn("Sticker preview skipped: EditableMesh budget exhausted");

        return;
    end;

    local meshPart = u296.meshPart;

    if not v283.Parent then
        meshPart:Destroy();
        u296.editableMesh:Destroy();

        return;
    end;

    meshPart.TextureID = Item.Asset;
    meshPart.Material = Enum.Material.Metal;
    meshPart.Transparency = 1;

    if Item.SurfaceAppereance then
        Item.SurfaceAppereance:Clone().Parent = meshPart;
    end;

    meshPart.Parent = v283;
    table.insert(u39, u296);
    u8:ProjectMeshAsync(u296, u285, {}, 0);

    if not v283.Parent then
        return;
    end;

    local u297 = false;
    local u298 = false;
    local u299 = nil;
    local u300 = nil;
    local Vector2_zero = Vector2.zero;
    local u301 = 0;
    local u302 = 0;
    local u303 = 40;
    local u304 = 40;
    local u305 = 0;
    local u306 = nil;
    local u307 = Position;
    local u308 = u287;
    local u309 = false;
    local u310 = u45;
    local RotateLeft = StickerThing.RotateLeft;
    local RotateRight = StickerThing.RotateRight;
    local v311 = u21();
    local u312 = 0;
    local u313 = 0;
    local u314 = nil;
    RotateLeft.Visible = v311 ~= "PC";
    RotateRight.Visible = v311 ~= "PC";
    RotateLeft.TextLabel.Text = v311 == "Console" and "LT" or "-15°";
    RotateRight.TextLabel.Text = v311 == "Console" and "RT" or "+15°";

    local function OnRotateButton(p315) -- Line: 2000
        -- upvalues: LocalPlayer (ref), RotateLeft (copy), RotateRight (copy), u46 (ref)
        for _, v in LocalPlayer.PlayerGui:GetGuiObjectsAtPosition(p315.Position.X, p315.Position.Y) do
            if v == RotateLeft or (v == RotateRight or v == u46.Scroll) then
                return true;
            end;
        end;

        return false;
    end;

    local function ReleaseRotate() -- Line: 2010
        -- upvalues: u312 (ref), u314 (ref), RotateLeft (copy), RotateRight (copy), TweenService (ref)
        u312 = 0;
        u314 = nil;

        for _, v in { RotateLeft, RotateRight } do
            TweenService:Create(v, TweenInfo.new(0.25), {
                BackgroundTransparency = 0.8
            }):Play();
        end;
    end;

    for i, v in {
        [-1] = RotateLeft,
        [1] = RotateRight
    } do
        u3:Add(`StickerRotate{i}`, v.InputBegan:Connect(function(p316) -- Line: 2019
            -- upvalues: u297 (ref), u312 (ref), u313 (ref), u314 (ref), i (copy), u287 (ref), TweenService (ref), v (copy)
            if u297 or p316.UserInputType ~= Enum.UserInputType.MouseButton1 and p316.UserInputType ~= Enum.UserInputType.Touch then
                return;
            end;

            local os_clock_ret = os.clock();
            u312 = i;
            u313 = os_clock_ret;
            u314 = p316;
            u287 = math.clamp(u287 + i * 15, -355, 355);
            TweenService:Create(v, TweenInfo.new(0.1), {
                BackgroundTransparency = 0.6
            }):Play();
        end));
    end;

    local function SetDragging(p317: boolean) -- Line: 2031
        -- upvalues: u298 (ref), meshPart (copy)
        u298 = p317;
        meshPart.Transparency = p317 and 0.6 or 0.03;
    end;

    u3:Add("InpectInputBegan", UserInputService.InputBegan:Connect(function(p318) -- Line: 2037
        -- upvalues: u297 (ref), u305 (ref), u299 (ref), OnRotateButton (copy), Vector2_new_ret (ref), CurrentCamera (copy), Workspace (ref), RaycastParams_new_ret (copy), Free (copy), Position (ref), u298 (ref), meshPart (copy)
        if u297 then
            return;
        end;

        if p318.KeyCode == Enum.KeyCode.DPadUp then
            u305 = -1;
        elseif p318.KeyCode == Enum.KeyCode.DPadDown then
            u305 = 1;
        end;

        if p318.UserInputType == Enum.UserInputType.MouseButton1 or p318.UserInputType == Enum.UserInputType.Touch and not u299 then
            if OnRotateButton(p318) then
                return;
            end;

            u299 = p318.UserInputType == Enum.UserInputType.Touch and p318 and p318 or nil;
            Vector2_new_ret = Vector2.new(p318.Position.X, p318.Position.Y);
            local v319 = CurrentCamera:ScreenPointToRay(Vector2_new_ret.X, Vector2_new_ret.Y);
            local v320 = Workspace:Raycast(v319.Origin, v319.Direction * 100, RaycastParams_new_ret);

            if v320 and Free(v320.Position) then
                Position = v320.Position;
            end;

            u298 = true;
            meshPart.Transparency = 0.6;
        end;
    end));
    u3:Add("InpectInputEnded", UserInputService.InputEnded:Connect(function(p321) -- Line: 2061
        -- upvalues: u305 (ref), u298 (ref), u299 (ref), meshPart (copy), u314 (ref), ReleaseRotate (copy), u302 (ref), u301 (ref)
        if p321.KeyCode == Enum.KeyCode.DPadUp or p321.KeyCode == Enum.KeyCode.DPadDown then
            u305 = 0;
        end;

        if u298 and (p321.UserInputType == Enum.UserInputType.MouseButton1 or p321 == u299) then
            u299 = nil;
            u298 = false;
            meshPart.Transparency = 0.03;
        end;

        if u314 and (p321 == u314 or p321.UserInputType == Enum.UserInputType.MouseButton1 and u314.UserInputType == Enum.UserInputType.MouseButton1) then
            ReleaseRotate();
        end;

        if p321.KeyCode == Enum.KeyCode.ButtonR2 then
            u302 = 0;

            return;
        end;

        if p321.KeyCode == Enum.KeyCode.ButtonL2 then
            u301 = 0;
        end;
    end));
    u3:Add("InpectInputChanged", UserInputService.InputChanged:Connect(function(p322) -- Line: 2082
        -- upvalues: Vector2_zero (ref), u302 (ref), u301 (ref), u297 (ref), u298 (ref), u299 (ref), Vector2_new_ret (ref), CurrentCamera (copy), Workspace (ref), RaycastParams_new_ret (copy), Free (copy), Position (ref), UserInputService (ref), u304 (ref), u287 (ref)
        if p322.KeyCode == Enum.KeyCode.Thumbstick2 then
            Vector2_zero = Vector2.new(p322.Position.X, -p322.Position.Y);
        elseif p322.KeyCode == Enum.KeyCode.ButtonR2 then
            u302 = p322.Position.Z;
        elseif p322.KeyCode == Enum.KeyCode.ButtonL2 then
            u301 = p322.Position.Z;
        end;

        if u297 then
            return;
        end;

        if u298 and (p322.UserInputType == Enum.UserInputType.MouseMovement or p322 == u299) then
            Vector2_new_ret = Vector2.new(p322.Position.X, p322.Position.Y);
            local v323 = CurrentCamera:ScreenPointToRay(Vector2_new_ret.X, Vector2_new_ret.Y);
            local v324 = Workspace:Raycast(v323.Origin, v323.Direction * 100, RaycastParams_new_ret);

            if v324 and Free(v324.Position) then
                Position = v324.Position;
            end;
        elseif p322.UserInputType == Enum.UserInputType.MouseWheel then
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
                u304 = math.clamp(u304 - p322.Position.Z * 4, 15, 50);

                return;
            end;

            u287 = math.clamp(u287 + p322.Position.Z * 5, -355, 355);
        end;
    end));
    u3:Add("InpectPinch", UserInputService.TouchPinch:Connect(function(p325, p326, p327, p328) -- Line: 2107
        -- upvalues: u306 (ref), u304 (ref)
        if p328 == Enum.UserInputState.Begin then
            u306 = u304;

            return;
        end;

        if u306 and p328 == Enum.UserInputState.Change then
            u304 = math.clamp(u306 / p326, 15, 50);
        end;
    end));
    u3:Add("InpectRotate", UserInputService.TouchRotate:Connect(function(p329, p330, p331, p332) -- Line: 2115
        -- upvalues: u297 (ref), u300 (ref), u287 (ref)
        if u297 then
            return;
        end;

        if p332 == Enum.UserInputState.Begin then
            u300 = u287;

            return;
        end;

        if u300 and p332 == Enum.UserInputState.Change then
            u287 = math.clamp(u300 + p330, -355, 355);
        end;
    end));
    u3:Add("InpectInputAfk", RunService.PostSimulation:Connect(function(p333) -- Line: 2127
        -- upvalues: u304 (ref), u305 (ref), u303 (ref), u6 (ref), Workspace (ref), u297 (ref), Vector2_zero (ref), CurrentCamera (copy), Vector2_new_ret (ref), RaycastParams_new_ret (copy), Free (copy), Position (ref), u287 (ref), u302 (ref), u301 (ref), u312 (ref), u313 (ref), StickerThing (copy), u309 (ref), u310 (ref), u45 (ref), u307 (ref), u308 (ref), u296 (copy), u8 (ref), u285 (copy), u18 (ref), u284 (copy), u282 (copy), StickerApplying (copy), TweenService (ref), meshPart (copy)
        u304 = math.clamp(u304 + u305 * p333 * 30, 15, 50);
        u303 = u303 + (u304 - u303) * math.clamp(p333 * 15, 0, 1);

        if u6.IsLockedToScene() then
            Workspace.Camera.FieldOfView = u303;
        end;

        if not u297 then
            if Vector2_zero.Magnitude > 0.2 then
                local ViewportSize = CurrentCamera.ViewportSize;
                Vector2_new_ret = Vector2.new(math.clamp(Vector2_new_ret.X + Vector2_zero.X * p333 * 400, 0, ViewportSize.X), (math.clamp(Vector2_new_ret.Y + Vector2_zero.Y * p333 * 400, 0, ViewportSize.Y)));
                local v334 = CurrentCamera:ScreenPointToRay(Vector2_new_ret.X, Vector2_new_ret.Y);
                local v335 = Workspace:Raycast(v334.Origin, v334.Direction * 100, RaycastParams_new_ret);

                if v335 and Free(v335.Position) then
                    Position = v335.Position;
                end;
            end;

            u287 = math.clamp(u287 + (u302 - u301) * p333 * 180, -355, 355);

            if u312 ~= 0 and os.clock() - u313 > 0.3 then
                u287 = math.clamp(u287 + u312 * p333 * 120, -355, 355);
            end;
        end;

        StickerThing.RotationText.Text = `{math.round(u287) % 360}°`;

        if u309 and (u310 == u45 and ((u307 - Position).Magnitude < 0.0001 and math.abs(u308 - u287) < 0.001)) then
            return;
        end;

        u307 = u307:Lerp(Position, 0.2);
        u308 = u308 + (u287 - u308) * 0.2;

        if (u307 - Position).Magnitude < 0.002 and math.abs(u308 - u287) < 0.05 then
            u307 = Position;
            u308 = u287;
        end;

        u310 = u45;
        u296:Clear();
        u8:ProjectMeshAsync(u296, u285, { u18.StickerProjector(u284, 1, u284.CFrame:PointToObjectSpace(u307), u308, u45) }, #u282.Stickers);
        u296:Update();

        if not u309 then
            StickerApplying.Title.Text = `Apply Sticker {#u282.Stickers + 1}/3`;
            StickerThing.Position = UDim2.fromScale(0.5, 0.93);
            StickerThing.Visible = true;
            TweenService:Create(StickerApplying.Title, TweenInfo.new(0.3), {
                TextTransparency = 0
            }):Play();
            meshPart.Transparency = 0.03;
            TweenService:Create(StickerThing, TweenInfo.new(0.4, Enum.EasingStyle.Quint), {
                Position = UDim2.fromScale(0.5, 0.9)
            }):Play();
        end;

        u309 = true;
    end));
    u3:Add("ConfirmButton_MouseEnter", ApplySticker2.MouseEnter:Connect(function() -- Line: 2182
        -- upvalues: u297 (ref), TweenService (ref), ApplySticker2 (copy)
        if u297 then
            return;
        end;

        TweenService:Create(ApplySticker2, TweenInfo.new(0.25), {
            BackgroundColor3 = Color3.fromRGB(18, 188, 103)
        }):Play();
    end));
    u3:Add("ConfirmButton_MouseLeave", ApplySticker2.MouseLeave:Connect(function() -- Line: 2190
        -- upvalues: u297 (ref), TweenService (ref), ApplySticker2 (copy)
        if u297 then
            return;
        end;

        TweenService:Create(ApplySticker2, TweenInfo.new(0.25), {
            BackgroundColor3 = Color3.fromRGB(15, 158, 87)
        }):Play();
    end));
    u3:Add("ConfirmButton_MouseClick", ApplySticker2.MouseButton1Click:Connect(function() -- Line: 2198
        -- upvalues: u297 (ref), u46 (ref), u298 (ref), u299 (ref), meshPart (copy), ApplySticker (copy), ApplySticker2 (copy), Cancel (copy)
        if u297 then
            return;
        end;

        u297 = true;
        u46.Scroll.Interactable = false;

        if u298 then
            u299 = nil;
            u298 = false;
            meshPart.Transparency = 0.03;
        end;

        ApplySticker.BackgroundColor3 = Color3.fromRGB(15, 158, 87);
        ApplySticker.TextLabel.TextTransparency = 0;
        ApplySticker2.BackgroundColor3 = Color3.fromRGB(11, 121, 66);
        ApplySticker2.TextLabel.TextTransparency = 0.5;
        Cancel.UIStroke.Transparency = 0;
        Cancel.TextLabel.TextTransparency = 0;
    end));
    u3:Add("CancelButton_MouseEnter", Cancel.MouseEnter:Connect(function() -- Line: 2219
        -- upvalues: u297 (ref), TweenService (ref), Cancel (copy)
        if not u297 then
            return;
        end;

        TweenService:Create(Cancel, TweenInfo.new(0.25), {
            BackgroundTransparency = 0.7
        }):Play();
    end));
    u3:Add("CancelButton_MouseLeave", Cancel.MouseLeave:Connect(function() -- Line: 2227
        -- upvalues: u297 (ref), TweenService (ref), Cancel (copy)
        if not u297 then
            return;
        end;

        TweenService:Create(Cancel, TweenInfo.new(0.25), {
            BackgroundTransparency = 0.8
        }):Play();
    end));
    u3:Add("CancelButton_MouseClick", Cancel.MouseButton1Click:Connect(function() -- Line: 2235
        -- upvalues: u297 (ref), u46 (ref), Cancel (copy), ApplySticker2 (copy), ApplySticker (copy)
        if not u297 then
            return;
        end;

        u297 = false;
        u46.Scroll.Interactable = true;
        Cancel.UIStroke.Transparency = 0.5;
        Cancel.TextLabel.TextTransparency = 0.5;
        Cancel.BackgroundTransparency = 0.8;
        ApplySticker2.BackgroundColor3 = Color3.fromRGB(15, 158, 87);
        ApplySticker2.TextLabel.TextTransparency = 0;
        ApplySticker.BackgroundColor3 = Color3.fromRGB(11, 121, 66);
        ApplySticker.TextLabel.TextTransparency = 0.5;
    end));
    u3:Add("ApplySticker_MouseEnter", ApplySticker.MouseEnter:Connect(function() -- Line: 2252
        -- upvalues: u297 (ref), TweenService (ref), ApplySticker (copy)
        if not u297 then
            return;
        end;

        TweenService:Create(ApplySticker, TweenInfo.new(0.25), {
            BackgroundColor3 = Color3.fromRGB(18, 188, 103)
        }):Play();
    end));
    u3:Add("ApplySticker_MouseLeave", ApplySticker.MouseLeave:Connect(function() -- Line: 2260
        -- upvalues: u297 (ref), TweenService (ref), ApplySticker (copy)
        if not u297 then
            return;
        end;

        TweenService:Create(ApplySticker, TweenInfo.new(0.25), {
            BackgroundColor3 = Color3.fromRGB(15, 158, 87)
        }):Play();
    end));
    u3:Add("ApplySticker_MouseClick", ApplySticker.MouseButton1Click:Connect(function() -- Line: 2268
        -- upvalues: u297 (ref), u14 (ref), u277 (copy), u278 (copy), u279 (copy), u280 (copy), u284 (copy), Position (ref), u287 (ref), u45 (ref), u1 (ref)
        if not u297 then
            return;
        end;

        u14.Gui.ApplySticker.Fire({
            WeaponName = u277,
            SkinName = u278,
            SkinId = u279,
            StickerName = u280,
            Position = u284.CFrame:PointToObjectSpace(Position),
            Rotation = math.round(u287) % 360,
            Size = u45
        });
        u1.Close();
    end));
end;

function u1.StickerRemove(u336: string, u337: string, u338: string) -- Line: 2289
    -- upvalues: u7 (ref), u17 (ref), u11 (ref), u40 (ref), u1 (copy), EnterStickerMode (copy), u43 (ref), u4 (ref), TweenService (copy), u15 (ref), u3 (ref), u12 (ref), u14 (ref)
    local v339 = u7.Get(u336);
    local WeaponSkin = u17.GetWeaponSkin(u336, u337);
    local v340 = u11.Get().Equipment[u336][u337][u338];
    local Stickers = v340.Stickers;
    u1.Item(u336, u337, WeaponSkin.Rarity, WeaponSkin.Description or v339.GuiInformation.Description, Stickers, nil, nil, v340.NameTag, u338, v340.KillTrack, v340.KillTrackColor);

    if u40 == u40 then
        return;
    end;

    EnterStickerMode("Remove");
    local u341 = u43;
    local StickerApplying = u4.Main.StickerApplying;
    local Stickers2 = u4.Main.Stickers;
    local RemoveSticker = u4.Main.DownBar.RightDown.RemoveSticker;
    StickerApplying.UseOn.Text = `<font weight="medium">Remove a sticker from</font> {v339.DisplayName or u336} | {WeaponSkin.DisplayName or u337}`;
    StickerApplying.Title.Text = "Remove Sticker";
    StickerApplying.Null.Visible = false;
    Stickers2.Position = UDim2.fromScale(0.5, 0.93);
    Stickers2.Visible = true;
    RemoveSticker.Visible = true;
    TweenService:Create(Stickers2, TweenInfo.new(0.4, Enum.EasingStyle.Quint), {
        Position = UDim2.fromScale(0.5, 0.9)
    }):Play();
    local u342 = 1;

    for _, child in Stickers2:GetChildren() do
        if child:IsA("ImageButton") then
            child:Destroy();
        end;
    end;

    for i, v in Stickers do
        local u343 = u1.stickerRemoveFrame(Stickers2, u15.GetItem("Stickers", v.StickerName).Thumbnail);
        u343.SelectedFrame.Visible = i == u342;
        u343.LayoutOrder = i;
        u3:Add(`{i}Sticker_MouseEnter`, u343.MouseEnter:Connect(function() -- Line: 2331
            -- upvalues: TweenService (ref), u343 (copy)
            TweenService:Create(u343, TweenInfo.new(0.25), {
                Size = UDim2.fromScale(1.05, 1.05)
            }):Play();
        end));
        u3:Add(`{i}Sticker_MouseLeave`, u343.MouseLeave:Connect(function() -- Line: 2335
            -- upvalues: TweenService (ref), u343 (copy)
            TweenService:Create(u343, TweenInfo.new(0.25), {
                Size = UDim2.fromScale(1, 1)
            }):Play();
        end));
        u3:Add(`{i}Sticker_MouseClick`, u343.MouseButton1Click:Connect(function() -- Line: 2339
            -- upvalues: u342 (ref), i (copy), u341 (copy), TweenService (ref), Stickers2 (copy)
            u342 = i;
            local u344 = u341[i];

            if u344 then
                for _, v2 in u344 do
                    TweenService:Create(v2, TweenInfo.new(0.1, Enum.EasingStyle.Quint), {
                        Transparency = 0.6
                    }):Play();
                end;

                task.delay(0.1, function() -- Line: 2349
                    -- upvalues: u344 (copy), TweenService (ref)
                    for _, v2 in u344 do
                        TweenService:Create(v2, TweenInfo.new(0.5, Enum.EasingStyle.Quint), {
                            Transparency = 0.03
                        }):Play();
                    end;
                end);
            end;

            for _, child in Stickers2:GetChildren() do
                if child:IsA("ImageButton") then
                    child.SelectedFrame.Visible = child.LayoutOrder == u342;
                end;
            end;
        end));
    end;

    u3:Add("RemoveSticker_MouseEnter", RemoveSticker.MouseEnter:Connect(function() -- Line: 2364
        -- upvalues: TweenService (ref), RemoveSticker (copy)
        TweenService:Create(RemoveSticker, TweenInfo.new(0.25), {
            BackgroundColor3 = Color3.fromRGB(18, 188, 103)
        }):Play();
    end));
    u3:Add("RemoveSticker_MouseLeave", RemoveSticker.MouseLeave:Connect(function() -- Line: 2368
        -- upvalues: TweenService (ref), RemoveSticker (copy)
        TweenService:Create(RemoveSticker, TweenInfo.new(0.25), {
            BackgroundColor3 = Color3.fromRGB(15, 158, 87)
        }):Play();
    end));
    u3:Add("RemoveSticker_MouseClick", RemoveSticker.MouseButton1Click:Connect(function() -- Line: 2372
        -- upvalues: Stickers (copy), u342 (ref), u12 (ref), u14 (ref), u336 (copy), u337 (copy), u338 (copy), u1 (ref)
        local u345 = Stickers[u342];
        u12:Create("Remove Sticker", "Are you sure you want to remove this sticker? It will be destroyed.", function() -- Line: 2375
            -- upvalues: u14 (ref), u336 (ref), u337 (ref), u338 (ref), u345 (copy), u1 (ref)
            u14.Gui.RemoveSticker.Fire({
                WeaponName = u336,
                SkinName = u337,
                SkinId = u338,
                StickerName = u345.StickerName,
                Position = Vector3.new(unpack(u345.Position)),
                Rotation = math.round(u345.Rotation)
            });
            u1.Close();
        end);
    end));
end;

function u1.NameTagApply(u346: string, u347: string, u348: string, p349: string?, p350: number?) -- Line: 2392
    -- upvalues: u15 (ref), u7 (ref), u17 (ref), u4 (ref), u1 (copy), u3 (ref), u50 (ref), u51 (ref), u10 (ref), u12 (ref), u14 (ref)
    local v351 = u15.GetCategory(u346) or u7.Get(u346);
    local v352 = u15.GetItem(u346, u347) or u17.GetWeaponSkin(u346, u347);

    if not (v351 and v352) then
        return;
    end;

    if not u4.Visible then
        u1.Item(u346, u347, v352.Rarity or "Stock", v352.Description or "", nil, false, v352.Emissive, p349, u348, p350);
    end;

    u3:Removes("NameTagApplyClick", "NameTagTextChange");
    u4.Main.DownBar.Description.Visible = false;
    u4.Main.DownBar.RightDown.ApplySticker.Visible = false;
    u4.Main.DownBar.RightDown.RemoveSticker.Visible = false;
    u4.Main.DownBar.RightDown.ApplyKillTrack.Visible = false;

    if u4.Main.DownBar.RightDown:FindFirstChild("ApplyKillTrackColor") then
        u4.Main.DownBar.RightDown.ApplyKillTrackColor.Visible = false;
    end;

    if u50 then
        u50.Visible = false;
    end;

    if u51 then
        u51.Destroy();
        u51 = nil;
    end;

    if u4.Main.DownBar.RightDown:FindFirstChild("RemoveNameTag") then
        u4.Main.DownBar.RightDown.RemoveNameTag.Visible = false;
    end;

    u4.Main.StickerApplying.Visible = false;
    u4.Main.StickerThing.Visible = false;
    u4.Main.Stickers.Visible = false;
    local NoCollectionFrame = u4.Main.NoCollectionFrame;
    local v353;

    if v351 then
        v353 = v351.DisplayName or u346;
    else
        v353 = u346;
    end;

    local v354;

    if v352 then
        v354 = v352.DisplayName or u347;
    else
        v354 = u347;
    end;

    NoCollectionFrame.WeaponSkin.Text = `Rename: {v353} | {v354}`;
    NoCollectionFrame.Visible = true;
    local NameTagTextBox = u4.Main.NameTagTextBox;
    local TextBox = NameTagTextBox.TextBox;
    local NameTagViewport = u4.Main.NameTagViewport;
    local TextLabel = NameTagViewport.TextLabel;
    NameTagTextBox.Visible = true;
    NameTagViewport.Visible = true;
    u4.Main.DownBar.RightDown.ApplyNameTag.Visible = true;
    u4.Main.DownBar.RightDown.ApplyNameTag.TextLabel.Text = "APPLY NAME TAG";
    local v355 = p349 or "";
    TextBox.Text = v355;
    TextLabel.Text = v355 == "" and "ENTER NAME" or (v355 or "ENTER NAME");

    local function FilterText(p356: string) -- Line: 2451
        local string_gsub_ret = string.gsub(p356, "[\r\n\t]", "");
        local string_gsub_ret2 = string.gsub(string_gsub_ret, "[\0-\31\127]", "");

        if (utf8.len(string_gsub_ret2) or #string_gsub_ret2) > 20 then
            local v357 = 0;

            for i, _ in utf8.graphemes(string_gsub_ret2) do
                v357 = v357 + 1;

                if v357 > 20 then
                    return string.sub(string_gsub_ret2, 1, i - 1);
                end;
            end;
        end;

        return string_gsub_ret2;
    end;

    local function UpdateButtonState() -- Line: 2470
        -- upvalues: TextBox (copy), u4 (ref), TextLabel (copy)
        local v358 = string.match(TextBox.Text, "^%s*(.-)%s*$") or "";
        local v359 = utf8.len(v358) or #v358;

        if v358 == "" or v359 > 20 then
            u4.Main.DownBar.RightDown.ApplyNameTag.BackgroundColor3 = Color3.fromRGB(11, 100, 55);
            u4.Main.DownBar.RightDown.ApplyNameTag.TextLabel.TextTransparency = 0.5;
            TextLabel.Text = TextBox.Text == "" and "ENTER NAME" or (TextBox.Text or "ENTER NAME");

            return;
        end;

        u4.Main.DownBar.RightDown.ApplyNameTag.BackgroundColor3 = Color3.fromRGB(15, 158, 87);
        u4.Main.DownBar.RightDown.ApplyNameTag.TextLabel.TextTransparency = 0;
        TextLabel.Text = TextBox.Text == "" and "ENTER NAME" or (TextBox.Text or "ENTER NAME");
    end;

    UpdateButtonState();
    local Text = TextBox.Text;
    u3:Add("NameTagTextChange", TextBox:GetPropertyChangedSignal("Text"):Connect(function() -- Line: 2489
        -- upvalues: FilterText (copy), TextBox (copy), Text (ref), u10 (ref), UpdateButtonState (copy)
        local v360 = FilterText(TextBox.Text);

        if TextBox.Text ~= v360 then
            TextBox.Text = v360;
        end;

        if v360 ~= Text then
            Text = v360;

            if u10 and TextBox:IsFocused() then
                u10.Play("UI.rename_teletype");
            end;
        end;

        UpdateButtonState();
    end));
    u3:Add("NameTagApplyClick", u4.Main.DownBar.RightDown.ApplyNameTag.MouseButton1Click:Connect(function() -- Line: 2510
        -- upvalues: TextBox (copy), u346 (copy), u347 (copy), u12 (ref), u14 (ref), u348 (copy), u10 (ref), u1 (ref)
        local u361 = string.match(TextBox.Text, "^%s*(.-)%s*$") or "";
        local v362 = utf8.len(u361) or #u361;

        if u361 == "" or v362 > 20 then
            return;
        end;

        local u363 = Enums.WeaponsNum[u346];
        local u364 = Enums.Skins[u346] and Enums.Skins[u346][u347];
        u12:Create("Apply Name Tag", `Apply the name tag "{u361}"?`, function() -- Line: 2521
            -- upvalues: u14 (ref), u363 (copy), u364 (copy), u348 (ref), u361 (copy), u10 (ref), u1 (ref)
            u14.Gui.ApplyNameTag.Fire({
                WeaponName = u363,
                SkinName = u364,
                SkinId = u348,
                NameTag = u361
            });
            u1.Close();
        end);
    end));
    TextBox:CaptureFocus();
end;

function u1.NameTagRemove(p365: string, p366: string, u367: string) -- Line: 2540
    -- upvalues: u12 (ref), u14 (ref), u1 (copy)
    local u368 = Enums.WeaponsNum[p365];
    local u369 = Enums.Skins[p365] and Enums.Skins[p365][p366];
    u12:Create("Remove Name Tag", "Are you sure you want to remove this name tag?", function() -- Line: 2544
        -- upvalues: u14 (ref), u368 (copy), u369 (copy), u367 (copy), u1 (ref)
        u14.Gui.RemoveNameTag.Fire({
            WeaponName = u368,
            SkinName = u369,
            SkinId = u367
        });
        u1.Close();
    end);
end;

function u1.KillTrackApply(p370: string, p371: string, u372: string) -- Line: 2555
    -- upvalues: u12 (ref), u14 (ref), u10 (ref), u1 (copy)
    local u373 = Enums.WeaponsNum[p370];
    local u374 = Enums.Skins[p370] and Enums.Skins[p370][p371];

    if not (u373 and u374) then
        return;
    end;

    u12:Create("Apply KillTrack", "Are you sure you want to apply KillTrack?", function() -- Line: 2563
        -- upvalues: u14 (ref), u373 (copy), u374 (copy), u372 (copy), u10 (ref), u1 (ref)
        u14.Gui.ApplyKillTrack.Fire({
            WeaponName = u373,
            SkinName = u374,
            SkinId = u372
        });
        u1.Close();
    end);
end;

function u1.KillTrackRemove(p375: string, p376: string, u377: string) -- Line: 2578
    -- upvalues: u12 (ref), u14 (ref), u10 (ref), u1 (copy)
    local u378 = Enums.WeaponsNum[p375];
    local u379 = Enums.Skins[p375] and Enums.Skins[p375][p376];
    u12:Create("Remove KillTrack", "Are you sure you want to remove KillTrack?", function() -- Line: 2582
        -- upvalues: u14 (ref), u378 (copy), u379 (copy), u377 (copy), u10 (ref), u1 (ref)
        if u14 and (u14.Gui and u14.Gui.RemoveKillTrack) then
            u14.Gui.RemoveKillTrack.Fire({
                WeaponName = u378,
                SkinName = u379,
                SkinId = u377
            });
        end;

        u1.Close();
    end);
end;

function u1.KillTrackColorApply(u380: string, u381: string, u382: string, p383: string?, p384: number?, p385: any) -- Line: 2599
    -- upvalues: u15 (ref), u7 (ref), u17 (ref), u4 (ref), u1 (copy), u3 (ref), u51 (ref), u49 (ref), u50 (ref), u9 (ref), u12 (ref), u14 (ref), u10 (ref)
    local v386 = u15.GetCategory(u380) or u7.Get(u380);
    local v387 = u15.GetItem(u380, u381) or u17.GetWeaponSkin(u380, u381);

    if not (v386 and v387) then
        return;
    end;

    if not u4.Visible then
        u1.Item(u380, u381, v387.Rarity or "Stock", v387.Description or "", nil, false, v387.Emissive, p383, u382, p384, p385);
    end;

    u3:Removes(
        "NameTagApplyClick",
        "NameTagTextChange",
        "KillTrackColorApplyClick",
        "KillTrackColorInspectBtnApply",
        "KillTrackInspectBtnRemove"
    );

    if u51 then
        u51.Destroy();
        u51 = nil;
    end;

    u4.Main.DownBar.Description.Visible = false;
    u4.Main.DownBar.RightDown.ApplySticker.Visible = false;
    u4.Main.DownBar.RightDown.RemoveSticker.Visible = false;
    u4.Main.DownBar.RightDown.ApplyKillTrack.Visible = false;
    u4.Main.DownBar.RightDown.ApplyNameTag.Visible = false;

    if u4.Main.DownBar.RightDown:FindFirstChild("RemoveNameTag") then
        u4.Main.DownBar.RightDown.RemoveNameTag.Visible = false;
    end;

    if u4.Main.DownBar.RightDown:FindFirstChild("RemoveKillTrack") then
        u4.Main.DownBar.RightDown.RemoveKillTrack.Visible = false;
    end;

    u4.Main.NameTagTextBox.Visible = false;
    u4.Main.NameTagViewport.Visible = false;
    u4.Main.StickerApplying.Visible = false;
    u4.Main.StickerThing.Visible = false;
    u4.Main.Stickers.Visible = false;
    local NoCollectionFrame = u4.Main.NoCollectionFrame;
    local v388;

    if v386 then
        v388 = v386.DisplayName or u380;
    else
        v388 = u380;
    end;

    local v389;

    if v387 then
        v389 = v387.DisplayName or u381;
    else
        v389 = u381;
    end;

    NoCollectionFrame.WeaponSkin.Text = `Color KillTrack: {v388} | {v389}`;
    NoCollectionFrame.Visible = true;
    local ApplyKillTrackColor = u4.Main.DownBar.RightDown.ApplyKillTrackColor;
    ApplyKillTrackColor.Visible = true;
    ApplyKillTrackColor.TextLabel.Text = "APPLY COLOR";
    ApplyKillTrackColor.BackgroundColor3 = Color3.fromRGB(15, 158, 87);
    ApplyKillTrackColor.TextLabel.TextTransparency = 0;
    local v390 = v386 and v386.Data and v386.Data.Type == "Melee" and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(255, 102, 0);

    if p385 then
        v390 = Color3.fromRGB(p385[1], p385[2], p385[3]) or v390;
    end;

    local u391 = v390;

    if u49 then
        u49.TextColor3 = v390;
    end;

    if u50 then
        u50.AnchorPoint = Vector2.new(0.5, 1);
        u50.Position = UDim2.fromScale(0.5, 0.9);
        u50.Visible = true;
        u51 = u9.SetupColorPicker(u50, nil, v390, function(p392) -- Line: 2662
            -- upvalues: u391 (ref), u49 (ref)
            u391 = p392;

            if u49 then
                u49.TextColor3 = p392;
            end;
        end);
    end;

    u3:Add("KillTrackColorApplyClick", ApplyKillTrackColor.MouseButton1Click:Connect(function() -- Line: 2670
        -- upvalues: u380 (copy), u381 (copy), u51 (ref), u391 (ref), u12 (ref), u14 (ref), u382 (copy), u10 (ref), u1 (ref)
        local u393 = Enums.WeaponsNum[u380];
        local u394 = Enums.Skins[u380] and Enums.Skins[u380][u381];

        if not (u393 and u394) then
            return;
        end;

        local v395 = u51 and (u51.GetColor and u51.GetColor()) or u391;
        local math_round_ret = math.round(v395.R * 255);
        local math_round_ret2 = math.round(v395.G * 255);
        local math_round_ret3 = math.round(v395.B * 255);
        u12:Create("Apply KillTrack Color", "Are you sure you want to apply this KillTrack color?", function() -- Line: 2683
            -- upvalues: u14 (ref), u393 (copy), u394 (copy), u382 (ref), math_round_ret (copy), math_round_ret2 (copy), math_round_ret3 (copy), u10 (ref), u1 (ref)
            u14.Gui.ApplyKillTrackColor.Fire({
                WeaponName = u393,
                SkinName = u394,
                SkinId = u382,
                Color = { math_round_ret, math_round_ret2, math_round_ret3 }
            });
            u1.Close();
        end);
    end));
end;

function u1.Start(p396) -- Line: 2700
    -- upvalues: u2 (ref), u9 (ref), u4 (ref), u1 (copy), u46 (ref), u47 (ref), u45 (ref), u23 (ref), u56 (ref), u57 (copy), u58 (ref), u30 (ref), TweenService (copy), TweenInfo_new_ret (copy), UserInputService (copy)
    u2 = p396:GetModule("Gui");
    u9 = u2.GetComponent("Settings");
    u4 = u1.new();
    local v398, v399 = u9.NewSlider("Sticker Size", u4.Main.StickerThing, 2, 2, 1, 3, false, function(p397) -- Line: 2706
        -- upvalues: u45 (ref)
        u45 = p397;
    end, 1, "SizeSlider", nil, { 1, 2, 3 });
    u46 = v398;
    u47 = v399;
    local TextBox = u46.Value.TextBox;
    u46.AnchorPoint = Vector2.new(0.5, 0.5);
    u46.Position = UDim2.fromScale(0.5, 0.73);
    u46.Size = UDim2.fromScale(0.85, 0.2);
    u46.UIAspectRatioConstraint.AspectRatio = 9;
    u46.Scroll.Position = UDim2.fromScale(0.78, 0.5);
    u46.Scroll.Size = UDim2.fromScale(0.46, 0.8);
    u46.Value.Size = UDim2.fromScale(0.18, 0.6);
    TextBox.Interactable = false;
    TextBox.TextXAlignment = Enum.TextXAlignment.Center;
    TextBox:GetPropertyChangedSignal("Text"):Connect(function() -- Line: 2722
        -- upvalues: TextBox (copy)
        local v400 = Enums.StickerSizes[tonumber(TextBox.Text)];

        if v400 then
            TextBox.Text = v400;
        end;
    end);
    TextBox.Text = Enums.StickerSizes[u45];
    u23 = u2.GetComponent("Loadout");
    local v402, v403 = u9.NewDropDown(true, u57, "", "", function(p401) -- Line: 2735
        -- upvalues: u58 (ref)
        u58(p401);
    end, nil, "", u4.Main.DownBar.LeftHolder, 10);
    u56 = v403;
    v402.Name = "Picker";
    v402.Size = UDim2.fromScale(0.22, 1);
    v402.Visible = false;
    v402.UIAspectRatioConstraint:Destroy();
    v402.Line:Destroy();
    u9:AddConnection("Game", "HUD & UI", "Free Inspect", function(p404) -- Line: 2745
        -- upvalues: u30 (ref)
        u30 = p404;
    end);
    u1.CreateClose();
    local NoCollectionFrame = u4.Main.NoCollectionFrame;
    NoCollectionFrame.WeaponSkin:GetPropertyChangedSignal("TextBounds"):Connect(u1.FitTitle);
    NoCollectionFrame:GetPropertyChangedSignal("AbsoluteSize"):Connect(u1.FitTitle);

    for i, v in {
        [-1] = NoCollectionFrame.Previous,
        [1] = NoCollectionFrame.Next
    } do
        v.MouseEnter:Connect(function() -- Line: 2758
            -- upvalues: TweenService (ref), v (copy), TweenInfo_new_ret (ref)
            TweenService:Create(v, TweenInfo_new_ret, {
                ImageTransparency = 0
            }):Play();
        end);
        v.MouseLeave:Connect(function() -- Line: 2762
            -- upvalues: TweenService (ref), v (copy), TweenInfo_new_ret (ref)
            TweenService:Create(v, TweenInfo_new_ret, {
                ImageTransparency = 0.4
            }):Play();
        end);
        v.MouseButton1Click:Connect(function() -- Line: 2766
            -- upvalues: u1 (ref), i (copy)
            u1.Step(i);
        end);
    end;

    UserInputService.InputBegan:Connect(function(p405) -- Line: 2771
        -- upvalues: UserInputService (ref), u1 (ref)
        if UserInputService:GetFocusedTextBox() then
            return;
        end;

        if p405.KeyCode == Enum.KeyCode.Left or p405.KeyCode == Enum.KeyCode.ButtonL1 then
            u1.Step(-1);

            return;
        end;

        if p405.KeyCode == Enum.KeyCode.Right or p405.KeyCode == Enum.KeyCode.ButtonR1 then
            u1.Step(1);
        end;
    end);
end;

function u1.Init(p406) -- Line: 2788
    -- upvalues: u2 (ref), u3 (ref), u14 (ref), u5 (ref), u6 (ref), u7 (ref), u15 (ref), u8 (ref), u16 (ref), u17 (ref), u18 (ref), u19 (ref), u20 (ref), u21 (ref), u10 (ref), u11 (ref), u12 (ref), u13 (ref), u22 (ref)
    u2 = p406:GetModule("Gui");
    u3 = p406:GetModule("Maid").new();
    u14 = p406:GetModule("Network");
    u5 = p406:GetModule("RarityColors");
    u6 = p406:GetModule("CameraController");
    u7 = p406:GetModule("WeaponManager");
    u15 = p406:GetModule("ItemManager");
    u8 = p406:GetModule("ProjectDecal");
    u16 = p406:GetModule("Threads");
    u17 = p406:GetModule("SkinManager");
    u18 = p406:GetModule("Viewmodel");
    u19 = p406:GetModule("AnimationManager");
    u20 = p406:GetModule("Blur");
    u21 = p406:GetModule("GetUserPlatform");
    u10 = p406:GetModule("SoundManager");
    u11 = p406:GetModule("InventoryData");
    Enums = p406:GetModule("Enums");
    u12 = u2.GetComponent("Notify");
    u13 = p406:GetModule("CaseInspect");
    u22 = p406:GetModule("CharacterModel");
end;

function u1.new() -- Line: 2811
    -- upvalues: u2 (ref), Assets (copy), u9 (ref), u50 (ref)
    local Frame = Instance.new("Frame");
    Frame.Name = "Inspect";
    Frame.AnchorPoint = Vector2.new(0.5, 0.5);
    Frame.BackgroundTransparency = 1;
    Frame.ClipsDescendants = true;
    Frame.Position = UDim2.fromScale(0.5, 0.5);
    Frame.Size = UDim2.fromScale(1, 1);
    Frame.Visible = false;
    local Frame2 = Instance.new("Frame");
    Frame2.Name = "Main";
    Frame2.AnchorPoint = Vector2.new(0.5, 0.5);
    Frame2.BackgroundTransparency = 1;
    Frame2.Position = UDim2.fromScale(0.5, 0.5);
    Frame2.Size = UDim2.fromScale(1, 1);
    Frame2.ZIndex = 2;
    local UIAspectRatioConstraint = Instance.new("UIAspectRatioConstraint");
    UIAspectRatioConstraint.Name = "UIAspect";
    UIAspectRatioConstraint.Parent = Frame2;
    local Frame3 = Instance.new("Frame");
    Frame3.Name = "DownBar";
    Frame3.AnchorPoint = Vector2.new(0.5, 1);
    Frame3.BackgroundTransparency = 1;
    Frame3.Position = UDim2.fromScale(0.5, 1);
    Frame3.Size = UDim2.fromScale(1, 0.08);
    local Frame4 = Instance.new("Frame");
    Frame4.Name = "LeftHolder";
    Frame4.BackgroundTransparency = 1;
    Frame4.Size = UDim2.fromScale(1, 1);
    Frame4.ZIndex = 999;
    local UIPadding = Instance.new("UIPadding");
    UIPadding.Name = "PaddingHolder";
    UIPadding.PaddingBottom = UDim.new(0.2, 0);
    UIPadding.PaddingLeft = UDim.new(0.01, 0);
    UIPadding.PaddingRight = UDim.new(0.01, 0);
    UIPadding.PaddingTop = UDim.new(0.2, 0);
    UIPadding.Parent = Frame4;
    local UIListLayout = Instance.new("UIListLayout");
    UIListLayout.Name = "LayoutHolder";
    UIListLayout.FillDirection = Enum.FillDirection.Horizontal;
    UIListLayout.Padding = UDim.new(0.01, 0);
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder;
    UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Center;
    UIListLayout.Parent = Frame4;
    Frame4.Parent = Frame3;
    local Frame5 = Instance.new("Frame");
    Frame5.Name = "RightDown";
    Frame5.BackgroundTransparency = 1;
    Frame5.Size = UDim2.fromScale(1, 1);
    local UIPadding2 = Instance.new("UIPadding");
    UIPadding2.Name = "Padding";
    UIPadding2.PaddingBottom = UDim.new(0.2, 0);
    UIPadding2.PaddingLeft = UDim.new(0.01, 0);
    UIPadding2.PaddingRight = UDim.new(0.01, 0);
    UIPadding2.PaddingTop = UDim.new(0.2, 0);
    UIPadding2.Parent = Frame5;
    local UIListLayout2 = Instance.new("UIListLayout");
    UIListLayout2.Name = "UIList";
    UIListLayout2.FillDirection = Enum.FillDirection.Horizontal;
    UIListLayout2.HorizontalAlignment = Enum.HorizontalAlignment.Right;
    UIListLayout2.Padding = UDim.new(0.01, 0);
    UIListLayout2.SortOrder = Enum.SortOrder.LayoutOrder;
    UIListLayout2.VerticalAlignment = Enum.VerticalAlignment.Center;
    UIListLayout2.Parent = Frame5;
    local ImageButton = Instance.new("ImageButton");
    ImageButton.Name = "CloseButton";
    ImageButton.AutoButtonColor = false;
    ImageButton.BackgroundTransparency = 1;
    ImageButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255);
    ImageButton.Size = UDim2.fromScale(0.06, 1);
    ImageButton.LayoutOrder = 10;
    local UICorner = Instance.new("UICorner");
    UICorner.Name = "CornerClose";
    UICorner.CornerRadius = UDim.new(0.1, 0);
    UICorner.Parent = ImageButton;
    local TextLabel = Instance.new("TextLabel");
    TextLabel.Name = "CloseText";
    TextLabel.AnchorPoint = Vector2.new(0.5, 0.5);
    TextLabel.BackgroundTransparency = 1;
    TextLabel.FontFace = Font.new("rbxasset://fonts/families/Oswald.json");
    TextLabel.Position = UDim2.fromScale(0.5, 0.5);
    TextLabel.Size = UDim2.fromScale(0.9, 0.6);
    TextLabel.Text = "CLOSE";
    TextLabel.TextColor3 = Color3.new(1, 1, 1);
    TextLabel.TextScaled = true;
    TextLabel.TextStrokeColor3 = Color3.new(1, 1, 1);
    TextLabel.ZIndex = 343;
    TextLabel.Parent = ImageButton;
    local ImageButton2 = Instance.new("ImageButton");
    ImageButton2.Name = "ApplySticker";
    ImageButton2.AutoButtonColor = false;
    ImageButton2.BackgroundColor3 = Color3.fromRGB(15, 158, 87);
    ImageButton2.LayoutOrder = 1;
    ImageButton2.Size = UDim2.fromScale(0.12, 1);
    ImageButton2.Visible = false;
    local UICorner2 = Instance.new("UICorner");
    UICorner2.Name = "UIClose";
    UICorner2.CornerRadius = UDim.new(0.1, 0);
    UICorner2.Parent = ImageButton2;
    local TextLabel2 = Instance.new("TextLabel");
    TextLabel2.Name = "TextLabel";
    TextLabel2.AnchorPoint = Vector2.new(0.5, 0.5);
    TextLabel2.BackgroundTransparency = 1;
    TextLabel2.FontFace = Font.new("rbxasset://fonts/families/Oswald.json");
    TextLabel2.Position = UDim2.fromScale(0.5, 0.5);
    TextLabel2.Size = UDim2.fromScale(0.9, 0.7);
    TextLabel2.Text = "APPLY STICKER";
    TextLabel2.TextColor3 = Color3.new(1, 1, 1);
    TextLabel2.TextScaled = true;
    TextLabel2.TextStrokeColor3 = Color3.new(1, 1, 1);
    TextLabel2.ZIndex = 343;
    TextLabel2.Parent = ImageButton2;
    ImageButton2.Parent = Frame5;
    local ImageButton3 = Instance.new("ImageButton");
    ImageButton3.Name = "ApplyNameTag";
    ImageButton3.AutoButtonColor = false;
    ImageButton3.BackgroundColor3 = Color3.fromRGB(15, 158, 87);
    ImageButton3.LayoutOrder = 1;
    ImageButton3.Size = UDim2.fromScale(0.14, 1);
    ImageButton3.Visible = false;
    local UICorner3 = Instance.new("UICorner");
    UICorner3.Name = "UIClose";
    UICorner3.CornerRadius = UDim.new(0.1, 0);
    UICorner3.Parent = ImageButton3;
    local TextLabel3 = Instance.new("TextLabel");
    TextLabel3.Name = "TextLabel";
    TextLabel3.AnchorPoint = Vector2.new(0.5, 0.5);
    TextLabel3.BackgroundTransparency = 1;
    TextLabel3.FontFace = Font.new("rbxasset://fonts/families/Oswald.json");
    TextLabel3.Position = UDim2.fromScale(0.5, 0.5);
    TextLabel3.Size = UDim2.fromScale(0.9, 0.7);
    TextLabel3.Text = "APPLY NAME TAG";
    TextLabel3.TextColor3 = Color3.new(1, 1, 1);
    TextLabel3.TextScaled = true;
    TextLabel3.TextStrokeColor3 = Color3.new(1, 1, 1);
    TextLabel3.ZIndex = 343;
    TextLabel3.Parent = ImageButton3;
    ImageButton3.Parent = Frame5;
    local v407 = ImageButton3:Clone();
    v407.Name = "ViewGlow";
    v407.Size = UDim2.fromScale(0.12, 1);
    v407.BackgroundColor3 = Color3.fromRGB(175, 231, 255);
    v407.TextLabel.TextColor3 = Color3.fromRGB(16, 16, 16);
    v407.TextLabel.Text = "VIEW GLOW";
    v407.Parent = Frame5;
    local v408 = ImageButton3:Clone();
    v408.Name = "ApplyKillTrack";
    v408.Size = UDim2.fromScale(0.14, 1);
    v408.TextLabel.Text = "ADD KILLTRACK";
    v408.Parent = Frame5;
    local v409 = ImageButton3:Clone();
    v409.Name = "ApplyKillTrackColor";
    v409.Size = UDim2.fromScale(0.14, 1);
    v409.TextLabel.Text = "COLOR KILLTRACK";
    v409.Visible = false;
    v409.Parent = Frame5;
    local ImageButton4 = Instance.new("ImageButton");
    ImageButton4.Name = "RemoveNameTag";
    ImageButton4.AutoButtonColor = false;
    ImageButton4.BackgroundColor3 = Color3.fromRGB(180, 40, 40);
    ImageButton4.LayoutOrder = 1;
    ImageButton4.Size = UDim2.fromScale(0.16, 1);
    ImageButton4.Visible = false;
    local UICorner4 = Instance.new("UICorner");
    UICorner4.Name = "UICorner";
    UICorner4.CornerRadius = UDim.new(0.1, 0);
    UICorner4.Parent = ImageButton4;
    local TextLabel4 = Instance.new("TextLabel");
    TextLabel4.Name = "TextLabel";
    TextLabel4.AnchorPoint = Vector2.new(0.5, 0.5);
    TextLabel4.BackgroundTransparency = 1;
    TextLabel4.FontFace = Font.new("rbxasset://fonts/families/Oswald.json");
    TextLabel4.Position = UDim2.fromScale(0.5, 0.5);
    TextLabel4.Size = UDim2.fromScale(0.9, 0.7);
    TextLabel4.Text = "REMOVE NAME TAG";
    TextLabel4.TextColor3 = Color3.new(1, 1, 1);
    TextLabel4.TextScaled = true;
    TextLabel4.TextStrokeColor3 = Color3.new(1, 1, 1);
    TextLabel4.ZIndex = 343;
    TextLabel4.Parent = ImageButton4;
    ImageButton4.Parent = Frame5;
    local ImageButton5 = Instance.new("ImageButton");
    ImageButton5.Name = "RemoveKillTrack";
    ImageButton5.AutoButtonColor = false;
    ImageButton5.BackgroundColor3 = Color3.fromRGB(180, 40, 40);
    ImageButton5.LayoutOrder = 1;
    ImageButton5.Size = UDim2.fromScale(0.16, 1);
    ImageButton5.Visible = false;
    local UICorner5 = Instance.new("UICorner");
    UICorner5.Name = "UICorner";
    UICorner5.CornerRadius = UDim.new(0.1, 0);
    UICorner5.Parent = ImageButton5;
    local TextLabel5 = Instance.new("TextLabel");
    TextLabel5.Name = "TextLabel";
    TextLabel5.AnchorPoint = Vector2.new(0.5, 0.5);
    TextLabel5.BackgroundTransparency = 1;
    TextLabel5.FontFace = Font.new("rbxasset://fonts/families/Oswald.json");
    TextLabel5.Position = UDim2.fromScale(0.5, 0.5);
    TextLabel5.Size = UDim2.fromScale(0.9, 0.7);
    TextLabel5.Text = "REMOVE KILLTRACK";
    TextLabel5.TextColor3 = Color3.new(1, 1, 1);
    TextLabel5.TextScaled = true;
    TextLabel5.TextStrokeColor3 = Color3.new(1, 1, 1);
    TextLabel5.ZIndex = 343;
    TextLabel5.Parent = ImageButton5;
    ImageButton5.Parent = Frame5;
    local ImageButton6 = Instance.new("ImageButton");
    ImageButton6.Name = "RemoveSticker";
    ImageButton6.AutoButtonColor = false;
    ImageButton6.BackgroundColor3 = Color3.fromRGB(15, 158, 87);
    ImageButton6.LayoutOrder = 1;
    ImageButton6.Size = UDim2.fromScale(0.14, 1);
    local UICorner6 = Instance.new("UICorner");
    UICorner6.Name = "UIClose";
    UICorner6.CornerRadius = UDim.new(0.1, 0);
    UICorner6.Parent = ImageButton6;
    local TextLabel6 = Instance.new("TextLabel");
    TextLabel6.Name = "TextLabel";
    TextLabel6.AnchorPoint = Vector2.new(0.5, 0.5);
    TextLabel6.BackgroundTransparency = 1;
    TextLabel6.FontFace = Font.new("rbxasset://fonts/families/Oswald.json");
    TextLabel6.Position = UDim2.fromScale(0.5, 0.5);
    TextLabel6.Size = UDim2.fromScale(0.9, 0.7);
    TextLabel6.Text = "REMOVE STICKER";
    TextLabel6.TextColor3 = Color3.new(1, 1, 1);
    TextLabel6.TextScaled = true;
    TextLabel6.TextStrokeColor3 = Color3.new(1, 1, 1);
    TextLabel6.ZIndex = 343;
    TextLabel6.Parent = ImageButton6;
    ImageButton6.Parent = Frame5;
    ImageButton.Parent = Frame5;
    Frame5.Parent = Frame3;
    local Frame6 = Instance.new("Frame");
    Frame6.Name = "LineDown";
    Frame6.AnchorPoint = Vector2.new(0, 1);
    Frame6.BackgroundColor3 = Color3.new(1, 1, 1);
    Frame6.BackgroundTransparency = 0.8;
    Frame6.BorderColor3 = Color3.new();
    Frame6.BorderSizePixel = 0;
    Frame6.Size = UDim2.new(1, 0, 0, 1);
    Frame6.Parent = Frame3;
    local TextLabel7 = Instance.new("TextLabel");
    TextLabel7.Name = "Description";
    TextLabel7.AnchorPoint = Vector2.new(0.5, 1);
    TextLabel7.BackgroundTransparency = 1;
    TextLabel7.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.Medium, Enum.FontStyle.Normal);
    TextLabel7.Position = UDim2.fromScale(0.5, -0.394708);
    TextLabel7.Size = UDim2.fromScale(0.85, 1.35386);
    TextLabel7.Text = "Glock – A modern, revolutionary pistol that set new standards for service and civilian firearms. Features a unique polymer-frame design, legendary reliability, and simple maintenance. Safety is ensured by an integrated trigger safety system. Chambered in 9x19mm, .40 S&W, .45 ACP, and others.";
    TextLabel7.TextColor3 = Color3.new(1, 1, 1);
    TextLabel7.TextScaled = true;
    TextLabel7.TextStrokeColor3 = Color3.new(1, 1, 1);
    TextLabel7.TextTransparency = 0.4;
    TextLabel7.TextXAlignment = Enum.TextXAlignment.Left;
    TextLabel7.TextYAlignment = Enum.TextYAlignment.Bottom;
    TextLabel7.ZIndex = 343;
    TextLabel7.Parent = Frame3;
    Frame3.Parent = Frame2;
    local Frame7 = Instance.new("Frame");
    Frame7.Name = "TopFrame";
    Frame7.AnchorPoint = Vector2.new(0.5, 0);
    Frame7.BackgroundTransparency = 1;
    Frame7.Position = UDim2.fromScale(0.5, 0.025);
    Frame7.Size = UDim2.fromScale(0.65, 0.15);
    Frame7.Visible = false;
    local ImageLabel = Instance.new("ImageLabel");
    ImageLabel.Name = "Rarity";
    ImageLabel.AnchorPoint = Vector2.new(0.5, 1);
    ImageLabel.BackgroundTransparency = 1;
    ImageLabel.Image = "rbxassetid://186491278";
    ImageLabel.ImageTransparency = 0.8;
    ImageLabel.Position = UDim2.new(0.5, 0, 1, 2);
    ImageLabel.ScaleType = Enum.ScaleType.Slice;
    ImageLabel.Size = UDim2.new(1, 2, 0.05, 2);
    ImageLabel.SliceCenter = Rect.new(48, 48, 48, 48);
    ImageLabel.ZIndex = -9999;
    local Frame8 = Instance.new("Frame");
    Frame8.Name = "RarityFrame";
    Frame8.AnchorPoint = Vector2.new(0.5, 0.5);
    Frame8.BackgroundColor3 = Color3.fromRGB(116, 165, 255);
    Frame8.BorderColor3 = Color3.new();
    Frame8.BorderSizePixel = 0;
    Frame8.Position = UDim2.fromScale(0.5, 0.5);
    Frame8.Size = UDim2.new(1, -4, 1, -4);
    local UIGradient = Instance.new("UIGradient");
    UIGradient.Name = "UIGradient";
    UIGradient.Color = ColorSequence.new({ ColorSequenceKeypoint.new(0, Color3.new(1, 1, 1)), ColorSequenceKeypoint.new(1, Color3.fromRGB(239, 239, 239)) });
    UIGradient.Parent = Frame8;
    Frame8.Parent = ImageLabel;
    ImageLabel.Parent = Frame7;
    local ImageLabel2 = Instance.new("ImageLabel");
    ImageLabel2.Name = "IconFrame";
    ImageLabel2.BackgroundTransparency = 1;
    ImageLabel2.Image = "rbxassetid://100429874437897";
    ImageLabel2.Position = UDim2.fromScale(0.025, 0);
    ImageLabel2.Size = UDim2.fromScale(0.9, 0.9);
    ImageLabel2.SizeConstraint = Enum.SizeConstraint.RelativeYY;
    ImageLabel2.Parent = Frame7;
    local TextLabel8 = Instance.new("TextLabel");
    TextLabel8.Name = "WeaponSkin";
    TextLabel8.BackgroundTransparency = 1;
    TextLabel8.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal);
    TextLabel8.Position = UDim2.fromScale(0.275, 0.15);
    TextLabel8.Size = UDim2.fromScale(0.7, 0.4);
    TextLabel8.Text = "Glock | Test White";
    TextLabel8.TextColor3 = Color3.fromRGB(245, 245, 245);
    TextLabel8.TextScaled = true;
    TextLabel8.TextStrokeColor3 = Color3.new(1, 1, 1);
    TextLabel8.TextXAlignment = Enum.TextXAlignment.Left;
    TextLabel8.ZIndex = 343;
    TextLabel8.Parent = Frame7;
    local TextLabel9 = Instance.new("TextLabel");
    TextLabel9.Name = "Collection";
    TextLabel9.BackgroundTransparency = 1;
    TextLabel9.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.Medium, Enum.FontStyle.Normal);
    TextLabel9.Position = UDim2.fromScale(0.275, 0.55);
    TextLabel9.Size = UDim2.fromScale(0.7, 0.2);
    TextLabel9.Text = "Legacy Case";
    TextLabel9.TextColor3 = Color3.fromRGB(234, 234, 234);
    TextLabel9.TextScaled = true;
    TextLabel9.TextStrokeColor3 = Color3.new(1, 1, 1);
    TextLabel9.TextXAlignment = Enum.TextXAlignment.Left;
    TextLabel9.ZIndex = 343;
    TextLabel9.Parent = Frame7;
    Frame7.Parent = Frame2;
    local Frame9 = Instance.new("Frame");
    Frame9.Name = "NoCollectionFrame";
    Frame9.AnchorPoint = Vector2.new(0.5, 0);
    Frame9.BackgroundTransparency = 1;
    Frame9.Position = UDim2.fromScale(0.5, 0.025);
    Frame9.Size = UDim2.fromScale(0.75, 0.08);
    Frame9.Visible = false;
    local ImageLabel3 = Instance.new("ImageLabel");
    ImageLabel3.Name = "Rarity";
    ImageLabel3.AnchorPoint = Vector2.new(0.5, 1);
    ImageLabel3.BackgroundTransparency = 1;
    ImageLabel3.Image = "rbxassetid://186491278";
    ImageLabel3.ImageTransparency = 0.8;
    ImageLabel3.Position = UDim2.new(0.5, 0, 1, 2);
    ImageLabel3.ScaleType = Enum.ScaleType.Slice;
    ImageLabel3.Size = UDim2.new(0.15, 2, 0.116, 2);
    ImageLabel3.SliceCenter = Rect.new(48, 48, 48, 48);
    ImageLabel3.ZIndex = -9999;
    local Frame10 = Instance.new("Frame");
    Frame10.Name = "Frame";
    Frame10.AnchorPoint = Vector2.new(0.5, 0.5);
    Frame10.BackgroundColor3 = Color3.fromRGB(240, 241, 255);
    Frame10.BorderColor3 = Color3.new();
    Frame10.BorderSizePixel = 0;
    Frame10.Position = UDim2.fromScale(0.5, 0.5);
    Frame10.Size = UDim2.new(1, -4, 1, -4);
    local UIGradient2 = Instance.new("UIGradient");
    UIGradient2.Name = "UIGradient";
    UIGradient2.Color = ColorSequence.new({ ColorSequenceKeypoint.new(0, Color3.new(1, 1, 1)), ColorSequenceKeypoint.new(1, Color3.fromRGB(239, 239, 239)) });
    UIGradient2.Parent = Frame10;
    Frame10.Parent = ImageLabel3;
    ImageLabel3.Parent = Frame9;
    local TextLabel10 = Instance.new("TextLabel");
    TextLabel10.Name = "WeaponSkin";
    TextLabel10.BackgroundTransparency = 1;
    TextLabel10.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal);
    TextLabel10.Position = UDim2.fromScale(0, 0.212267);
    TextLabel10.Size = UDim2.fromScale(1, 0.672167);
    TextLabel10.Text = "AK-47";
    TextLabel10.TextColor3 = Color3.fromRGB(245, 245, 245);
    TextLabel10.TextScaled = true;
    TextLabel10.TextStrokeColor3 = Color3.new(1, 1, 1);
    TextLabel10.ZIndex = 343;
    TextLabel10.Parent = Frame9;
    local ImageButton7 = Instance.new("ImageButton");
    ImageButton7.Name = "Previous";
    ImageButton7.AnchorPoint = Vector2.new(1, 0.5);
    ImageButton7.BackgroundTransparency = 1;
    ImageButton7.Image = "rbxassetid://122092056328472";
    ImageButton7.ImageColor3 = Color3.fromRGB(232, 232, 232);
    ImageButton7.ImageTransparency = 0.4;
    ImageButton7.Position = UDim2.fromScale(0.35, 0.55);
    ImageButton7.ScaleType = Enum.ScaleType.Fit;
    ImageButton7.Size = UDim2.fromScale(0.42, 0.42);
    ImageButton7.SizeConstraint = Enum.SizeConstraint.RelativeYY;
    ImageButton7.Visible = false;
    ImageButton7.ZIndex = 343;
    ImageButton7.Parent = Frame9;
    local ImageButton8 = Instance.new("ImageButton");
    ImageButton8.Name = "Next";
    ImageButton8.AnchorPoint = Vector2.new(0, 0.5);
    ImageButton8.BackgroundTransparency = 1;
    ImageButton8.Image = "rbxassetid://122092056328472";
    ImageButton8.ImageColor3 = Color3.fromRGB(232, 232, 232);
    ImageButton8.ImageTransparency = 0.4;
    ImageButton8.Position = UDim2.fromScale(0.65, 0.55);
    ImageButton8.Rotation = 180;
    ImageButton8.ScaleType = Enum.ScaleType.Fit;
    ImageButton8.Size = UDim2.fromScale(0.42, 0.42);
    ImageButton8.SizeConstraint = Enum.SizeConstraint.RelativeYY;
    ImageButton8.Visible = false;
    ImageButton8.ZIndex = 343;
    ImageButton8.Parent = Frame9;
    Frame9.Parent = Frame2;
    Frame2.Parent = Frame;
    Frame.Parent = u2.Handler;
    local Frame11 = Instance.new("Frame");
    Frame11.Name = "StickerApplying";
    Frame11.AnchorPoint = Vector2.new(0.5, 0);
    Frame11.BackgroundTransparency = 1;
    Frame11.Position = UDim2.fromScale(0.5, 0.025);
    Frame11.Size = UDim2.fromScale(0.75, 0.119021);
    Frame11.Visible = false;
    local TextLabel11 = Instance.new("TextLabel");
    TextLabel11.Name = "UseOn";
    TextLabel11.BackgroundTransparency = 1;
    TextLabel11.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal);
    TextLabel11.Position = UDim2.fromScale(0, 0.532338);
    TextLabel11.RichText = true;
    TextLabel11.Size = UDim2.fromScale(1, 0.297639);
    TextLabel11.Text = "<font weight=\"medium\">Use on</font> AK-47 | Hello wrld";
    TextLabel11.TextColor3 = Color3.fromRGB(245, 245, 245);
    TextLabel11.TextScaled = true;
    TextLabel11.TextStrokeColor3 = Color3.new(1, 1, 1);
    TextLabel11.ZIndex = 343;
    TextLabel11.Parent = Frame11;
    local TextLabel12 = Instance.new("TextLabel");
    TextLabel12.Name = "Title";
    TextLabel12.BackgroundTransparency = 1;
    TextLabel12.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal);
    TextLabel12.Position = UDim2.fromScale(0, 0.0933541);
    TextLabel12.Size = UDim2.fromScale(1, 0.446561);
    TextLabel12.Text = "Apply Sticker 2/3";
    TextLabel12.TextColor3 = Color3.fromRGB(245, 245, 245);
    TextLabel12.TextScaled = true;
    TextLabel12.TextStrokeColor3 = Color3.new(1, 1, 1);
    TextLabel12.ZIndex = 343;
    TextLabel12.Parent = Frame11;
    local Frame12 = Instance.new("Frame");
    Frame12.Name = "Null";
    Frame12.AnchorPoint = Vector2.new(0.5, 0.5);
    Frame12.BackgroundTransparency = 1;
    Frame12.Position = UDim2.fromScale(0.499058, 1.01046);
    Frame12.Size = UDim2.fromScale(0.658115, 0.200571);
    local TextLabel13 = Instance.new("TextLabel");
    TextLabel13.Name = "MainText";
    TextLabel13.AnchorPoint = Vector2.new(0, 0.5);
    TextLabel13.AutoLocalize = false;
    TextLabel13.BackgroundTransparency = 1;
    TextLabel13.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.Medium, Enum.FontStyle.Normal);
    TextLabel13.LayoutOrder = 4;
    TextLabel13.Position = UDim2.fromScale(0.252835, 0.5);
    TextLabel13.Size = UDim2.fromScale(0.867165, 1.1);
    TextLabel13.Text = "A sticker can only be applied once";
    TextLabel13.TextColor3 = Color3.new(1, 1, 1);
    TextLabel13.TextScaled = true;
    TextLabel13.TextTransparency = 0.25;
    TextLabel13.TextXAlignment = Enum.TextXAlignment.Left;
    TextLabel13.ZIndex = 9;
    TextLabel13.Parent = Frame12;
    local ImageLabel4 = Instance.new("ImageLabel");
    ImageLabel4.Name = "IconInfo";
    ImageLabel4.AnchorPoint = Vector2.new(0, 0.5);
    ImageLabel4.BackgroundTransparency = 1;
    ImageLabel4.Image = "rbxassetid://80205853195967";
    ImageLabel4.Position = UDim2.fromScale(0.19, 0.5);
    ImageLabel4.Size = UDim2.fromScale(0.9, 0.9);
    ImageLabel4.SizeConstraint = Enum.SizeConstraint.RelativeYY;
    ImageLabel4.Parent = Frame12;
    Frame12.Parent = Frame11;
    local Frame13 = Instance.new("Frame");
    Frame13.Name = "Disclaimer";
    Frame13.AnchorPoint = Vector2.new(0.5, 0.5);
    Frame13.BackgroundTransparency = 1;
    Frame13.Position = UDim2.fromScale(0.5, 1.4);
    Frame13.Size = UDim2.fromScale(1.4, 0.22);
    local TextLabel14 = Instance.new("TextLabel");
    TextLabel14.Name = "MainText";
    TextLabel14.AnchorPoint = Vector2.new(0, 0.5);
    TextLabel14.AutoLocalize = false;
    TextLabel14.BackgroundTransparency = 1;
    TextLabel14.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.Medium, Enum.FontStyle.Normal);
    TextLabel14.LayoutOrder = 4;
    TextLabel14.Position = UDim2.fromScale(0.03, 0.5);
    TextLabel14.RichText = true;
    TextLabel14.Size = UDim2.fromScale(0.97, 1);
    TextLabel14.Text = "<b><font color=\"#FFA500\">PLEASE NOTE:</font></b> Placing stickers to create <b>inappropriate or explicit content</b> or anything that breaks the <b>Roblox Terms of Service</b> will get your <b><font color=\"#FF5555\">skin deleted</font></b>.";
    TextLabel14.TextColor3 = Color3.new(1, 1, 1);
    TextLabel14.TextScaled = true;
    TextLabel14.TextTransparency = 0.25;
    TextLabel14.TextXAlignment = Enum.TextXAlignment.Left;
    TextLabel14.ZIndex = 9;
    TextLabel14.Parent = Frame13;
    local ImageLabel5 = Instance.new("ImageLabel");
    ImageLabel5.Name = "IconInfo";
    ImageLabel5.AnchorPoint = Vector2.new(0, 0.5);
    ImageLabel5.BackgroundTransparency = 1;
    ImageLabel5.Image = "rbxassetid://80205853195967";
    ImageLabel5.Position = UDim2.fromScale(0, 0.5);
    ImageLabel5.Size = UDim2.fromScale(1, 1);
    ImageLabel5.SizeConstraint = Enum.SizeConstraint.RelativeYY;
    ImageLabel5.Parent = Frame13;
    Frame13.Parent = Frame11;
    Frame11.Parent = Frame2;
    local Frame14 = Instance.new("Frame");
    Frame14.Name = "StickerThing";
    Frame14.AnchorPoint = Vector2.new(0.5, 1);
    Frame14.BackgroundTransparency = 1;
    Frame14.Position = UDim2.fromScale(0.5, 0.9);
    Frame14.Size = UDim2.fromScale(0.4, 0.26);
    Frame14.Visible = false;
    local ImageButton9 = Instance.new("ImageButton");
    ImageButton9.Name = "ApplySticker";
    ImageButton9.AnchorPoint = Vector2.new(0, 1);
    ImageButton9.AutoButtonColor = false;
    ImageButton9.BackgroundColor3 = Color3.fromRGB(15, 158, 87);
    ImageButton9.LayoutOrder = 1;
    ImageButton9.Position = UDim2.fromScale(0.075, 1);
    ImageButton9.Size = UDim2.fromScale(0.4, 0.173);
    local UICorner7 = Instance.new("UICorner");
    UICorner7.Name = "UICorner";
    UICorner7.CornerRadius = UDim.new(0.1, 0);
    UICorner7.Parent = ImageButton9;
    local TextLabel15 = Instance.new("TextLabel");
    TextLabel15.Name = "TextLabel";
    TextLabel15.AnchorPoint = Vector2.new(0.5, 0.5);
    TextLabel15.BackgroundTransparency = 1;
    TextLabel15.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.Bold, Enum.FontStyle.Normal);
    TextLabel15.Position = UDim2.fromScale(0.5, 0.5);
    TextLabel15.Size = UDim2.fromScale(0.9, 0.55);
    TextLabel15.Text = "Confirm Position";
    TextLabel15.TextColor3 = Color3.new(1, 1, 1);
    TextLabel15.TextScaled = true;
    TextLabel15.TextStrokeColor3 = Color3.new(1, 1, 1);
    TextLabel15.ZIndex = 343;
    TextLabel15.Parent = ImageButton9;
    ImageButton9.Parent = Frame14;
    local ImageButton10 = Instance.new("ImageButton");
    ImageButton10.Name = "Cancel";
    ImageButton10.AnchorPoint = Vector2.new(1, 1);
    ImageButton10.AutoButtonColor = false;
    ImageButton10.BackgroundColor3 = Color3.new();
    ImageButton10.BackgroundTransparency = 0.8;
    ImageButton10.LayoutOrder = 1;
    ImageButton10.Position = UDim2.fromScale(0.925, 1);
    ImageButton10.Size = UDim2.fromScale(0.4, 0.173);
    local UICorner8 = Instance.new("UICorner");
    UICorner8.Name = "UICorner";
    UICorner8.CornerRadius = UDim.new(0.1, 0);
    UICorner8.Parent = ImageButton10;
    local TextLabel16 = Instance.new("TextLabel");
    TextLabel16.Name = "TextLabel";
    TextLabel16.AnchorPoint = Vector2.new(0.5, 0.5);
    TextLabel16.BackgroundTransparency = 1;
    TextLabel16.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.Bold, Enum.FontStyle.Normal);
    TextLabel16.Position = UDim2.fromScale(0.5, 0.5);
    TextLabel16.Size = UDim2.fromScale(0.9, 0.55);
    TextLabel16.Text = "Cancel";
    TextLabel16.TextColor3 = Color3.new(1, 1, 1);
    TextLabel16.TextScaled = true;
    TextLabel16.TextStrokeColor3 = Color3.new(1, 1, 1);
    TextLabel16.ZIndex = 343;
    TextLabel16.Parent = ImageButton10;
    local UIStroke = Instance.new("UIStroke");
    UIStroke.Name = "UIStroke";
    UIStroke.BorderStrokePosition = Enum.BorderStrokePosition.Inner;
    UIStroke.Color = Color3.new(1, 1, 1);
    UIStroke.Transparency = 0.5;
    UIStroke.Parent = ImageButton10;
    ImageButton10.Parent = Frame14;
    local ImageLabel6 = Instance.new("ImageLabel");
    ImageLabel6.Name = "ImageLabel";
    ImageLabel6.AnchorPoint = Vector2.new(0.5, 0.5);
    ImageLabel6.BackgroundTransparency = 1;
    ImageLabel6.Image = "rbxassetid://87888833441425";
    ImageLabel6.Position = UDim2.fromScale(0.5, 0.35);
    ImageLabel6.Size = UDim2.fromScale(0.5, 0.5);
    ImageLabel6.SizeConstraint = Enum.SizeConstraint.RelativeYY;
    ImageLabel6.Parent = Frame14;
    local TextLabel17 = Instance.new("TextLabel");
    TextLabel17.Name = "RotationText";
    TextLabel17.AnchorPoint = Vector2.new(0.5, 0.5);
    TextLabel17.BackgroundTransparency = 1;
    TextLabel17.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal);
    TextLabel17.Position = UDim2.fromScale(0.5, 0.6);
    TextLabel17.Size = UDim2.fromScale(0.4, 0.077);
    TextLabel17.Text = "0°";
    TextLabel17.TextColor3 = Color3.fromRGB(245, 245, 245);
    TextLabel17.TextScaled = true;
    TextLabel17.TextTransparency = 0.25;
    TextLabel17.ZIndex = 343;
    TextLabel17.Parent = Frame14;

    for _, v in { { "RotateLeft", "-15°", 0.25 }, { "RotateRight", "+15°", 0.75 } } do
        local ImageButton11 = Instance.new("ImageButton");
        ImageButton11.Name = v[1];
        ImageButton11.AnchorPoint = Vector2.new(0.5, 0.5);
        ImageButton11.AutoButtonColor = false;
        ImageButton11.BackgroundColor3 = Color3.new();
        ImageButton11.BackgroundTransparency = 0.8;
        ImageButton11.Position = UDim2.fromScale(v[3], 0.35);
        ImageButton11.Size = UDim2.fromScale(0.423, 0.231);
        ImageButton11.SizeConstraint = Enum.SizeConstraint.RelativeYY;
        ImageButton11.Visible = false;
        local UICorner9 = Instance.new("UICorner");
        UICorner9.Name = "UICorner";
        UICorner9.CornerRadius = UDim.new(0.1, 0);
        UICorner9.Parent = ImageButton11;
        local UIStroke2 = Instance.new("UIStroke");
        UIStroke2.Name = "UIStroke";
        UIStroke2.BorderStrokePosition = Enum.BorderStrokePosition.Inner;
        UIStroke2.Color = Color3.new(1, 1, 1);
        UIStroke2.Transparency = 0.5;
        UIStroke2.Parent = ImageButton11;
        local TextLabel18 = Instance.new("TextLabel");
        TextLabel18.Name = "TextLabel";
        TextLabel18.AnchorPoint = Vector2.new(0.5, 0.5);
        TextLabel18.BackgroundTransparency = 1;
        TextLabel18.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.Bold, Enum.FontStyle.Normal);
        TextLabel18.Position = UDim2.fromScale(0.5, 0.5);
        TextLabel18.Size = UDim2.fromScale(0.9, 0.55);
        TextLabel18.Text = v[2];
        TextLabel18.TextColor3 = Color3.new(1, 1, 1);
        TextLabel18.TextScaled = true;
        TextLabel18.ZIndex = 343;
        TextLabel18.Parent = ImageButton11;
        ImageButton11.Parent = Frame14;
    end;

    Frame14.Parent = Frame2;
    local Frame15 = Instance.new("Frame");
    Frame15.Name = "Stickers";
    Frame15.AnchorPoint = Vector2.new(0.5, 1);
    Frame15.BackgroundTransparency = 1;
    Frame15.Position = UDim2.fromScale(0.5, 0.9);
    Frame15.Size = UDim2.fromScale(0.4, 0.119054);
    local UIListLayout3 = Instance.new("UIListLayout");
    UIListLayout3.Name = "UIListLayout";
    UIListLayout3.FillDirection = Enum.FillDirection.Horizontal;
    UIListLayout3.HorizontalAlignment = Enum.HorizontalAlignment.Center;
    UIListLayout3.Padding = UDim.new(0.05, 0);
    UIListLayout3.SortOrder = Enum.SortOrder.LayoutOrder;
    UIListLayout3.VerticalAlignment = Enum.VerticalAlignment.Center;
    UIListLayout3.Parent = Frame15;
    Frame15.Parent = Frame2;
    local Frame16 = Instance.new("Frame");
    Frame16.Name = "NameTagTextBox";
    Frame16.AnchorPoint = Vector2.new(0.5, 1);
    Frame16.BackgroundColor3 = Color3.new();
    Frame16.BackgroundTransparency = 0.65;
    Frame16.Position = UDim2.fromScale(0.5, 0.88);
    Frame16.Size = UDim2.fromScale(0.5, 0.045);
    Frame16.Visible = false;
    local TextBox = Instance.new("TextBox");
    TextBox.Name = "TextBox";
    TextBox.AnchorPoint = Vector2.new(0.5, 0.5);
    TextBox.BackgroundTransparency = 1;
    TextBox.ClearTextOnFocus = false;
    TextBox.CursorPosition = -1;
    TextBox.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal);
    TextBox.Position = UDim2.fromScale(0.5, 0.5);
    TextBox.Size = UDim2.fromScale(0.98, 0.98);
    TextBox.Text = "BROWN FOX ON LAZY DOG";
    TextBox.TextColor3 = Color3.fromRGB(198, 198, 198);
    TextBox.TextScaled = true;
    TextBox.TextXAlignment = Enum.TextXAlignment.Left;
    TextBox.Parent = Frame16;
    local UIStroke2 = Instance.new("UIStroke");
    UIStroke2.Name = "UIStroke";
    UIStroke2.ApplyStrokeMode = Enum.ApplyStrokeMode.Border;
    UIStroke2.Color = Color3.new(1, 1, 1);
    UIStroke2.LineJoinMode = Enum.LineJoinMode.Miter;
    UIStroke2.Transparency = 0.5;
    UIStroke2.Parent = Frame16;
    Frame16.Parent = Frame2;
    local ViewportFrame = Instance.new("ViewportFrame");
    ViewportFrame.Name = "NameTagViewport";
    ViewportFrame.AnchorPoint = Vector2.new(0.5, 0.5);
    ViewportFrame.BackgroundTransparency = 1;
    ViewportFrame.Position = UDim2.fromScale(0.5, 0.5);
    ViewportFrame.Size = UDim2.fromScale(1, 1);
    ViewportFrame.Visible = false;
    local Camera = Instance.new("Camera");
    Camera.Name = "Camera";
    Camera.CFrame = CFrame.new(0, 0, 0.75, 1, 0, 0, 0, 1, 0, 0, 0, 1);
    Camera.Focus = CFrame.new();
    Camera.Parent = ViewportFrame;
    ViewportFrame.CurrentCamera = Camera;
    local v410 = Assets.InspectNameTag:Clone();
    v410:PivotTo(CFrame.Angles(0, 3.141592653589793, 0));
    v410.Parent = ViewportFrame;
    local TextLabel18 = Instance.new("TextLabel");
    TextLabel18.Name = "TextLabel";
    TextLabel18.AnchorPoint = Vector2.new(0.5, 0.5);
    TextLabel18.BackgroundTransparency = 1;
    TextLabel18.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.Bold, Enum.FontStyle.Normal);
    TextLabel18.Position = UDim2.fromScale(0.5, 0.488);
    TextLabel18.Size = UDim2.fromScale(0.75, 0.0625312);
    TextLabel18.Text = "BROWN FOX ON LAZY DOG";
    TextLabel18.TextColor3 = Color3.new(1, 1, 1);
    TextLabel18.TextScaled = true;
    TextLabel18.TextStrokeColor3 = Color3.new(1, 1, 1);
    TextLabel18.TextTransparency = 0.4;
    TextLabel18.Parent = ViewportFrame;
    ViewportFrame.Parent = Frame2;
    local _, v411 = u9.colorUI();
    v411.Name = "KillTrackColorPicker";
    v411.AnchorPoint = Vector2.new(0.5, 1);
    v411.Position = UDim2.fromScale(0.5, 0.9);
    v411.Visible = false;
    v411.ZIndex = 5;
    v411.Parent = Frame2;
    u50 = v411;

    return Frame;
end;

function u1.stickerRemoveFrame(p412, p413) -- Line: 3690
    local ImageButton = Instance.new("ImageButton");
    ImageButton.Name = "Sticker";
    ImageButton.AnchorPoint = Vector2.new(0.5, 0.5);
    ImageButton.BackgroundTransparency = 1;
    ImageButton.Image = `rbxassetid://{p413}`;
    ImageButton.Position = UDim2.fromScale(0.5, 0.4);
    ImageButton.Size = UDim2.fromScale(1, 1);
    ImageButton.SizeConstraint = Enum.SizeConstraint.RelativeYY;
    local ImageLabel = Instance.new("ImageLabel");
    ImageLabel.Name = "SelectedFrame";
    ImageLabel.AnchorPoint = Vector2.new(0.5, 1);
    ImageLabel.BackgroundTransparency = 1;
    ImageLabel.Image = "rbxassetid://79889419533417";
    ImageLabel.ImageColor3 = Color3.fromRGB(19, 207, 113);
    ImageLabel.Position = UDim2.fromScale(0.5, 0);
    ImageLabel.ScaleType = Enum.ScaleType.Fit;
    ImageLabel.Size = UDim2.fromScale(0.35, 0.35);
    ImageLabel.SizeConstraint = Enum.SizeConstraint.RelativeYY;
    ImageLabel.Parent = ImageButton;
    ImageButton.Parent = p412;

    return ImageButton;
end;

function u1.newButton() -- Line: 3717
    local ImageButton = Instance.new("ImageButton");
    ImageButton.Name = "HolderButton";
    ImageButton.AutoButtonColor = false;
    ImageButton.BackgroundTransparency = 1;
    ImageButton.Size = UDim2.fromScale(1, 1);
    ImageButton.LayoutOrder = 0;
    ImageButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255);
    ImageButton.SizeConstraint = Enum.SizeConstraint.RelativeYY;
    local ImageLabel = Instance.new("ImageLabel");
    ImageLabel.Name = "IconBT";
    ImageLabel.AnchorPoint = Vector2.new(0.5, 0.5);
    ImageLabel.BackgroundTransparency = 1;
    ImageLabel.Image = "rbxassetid://100429874437897";
    ImageLabel.Position = UDim2.fromScale(0.5, 0.5);
    ImageLabel.ScaleType = Enum.ScaleType.Fit;
    ImageLabel.Size = UDim2.fromScale(0.8, 0.8);
    ImageLabel.SizeConstraint = Enum.SizeConstraint.RelativeYY;
    ImageLabel.ImageColor3 = Color3.fromRGB(255, 255, 255);
    ImageLabel.Parent = ImageButton;
    local UICorner = Instance.new("UICorner");
    UICorner.Name = "CornerBT";
    UICorner.CornerRadius = UDim.new(0.1, 0);
    UICorner.Parent = ImageButton;
    local CanvasGroup = Instance.new("CanvasGroup");
    CanvasGroup.Name = "HoverFrame";
    CanvasGroup.AnchorPoint = Vector2.new(0.5, 0);
    CanvasGroup.BackgroundColor3 = Color3.fromRGB(16, 16, 16);
    CanvasGroup.Position = UDim2.fromScale(0.5, -1.20416);
    CanvasGroup.Size = UDim2.fromScale(4.07022, 0.925926);
    CanvasGroup.ZIndex = 2;
    CanvasGroup.GroupTransparency = 1;
    CanvasGroup.Parent = ImageButton;
    local TextLabel = Instance.new("TextLabel");
    TextLabel.Name = "HoverText";
    TextLabel.BackgroundTransparency = 1;
    TextLabel.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal);
    TextLabel.Position = UDim2.fromScale(0, 0.23);
    TextLabel.Size = UDim2.fromScale(1, 0.53481);
    TextLabel.Text = "";
    TextLabel.TextColor3 = Color3.new(1, 1, 1);
    TextLabel.TextScaled = true;
    TextLabel.Parent = CanvasGroup;
    local UICorner2 = Instance.new("UICorner");
    UICorner2.Name = "HoverCorner";
    UICorner2.CornerRadius = UDim.new(0.1, 0);
    UICorner2.Parent = CanvasGroup;

    return ImageButton;
end;

return u1;