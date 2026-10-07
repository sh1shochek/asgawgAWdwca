-- ReplicatedStorage.Controllers.CaseSceneController.SceneRegistry
-- Script path: ReplicatedStorage.Controllers.CaseSceneController.SceneRegistry
-- Decompile time: 0.49 ms

local v1 = {}
local u1 = {
    Default = {
        AssetFolder = "CaseScene",
        InteractionType = "Click",
        Animations = {
            CaseFall = "rbxassetid://91366765923171",
            CloseIdle = "rbxassetid://96896409518629",
            CaseOpening = "rbxassetid://100000665946048",
            OpenIdle = "rbxassetid://127592440292292",
        },
        Sounds = {Drop = "Case Fall", Opening = "Case Opening"},
    },
    CharmCapsule = {
        AssetFolder = "CharmScene",
        InteractionType = "Drag",
        Animations = {PackOpening = "rbxassetid://97837283629886"},
        DragSettings = {Threshold = 0.5, EndKeyframe = "DragEndPoint"},
        Sounds = {DragStart = "Charm Drag Start", DragLoop = "Charm Drag Loop"},
    },
    Package = {
        AssetFolder = "PackageScene",
        InteractionType = "Click",
        Animations = {
            CaseFall = "rbxassetid://134599478765866",
            CloseIdle = "rbxassetid://119593507010060",
            CaseOpening = "rbxassetid://97681949800792",
        },
        AnimationKeyframeSounds = {
            CaseFall = {Drop = "Package Drop"},
            CaseOpening = {
                RightTape = "Package Right Tape",
                LeftTape = "Package Left Tape",
                FrontLid = "Package Front Lid",
                FinalOpen = "Package Final Open",
            },
        },
    },
    Console = {
        AssetFolder = "ConsoleScene",
        InteractionType = "Click",
        Animations = {CaseFall = "rbxassetid://127945219825547", CaseOpening = "rbxassetid://136396496384739"},
        Sounds = {Enter = "Console Enter Animation", Opening = "Console Open Animation"},
    },
}
local u17 = {
    Case = "Default",
    ["Sticker Capsule"] = "Default",
    ["Charm Capsule"] = "CharmCapsule",
    Package = "Package",
    Console = "Console",
}

function v1.GetSceneForCaseType(a1) -- Line: 134 -- upvalues: u17 (val) -- types: a1: string
    return u17[a1] or "Default"
end

function v1.GetConfig(a1) -- Line: 138 -- upvalues: u1 (val) -- types: a1: string
    return u1[a1]
end

function v1.GetAllSceneNames() -- Line: 142 -- upvalues: u1 (val)
    local v1 = {}
    for i in u1 do
        table.insert(v1, i)
    end
    return v1
end

return v1