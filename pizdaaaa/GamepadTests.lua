-- ReplicatedStorage.GameClient.Gui.Misc.GamepadTests
-- Script path: ReplicatedStorage.GameClient.Gui.Misc.GamepadTests
-- Decompile time: 60.75 ms

-- Decompiled with Potassium's decompiler.

local v1 = {};
local GuiService = game:GetService("GuiService");
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
local u12 = nil;
local u13 = {};
local u14 = {
    PASS = Color3.fromRGB(116, 255, 132),
    FAIL = Color3.fromRGB(255, 151, 153),
    SKIP = Color3.fromRGB(255, 203, 107),
    INFO = Color3.fromRGB(172, 195, 220)
};

local function Report(p15: string, p16: string, p17: string, p18: string?) -- Line: 27
    -- upvalues: u13 (ref), u12 (ref), u14 (copy)
    local v19 = u13;
    v19[p15] = v19[p15] + 1;
    u12(`[{p15}] {p16}: {p17}` .. (p18 and p18 ~= "" and (` ({p18})` or "") or ""), u14[p15]);
end;

local function Check(p20: string, p21: string, p22: boolean, p23: string?) -- Line: 33
    -- upvalues: u13 (ref), u12 (ref), u14 (copy)
    local v24 = p22 and "PASS" or "FAIL";

    if p22 or not p23 then
        p23 = nil;
    end;

    local v25 = u13;
    v25[v24] = v25[v24] + 1;
    u12(`[{v24}] {p20}: {p21}` .. (p23 and p23 ~= "" and (` ({p23})` or "") or ""), u14[v24]);
end;

local function Skip(p26: string, p27: string, p28: string) -- Line: 37
    -- upvalues: u13 (ref), u12 (ref), u14 (copy)
    local v29 = u13;
    v29.SKIP = v29.SKIP + 1;
    u12(`[SKIP] {p26}: {p27}` .. (p28 and p28 ~= "" and (` ({p28})` or "") or ""), u14.SKIP);
end;

local function Shown(p30: userdata) -- Line: 41
    -- upvalues: u2 (ref)
    while p30 and p30 ~= u2.Handler do
        if p30:IsA("GuiObject") and not p30.Visible then
            return false;
        end;

        p30 = p30.Parent;
    end;

    return p30 == u2.Handler;
end;

local function Focusable(p31: userdata?) -- Line: 55
    -- upvalues: Shown (copy)
    local v32;

    if p31 == nil then
        v32 = false;
    else
        v32 = p31:IsA("GuiObject") and (p31.Selectable and p31.Interactable) and Shown(p31);
    end;

    return v32;
end;

local function Settle(p33: number?) -- Line: 59
    -- upvalues: u7 (ref)
    task.wait(p33 or 0.1);
    u7.Step(0);
end;

local function Focus(p34: userdata) -- Line: 64
    -- upvalues: GuiService (copy), u7 (ref)
    GuiService.SelectedObject = p34;
    task.wait();

    if GuiService.SelectedObject ~= p34 then
        GuiService.SelectedObject = p34;
        task.wait();
        local _ = GuiService.SelectedObject == p34;
    end;

    u7.Step(0);

    return GuiService.SelectedObject == p34;
end;

local function Move(p35: userdata) -- Line: 79
    -- upvalues: GuiService (copy)
    GuiService.SelectedObject = p35;
    task.wait();
    task.wait();

    return GuiService.SelectedObject;
end;

local function Drive(p36: any, p37: number) -- Line: 87
    -- upvalues: u7 (ref)
    u7.SetVirtual(p36);
    u7.Step(p37);
    u7.SetVirtual({});
    u7.Step(0);
end;

local function Overlaps(p38: userdata, p39: userdata) -- Line: 94
    local AbsolutePosition = p38.AbsolutePosition;
    local AbsoluteSize = p38.AbsoluteSize;
    local AbsolutePosition2 = p39.AbsolutePosition;
    local AbsoluteSize2 = p39.AbsoluteSize;
    local v40;

    if AbsolutePosition.X < AbsolutePosition2.X + AbsoluteSize2.X and (AbsolutePosition2.X < AbsolutePosition.X + AbsoluteSize.X and AbsolutePosition.Y < AbsolutePosition2.Y + AbsoluteSize2.Y) then
        v40 = AbsolutePosition2.Y < AbsolutePosition.Y + AbsoluteSize.Y;
    else
        v40 = false;
    end;

    return v40;
end;

local function Open(p41: any, p42: string) -- Line: 101
    local v43 = p41.Pages[p42];

    if v43.HasUnderHold then
        for i, v in p41.Pages do
            if v.UnderUI and v43.Button:IsDescendantOf(v.UnderUI) then
                p41:OpenTab(i);
                break;
            end;
        end;
    end;

    p41:OpenTab(p42);
end;

local function ActivePage(p44) -- Line: 116
    return p44.CurrentTab.Name == "PageUnder" and p44.CurrentTabUnder or p44.CurrentTab;
end;

local function Targets(p45: userdata) -- Line: 120
    -- upvalues: u5 (ref), Shown (copy)
    local v46 = {};

    for _, descendant in p45:GetDescendants() do
        local _, v47 = u5.Locate(descendant);

        if not v47 then
            local v48;

            if descendant == nil then
                v48 = false;
            else
                v48 = descendant:IsA("GuiObject") and (descendant.Selectable and descendant.Interactable) and Shown(descendant);
            end;

            if v48 then
                table.insert(v46, descendant);
            end;
        end;
    end;

    return v46;
end;

local function Trip(p49: string, p50: string, p51: userdata, p52: userdata?, p53: any) -- Line: 134
    -- upvalues: Shown (copy), u13 (ref), u12 (ref), u14 (copy), Focus (copy), GuiService (copy)
    local v54 = nil;

    for _, descendant in p51:GetDescendants() do
        if descendant ~= p52 and descendant:IsA("GuiButton") then
            local v55;

            if descendant == nil then
                v55 = false;
            else
                v55 = descendant:IsA("GuiObject") and (descendant.Selectable and descendant.Interactable) and Shown(descendant);
            end;

            if v55 then
                v54 = descendant;
                break;
            end;
        end;
    end;

    if not (p52 and v54) then
        local v56 = u13;
        v56.SKIP = v56.SKIP + 1;
        u12(`[SKIP] {p49}: {`{p50} focus memory`}` .. " (strip has one button)", u14.SKIP);

        return;
    end;

    local v57 = p53[#p53];
    local v58 = p53[1];
    Focus(v57);
    local v59 = `{p50}: up lands on the active tab`;
    GuiService.SelectedObject = v54;
    task.wait();
    task.wait();
    local v60 = GuiService.SelectedObject == p52 and "PASS" or "FAIL";
    local v61 = nil;
    local v62 = u13;
    v62[v60] = v62[v60] + 1;
    u12(`[{v60}] {p49}: {v59}` .. (v61 and v61 ~= "" and (` ({v61})` or "") or ""), u14[v60]);
    local v63 = `{p50}: down returns to the last item`;
    GuiService.SelectedObject = v58;
    task.wait();
    task.wait();
    local v64 = GuiService.SelectedObject == v57 and "PASS" or "FAIL";
    local v65 = nil;
    local v66 = u13;
    v66[v64] = v66[v64] + 1;
    u12(`[{v64}] {p49}: {v63}` .. (v65 and v65 ~= "" and (` ({v65})` or "") or ""), u14[v64]);
end;

local function TestTabs(p67: string) -- Line: 159
    -- upvalues: u6 (ref), u13 (ref), u12 (ref), u14 (copy)
    for _, v in { { "Inventory", "Home", "Inventory" }, { "Loadout", "Home", "Store", "Home", "Loadout" }, { "Inventory", "Home", "Loadout", "Home" } } do
        local v68 = v;

        for _, v2 in v do
            u6.OpenTab(v2);
            task.wait(0.05);
        end;

        task.wait(0.6);
        local CurrentTab = u6.GetCurrentTab();
        local v69 = {};

        for _, child in CurrentTab.Parent:GetChildren() do
            if child ~= CurrentTab and child.Visible then
                table.insert(v69, child.Name);
            end;
        end;

        local v70 = `fast {table.concat(v68, " > ")} leaves only {CurrentTab.Name} shown`;
        local v71;

        if CurrentTab.Name == v68[#v68] then
            v71 = CurrentTab.Visible and #v69 == 0;
        else
            v71 = false;
        end;

        local table_concat_ret = table.concat(v69, ", ");
        local v72 = v71 and "PASS" or "FAIL";

        if v71 or not table_concat_ret then
            table_concat_ret = nil;
        end;

        local v73 = u13;
        v73[v72] = v73[v72] + 1;
        u12(`[{v72}] {p67}: {v70}` .. (table_concat_ret and table_concat_ret ~= "" and (` ({table_concat_ret})` or "") or ""), u14[v72]);
    end;
end;

local function TestScoreboard(p74: string) -- Line: 181
    -- upvalues: u2 (ref), u13 (ref), u12 (ref), u14 (copy)
    local v75 = {};
    local v76 = 0;

    for _, descendant in u2.Handler.HUD.Scoreboard:GetDescendants() do
        if descendant:IsA("GuiObject") and descendant.Selectable then
            if descendant.Name == "CL" then
                v76 = v76 + 1;
            else
                table.insert(v75, descendant:GetFullName());
            end;
        end;
    end;

    local v77 = `{v76} player rows take focus`;
    local v78 = v76 > 0 and "PASS" or "FAIL";
    local v79 = nil;
    local v80 = u13;
    v80[v78] = v80[v78] + 1;
    u12(`[{v78}] {p74}: {v77}` .. (v79 and v79 ~= "" and (` ({v79})` or "") or ""), u14[v78]);
    local v81 = #v75 == 0;
    local v82 = v75[1];
    local v83 = v81 and "PASS" or "FAIL";

    if v81 or not v82 then
        v82 = nil;
    end;

    local v84 = u13;
    v84[v83] = v84[v83] + 1;
    u12(`[{v83}] {p74}: avatars and blur are not focus targets` .. (v82 and v82 ~= "" and (` ({v82})` or "") or ""), u14[v83]);
end;

local function TestBuymenu(p85: string) -- Line: 201
    -- upvalues: u2 (ref), u13 (ref), u12 (ref), u14 (copy), u10 (ref), u7 (ref), GuiService (copy), Shown (copy), Focus (copy)
    local Buymenu = u2.Handler.HUD.Buymenu;
    local v86 = {};
    local v87 = {};

    for _, descendant in Buymenu:GetDescendants() do
        if descendant:IsA("GuiButton") and descendant:FindFirstChild("ItemName") then
            table.insert(v86, descendant);

            if not descendant.Selectable then
                table.insert(v87, descendant.ItemName.Text);
            end;
        end;
    end;

    local v88 = `{#v86} weapon cards accept focus`;
    local v89;

    if #v86 > 0 then
        v89 = #v87 == 0;
    else
        v89 = false;
    end;

    local table_concat_ret = table.concat(v87, ", ");
    local v90 = v89 and "PASS" or "FAIL";

    if v89 or not table_concat_ret then
        table_concat_ret = nil;
    end;

    local v91 = u13;
    v91[v90] = v91[v90] + 1;
    u12(`[{v90}] {p85}: {v88}` .. (table_concat_ret and table_concat_ret ~= "" and (` ({table_concat_ret})` or "") or ""), u14[v90]);

    if u2.Handler.MainMenu.Visible or not u2.Handler.HUD.Visible then
        local v92 = u13;
        v92.SKIP = v92.SKIP + 1;
        u12(`[SKIP] {p85}: open, focus, close` .. " (run it in a round with the main menu closed)", u14.SKIP);

        return;
    end;

    local Visible = Buymenu.Visible;

    if not Visible then
        u10.Visible();
        task.wait(0.3);
    end;

    if not Buymenu.Visible then
        local v93 = u13;
        v93.SKIP = v93.SKIP + 1;
        u12(`[SKIP] {p85}: open, focus, close` .. " (stand in a buy zone during buy time)", u14.SKIP);

        return;
    end;

    task.wait(0.1);
    u7.Step(0);
    local SelectedObject = GuiService.SelectedObject;
    local v94;

    if u7.Active() == "Buymenu" and SelectedObject ~= nil then
        v94 = SelectedObject:IsDescendantOf(Buymenu);
    else
        v94 = false;
    end;

    local v95 = v94 and "PASS" or "FAIL";
    local v96 = nil;
    local v97 = u13;
    v97[v95] = v97[v95] + 1;
    u12(`[{v95}] {p85}: opening moves focus into the buy menu` .. (v96 and v96 ~= "" and (` ({v96})` or "") or ""), u14[v95]);
    local v98 = nil;

    for _, v in v86 do
        local v99;

        if v == nil then
            v99 = false;
        else
            v99 = v:IsA("GuiObject") and (v.Selectable and v.Interactable) and Shown(v);
        end;

        if v99 then
            v98 = v;
            break;
        end;
    end;

    if v98 then
        local v100 = Focus(v98) and "PASS" or "FAIL";
        local v101 = nil;
        local v102 = u13;
        v102[v100] = v102[v100] + 1;
        u12(`[{v100}] {p85}: weapon card takes focus (A buys it)` .. (v101 and v101 ~= "" and (` ({v101})` or "") or ""), u14[v100]);
        task.wait(0.3);
        local v103 = v98.BackgroundColor3.R * 255 > 40 and "PASS" or "FAIL";
        local v104 = nil;
        local v105 = u13;
        v105[v103] = v105[v103] + 1;
        u12(`[{v103}] {p85}: focus highlights like mouse hover` .. (v104 and v104 ~= "" and (` ({v104})` or "") or ""), u14[v103]);
    else
        local v106 = u13;
        v106.SKIP = v106.SKIP + 1;
        u12(`[SKIP] {p85}: weapon card focus` .. " (no weapon cards shown)", u14.SKIP);
    end;

    u7.Press(Enum.KeyCode.ButtonB);
    task.wait(0.3);
    local v107 = Buymenu.Visible and "FAIL" or "PASS";
    local v108 = nil;
    local v109 = u13;
    v109[v107] = v109[v107] + 1;
    u12(`[{v107}] {p85}: B closes the buy menu` .. (v108 and v108 ~= "" and (` ({v108})` or "") or ""), u14[v107]);

    if Visible then
        u10.Visible();
    end;
end;

local function TestLoadout(p110: string) -- Line: 267
    -- upvalues: u6 (ref), u7 (ref), u8 (ref), Shown (copy), u13 (ref), u12 (ref), u14 (copy), Focus (copy)
    u6.OpenTab("Loadout");
    task.wait(0.5);
    u7.Step(0);
    local u111 = nil;
    local u112 = nil;

    for _, v in u8.GetSlots() do
        local v113 = v["1"];
        local v114 = v["2"];

        if typeof(v113) == "Instance" and (typeof(v114) == "Instance" and (Shown(v113.Icon) and Shown(v114.Icon))) then
            u112 = v114;
            u111 = v113;
            break;
        end;
    end;

    if not u111 then
        local v115 = u13;
        v115.SKIP = v115.SKIP + 1;
        u12(`[SKIP] {p110}: drag and drop` .. " (no category with two visible slots)", u14.SKIP);

        return;
    end;

    local Icon = u111.Icon;
    local v116;

    if Icon == nil then
        v116 = false;
    else
        v116 = Icon:IsA("GuiObject") and (Icon.Selectable and Icon.Interactable) and Shown(Icon);
    end;

    local v117 = v116 and "PASS" or "FAIL";
    local v118 = nil;
    local v119 = u13;
    v119[v117] = v119[v117] + 1;
    u12(`[{v117}] {p110}: slot icon is focusable` .. (v118 and v118 ~= "" and (` ({v118})` or "") or ""), u14[v117]);
    local v120 = u111.IconShadow.Selectable and "FAIL" or "PASS";
    local v121 = nil;
    local v122 = u13;
    v122[v120] = v122[v120] + 1;
    u12(`[{v120}] {p110}: icon shadow is not a focus target` .. (v121 and v121 ~= "" and (` ({v121})` or "") or ""), u14[v120]);
    local Attribute = u111:GetAttribute("WeaponName");
    local Attribute2 = u112:GetAttribute("WeaponName");

    local function Carry() -- Line: 292
        -- upvalues: Focus (ref), u111 (ref), u7 (ref), u8 (ref), u112 (ref)
        Focus(u111.Icon);
        u7.Press(Enum.KeyCode.ButtonX);
        local v123 = u8.IsHolding();
        Focus(u112.Icon);

        return v123;
    end;

    local function Slots() -- Line: 303
        -- upvalues: u111 (ref), u112 (ref)
        return `{u111:GetAttribute("WeaponName")} / {u112:GetAttribute("WeaponName")}`;
    end;

    Focus(u111.Icon);
    u7.Press(Enum.KeyCode.ButtonX);
    local v124 = u8.IsHolding();
    Focus(u112.Icon);
    local v125 = v124 and "PASS" or "FAIL";
    local v126 = nil;
    local v127 = u13;
    v127[v125] = v127[v125] + 1;
    u12(`[{v125}] {p110}: X picks up the focused weapon` .. (v126 and v126 ~= "" and (` ({v126})` or "") or ""), u14[v125]);
    u7.Press(Enum.KeyCode.ButtonB);
    task.wait(0.1);
    local v128 = not u8.IsHolding();

    if v128 then
        if u111:GetAttribute("WeaponName") == Attribute then
            v128 = u112:GetAttribute("WeaponName") == Attribute2;
        else
            v128 = false;
        end;
    end;

    local v129 = `{u111:GetAttribute("WeaponName")} / {u112:GetAttribute("WeaponName")}`;
    local v130 = v128 and "PASS" or "FAIL";

    if v128 or not v129 then
        v129 = nil;
    end;

    local v131 = u13;
    v131[v130] = v131[v130] + 1;
    u12(`[{v130}] {p110}: B cancels without placing` .. (v129 and v129 ~= "" and (` ({v129})` or "") or ""), u14[v130]);
    Focus(u111.Icon);
    u7.Press(Enum.KeyCode.ButtonX);
    u8.IsHolding();
    Focus(u112.Icon);
    u7.Press(Enum.KeyCode.ButtonX);
    task.wait(0.1);
    local v132 = not u8.IsHolding();

    if v132 then
        if u111:GetAttribute("WeaponName") == Attribute2 then
            v132 = u112:GetAttribute("WeaponName") == Attribute;
        else
            v132 = false;
        end;
    end;

    local v133 = `{u111:GetAttribute("WeaponName")} / {u112:GetAttribute("WeaponName")}`;
    local v134 = v132 and "PASS" or "FAIL";

    if v132 or not v133 then
        v133 = nil;
    end;

    local v135 = u13;
    v135[v134] = v135[v134] + 1;
    u12(`[{v134}] {p110}: X places onto the focused slot` .. (v133 and v133 ~= "" and (` ({v133})` or "") or ""), u14[v134]);
    Focus(u111.Icon);
    u7.Press(Enum.KeyCode.ButtonX);
    u8.IsHolding();
    Focus(u112.Icon);
    u7.Press(Enum.KeyCode.ButtonX);
    task.wait(0.1);
    local v136;

    if u111:GetAttribute("WeaponName") == Attribute then
        v136 = u112:GetAttribute("WeaponName") == Attribute2;
    else
        v136 = false;
    end;

    local v137 = `{u111:GetAttribute("WeaponName")} / {u112:GetAttribute("WeaponName")}`;
    local v138 = v136 and "PASS" or "FAIL";

    if v136 or not v137 then
        v137 = nil;
    end;

    local v139 = u13;
    v139[v138] = v139[v138] + 1;
    u12(`[{v138}] {p110}: loadout restored` .. (v137 and v137 ~= "" and (` ({v137})` or "") or ""), u14[v138]);
end;

local function TestPlay(p140: string) -- Line: 327
    -- upvalues: u6 (ref), u7 (ref), Shown (copy), u13 (ref), u12 (ref), u14 (copy), Focus (copy)
    u6.OpenTab("Play");
    task.wait(0.5);
    u7.Step(0);
    local CurrentTab = u6.GetCurrentTab();

    for _, v in { "CT", "T" } do
        local ImageButton = CurrentTab[v].ImageButton;
        local v141 = v;
        local v142 = {};

        for _, descendant in CurrentTab[v]:GetDescendants() do
            if descendant ~= ImageButton and (descendant:IsA("GuiObject") and descendant.Selectable) then
                table.insert(v142, descendant.Name);
            end;
        end;

        local v143 = `{v141} circle is focusable`;
        local v144;

        if ImageButton == nil then
            v144 = false;
        else
            v144 = ImageButton:IsA("GuiObject") and (ImageButton.Selectable and ImageButton.Interactable) and Shown(ImageButton);
        end;

        local v145 = v144 and "PASS" or "FAIL";
        local v146 = nil;
        local v147 = u13;
        v147[v145] = v147[v145] + 1;
        u12(`[{v145}] {p140}: {v143}` .. (v146 and v146 ~= "" and (` ({v146})` or "") or ""), u14[v145]);
        local v148 = `{v141} circle is the only target in its card`;
        local v149 = #v142 == 0;
        local table_concat_ret = table.concat(v142, ", ");
        local v150 = v149 and "PASS" or "FAIL";

        if v149 or not table_concat_ret then
            table_concat_ret = nil;
        end;

        local v151 = u13;
        v151[v150] = v151[v150] + 1;
        u12(`[{v150}] {p140}: {v148}` .. (table_concat_ret and table_concat_ret ~= "" and (` ({table_concat_ret})` or "") or ""), u14[v150]);
        local v152 = `{v141} circle takes focus (A joins)`;
        local v153 = Focus(ImageButton) and "PASS" or "FAIL";
        local v154 = nil;
        local v155 = u13;
        v155[v153] = v155[v153] + 1;
        u12(`[{v153}] {p140}: {v152}` .. (v154 and v154 ~= "" and (` ({v154})` or "") or ""), u14[v153]);
        task.wait(0.3);
        local v156 = `{v141} focus highlights like mouse hover`;
        local v157 = ImageButton.ImageLabel.ImageTransparency < 0.3 and "PASS" or "FAIL";
        local v158 = nil;
        local v159 = u13;
        v159[v157] = v159[v157] + 1;
        u12(`[{v157}] {p140}: {v156}` .. (v158 and v158 ~= "" and (` ({v158})` or "") or ""), u14[v157]);
    end;

    local Spectate = CurrentTab.Spectate;
    local v160;

    if Spectate == nil then
        v160 = false;
    else
        v160 = Spectate:IsA("GuiObject") and (Spectate.Selectable and Spectate.Interactable) and Shown(Spectate);
    end;

    local v161 = v160 and "PASS" or "FAIL";
    local v162 = nil;
    local v163 = u13;
    v163[v161] = v163[v161] + 1;
    u12(`[{v161}] {p140}: Spectate is focusable` .. (v162 and v162 ~= "" and (` ({v162})` or "") or ""), u14[v161]);
end;

local function TestStore(p164: string) -- Line: 355
    -- upvalues: u6 (ref), u7 (ref), u5 (ref), Open (copy), Shown (copy), u13 (ref), u12 (ref), u14 (copy), Focus (copy)
    u6.OpenTab("Store");
    task.wait(0.3);
    u7.Step(0);
    local v165 = u5.Find(u6.GetCurrentTab());
    Open(v165, "Containers");
    task.wait(0.5);
    u7.Step(0);
    local v166 = {};

    for _, descendant in v165.Hold:GetDescendants() do
        if descendant:IsA("GuiButton") and (descendant:GetAttribute("ConnectName") and Shown(descendant)) then
            table.insert(v166, descendant);
        end;
    end;

    if #v166 == 0 then
        local v167 = u13;
        v167.SKIP = v167.SKIP + 1;
        u12(`[SKIP] {p164}: case cards` .. " (no cases listed)", u14.SKIP);

        return;
    end;

    local v168 = {};
    local v169 = {};

    for _, v in v166 do
        local v170;

        if v == nil then
            v170 = false;
        else
            v170 = v:IsA("GuiObject") and (v.Selectable and v.Interactable) and Shown(v);
        end;

        if not v170 or v.Icon.Selectable then
            table.insert(v168, v.Name);
        end;

        local v171 = v;

        for _, descendant in v:GetDescendants() do
            if descendant:IsA("GuiObject") and (descendant.Selectable and not descendant:IsDescendantOf(v171.Price)) then
                table.insert(v169, descendant:GetFullName());
            end;
        end;
    end;

    local v172 = `{#v166} case cards take focus, icons do not`;
    local v173 = #v168 == 0;
    local table_concat_ret = table.concat(v168, ", ");
    local v174 = v173 and "PASS" or "FAIL";

    if v173 or not table_concat_ret then
        table_concat_ret = nil;
    end;

    local v175 = u13;
    v175[v174] = v175[v174] + 1;
    u12(`[{v174}] {p164}: {v172}` .. (table_concat_ret and table_concat_ret ~= "" and (` ({table_concat_ret})` or "") or ""), u14[v174]);
    local v176 = #v169 == 0;
    local v177 = v169[1];
    local v178 = v176 and "PASS" or "FAIL";

    if v176 or not v177 then
        v177 = nil;
    end;

    local v179 = u13;
    v179[v178] = v179[v178] + 1;
    u12(`[{v178}] {p164}: only purchase buttons are nested targets` .. (v177 and v177 ~= "" and (` ({v177})` or "") or ""), u14[v178]);
    local v180 = v166[1];
    local v181 = Focus(v180) and "PASS" or "FAIL";
    local v182 = nil;
    local v183 = u13;
    v183[v181] = v183[v181] + 1;
    u12(`[{v181}] {p164}: case card takes focus (A opens purchase)` .. (v182 and v182 ~= "" and (` ({v182})` or "") or ""), u14[v181]);
    task.wait(0.35);
    local v184 = v180.Icon.Size.X.Scale > 1 and "PASS" or "FAIL";
    local v185 = nil;
    local v186 = u13;
    v186[v184] = v186[v184] + 1;
    u12(`[{v184}] {p164}: focus highlights like mouse hover` .. (v185 and v185 ~= "" and (` ({v185})` or "") or ""), u14[v184]);
end;

local function TestCaseScreen(p187: string) -- Line: 403
    -- upvalues: u6 (ref), u7 (ref), u5 (ref), Open (copy), Shown (copy), u4 (ref), u13 (ref), u12 (ref), u14 (copy), u2 (ref), Focus (copy), u11 (ref), GuiService (copy)
    u6.OpenTab("Store");
    task.wait(0.3);
    u7.Step(0);
    local v188 = u5.Find(u6.GetCurrentTab());
    Open(v188, "Containers");
    task.wait(0.5);
    u7.Step(0);
    local v189 = nil;
    local v190 = nil;
    local v191 = nil;

    for _, descendant in v188.Hold:GetDescendants() do
        if descendant:IsA("GuiButton") and (descendant:GetAttribute("ConnectName") and Shown(descendant)) then
            v191 = descendant;
            break;
        end;
    end;

    for i, v in u4.GetItems("Containers") do
        if v.Available and v.Price then
            v190 = i;
            v189 = v;
            break;
        end;
    end;

    if not (v191 and v189) then
        local v192 = u13;
        v192.SKIP = v192.SKIP + 1;
        u12(`[SKIP] {p187}: case screen` .. " (no cases listed)", u14.SKIP);

        return;
    end;

    local CaseInspect = u2.Handler.CaseInspect;
    local Skip2 = CaseInspect.MainInspect.SkipBar.Skip;
    local v193 = {};

    for _, descendant in CaseInspect.MainInspect.SkipBar:GetDescendants() do
        if descendant ~= Skip2 and (descendant:IsA("GuiObject") and descendant.Selectable) then
            table.insert(v193, descendant.Name);
        end;
    end;

    local v194 = Skip2.Selectable and #v193 == 0;
    local table_concat_ret = table.concat(v193, ", ");
    local v195 = v194 and "PASS" or "FAIL";

    if v194 or not table_concat_ret then
        table_concat_ret = nil;
    end;

    local v196 = u13;
    v196[v195] = v196[v195] + 1;
    u12(`[{v195}] {p187}: Skip is the only target in the skip bar` .. (table_concat_ret and table_concat_ret ~= "" and (` ({table_concat_ret})` or "") or ""), u14[v195]);
    local v197 = CaseInspect.RareItems.Selectable and "FAIL" or "PASS";
    local v198 = nil;
    local v199 = u13;
    v199[v197] = v199[v197] + 1;
    u12(`[{v197}] {p187}: rare items backdrop is not a focus target` .. (v198 and v198 ~= "" and (` ({v198})` or "") or ""), u14[v197]);
    Focus(v191);
    u11.SetVisible(true, v189.Price, v189.RobuxPrice, v190, v189.Thumbnail);
    task.wait(0.5);
    u7.Step(0);
    local SelectedObject = GuiService.SelectedObject;
    local v200 = CaseInspect.Visible and u7.Active() == "CaseInspect";
    local v201 = v200 and "PASS" or "FAIL";
    local v202 = nil;
    local v203 = u13;
    v203[v201] = v203[v201] + 1;
    u12(`[{v201}] {p187}: purchase screen takes controller focus` .. (v202 and v202 ~= "" and (` ({v202})` or "") or ""), u14[v201]);
    local v204;

    if SelectedObject == nil then
        v204 = false;
    else
        v204 = SelectedObject:IsDescendantOf(CaseInspect.MainInspect.DownBar);
    end;

    local v205 = v204 and "PASS" or "FAIL";
    local v206 = nil;
    local v207 = u13;
    v207[v205] = v207[v205] + 1;
    u12(`[{v205}] {p187}: focus lands on a purchase button` .. (v206 and v206 ~= "" and (` ({v206})` or "") or ""), u14[v205]);
    local OddsHover = CaseInspect.MainInspect.DownBar.LeftDown.OddsHover;
    local v208 = Focus(OddsHover) and "PASS" or "FAIL";
    local v209 = nil;
    local v210 = u13;
    v210[v208] = v210[v208] + 1;
    u12(`[{v208}] {p187}: case odds take focus` .. (v209 and v209 ~= "" and (` ({v209})` or "") or ""), u14[v208]);
    task.wait(0.35);
    local v211 = OddsHover.HoverFrame.GroupTransparency < 0.5 and "PASS" or "FAIL";
    local v212 = nil;
    local v213 = u13;
    v213[v211] = v213[v211] + 1;
    u12(`[{v211}] {p187}: focus shows the odds like mouse hover` .. (v212 and v212 ~= "" and (` ({v212})` or "") or ""), u14[v211]);
    u7.Press(Enum.KeyCode.ButtonB);
    task.wait(0.5);
    task.wait(0.1);
    u7.Step(0);
    local v214 = CaseInspect.Visible and "FAIL" or "PASS";
    local v215 = nil;
    local v216 = u13;
    v216[v214] = v216[v214] + 1;
    u12(`[{v214}] {p187}: B closes the purchase screen` .. (v215 and v215 ~= "" and (` ({v215})` or "") or ""), u14[v214]);
    local Visible = u2.Handler.MainMenu.Visible;

    if Visible then
        if u7.Active() == "MainMenu" then
            Visible = u6.GetCurrentTab().Name == "Store";
        else
            Visible = false;
        end;
    end;

    local v217 = Visible and "PASS" or "FAIL";
    local v218 = nil;
    local v219 = u13;
    v219[v217] = v219[v217] + 1;
    u12(`[{v217}] {p187}: B brings the main menu back` .. (v218 and v218 ~= "" and (` ({v218})` or "") or ""), u14[v217]);
    local v220 = GuiService.SelectedObject == v191 and "PASS" or "FAIL";
    local v221 = nil;
    local v222 = u13;
    v222[v220] = v222[v220] + 1;
    u12(`[{v220}] {p187}: focus returns to the case card` .. (v221 and v221 ~= "" and (` ({v221})` or "") or ""), u14[v220]);
end;

local function TestChallenges(p223: string) -- Line: 472
    -- upvalues: u6 (ref), u7 (ref), u5 (ref), Open (copy), Shown (copy), u13 (ref), u12 (ref), u14 (copy), Focus (copy), GuiService (copy)
    u6.OpenTab("Rewards");
    task.wait(0.3);
    u7.Step(0);
    local v224 = u5.Find(u6.GetCurrentTab());
    Open(v224, "Challenges");
    task.wait(0.5);
    u7.Step(0);
    local Abandon = v224.Pages.Challenges.Page:FindFirstChild("Abandon", true);
    local Claim = Abandon.Parent.Claim;
    local v225;

    if Claim == nil then
        v225 = false;
    else
        v225 = Claim:IsA("GuiObject") and (Claim.Selectable and Claim.Interactable) and Shown(Claim);
    end;

    local v226 = v225 and "PASS" or "FAIL";
    local v227 = nil;
    local v228 = u13;
    v228[v226] = v228[v226] + 1;
    u12(`[{v226}] {p223}: Start button is focusable` .. (v227 and v227 ~= "" and (` ({v227})` or "") or ""), u14[v226]);

    if Claim.Title.Text == "CLAIM" then
        local v229 = Abandon.Selectable == (Abandon.Title.TextTransparency < 1) and "PASS" or "FAIL";
        local v230 = nil;
        local v231 = u13;
        v231[v229] = v231[v229] + 1;
        u12(`[{v229}] {p223}: Abandon is a target only while drawn` .. (v230 and v230 ~= "" and (` ({v230})` or "") or ""), u14[v229]);
    else
        local v232 = Abandon.Selectable and "FAIL" or "PASS";
        local v233 = nil;
        local v234 = u13;
        v234[v232] = v234[v232] + 1;
        u12(`[{v232}] {p223}: hidden Abandon is not a target` .. (v233 and v233 ~= "" and (` ({v233})` or "") or ""), u14[v232]);
    end;

    local v235 = {};

    for _, descendant in Abandon.Parent:GetDescendants() do
        if descendant ~= Claim and not descendant:IsDescendantOf(Claim) then
            local v236;

            if descendant == nil then
                v236 = false;
            else
                v236 = descendant:IsA("GuiObject") and (descendant.Selectable and descendant.Interactable) and Shown(descendant);
            end;

            if v236 then
                local AbsolutePosition = descendant.AbsolutePosition;
                local AbsoluteSize = descendant.AbsoluteSize;
                local AbsolutePosition2 = Claim.AbsolutePosition;
                local AbsoluteSize2 = Claim.AbsoluteSize;
                local v237;

                if AbsolutePosition.X < AbsolutePosition2.X + AbsoluteSize2.X and (AbsolutePosition2.X < AbsolutePosition.X + AbsoluteSize.X and AbsolutePosition.Y < AbsolutePosition2.Y + AbsoluteSize2.Y) then
                    v237 = AbsolutePosition2.Y < AbsolutePosition.Y + AbsoluteSize.Y;
                else
                    v237 = false;
                end;

                if v237 then
                    table.insert(v235, descendant.Name);
                end;
            end;
        end;
    end;

    local v238 = #v235 == 0;
    local table_concat_ret = table.concat(v235, ", ");
    local v239 = v238 and "PASS" or "FAIL";

    if v238 or not table_concat_ret then
        table_concat_ret = nil;
    end;

    local v240 = u13;
    v240[v239] = v240[v239] + 1;
    u12(`[{v239}] {p223}: nothing focusable overlaps Start` .. (table_concat_ret and table_concat_ret ~= "" and (` ({table_concat_ret})` or "") or ""), u14[v239]);
    local v241 = Focus(Claim) and "PASS" or "FAIL";
    local v242 = nil;
    local v243 = u13;
    v243[v241] = v243[v241] + 1;
    u12(`[{v241}] {p223}: Start takes focus` .. (v242 and v242 ~= "" and (` ({v242})` or "") or ""), u14[v241]);
    task.wait(0.3);
    u7.Step(0);
    local v244 = GuiService.SelectedObject == Claim and "PASS" or "FAIL";
    local v245 = nil;
    local v246 = u13;
    v246[v244] = v246[v244] + 1;
    u12(`[{v244}] {p223}: Start keeps focus` .. (v245 and v245 ~= "" and (` ({v245})` or "") or ""), u14[v244]);
end;

local function TestColorPicker(p247: string) -- Line: 508
    -- upvalues: u6 (ref), u7 (ref), u5 (ref), u3 (ref), Open (copy), Shown (copy), u13 (ref), u12 (ref), u14 (copy), GuiService (copy), Drive (copy), Focus (copy)
    u6.OpenTab("Settings");
    task.wait(0.3);
    u7.Step(0);
    local v248 = u5.Find(u6.GetCurrentTab());
    local v249 = nil;
    local v250 = nil;

    if u3.ActivePicker then
        u3.Pickers[u3.ActivePicker].Close();
    end;

    for i, v in u3.Pickers do
        local v251 = i;
        local v252 = v;

        for i2, v2 in v248.Pages do
            if v2.Page and v252.Row:IsDescendantOf(v2.Page) then
                Open(v248, i2);
                task.wait(0.3);
                u7.Step(0);
                break;
            end;
        end;

        if Shown(v252.Row) then
            v249 = v251;
            v250 = v252;
        end;
    end;

    if not v250 then
        local v253 = u13;
        v253.SKIP = v253.SKIP + 1;
        u12(`[SKIP] {p247}: picker` .. " (no color picker row found)", u14.SKIP);

        return;
    end;

    local v254 = { v250.Get() };
    local Row = v250.Row;
    local v255;

    if Row == nil then
        v255 = false;
    else
        v255 = Row:IsA("GuiObject") and (Row.Selectable and Row.Interactable) and Shown(Row);
    end;

    if v255 then
        v255 = not v250.Row.SelectedColor.Selectable;
    end;

    local v256 = v255 and "PASS" or "FAIL";
    local v257 = nil;
    local v258 = u13;
    v258[v256] = v258[v256] + 1;
    u12(`[{v256}] {p247}: color row takes focus (A opens picker)` .. (v257 and v257 ~= "" and (` ({v257})` or "") or ""), u14[v256]);
    u3.PickerOpen(v249, v250.Row);
    task.wait(0.2);
    u7.Step(0);
    local SelectedObject = GuiService.SelectedObject;
    local v259;

    if u7.Active() == "ColorPicker" and SelectedObject ~= nil then
        v259 = SelectedObject:IsDescendantOf(v249);
    else
        v259 = false;
    end;

    local v260 = v259 and "PASS" or "FAIL";
    local v261 = nil;
    local v262 = u13;
    v262[v260] = v262[v260] + 1;
    u12(`[{v260}] {p247}: opening moves focus into the picker` .. (v261 and v261 ~= "" and (` ({v261})` or "") or ""), u14[v260]);
    local v263, _, _ = v250.Get();
    Drive({
        [v263 < 0.5 and Enum.KeyCode.ButtonR2 or Enum.KeyCode.ButtonL2] = Vector3.new(0, 0, 1)
    }, 0.3);
    local v264 = v250.Get() - v263;
    local v265 = math.abs(v264) > 0.05 and "PASS" or "FAIL";
    local v266 = nil;
    local v267 = u13;
    v267[v265] = v267[v265] + 1;
    u12(`[{v265}] {p247}: LT/RT shift hue` .. (v266 and v266 ~= "" and (` ({v266})` or "") or ""), u14[v265]);
    local _, v268, v269 = v250.Get();
    Drive({
        [Enum.KeyCode.Thumbstick2] = Vector3.new(v268 < 0.5 and 1 or -1, v269 < 0.5 and 1 or -1, 0)
    }, 0.3);
    local _, v270, v271 = v250.Get();
    local v272;

    if math.abs(v270 - v268) > 0.05 then
        v272 = math.abs(v271 - v269) > 0.05;
    else
        v272 = false;
    end;

    local v273 = v272 and "PASS" or "FAIL";
    local v274 = nil;
    local v275 = u13;
    v275[v273] = v275[v273] + 1;
    u12(`[{v273}] {p247}: right stick moves the shade` .. (v274 and v274 ~= "" and (` ({v274})` or "") or ""), u14[v273]);
    Focus(v250.Hue);
    local v276 = v250.Get();
    Drive({
        [v276 < 0.5 and Enum.KeyCode.DPadRight or Enum.KeyCode.DPadLeft] = true
    }, 0.3);
    local v277 = v250.Get() - v276;
    local v278 = math.abs(v277) > 0.05 and "PASS" or "FAIL";
    local v279 = nil;
    local v280 = u13;
    v280[v278] = v280[v278] + 1;
    u12(`[{v278}] {p247}: D-pad slides the hue bar` .. (v279 and v279 ~= "" and (` ({v279})` or "") or ""), u14[v278]);
    local v281;

    if v250.Hue.NextSelectionLeft == v250.Hue then
        v281 = v250.Hue.NextSelectionRight == v250.Hue;
    else
        v281 = false;
    end;

    local v282 = v281 and "PASS" or "FAIL";
    local v283 = nil;
    local v284 = u13;
    v284[v282] = v284[v282] + 1;
    u12(`[{v282}] {p247}: hue bar keeps left/right for itself` .. (v283 and v283 ~= "" and (` ({v283})` or "") or ""), u14[v282]);
    Focus(v250.Lightness);
    local _, _, v285 = v250.Get();
    Drive({
        [v285 < 0.5 and Enum.KeyCode.DPadLeft or Enum.KeyCode.DPadRight] = true
    }, 0.3);
    local _, _, v286 = v250.Get();
    local v287 = math.abs(v286 - v285) > 0.05 and "PASS" or "FAIL";
    local v288 = nil;
    local v289 = u13;
    v289[v287] = v289[v287] + 1;
    u12(`[{v287}] {p247}: D-pad slides the lightness bar` .. (v288 and v288 ~= "" and (` ({v288})` or "") or ""), u14[v287]);
    Focus(v250.Saturation);
    local v290;

    if v250.Saturation.NextSelectionUp == v250.Saturation and (v250.Saturation.NextSelectionDown == v250.Saturation and v250.Saturation.NextSelectionLeft == v250.Saturation) then
        v290 = v250.Saturation.NextSelectionRight == v250.Saturation;
    else
        v290 = false;
    end;

    local v291 = v290 and "PASS" or "FAIL";
    local v292 = nil;
    local v293 = u13;
    v293[v291] = v293[v291] + 1;
    u12(`[{v291}] {p247}: shade square keeps every direction for itself` .. (v292 and v292 ~= "" and (` ({v292})` or "") or ""), u14[v291]);
    local _, v294, v295 = v250.Get();
    Drive({
        [v294 < 0.5 and Enum.KeyCode.DPadRight or Enum.KeyCode.DPadLeft] = true
    }, 0.3);
    local _, v296 = v250.Get();
    local v297 = math.abs(v296 - v294) > 0.05 and "PASS" or "FAIL";
    local v298 = nil;
    local v299 = u13;
    v299[v297] = v299[v297] + 1;
    u12(`[{v297}] {p247}: D-pad moves the shade cursor directly` .. (v298 and v298 ~= "" and (` ({v298})` or "") or ""), u14[v297]);
    Drive({
        [Enum.KeyCode.Thumbstick1] = Vector3.new(0, v295 < 0.5 and 1 or -1, 0)
    }, 0.3);
    local _, _, v300 = v250.Get();
    local v301 = math.abs(v300 - v295) > 0.05 and "PASS" or "FAIL";
    local v302 = nil;
    local v303 = u13;
    v303[v301] = v303[v301] + 1;
    u12(`[{v301}] {p247}: left stick moves the shade cursor directly` .. (v302 and v302 ~= "" and (` ({v302})` or "") or ""), u14[v301]);
    u7.Press(Enum.KeyCode.ButtonA);
    task.wait(0.1);
    u7.Step(0);
    local v304 = GuiService.SelectedObject == v250.Hue and "PASS" or "FAIL";
    local v305 = nil;
    local v306 = u13;
    v306[v304] = v306[v304] + 1;
    u12(`[{v304}] {p247}: A leaves the square to the hue bar` .. (v305 and v305 ~= "" and (` ({v305})` or "") or ""), u14[v304]);
    Focus(v250.Saturation);
    u7.Press(Enum.KeyCode.ButtonB);
    task.wait(0.1);
    u7.Step(0);
    local v307;

    if GuiService.SelectedObject == v250.Hue then
        v307 = v249.Visible and u7.Active() == "ColorPicker";
    else
        v307 = false;
    end;

    local v308 = v307 and "PASS" or "FAIL";
    local v309 = nil;
    local v310 = u13;
    v310[v308] = v310[v308] + 1;
    u12(`[{v308}] {p247}: B leaves the square and keeps the picker open` .. (v309 and v309 ~= "" and (` ({v309})` or "") or ""), u14[v308]);
    u7.Press(Enum.KeyCode.ButtonB);
    task.wait(0.1);
    u7.Step(0);
    local v311 = not v249.Visible;

    if v311 then
        if u6.GetCurrentTab().Name == "Settings" then
            v311 = u7.Active() == "MainMenu";
        else
            v311 = false;
        end;
    end;

    local v312 = v311 and "PASS" or "FAIL";
    local v313 = nil;
    local v314 = u13;
    v314[v312] = v314[v312] + 1;
    u12(`[{v312}] {p247}: second B closes only the picker` .. (v313 and v313 ~= "" and (` ({v313})` or "") or ""), u14[v312]);
    v250.Set(unpack(v254));
    v250.Commit();
end;

local function TestKeybinds(p315: string) -- Line: 619
    -- upvalues: u6 (ref), u7 (ref), u5 (ref), u2 (ref), u3 (ref), Open (copy), Shown (copy), u13 (ref), u12 (ref), u14 (copy), Focus (copy), GuiService (copy)
    u6.OpenTab("Settings");
    task.wait(0.3);
    u7.Step(0);
    local v316 = u5.Find(u6.GetCurrentTab());
    local GamepadHints = u2.Handler.GamepadHints;
    local v317 = nil;

    for i in u3.Binds do
        local v318 = i;

        for i2, v in v316.Pages do
            if v.Page and v318:IsDescendantOf(v.Page) then
                Open(v316, i2);
                task.wait(0.3);
                u7.Step(0);
                break;
            end;
        end;

        if Shown(v318) then
            v317 = v318;
        end;
    end;

    if not v317 then
        local v319 = u13;
        v319.SKIP = v319.SKIP + 1;
        u12(`[SKIP] {p315}: keybinds` .. " (no keybind row found)", u14.SKIP);

        return;
    end;

    local v320;

    if v317 == nil then
        v320 = false;
    else
        v320 = v317:IsA("GuiObject") and (v317.Selectable and v317.Interactable) and Shown(v317);
    end;

    local v321 = v320 and "PASS" or "FAIL";
    local v322 = nil;
    local v323 = u13;
    v323[v321] = v323[v321] + 1;
    u12(`[{v321}] {p315}: bind button is focusable (A rebinds)` .. (v322 and v322 ~= "" and (` ({v322})` or "") or ""), u14[v321]);
    local v324 = v317.Remove.Selectable and "FAIL" or "PASS";
    local v325 = nil;
    local v326 = u13;
    v326[v324] = v326[v324] + 1;
    u12(`[{v324}] {p315}: small remove button is not a focus target` .. (v325 and v325 ~= "" and (` ({v325})` or "") or ""), u14[v324]);
    local v327 = Focus(v317) and "PASS" or "FAIL";
    local v328 = nil;
    local v329 = u13;
    v329[v327] = v329[v327] + 1;
    u12(`[{v327}] {p315}: bind takes focus` .. (v328 and v328 ~= "" and (` ({v328})` or "") or ""), u14[v327]);
    task.wait(0.1);
    u7.Step(0);
    local v330 = GamepadHints.Remove.Visible and "PASS" or "FAIL";
    local v331 = nil;
    local v332 = u13;
    v332[v330] = v332[v330] + 1;
    u12(`[{v330}] {p315}: X REMOVE hint shows on a bind` .. (v331 and v331 ~= "" and (` ({v331})` or "") or ""), u14[v330]);
    u3.Capturing = true;
    task.wait(0.1);
    u7.Step(0);
    local v333;

    if GuiService.SelectedObject == nil then
        v333 = u7.Navigating();
    else
        v333 = false;
    end;

    local v334 = v333 and "PASS" or "FAIL";
    local v335 = nil;
    local v336 = u13;
    v336[v334] = v336[v334] + 1;
    u12(`[{v334}] {p315}: capturing lifts focus so A/B/D-pad get bound` .. (v335 and v335 ~= "" and (` ({v335})` or "") or ""), u14[v334]);
    local v337 = GamepadHints.Cancel.Visible and not GamepadHints.Select.Visible and not GamepadHints.Back.Visible and "PASS" or "FAIL";
    local v338 = nil;
    local v339 = u13;
    v339[v337] = v339[v337] + 1;
    u12(`[{v337}] {p315}: capturing shows only the CANCEL hint` .. (v338 and v338 ~= "" and (` ({v338})` or "") or ""), u14[v337]);
    u3.Capturing = false;
    task.wait(0.1);
    u7.Step(0);
    local v340 = GuiService.SelectedObject == v317 and "PASS" or "FAIL";
    local v341 = nil;
    local v342 = u13;
    v342[v340] = v342[v340] + 1;
    u12(`[{v340}] {p315}: focus returns to the bind after capture` .. (v341 and v341 ~= "" and (` ({v341})` or "") or ""), u14[v340]);
end;

local function TestAnalytics(p343: string) -- Line: 667
    -- upvalues: u6 (ref), u7 (ref), u5 (ref), u13 (ref), u12 (ref), u14 (copy), Open (copy), Targets (copy), Trip (copy), GuiService (copy), Shown (copy), u9 (ref), Focus (copy)
    u6.OpenTab("Analytics");
    task.wait(0.3);
    u7.Step(0);
    local v344 = u5.Find(u6.GetCurrentTab());
    local v345 = {};

    for _, descendant in v344.Hold:GetDescendants() do
        if descendant:IsA("GuiObject") and not (descendant:IsA("GuiButton") or (descendant:IsA("TextBox") or (not descendant.Selectable or descendant:GetAttribute("Select") == true))) then
            table.insert(v345, descendant:GetFullName());
        end;
    end;

    local v346 = #v345 == 0;
    local v347 = v345[1];
    local v348 = v346 and "PASS" or "FAIL";

    if v346 or not v347 then
        v347 = nil;
    end;

    local v349 = u13;
    v349[v348] = v349[v348] + 1;
    u12(`[{v348}] {p343}: no untagged containers act as focus sinks` .. (v347 and v347 ~= "" and (` ({v347})` or "") or ""), u14[v348]);

    for _, v in { "Leaderboards", "Containers", "Scoreboard", "Weapon Stats", "Timeline" } do
        Open(v344, v);
        local v350 = os.clock() + 3;
        local v351 = v;
        local v352;

        repeat
            task.wait(0.2);
            v352 = Targets(v344.CurrentTab.Name == "PageUnder" and v344.CurrentTabUnder or v344.CurrentTab);
        until #v352 > 0 or v350 < os.clock();

        u7.Step(0);

        if #v352 == 0 then
            local v353 = u13;
            v353.SKIP = v353.SKIP + 1;
            u12(`[SKIP] {p343}: {`{v351} focus`}` .. " (page has no data yet)", u14.SKIP);
        else
            local v354 = u13;
            v354.PASS = v354.PASS + 1;
            u12(`[PASS] {p343}: {`{v351} has {#v352} focus targets`}` .. "", u14.PASS);
            Trip(p343, `{v351} tabs`, v344.TopHolder, v344.ActiveButton, v352);

            if v344.CurrentTab.Name == "PageUnder" then
                Trip(p343, `{v351} sub-tabs`, v344.CurrentTab, v344.ActiveUnder, v352);
            end;
        end;
    end;

    Open(v344, "Leaderboards");
    task.wait(0.3);
    u7.Step(0);
    local v355 = 0;
    local v356 = {};

    for _, child in v344.TopHolder:GetChildren() do
        if child:IsA("GuiButton") and child.Visible then
            v355 = v355 + 1;
        end;
    end;

    for i = 1, v355 do
        u7.Press(Enum.KeyCode.ButtonR2);
        task.wait(0.2);
        u7.Step(0);
        local SelectedObject = GuiService.SelectedObject;
        local v357;

        if SelectedObject and (SelectedObject:IsDescendantOf(v344.CurrentTab.Name == "PageUnder" and v344.CurrentTabUnder or v344.CurrentTab) or SelectedObject == v344.ActiveButton) then
            v357 = i;
        else
            table.insert(v356, v344.ActiveButton.TabText.Text);
            v357 = i;
        end;
    end;

    local v358 = #v356 == 0;
    local table_concat_ret = table.concat(v356, ", ");
    local v359 = v358 and "PASS" or "FAIL";

    if v358 or not table_concat_ret then
        table_concat_ret = nil;
    end;

    local v360 = u13;
    v360[v359] = v360[v359] + 1;
    u12(`[{v359}] {p343}: LT/RT land focus on every page` .. (table_concat_ret and table_concat_ret ~= "" and (` ({table_concat_ret})` or "") or ""), u14[v359]);
    Open(v344, "Matches");
    task.wait(0.5);
    u7.Step(0);
    local v361 = {};

    for _, descendant in v344.Hold:GetDescendants() do
        if descendant:GetAttribute("MatchIndex") then
            local v362;

            if descendant == nil then
                v362 = false;
            else
                v362 = descendant:IsA("GuiObject") and (descendant.Selectable and descendant.Interactable) and Shown(descendant);
            end;

            if v362 then
                table.insert(v361, descendant);
            end;
        end;
    end;

    if #v361 == 0 then
        local v363 = u13;
        v363.SKIP = v363.SKIP + 1;
        u12(`[SKIP] {p343}: match rows` .. " (no matches played)", u14.SKIP);

        return;
    end;

    local Selected = u9.GetSelected();
    local v364 = v361[1];

    for _, v in v361 do
        if v:GetAttribute("MatchIndex") ~= Selected then
            v364 = v;
            break;
        end;
    end;

    Focus(v364);
    u7.Press(Enum.KeyCode.ButtonA);
    local v365 = u9.GetSelected() == v364:GetAttribute("MatchIndex") and "PASS" or "FAIL";
    local v366 = nil;
    local v367 = u13;
    v367[v365] = v367[v365] + 1;
    u12(`[{v365}] {p343}: A on a match row opens that match` .. (v366 and v366 ~= "" and (` ({v366})` or "") or ""), u14[v365]);

    if Selected and Selected ~= u9.GetSelected() then
        u9.SelectMatch(Selected);
    end;
end;

local function Execute(p368: string, p369: any) -- Line: 769
    -- upvalues: u12 (ref), u14 (copy), u13 (ref), u7 (ref)
    u12(`-- {p368}`, u14.INFO);
    local success, result = pcall(p369, p368);

    if not success then
        local v370 = tostring(result);
        local v371 = u13;
        v371.FAIL = v371.FAIL + 1;
        u12(`[FAIL] {p368}: suite errored` .. (v370 and v370 ~= "" and (` ({v370})` or "") or ""), u14.FAIL);
    end;

    u7.SetVirtual({});
end;

function v1.Run(p372) -- Line: 783
    -- upvalues: u12 (ref), u13 (ref), u2 (ref), u6 (ref), u7 (ref), Execute (copy), TestBuymenu (copy), TestScoreboard (copy), TestTabs (copy), TestLoadout (copy), TestPlay (copy), TestStore (copy), TestCaseScreen (copy), TestChallenges (copy), TestColorPicker (copy), TestKeybinds (copy), TestAnalytics (copy), u14 (copy)
    u12 = p372;
    u13 = {
        PASS = 0,
        FAIL = 0,
        SKIP = 0
    };
    local MainMenu = u2.Handler.MainMenu;
    local Visible = MainMenu.Visible;
    local CurrentTab = u6.GetCurrentTab();
    u7.Force(true);
    u7.SetVirtual({});
    task.wait(0.1);
    u7.Step(0);
    Execute("Buy Menu", TestBuymenu);

    if not MainMenu.Visible then
        u6.Visible(true);
        task.wait(1);
    end;

    Execute("Scoreboard", TestScoreboard);
    Execute("Tabs", TestTabs);
    Execute("Loadout", TestLoadout);
    Execute("Play", TestPlay);
    Execute("Store", TestStore);
    Execute("Case Screen", TestCaseScreen);
    Execute("Challenges", TestChallenges);
    Execute("Color Picker", TestColorPicker);
    Execute("Keybinds", TestKeybinds);
    Execute("Analytics", TestAnalytics);
    u7.SetVirtual(nil);
    u7.Force(false);

    if Visible then
        if CurrentTab and CurrentTab ~= u6.GetCurrentTab() then
            u6.OpenTab(CurrentTab.Name);
        end;
    else
        u6.Visible();
    end;

    u12(`{u13.PASS} passed, {u13.FAIL} failed, {u13.SKIP} skipped`, u13.FAIL > 0 and u14.FAIL or u14.PASS);
end;

function v1.Init(p373) -- Line: 827
    -- upvalues: u2 (ref), u3 (ref), u4 (ref), u5 (ref), u6 (ref), u7 (ref), u8 (ref), u9 (ref), u10 (ref), u11 (ref)
    u2 = p373:GetModule("Gui");
    u3 = p373:GetModule("Settings");
    u4 = p373:GetModule("ItemManager");
    u5 = u2.GetComponent("Tabs");
    u6 = u2.GetComponent("MainMenu");
    u7 = u2.GetComponent("Gamepad");
    u8 = u2.GetComponent("Loadout");
    u9 = u2.GetComponent("Matches");
    u10 = u2.GetComponent("Buymenu");
    u11 = u2.GetComponent("CaseInspect");
end;

return v1;