-- Decompiled with Potassium's decompiler.

local v1 = {};
local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Remotes = require(ReplicatedStorage.Database.Security.Remotes);
local Hints = ReplicatedStorage:WaitForChild("Assets"):WaitForChild("UI"):WaitForChild("Hints");
Hints:WaitForChild("Static");
Hints:WaitForChild("Ranged");
Players.LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("MainGui", (1 / 0)):WaitForChild("Gameplay"):WaitForChild("Middle");

function v1.createHint(p2: table, p3: string, p4: userdata?, p5: string?, p6: string?, p7: boolean?) -- Line: 18
end;

function v1.clearHint(p8: table, p9: string?) -- Line: 21
end;

Remotes.Hints.BombSiteEntered.Listen(function() -- Line: 25
end);
Remotes.Hints.ClearHint.Listen(function() -- Line: 26
end);

return v1;