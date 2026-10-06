-- Decompiled with Potassium's decompiler.

local v1 = {};

local function integer(p2: any, p3: number) -- Line: 26
    local v4;

    if type(p2) == "number" and (p2 >= 1 and p2 <= p3) then
        v4 = p2 % 1 == 0;
    else
        v4 = false;
    end;

    return v4;
end;

function v1.validate(p5) -- Line: 30
    local v6;

    if type(p5) == "table" then
        local CombatantId = p5.CombatantId;

        if type(CombatantId) == "number" and (CombatantId >= 1 and CombatantId <= 9007199254740991) then
            v6 = CombatantId % 1 == 0;
        else
            v6 = false;
        end;

        if v6 then
            local ActorId = p5.ActorId;

            if type(ActorId) == "number" and (ActorId >= 1 and ActorId <= 4294967295) then
                v6 = ActorId % 1 == 0;
            else
                v6 = false;
            end;

            if v6 then
                local Generation = p5.Generation;

                if type(Generation) == "number" and (Generation >= 1 and Generation <= 65535) then
                    v6 = Generation % 1 == 0;
                else
                    v6 = false;
                end;

                if v6 then
                    if type(p5.DisplayName) == "string" and (type(p5.Team) == "string" and (type(p5.CharacterName) == "string" and (p5.CharacterName ~= "" and (type(p5.Health) == "number" and (p5.Health >= 0 and (type(p5.MaxHealth) == "number" and (p5.MaxHealth > 0 and (p5.MaxHealth < (1 / 0) and p5.Health <= p5.MaxHealth)))))))) then
                        v6 = type(p5.Dead) == "boolean";
                    else
                        v6 = false;
                    end;
                end;
            end;
        end;
    else
        v6 = false;
    end;

    return v6;
end;

function v1.sameLife(p7: table, p8: table) -- Line: 48
    local v9;

    if p7.CombatantId == p8.CombatantId and p7.ActorId == p8.ActorId then
        v9 = p7.Generation == p8.Generation;
    else
        v9 = false;
    end;

    return v9;
end;

function v1.decide(p10: table?, p11: any) -- Line: 54
    if p10 == nil or (p10.Dead or p10.Health <= 0) then
        return "Destroy";
    end;

    if p11 == nil then
        return "Hide";
    end;

    if p11.UserId ~= 0 or (p11.ActorId ~= p10.ActorId or p11.Generation ~= p10.Generation) then
        return "Hide";
    end;

    local RenderPose = p11.RenderPose;

    return RenderPose == nil and "Hold" or (RenderPose.UserId == 0 and (RenderPose.ActorId == p10.ActorId and RenderPose.Generation == p10.Generation) and "Present" or "Hide");
end;

return table.freeze(v1);