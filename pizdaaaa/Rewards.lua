-- ReplicatedStorage.GameClient.Gui.MainMenu.SideSection.Rewards
-- Script path: ReplicatedStorage.GameClient.Gui.MainMenu.SideSection.Rewards
-- Decompile time: 10.00 ms

-- Decompiled with Potassium's decompiler.

local u1 = {};
game:GetService("Players");
game:GetService("TweenService");
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

function u1.RewardsNotifications(u12) -- Line: 30
    -- upvalues: u9 (ref), u7 (ref), u8 (ref), u11 (ref), u10 (ref)
    task.spawn(function() -- Line: 31
        -- upvalues: u12 (copy), u9 (ref), u7 (ref), u8 (ref), u11 (ref), u10 (ref)
        for _, v in u12 do
            local v13, v14 = unpack(v);

            if v13 == "Credits" then
                u9:Create(`+${v14}`, Color3.fromRGB(129, 255, 120));
            elseif v13 == "XP" then
                u9:Create(`+{v14} XP`, Color3.fromRGB(225, 255, 116));
            elseif v13 == "Item" or (v13 == "Container" or v13 == "Graphic Art") then
                local v15, v16 = unpack(v14:split("_"));
                local v17 = u7.GetItem(v15, v16) or u8.GetWeaponSkin(v15, v16);
                u9:Create(`+ {(u7.GetCategory(v15) or u11.Get(v15)).DisplayName or v15} | {v17.DisplayName or v16}`, u10[v17.Rarity]);
            end;

            task.wait(0.2);
        end;
    end);
end;

local u18 = nil;

function u1.Activate(p19: string?) -- Line: 60
    -- upvalues: u18 (ref), u1 (copy)
    if u18 then
        u18.Activate();
    end;

    if p19 and u1.Tabs then
        u1.Tabs:OpenTab(p19);
    end;
end;

function u1.Init(p20) -- Line: 69
    -- upvalues: u2 (ref), u3 (ref), u5 (ref), u4 (ref), u9 (ref), u7 (ref), u8 (ref), u10 (ref), u11 (ref)
    u2 = p20:GetModule("Gui");
    u3 = u2.GetComponent("MainMenu");
    u5 = u2.GetComponent("Tabs");
    u4 = p20:GetModule("Maid").new();
    u9 = u2.GetComponent("MenuNotification");
    u7 = p20:GetModule("ItemManager");
    u8 = p20:GetModule("SkinManager");
    u10 = p20:GetModule("RarityColors");
    u11 = p20:GetModule("WeaponManager");
end;

function u1.Start(p21) -- Line: 82
    -- upvalues: u6 (ref), u3 (ref), u18 (ref), u1 (copy), u5 (ref)
    u6 = u3.AddTab("Rewards");
    u18 = u3.AddSideButton("Rewards", u6, "rbxassetid://86354349095664", 1);
    u1.Tabs = u5:CreateTab(u6);
end;

return u1;