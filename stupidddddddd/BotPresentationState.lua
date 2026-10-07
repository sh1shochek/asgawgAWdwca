-- ReplicatedStorage.Components.Common.BotPresentationState
-- Script path: ReplicatedStorage.Components.Common.BotPresentationState
-- Decompile time: 1.56 ms

local v1 = {}

local function integer(a1, a2) -- Line: 26 -- types: a2: number
    local v1 = false
    if type(a1) == "number" then
        v1 = false
        if a1 >= 1 then
            v1 = false
            if a1 <= a2 then
                v1 = a1 % 1 == 0
            end
        end
    end
    return v1
end

function v1.validate(a1) -- Line: 30
    local v1 = false
    if type(a1) == "table" then
        local CombatantId = a1.CombatantId
        v1 = false
        if type(CombatantId) == "number" then
            v1 = false
            if CombatantId >= 1 then
                v1 = false
                if CombatantId <= 9007199254740991 then
                    v1 = CombatantId % 1 == 0
                end
            end
        end
        if v1 then
            local ActorId = a1.ActorId
            v1 = false
            if type(ActorId) == "number" then
                v1 = false
                if ActorId >= 1 then
                    v1 = false
                    if ActorId <= 4294967295 then
                        v1 = ActorId % 1 == 0
                    end
                end
            end
            if v1 then
                local Generation = a1.Generation
                v1 = false
                if type(Generation) == "number" then
                    v1 = false
                    if Generation >= 1 then
                        v1 = false
                        if Generation <= 65535 then
                            v1 = Generation % 1 == 0
                        end
                    end
                end
                if v1 then
                    v1 = false
                    if type(a1.DisplayName) == "string" then
                        v1 = false
                        if type(a1.Team) == "string" then
                            v1 = false
                            if type(a1.CharacterName) == "string" then
                                v1 = false
                                if a1.CharacterName ~= "" then
                                    v1 = false
                                    if type(a1.Health) == "number" then
                                        v1 = false
                                        if 0 <= a1.Health then
                                            v1 = false
                                            if type(a1.MaxHealth) == "number" then
                                                v1 = false
                                                if 0 < a1.MaxHealth then
                                                    v1 = false
                                                    if a1.MaxHealth < (1 / 0) then
                                                        v1 = false
                                                        if a1.Health <= a1.MaxHealth then
                                                            v1 = type(a1.Dead) == "boolean"
                                                        end
                                                    end
                                                end
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end
    return v1
end

function v1.sameLife(a1, a2) -- Line: 48 -- types: a1: table, a2: table
    local v1 = false
    if a1.CombatantId == a2.CombatantId then
        v1 = false
        if a1.ActorId == a2.ActorId then
            v1 = a1.Generation == a2.Generation
        end
    end
    return v1
end

function v1.decide(a1, a2) -- Line: 54 -- types: a1: table?
    if a1 ~= nil and not a1.Dead and not (a1.Health <= 0) then
        if a2 == nil then
            return "Hide"
        end
        if a2.UserId == 0 and a2.ActorId == a1.ActorId and a2.Generation == a1.Generation then
            local RenderPose = a2.RenderPose
            if RenderPose == nil then
                return "Hold"
            end
            if RenderPose.UserId == 0
                and RenderPose.ActorId == a1.ActorId
                and RenderPose.Generation == a1.Generation then
                return "Present"
            end
            return "Hide"
        end
        return "Hide"
    end
    return "Destroy"
end

return table.freeze(v1)