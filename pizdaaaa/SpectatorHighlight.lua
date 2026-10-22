-- ReplicatedStorage.ClientModules.SpectatorHighlight
-- Script path: ReplicatedStorage.ClientModules.SpectatorHighlight
-- Decompile time: 5.81 ms

-- Decompiled with Potassium's decompiler.

local u1 = {};
game:GetService("TweenService");
local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local _ = workspace.CurrentCamera;
local LocalPlayer = Players.LocalPlayer;
local u2 = {
    CT = Color3.fromRGB(172, 195, 220),
    T = Color3.fromRGB(255, 203, 107),
    Spectator = Color3.fromRGB(120, 120, 120)
};
local Highlight = ReplicatedStorage.Assets.Highlight;
local u3 = false;
local u4 = false;
local u5 = nil;
local u6 = nil;
local u7 = nil;
local u8 = nil;
local u9 = nil;
local u10 = false;

local function ShouldHighlight(p11) -- Line: 47
    -- upvalues: u4 (ref), LocalPlayer (copy), u7 (ref), u3 (ref), u9 (ref)
    local v12 = p11.Data and p11.Data.Team;

    if u4 then
        local v13;

        if p11.UserId == LocalPlayer.UserId then
            v13 = false;
        else
            v13 = not p11.HiddenApplied and not u7.IsFirstPersonTarget(p11.Identifier);
        end;

        return v13;
    end;

    local v14 = u3 and not (p11.HiddenApplied or u7.IsFirstPersonTarget(p11.Identifier)) and (u9 == "Spectator" and true or v12 == u9);

    return v14;
end;

function u1.Create(p15) -- Line: 67
    -- upvalues: ShouldHighlight (copy), Highlight (copy), Players (copy), u2 (copy), u4 (ref)
    if not ShouldHighlight(p15) then
        return;
    end;

    local v16 = p15.Data and p15.Data.Team;

    if not (p15.Model and p15.Model.Parent) then
        return;
    end;

    local v17 = Highlight:Clone();
    local UserId = p15.UserId;

    if UserId then
        Players:GetPlayerByUserId(UserId);
    end;

    v17.OutlineColor = u2[v16] or u2.Spectator;

    if u4 then
        v17.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop;
    end;

    v17.Adornee = p15.Model;
    v17.Parent = p15.Model;
    p15.Highlight = v17;
end;

function u1.Update(p18) -- Line: 96
    -- upvalues: ShouldHighlight (copy), u1 (copy)
    if ShouldHighlight(p18) then
        if not p18.Highlight then
            u1.Create(p18);
        end;

        return;
    end;

    u1.Destroy(p18);
end;

function u1.Destroy(p19) -- Line: 107
    local Highlight2 = p19.Highlight;

    if Highlight2 then
        Highlight2:Destroy();
        p19.Highlight = nil;
    end;
end;

function u1.Init(p20) -- Line: 117
    -- upvalues: u8 (ref), u6 (ref), u5 (ref), u7 (ref)
    u8 = p20:GetModule("Maid").new();
    u6 = p20:GetModule("Entities");
    u5 = p20:GetModule("CharacterController");
    u7 = p20:GetModule("Spectate");
end;

function u1.Start(p21) -- Line: 126
    -- upvalues: u4 (ref), LocalPlayer (copy), u6 (ref), u1 (copy), u9 (ref), u10 (ref), u3 (ref), u5 (ref)
    local function RefreshEsp() -- Line: 127
        -- upvalues: u4 (ref), LocalPlayer (ref), u6 (ref), u1 (ref)
        u4 = LocalPlayer:GetAttribute("EspEnabled") == true;

        for _, v in u6.GetAllCategoryEntities("Character") do
            u1.Destroy(v);
            u1.Update(v);
        end;
    end;

    LocalPlayer:GetAttributeChangedSignal("EspEnabled"):Connect(RefreshEsp);
    RefreshEsp();
    u9 = LocalPlayer:GetAttribute("Team");
    LocalPlayer:GetAttributeChangedSignal("Team"):Connect(function() -- Line: 138
        -- upvalues: u9 (ref), LocalPlayer (ref), u10 (ref), u3 (ref), u6 (ref), u1 (ref)
        u9 = LocalPlayer:GetAttribute("Team");

        if u9 == "Spectator" or not u10 then
            u3 = true;
        else
            u3 = false;
        end;

        for _, v in u6.GetAllCategoryEntities("Character") do
            u1.Update(v);
        end;
    end);
    u5.OnCharacterSpawn:Connect(function() -- Line: 152
        -- upvalues: u10 (ref), u3 (ref), u6 (ref), u1 (ref)
        u10 = true;
        u3 = false;

        for _, v in u6.GetAllCategoryEntities("Character") do
            u1.Update(v);
        end;
    end);
    u5.OnCharacterDestroy:Connect(function() -- Line: 161
        -- upvalues: u10 (ref), u3 (ref), u6 (ref), u1 (ref)
        u10 = false;
        u3 = true;

        for _, v in u6.GetAllCategoryEntities("Character") do
            u1.Update(v);
        end;
    end);
end;

return u1;