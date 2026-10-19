-- AutoScale (LocalScript)
-- full path: Players.jypit54U65.PlayerGui.MainGui.Menu.Inventory.Ignore.HoverNoCollection.AutoScale

-- Decompiled with Potassium's decompiler.

local script_Parent = script.Parent;
local UIScale = script_Parent:WaitForChild("UIScale");
local workspace_CurrentCamera = workspace.CurrentCamera;
workspace_CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(function() -- Line: 6, Name: updateScale
    -- upvalues: UIScale (copy), workspace_CurrentCamera (copy)
    UIScale.Scale = workspace_CurrentCamera.ViewportSize.X / 1920;
end);
UIScale.Scale = workspace_CurrentCamera.ViewportSize.X / 1920;
local Information = script_Parent:FindFirstChild("Information");

if Information then
    Information = Information:FindFirstChild("Rarity");
end;

local u1;

if Information then
    u1 = Information:FindFirstChild("Label");
else
    u1 = Information;
end;

local RarityBar = script_Parent:FindFirstChild("RarityBar");
local ItemName = script_Parent:FindFirstChild("ItemName");

if ItemName then
    ItemName = ItemName:FindFirstChild("RarityGlow");
end;

local function tint() -- Line: 18
    -- upvalues: u1 (copy), RarityBar (copy), ItemName (copy), Information (copy)
    if not u1 then
        return;
    end;

    local TextColor3 = u1.TextColor3;

    if RarityBar then
        RarityBar.BackgroundColor3 = TextColor3;
    end;

    if ItemName then
        ItemName.ImageColor3 = TextColor3;
    end;

    local PillStroke = Information:FindFirstChild("PillStroke");

    if PillStroke then
        PillStroke.Color = TextColor3;
    end;

    Information.BackgroundColor3 = TextColor3:Lerp(Color3.new(0, 0, 0), 0.82);
end;

if u1 then
    u1:GetPropertyChangedSignal("TextColor3"):Connect(tint);
end;

tint();