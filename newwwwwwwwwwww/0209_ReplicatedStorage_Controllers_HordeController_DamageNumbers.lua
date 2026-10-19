-- DamageNumbers (ModuleScript)
-- full path: ReplicatedStorage.Controllers.HordeController.DamageNumbers

-- Decompiled with Potassium's decompiler.

local v1 = {};
local TweenService = game:GetService("TweenService");
local RunService = game:GetService("RunService");
local Workspace = game:GetService("Workspace");
local Font_new_ret = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal);
local Color3_fromRGB_ret = Color3.fromRGB(255, 255, 255);
local Color3_new_ret = Color3.new(0, 0, 0);
local Color3_fromRGB_ret2 = Color3.fromRGB(255, 220, 140);
local Color3_fromRGB_ret3 = Color3.fromRGB(214, 41, 41);
local Color3_fromRGB_ret4 = Color3.fromRGB(255, 150, 60);
local TweenInfo_new_ret = TweenInfo.new(1.25, Enum.EasingStyle.Quad);
local TweenInfo_new_ret2 = TweenInfo.new(1, Enum.EasingStyle.Quad);
local TweenInfo_new_ret3 = TweenInfo.new(0.15);
local Random_new_ret = Random.new();
local u2 = {};
local u3 = {};
local u4 = false;
local u5 = {};
local u6 = {};

local function build() -- Line: 66
    -- upvalues: Font_new_ret (copy), Color3_new_ret (copy), Workspace (copy)
    local Attachment = Instance.new("Attachment");
    Attachment.Name = "DamageNumber";
    local BillboardGui = Instance.new("BillboardGui");
    BillboardGui.AlwaysOnTop = true;
    BillboardGui.LightInfluence = 0;
    BillboardGui.MaxDistance = 250;
    BillboardGui.ResetOnSpawn = false;
    BillboardGui.Enabled = false;
    BillboardGui.Parent = Attachment;
    local TextLabel = Instance.new("TextLabel");
    TextLabel.AnchorPoint = Vector2.new(0.5, 0.5);
    TextLabel.Position = UDim2.fromScale(0.5, 0.5);
    TextLabel.Size = UDim2.fromScale(1, 1);
    TextLabel.BackgroundTransparency = 1;
    TextLabel.FontFace = Font_new_ret;
    TextLabel.TextScaled = true;
    TextLabel.TextStrokeColor3 = Color3_new_ret;
    TextLabel.Parent = BillboardGui;
    Attachment.Parent = Workspace.Terrain;

    return {
        Serial = 0,
        Anchor = Attachment,
        Billboard = BillboardGui,
        Label = TextLabel,
        Tweens = {}
    };
end;

local function stopTweens(p7: table) -- Line: 92
    for _, v in p7.Tweens do
        v:Cancel();
    end;

    table.clear(p7.Tweens);
end;

local function play(p8: table, p9: userdata, p10: userdata, p11: table) -- Line: 99
    -- upvalues: TweenService (copy)
    local v12 = TweenService:Create(p9, p10, p11);
    p8.Tweens[#p8.Tweens + 1] = v12;
    v12:Play();
end;

local function release(p13: table) -- Line: 105
    -- upvalues: u5 (copy), u6 (copy)
    local table_find_ret = table.find(u5, p13);

    if table_find_ret then
        table.remove(u5, table_find_ret);
    end;

    for _, v in p13.Tweens do
        v:Cancel();
    end;

    table.clear(p13.Tweens);
    p13.Billboard.Enabled = false;
    u6[#u6 + 1] = p13;
end;

local function spawnNumber(p14: table) -- Line: 115
    -- upvalues: u5 (copy), u6 (copy), build (copy), Color3_fromRGB_ret3 (copy), Color3_fromRGB_ret4 (copy), Color3_fromRGB_ret2 (copy), Color3_fromRGB_ret (copy), Random_new_ret (copy), TweenInfo_new_ret (copy), TweenService (copy), TweenInfo_new_ret2 (copy), TweenInfo_new_ret3 (copy)
    while #u5 >= 40 do
        local v15 = u5[1];
        local table_find_ret = table.find(u5, v15);

        if table_find_ret then
            table.remove(u5, table_find_ret);
        end;

        for _, v in v15.Tweens do
            v:Cancel();
        end;

        table.clear(v15.Tweens);
        v15.Billboard.Enabled = false;
        u6[#u6 + 1] = v15;
    end;

    local u16 = table.remove(u6) or build();
    u16.Serial = u16.Serial + 1;
    local Serial = u16.Serial;
    u5[#u5 + 1] = u16;
    local v17 = p14.Headshot and 32 or 28;
    local Billboard = u16.Billboard;
    local Label = u16.Label;
    u16.Anchor.WorldPosition = p14.Position;
    Billboard.StudsOffsetWorldSpace = Vector3.new(0, 0, 0);
    Billboard.Size = UDim2.fromOffset(v17, v17);
    local v18;

    if p14.Died then
        v18 = Color3_fromRGB_ret3;
    elseif p14.Burn then
        v18 = Color3_fromRGB_ret4;
    elseif p14.Headshot then
        v18 = Color3_fromRGB_ret2;
    else
        v18 = Color3_fromRGB_ret;
    end;

    Label.TextColor3 = v18;
    Label.TextTransparency = 0;
    Label.TextStrokeTransparency = 0.45;
    Label.Rotation = Random_new_ret:NextNumber(-25, 25);
    local math_round_ret = math.round(p14.Damage);
    local math_max_ret = math.max(1, math_round_ret);
    Label.Text = tostring(math_max_ret);
    Billboard.Enabled = true;
    local v19 = Random_new_ret:NextNumber(-1.25, 1.25);
    local v20 = 2 + Random_new_ret:NextNumber(-1.25, 1.25);
    local v21 = TweenService:Create(Billboard, TweenInfo_new_ret, {
        StudsOffsetWorldSpace = Vector3.new(v19, v20, Random_new_ret:NextNumber(-1.25, 1.25)),
        Size = UDim2.fromOffset(36, 36)
    });
    u16.Tweens[#u16.Tweens + 1] = v21;
    v21:Play();
    local v22 = TweenService:Create(Label, TweenInfo_new_ret2, {
        Rotation = 0
    });
    u16.Tweens[#u16.Tweens + 1] = v22;
    v22:Play();
    task.delay(1.25, function() -- Line: 148
        -- upvalues: u16 (copy), Serial (copy), Label (copy), TweenInfo_new_ret3 (ref), TweenService (ref), u5 (ref), u6 (ref)
        if u16.Serial ~= Serial or not u16.Billboard.Enabled then
            return;
        end;

        local v23 = u16;
        local v24 = TweenService:Create(Label, TweenInfo_new_ret3, {
            TextTransparency = 1,
            TextStrokeTransparency = 1
        });
        v23.Tweens[#v23.Tweens + 1] = v24;
        v24:Play();
        task.delay(0.15, function() -- Line: 156
            -- upvalues: u16 (ref), Serial (ref), u5 (ref), u6 (ref)
            if u16.Serial == Serial and u16.Billboard.Enabled then
                local v25 = u16;
                local table_find_ret = table.find(u5, v25);

                if table_find_ret then
                    table.remove(u5, table_find_ret);
                end;

                for _, v in v25.Tweens do
                    v:Cancel();
                end;

                table.clear(v25.Tweens);
                v25.Billboard.Enabled = false;
                u6[#u6 + 1] = v25;
            end;
        end);
    end);
end;

local function flush() -- Line: 164
    -- upvalues: u4 (ref), u2 (copy), spawnNumber (copy)
    u4 = false;
    debug.profilebegin("Horde.DamageNumbers");

    for _, v in u2 do
        spawnNumber(v);
    end;

    table.clear(u2);
    debug.profileend();
end;

local function flushBurn(p26: number) -- Line: 174
    -- upvalues: u3 (copy), spawnNumber (copy)
    local v27 = u3[p26];

    if v27 then
        u3[p26] = nil;
        spawnNumber(v27);
    end;
end;

function v1.Show(p28: number, p29: vector, p30: number, p31: boolean, p32: boolean, p33: boolean?) -- Line: 187
    -- upvalues: u3 (copy), flushBurn (copy), spawnNumber (copy), u2 (copy), u4 (ref), RunService (copy), flush (copy)
    if not p33 then
        local v34 = u2[p28];

        if v34 then
            v34.Damage = v34.Damage + p30;
            v34.Headshot = v34.Headshot or p31;
            v34.Died = v34.Died or p32;
        else
            u2[p28] = {
                Burn = false,
                Damage = p30,
                Position = p29,
                Headshot = p31,
                Died = p32
            };
        end;

        if not u4 then
            u4 = true;
            RunService.Heartbeat:Once(flush);
        end;

        return;
    end;

    local v35 = u3[p28];

    if v35 then
        v35.Damage = v35.Damage + p30;
        v35.Died = v35.Died or p32;
    else
        u3[p28] = {
            Headshot = false,
            Burn = true,
            Damage = p30,
            Position = p29,
            Died = p32
        };
        task.delay(0.6, flushBurn, p28);
    end;

    local v36 = p32 and u3[p28];

    if v36 then
        u3[p28] = nil;
        spawnNumber(v36);
    end;
end;

function v1.Clear() -- Line: 218
    -- upvalues: u2 (copy), u3 (copy), u5 (copy), u6 (copy)
    table.clear(u2);
    table.clear(u3);

    for _, v in u5 do
        local v37 = v;

        for _, v2 in v.Tweens do
            v2:Cancel();
        end;

        table.clear(v37.Tweens);
        v37.Serial = v37.Serial + 1;
        v37.Anchor:Destroy();
    end;

    table.clear(u5);

    for _, v in u6 do
        v.Anchor:Destroy();
    end;

    table.clear(u6);
end;

return v1;