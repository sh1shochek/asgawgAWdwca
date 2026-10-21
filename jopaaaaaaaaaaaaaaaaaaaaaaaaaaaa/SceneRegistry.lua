-- ReplicatedStorage.Controllers.CaseSceneController.SceneRegistry
-- Script path: ReplicatedStorage.Controllers.CaseSceneController.SceneRegistry
-- Decompile time: 2.89 ms

-- Decompiled with Potassium's decompiler.

local v1 = {};
local ReplicatedStorage = game:GetService("ReplicatedStorage");
require(ReplicatedStorage.Database.Custom.Types);
local u2 = {
    Default = {
        AssetFolder = "CaseScene",
        InteractionType = "Click",
        Animations = {
            CaseFall = "rbxassetid://91366765923171",
            CloseIdle = "rbxassetid://96896409518629",
            CaseOpening = "rbxassetid://100000665946048",
            OpenIdle = "rbxassetid://127592440292292"
        },
        Sounds = {
            Drop = "Case Fall",
            Opening = "Case Opening"
        }
    },
    CharmCapsule = {
        AssetFolder = "CharmScene",
        InteractionType = "Drag",
        Animations = {
            PackOpening = "rbxassetid://97837283629886"
        },
        DragSettings = {
            Threshold = 0.5,
            EndKeyframe = "DragEndPoint"
        },
        Sounds = {
            DragStart = "Charm Drag Start",
            DragLoop = "Charm Drag Loop"
        }
    },
    Package = {
        AssetFolder = "PackageScene",
        InteractionType = "Click",
        Animations = {
            CaseFall = "rbxassetid://134599478765866",
            CloseIdle = "rbxassetid://119593507010060",
            CaseOpening = "rbxassetid://97681949800792"
        },
        AnimationKeyframeSounds = {
            CaseFall = {
                Drop = "Package Drop"
            },
            CaseOpening = {
                RightTape = "Package Right Tape",
                LeftTape = "Package Left Tape",
                FrontLid = "Package Front Lid",
                FinalOpen = "Package Final Open"
            }
        }
    },
    Console = {
        AssetFolder = "ConsoleScene",
        InteractionType = "Click",
        ConsoleColumnCount = 8,
        Animations = {
            CaseFall = "rbxassetid://127945219825547",
            CaseOpening = "rbxassetid://136396496384739"
        },
        Sounds = {
            Enter = "Console Enter Animation",
            Opening = "Console Open Animation"
        }
    },
    KnifeConsole = {
        AssetFolder = "KnifeConsoleScene",
        InteractionType = "Click",
        ConsoleColumnCount = 10,
        Animations = {
            CaseFall = "rbxassetid://127945219825547",
            CaseOpening = "rbxassetid://136396496384739"
        },
        Sounds = {
            Enter = "Console Enter Animation",
            Opening = "Console Open Animation"
        }
    }
};
local u3 = {
    Case = "Default",
    ["Sticker Capsule"] = "Default",
    ["Charm Capsule"] = "CharmCapsule",
    Package = "Package",
    Console = "Console"
};

local function hasSpecialItems(p4) -- Line: 158
    if p4.specialContents and #p4.specialContents > 0 then
        return true;
    end;

    for _, v in p4.contents do
        if v.isSpecial or v.rarity == "Special" then
            return true;
        end;
    end;

    return false;
end;

function v1.GetSceneForCase(p5: string, p6: any) -- Line: 170
    -- upvalues: u3 (copy)
    if p5 == "Console" and p6 then
        local v7;

        if p6.specialContents and #p6.specialContents > 0 then
            v7 = true;
        else
            v7 = false;

            for _, v in p6.contents do
                if v.isSpecial or v.rarity == "Special" then
                    v7 = true;
                    break;
                end;
            end;
        end;

        if v7 then
            return "KnifeConsole";
        end;
    end;

    return u3[p5] or "Default";
end;

function v1.GetConfig(p8: string) -- Line: 177
    -- upvalues: u2 (copy)
    return u2[p8];
end;

function v1.GetAllSceneNames() -- Line: 181
    -- upvalues: u2 (copy)
    local v9 = {};

    for i in u2 do
        table.insert(v9, i);
    end;

    return v9;
end;

return v1;