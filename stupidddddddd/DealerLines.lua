-- ReplicatedStorage.Controllers.BlackMarketSceneController.DealerLines
-- Script path: ReplicatedStorage.Controllers.BlackMarketSceneController.DealerLines
-- Decompile time: 1.57 ms

local function line(a1, a2) -- Line: 24 -- types: a1: string, a2: number
    return table.freeze({Sound = a1, Animation = ("rbxassetid://%*"):format(a2)})
end

return table.freeze({
    SOUND_GROUP = "ArmsDealer",
    IDLE_ANIMATION = "rbxassetid://127680394246389",
    INTRO_ANIMATION = "rbxassetid://95003386452387",
    Open = table.freeze({
        table.freeze({Sound = "Open 1", Animation = ("rbxassetid://%*"):format(108820213143581)}),
        table.freeze({Sound = "Open 3", Animation = ("rbxassetid://%*"):format(79434798599791)}),
        table.freeze({Sound = "Open 4", Animation = ("rbxassetid://%*"):format(131035732599957)}),
        table.freeze({Sound = "Open 5", Animation = ("rbxassetid://%*"):format(100695883001427)}),
        (line("Open 6", 128685469059709)),
    }),
    Rarity = table.freeze({
        Blue = table.freeze({
            table.freeze({Sound = "Blue 1", Animation = ("rbxassetid://%*"):format(114988568340900)}),
            line("Blue 2", 94131440299691),
        }),
        Purple = table.freeze({line("Purple 2", 70665452356574)}),
        Pink = table.freeze({
            table.freeze({Sound = "Pink 1", Animation = ("rbxassetid://%*"):format(70685214815664)}),
            line("Pink 2", 108640008269911),
        }),
        Red = table.freeze({
            table.freeze({Sound = "Red 1", Animation = ("rbxassetid://%*"):format(97498387726202)}),
            line("Red 2", 130623891787655),
        }),
        Special = table.freeze({
            table.freeze({Sound = "Gold 1", Animation = ("rbxassetid://%*"):format(85665191583665)}),
            line("Gold 3", 138367858596446),
        }),
    }),
    Purchase = table.freeze({
        table.freeze({Sound = "Purchase 1", Animation = ("rbxassetid://%*"):format(90216929714117)}),
        table.freeze({Sound = "Purchase 3", Animation = ("rbxassetid://%*"):format(109862435497094)}),
        table.freeze({Sound = "Purchase 4", Animation = ("rbxassetid://%*"):format(113255847772841)}),
        table.freeze({Sound = "Purchase 5", Animation = ("rbxassetid://%*"):format(125620695537467)}),
        (line("Purchase 6", 74929276364047)),
    }),
    Declined = table.freeze({
        table.freeze({Sound = "Declined 1", Animation = ("rbxassetid://%*"):format(129610298959912)}),
        table.freeze({Sound = "Declined 2", Animation = ("rbxassetid://%*"):format(132955562823743)}),
        table.freeze({Sound = "Declined 3", Animation = ("rbxassetid://%*"):format(122535234265641)}),
        (line("Declined 5", 77965099110387)),
    }),
    Refresh = table.freeze({
        table.freeze({Sound = "Refresh 1", Animation = ("rbxassetid://%*"):format(76033652919780)}),
        table.freeze({Sound = "Refresh 2", Animation = ("rbxassetid://%*"):format(110165533270896)}),
        table.freeze({Sound = "Refresh 3", Animation = ("rbxassetid://%*"):format(88608508842745)}),
        table.freeze({Sound = "Refresh 4", Animation = ("rbxassetid://%*"):format(123025404949952)}),
        table.freeze({Sound = "Refresh 5", Animation = ("rbxassetid://%*"):format(109491615847472)}),
        (line("Refresh 6", 84677609075487)),
    }),
    Discontinued = table.freeze({
        table.freeze({Sound = "Discontinued 1", Animation = ("rbxassetid://%*"):format(123062898010154)}),
        table.freeze({Sound = "Discontinued 2", Animation = ("rbxassetid://%*"):format(120236879337679)}),
        (line("Discontinued 3", 103547167570421)),
    }),
    Pick = function(a1) -- Line: 141 -- types: a1: table?
        if a1 and #a1 ~= 0 then
            return a1[math.random(1, #a1)]
        end
        return nil
    end,
})