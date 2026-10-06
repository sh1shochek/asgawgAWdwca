-- Decompiled with Potassium's decompiler.

local v1 = {};
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Players = game:GetService("Players");
local SpectateController = require(ReplicatedStorage.Controllers.SpectateController);
local GameState = require(ReplicatedStorage.Database.Components.GameState);
local LocalPlayer = Players.LocalPlayer;

function v1.DisableInput(p2: userdata) -- Line: 20
    p2.Active = false;

    for _, descendant in ipairs(p2:GetDescendants()) do
        if descendant:IsA("GuiObject") then
            descendant.Active = false;
        end;
    end;
end;

local function currentTarget() -- Line: 30
    -- upvalues: SpectateController (copy), LocalPlayer (copy)
    local CurrentSpectateInstance = SpectateController.GetCurrentSpectateInstance();

    if CurrentSpectateInstance then
        return CurrentSpectateInstance.Player;
    end;

    return LocalPlayer;
end;

function v1.Follow(u3: function) -- Line: 36
    -- upvalues: LocalPlayer (copy), SpectateController (copy), GameState (copy)
    LocalPlayer.CharacterAdded:Connect(function() -- Line: 37
        -- upvalues: u3 (copy), SpectateController (ref), LocalPlayer (ref)
        local CurrentSpectateInstance = SpectateController.GetCurrentSpectateInstance();
        local v4;

        if CurrentSpectateInstance then
            v4 = CurrentSpectateInstance.Player;
        else
            v4 = LocalPlayer;
        end;

        u3(v4);
    end);
    SpectateController.ListenToSpectate:Connect(function(p5) -- Line: 41
        -- upvalues: u3 (copy), LocalPlayer (ref)
        if p5 then
            u3(p5);

            return;
        end;

        if not LocalPlayer:GetAttribute("IsSpectating") then
            u3(LocalPlayer);
        end;
    end);
    LocalPlayer:GetAttributeChangedSignal("IsSpectating"):Connect(function() -- Line: 52
        -- upvalues: LocalPlayer (ref), u3 (copy), SpectateController (ref)
        if not LocalPlayer:GetAttribute("IsSpectating") then
            u3(LocalPlayer);

            return;
        end;

        local Player = SpectateController.GetPlayer();

        if Player then
            u3(Player);
        end;
    end);

    if LocalPlayer:GetAttribute("IsSpectating") then
        local Player = SpectateController.GetPlayer();

        if Player then
            u3(Player);
        end;
    else
        u3(LocalPlayer);
    end;

    GameState.ListenToState(function(p6, p7) -- Line: 75
        -- upvalues: u3 (copy), SpectateController (ref), LocalPlayer (ref)
        if p7 == "Buy Period" or p7 == "Round In Progress" then
            local CurrentSpectateInstance = SpectateController.GetCurrentSpectateInstance();
            local v8;

            if CurrentSpectateInstance then
                v8 = CurrentSpectateInstance.Player;
            else
                v8 = LocalPlayer;
            end;

            u3(v8);
        end;
    end);
end;

return v1;