-- ReplicatedStorage.Classes.WeaponComponent.Classes.Viewmodel
-- Script path: ReplicatedStorage.Classes.WeaponComponent.Classes.Viewmodel
-- Decompile time: 31.98 ms

local flushCarryOver
local u0 = {}
u0.__index = u0
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
require(script:WaitForChild("Types"))
local Camera = ((ReplicatedStorage:WaitForChild("Assets")):WaitForChild("MuzzleFlashes")):WaitForChild("Camera")
local DataController = require(ReplicatedStorage.Controllers.DataController)
local CharacterResolver = require(ReplicatedStorage.Components.Common.CharacterResolver)
local RunServiceController = require(ReplicatedStorage.Controllers.RunServiceController)
local GetMuzzleFlash = require(ReplicatedStorage.Components.Common.VFXLibary.CreateMuzzleFlash.GetMuzzleFlash)
local AttachGlovesToViewmodel = require(ReplicatedStorage.Database.Components.Common.AttachGlovesToViewmodel)
local Skins = require(ReplicatedStorage.Database.Components.Libraries.Skins)
local Sound = require(ReplicatedStorage.Classes.Sound)
local Janitor = require(ReplicatedStorage.Shared.Janitor)
local BakedViewmodelMirror = require(ReplicatedStorage.Shared.BakedViewmodelMirror)
local ViewmodelHand = require(ReplicatedStorage.Shared.ViewmodelHand)
local Router = require(ReplicatedStorage.Database.Security.Router)
local Animation = require(script.Classes.Animation)
local Bobble = require(script.Classes.Bobble)
local CurrentCamera = workspace.CurrentCamera
local u102 = table.freeze({})
local u103 = {"Weapon", "WeaponL", "WeaponR", "CharmBase"}
local u112 = CFrame.new(0, 10000, 0)
local u113 = {}
local u114 = 0
local u115 = nil
local u116 = {}

local function updateTransparency(a1, a2) -- Line: 67 -- types: a1: userdata, a2: boolean
    local Attribute, Attribute_2, Transparency, Transparency_2
    for i, v in ipairs(a1:GetDescendants()) do
        if v:IsA("BasePart") then
            Attribute = v:GetAttribute("HiddenTransparency")
            if a2 then
                Transparency = v.Transparency
                v.Transparency = 1
                if not Attribute then
                    v:SetAttribute("HiddenTransparency", Transparency)
                end
            elseif Attribute then
                v.Transparency = Attribute
            end
        elseif v:IsA("Texture") then
            if not a2 then
                Attribute_2 = v:GetAttribute("HiddenTransparency")
                if Attribute_2 ~= nil then
                    v.Transparency = Attribute_2
                    v:SetAttribute("HiddenTransparency", nil)
                end
            elseif v.Transparency < 1 then
                Transparency_2 = v.Transparency
                v:SetAttribute("HiddenTransparency", Transparency_2)
                v.Transparency = 1
            end
        end
    end
end

local function setupMuzzleFlashPart(a1, a2) -- Line: 99
    -- upvalues: GetMuzzleFlash (val), Camera (val)
    if a1 and a2.MuzzleType then
        GetMuzzleFlash(a1, Camera, a2.MuzzleType, "Motor6D")
        if a2.HasSuppressor then
            GetMuzzleFlash(a1, Camera, "Suppressor", "Motor6D")
        end
        return
    end
end

local function stripWeaponGeometry(a1) -- Line: 112 -- upvalues: u103 (val) -- types: a1: userdata
    local v1
    for i, v in ipairs(u103) do
        v1 = a1:FindFirstChild(v)
        if v1 then
            v1:Destroy()
        end
    end
end

local function findWeaponRoot(a1) -- Line: 121 -- types: a1: userdata
    return a1:FindFirstChild("Weapon") or a1:FindFirstChild("WeaponL") or a1:FindFirstChild("WeaponR")
end

local function getViewmodelStash() -- Line: 126 -- upvalues: u115 (ref), CurrentCamera (val)
    local v1 = u115
    if not v1 or v1.Parent ~= CurrentCamera then
        v1 = Instance.new("Folder")
        v1.Name = "ViewmodelStash"
        v1.Parent = CurrentCamera
        u115 = v1
    end
    return v1
end

local function getCarryOverKey(a1, a2, a3) -- Line: 138 -- upvalues: Players (val) -- types: a2: string, a3: string
    if not a1.Character and a1.Player == Players.LocalPlayer and a2 ~= "C4" then
        local Charm = a1.Charm
        local v1 = if type(Charm) ~= "table" then tostring(Charm) else ("%*:%*:%*"):format(Charm.Skin, Charm.Pattern, Charm.Position)
        local concat = table.concat
        local v2 = {}
        local v3 = a1.ViewmodelCameraWeapon or a2
        local v4 = tostring(a1.Float)
        local v5 = false
        if a1.StatTrack ~= nil then
            v5 = a1.StatTrack ~= false
        end
        local v6 = tostring(v5)
        v5 = tostring(a1.NameTag)
        local v7 = a1.ViewmodelHideWeaponGeometry == true
        v2[1] = v3
        v2[2] = a2
        v2[3] = a3
        v2[4] = v4
        v2[5] = v6
        v2[6] = v5
        v2[7] = v1
        v2[8] = (tostring(v7))
        return concat(v2, "|")
    end
    return nil
end

local function getCharacterKey(a1) -- Line: 158 -- types: a1: userdata
    local Attribute = a1:GetAttribute("Team")
    local Attribute_2 = a1:GetAttribute("CharacterName") or workspace:GetAttribute(if Attribute ~= "Counter-Terrorists" then "TCharacter" else "CTCharacter")
    local v1 = a1:FindFirstChild("Body Colors")
    local Torso = a1:FindFirstChild("Torso") or a1:FindFirstChild("UpperTorso")
    local TorsoColor3 = if not v1 then if not Torso then nil else if not Torso:IsA("BasePart") then nil else Torso.Color else v1.TorsoColor3
    return table.concat({
        tostring(Attribute),
        tostring(Attribute_2),
        tostring((a1:GetAttribute("EquippedGloves"))),
        if not TorsoColor3 then "" else TorsoColor3:ToHex(),
    }, "|")
end

local function isLocalPlayerDead() -- Line: 176 -- upvalues: Players (val)
    return Players.LocalPlayer:GetAttribute("Dead") == true
end

function flushCarryOver() -- Line: 180 -- upvalues: Players (val), u116 (val), flushCarryOver (val)
    local v1
    if Players.LocalPlayer:GetAttribute("Dead") == true then
        return
    end
    local v2 = os.clock()
    for i = #u116, 1, -1 do
        v1 = u116[i]
        if v1.Viewmodel.IsDestroyed then
            table.remove(u116, i)
        elseif v1.ExpiresAt <= v2 then
            table.remove(u116, i)
            v1.Viewmodel:destroy()
            task.delay(0, flushCarryOver)
            return
        end
    end
end

;(Players.LocalPlayer:GetAttributeChangedSignal("Dead")):Connect(function() -- Line: 201 -- upvalues: Players (val), u116 (val), flushCarryOver (val)
    local v1 = Players.LocalPlayer:GetAttribute("Dead") == true
    if not v1 and #u116 ~= 0 then
        v1 = os.clock() + 5
        for i, j in u116 do
            j.ExpiresAt = math.max(j.ExpiresAt, v1)
        end
        task.delay(5.1, flushCarryOver)
        return
    end
end)

local function weldLooseParts(a1) -- Line: 213 -- types: a1: userdata
    local Part0, Part1, Weld, v1
    local PrimaryPart = a1.PrimaryPart
    if not PrimaryPart then
        return
    end
    local Descendants = a1:GetDescendants()
    local v2 = {}
    for i, v in ipairs(Descendants) do
        if v:IsA("JointInstance") then
            if v.Enabled then
                Part0 = v.Part0
                Part1 = v.Part1
                if Part0 and Part1 then
                    v1 = v2[Part0] or {}
                    v2[Part0] = v1
                    v1 = v2[Part1] or {}
                    v2[Part1] = v1
                    table.insert(v2[Part0], Part1)
                    table.insert(v2[Part1], Part0)
                end
            end
        elseif v:IsA("WeldConstraint") and v.Enabled then
            Part0 = v.Part0
            Part1 = v.Part1
            if Part0 and Part1 then
                v1 = v2[Part0] or {}
                v2[Part0] = v1
                v1 = v2[Part1] or {}
                v2[Part1] = v1
                table.insert(v2[Part0], Part1)
                table.insert(v2[Part1], Part0)
            end
        end
    end
    local v3 = {[PrimaryPart] = true}
    local v4 = {PrimaryPart}
    while #v4 > 0 do
        for i2, j in v2[table.remove(v4)] or {} do
            if not v3[j] then
                v3[j] = true
                table.insert(v4, j)
            end
        end
    end
    local CharmBase = a1:FindFirstChild("CharmBase")
    for i3, k in ipairs(Descendants) do
        if k:IsA("BasePart") and k ~= PrimaryPart then
            if not CharmBase or not k:IsDescendantOf(CharmBase) then
                k.Anchored = false
                if not v3[k] then
                    Weld = Instance.new("Weld")
                    Weld.Name = "LooseWeld"
                    Weld.Part0 = PrimaryPart
                    Weld.Part1 = k
                    Weld.C0 = PrimaryPart.CFrame:ToObjectSpace(k.CFrame)
                    Weld.Parent = k
                end
            end
        end
    end
end

local function getChargeGuiObject(a1, a2) -- Line: 261 -- types: a1: userdata?, a2: string
    local Interactables = a1 and a1:FindFirstChild("Interactables")
    local Charge = Interactables and Interactables:FindFirstChild("Charge", true)
    local SurfaceGui = Charge and Charge:FindFirstChildOfClass("SurfaceGui")
    if not SurfaceGui then
        return nil
    end
    local v1 = SurfaceGui:FindFirstChild(a2)
    if v1 and v1:IsA(a2) then
        return v1
    end
    return SurfaceGui:FindFirstChildWhichIsA(a2)
end

local function getRechargeChargeAlpha(a1) -- Line: 277
    local Properties = a1 and a1.Properties
    if not Properties then
        return nil
    end
    local RechargeTime = Properties.RechargeTime
    local Rounds = Properties.Rounds
    if RechargeTime and Rounds and not (Rounds <= 0) then
        local v1 = math.clamp(((tonumber(a1.Rounds)) or Rounds) / Rounds, 0, 1)
        if v1 >= 1 then
            return 1
        end
        local v2 = tonumber(a1.RechargeStartTime)
        if not v2 then
            return v1
        end
        return (math.clamp(v1 + math.clamp((math.max((workspace:GetServerTimeNow()) - v2, 0)) / RechargeTime, 0, 1) / Rounds, 0, 1))
    end
    return nil
end

local u142 = Color3.fromRGB(125, 20, 20)
local u147 = Color3.fromRGB(255, 235, 140)
local u152 = Color3.fromRGB(40, 223, 213)

local function updateChargeFrame(a1, a2) -- Line: 313
    -- upvalues: getChargeGuiObject (val), getRechargeChargeAlpha (val), u152 (val), u142 (val), u147 (val)
    local ChargeFillFrame = a1.ChargeFillFrame
    if not ChargeFillFrame or not ChargeFillFrame.Parent then
        ChargeFillFrame = getChargeGuiObject(a1.Model, "Frame")
        a1.ChargeFillFrame = ChargeFillFrame
        a1.ChargeFillBaseSize = ChargeFillFrame and ChargeFillFrame.Size or nil
    end
    local ChargeTextLabel = a1.ChargeTextLabel
    if not ChargeTextLabel or not ChargeTextLabel.Parent then
        a1.ChargeTextLabel = (getChargeGuiObject(a1.Model, "TextLabel"))
    end
    local ChargeFillBaseSize = a1.ChargeFillBaseSize
    if ChargeFillFrame and ChargeFillBaseSize then
        local v1, v2
        local v3 = getRechargeChargeAlpha(a1.WeaponComponent) or 1
        local DisplayedChargeAlpha = a1.DisplayedChargeAlpha
        if DisplayedChargeAlpha == nil then
            v1 = v3
        elseif not (v3 < DisplayedChargeAlpha) then
            v2 = math.clamp(a2 * 3.5, 0, 1)
            v1 = DisplayedChargeAlpha + (v3 - DisplayedChargeAlpha) * v2
        else
            v1 = v3
        end
        if (math.abs(v3 - v1)) <= 0.001 then
            v1 = v3
        end
        if v1 >= 0.999 then
            v1 = 1
        end
        a1.DisplayedChargeAlpha = v1
        ChargeFillFrame.Size = UDim2.new(ChargeFillBaseSize.X.Scale, ChargeFillBaseSize.X.Offset, 0.8 * v1, 0)
        ChargeFillFrame.BackgroundColor3 = if not (v1 >= 0.999) then u142:Lerp(u147, v1) else u152
        if ChargeTextLabel then
            ChargeTextLabel.Text = ("%*%%"):format((math.round(v1 * 100)))
            ChargeTextLabel.TextColor3 = v2
        end
        return
    end
end

local u154 = {}
local u155 = {}

local function singleAssemblyRoot(a1) -- Line: 371 -- types: a1: userdata
    local PrimaryPart = a1.PrimaryPart
    if PrimaryPart == nil then
        return nil
    end
    for i, j in a1:GetDescendants() do
        if j:IsA("BasePart") and j.AssemblyRootPart ~= PrimaryPart then
            return nil
        end
    end
    return PrimaryPart
end

local function pivotModel(a1, a2, a3) -- Line: 384
    -- upvalues: singleAssemblyRoot (val), u154 (val), u155 (val)
    local v1 = os.clock()
    local v2 = a1[a2]
    if v2 == nil or v2.CheckAt <= v1 then
        a1[a2] = {Root = singleAssemblyRoot(a2), CheckAt = v1 + 0.5}
    end
    local Root = v2.Root
    if Root ~= nil and Root.Parent ~= nil and a2.PrimaryPart == Root then
        local v3 = u154
        local v4 = u155
        local v5 = a3 * (Root.PivotOffset:Inverse())
        v3[1] = Root
        v4[1] = v5
        workspace:BulkMoveTo(u154, u155, Enum.BulkMoveMode.FireCFrameChanged)
        return
    end
    a2:PivotTo(a3)
end

function u0.aim(a1) -- Line: 403 -- upvalues: CurrentCamera (val)
    a1.Bobble:setIsAiming(true)
    if a1.MuzzlePartWeld then
        local CFrame = CurrentCamera.CFrame
        local WorldPivot = a1.Model.WorldPivot
        local CFrame_2 = a1.MuzzlePartWeld.Part0.CFrame
        if a1.Mirror then
            WorldPivot = a1.Mirror:ToNormalPose((a1.Model:GetPivot()))
            CFrame_2 = a1.Mirror:ToNormalPose(CFrame_2)
        end
        local v1 = CFrame + CFrame.UpVector * -0.5 + WorldPivot.LookVector * 1 + WorldPivot.RightVector * 0.1
        a1.MuzzlePartWeld.C0 = CFrame_2:Inverse() * v1
    end
end

function u0:unaim() -- Line: 425
    self.Bobble:setIsAiming(false)
    if self.OriginalC0 and self.MuzzlePartWeld then
        self.MuzzlePartWeld.C0 = self.OriginalC0
    end
end

function u0:unhide() -- Line: 434 -- upvalues: updateTransparency (val)
    if self.Hidden then
        updateTransparency(self.Model, false)
        self.Hidden = false
    end
end

function u0.hide(a1) -- Line: 443 -- upvalues: updateTransparency (val)
    if not a1.Hidden then
        updateTransparency(a1.Model, true)
        a1.Hidden = true
    end
end

function u0:equip(a2) -- Line: 452 -- upvalues: CurrentCamera (val) -- types: a2: boolean
    self.IsEquipped = true
    if not self.Model then
        return
    end
    if self.Mirror then
        self.Mirror:PrepareEquip()
    end
    self.Model.Parent = CurrentCamera
    if self.LargeWeaponModel then
        self.LargeWeaponModel.Parent = CurrentCamera
    end
    self.Animation:stopAnimations()
    self.Animation:play("Idle")
    self:unhide()
    if not a2 then
        self.Animation:play((self.Animation:pickVariant("Equip")))
    end
end

function u0:unequip() -- Line: 478 -- upvalues: u115 (ref), CurrentCamera (val), pivotModel (val), u112 (val)
    self.IsEquipped = false
    self.Animation:stopAnimations()
    self.LastViewmodelPosition = nil
    local Model = self.Model
    if Model and Model:IsDescendantOf(workspace) then
        local v1 = u115
        if not v1 or v1.Parent ~= CurrentCamera then
            v1 = Instance.new("Folder")
            v1.Name = "ViewmodelStash"
            v1.Parent = CurrentCamera
            u115 = v1
        end
        Model.Parent = v1
        pivotModel(self.PivotPlans, Model, u112)
    end
    if self.LargeWeaponModel then
        self.LargeWeaponModel.Parent = nil
    end
end

function u0:applyCharmImpulse(a2) -- Line: 497 -- types: a2: vector
    if self.LargeCharmModel and self.LargeCharmModel.PrimaryPart then
        local CharmMassCache = self.CharmMassCache
        if self.CharmMassCacheModel ~= self.LargeCharmModel then
            CharmMassCache = 0
            for i, v in ipairs(self.LargeCharmModel:GetDescendants()) do
                if v:IsA("BasePart") then
                    CharmMassCache = CharmMassCache + v:GetMass()
                end
            end
            self.CharmMassCache = CharmMassCache
            self.CharmMassCacheModel = self.LargeCharmModel
        elseif typeof(CharmMassCache) ~= "number" then
            CharmMassCache = 0
            for i2, i3 in ipairs(self.LargeCharmModel:GetDescendants()) do
                if i3:IsA("BasePart") then
                    CharmMassCache = CharmMassCache + i3:GetMass()
                end
            end
            self.CharmMassCache = CharmMassCache
            self.CharmMassCacheModel = self.LargeCharmModel
        end
        self.LargeCharmModel.PrimaryPart:ApplyImpulse(a2 * 10 * CharmMassCache)
    end
end

function u0.render(a1, a2) -- Line: 520
    -- upvalues: updateChargeFrame (val), DataController (val), u102 (val), CurrentCamera (val), ViewmodelHand (val)
    -- upvalues: pivotModel (val)
    local Model = a1.Model and a1.Model:FindFirstChild("Stats")
    if not Model then
        return
    end
    debug.profilebegin("Viewmodel.render.UpdateChargeFrame")
    updateChargeFrame(a1, a2)
    debug.profileend()
    debug.profilebegin("Viewmodel.render.GetViewmodelSettings")
    local v1 = DataController.Get(a1.Player, "Settings.Game.Viewmodel") or u102
    debug.profileend()
    if a1.Bobble or a1.Inspecting then
        debug.profilebegin("Viewmodel.render.BobbleNextCFrame")
        local v2, v3, v4 = a1.Bobble:getNextCFrame(a2)
        debug.profileend()
        local Value = Model.Rotation.Value
        local v5 = CurrentCamera.CFrame * v2 * CFrame.Angles(Value.X, Value.Y, Value.Z) * CFrame.new(Model.Default.Value) * CFrame.new((v1["X Offset"] or 0) / 100, (v1["Y Offset"] or 0) / 100, (v1["Z Offset"] or 0) / 100)
        debug.profilebegin("Viewmodel.render.PivotModel")
        local PivotPlans = a1.PivotPlans
        local Mirror = a1.Mirror
        if not Mirror then
            pivotModel(PivotPlans, a1.Model, v5)
        else
            Mirror:SetLeftHanded(not a1.WeaponComponent.Character and ViewmodelHand.IsPlayerLeftHanded(a1.Player))
            pivotModel(PivotPlans, a1.Model, Mirror:GetDisplayPose(CurrentCamera.CFrame, v5))
            Mirror:UpdateSurfaces()
        end
        debug.profileend()
        if a1.LargeWeaponModel and a1.SmallWeaponModel then
            local Pivot = a1.SmallWeaponModel:GetPivot()
            if Mirror then
                Pivot = Mirror:ToNormalPose(Pivot)
            end
            debug.profilebegin("Viewmodel.render.PivotLargeWeaponModel")
            pivotModel(PivotPlans, a1.LargeWeaponModel, Pivot)
            debug.profileend()
            local Position = v5.Position
            if a1.LastViewmodelPosition then
                a1:applyCharmImpulse(-(Position - a1.LastViewmodelPosition) * 0.2)
            end
            a1.LastViewmodelPosition = Position
        end
        if a1.Bobble.Scope and a1.Bobble.IsAiming then
            debug.profilebegin("Viewmodel.render.Scope")
            local CFrame_3 = CurrentCamera.CFrame
            local v6 = v4.X * -CFrame_3.LookVector + v4.Y * -CFrame_3.UpVector
            a1.Bobble.Scope:PivotTo(CFrame_3 + CFrame_3.LookVector * 0.15 + v3 + v6)
            if a1.Bobble.ScopeReticlePart then
                a1.Bobble.ScopeReticlePart.CFrame = CFrame_3 * CFrame.Angles(1.5707963267948966, 1.5707963267948966, -1.5707963267948966) + CFrame_3.LookVector * 0.15
            end
            debug.profileend()
        end
    end
end

function u0:attachSleeves(a2) -- Line: 600 -- upvalues: ReplicatedStorage (val) -- types: a2: string
    local v1, v2, v3, v4
    local v5 = ReplicatedStorage.Assets.Sleeves:FindFirstChild(a2)
    if not v5 then
        return
    end
    for i, v in ipairs(v5:GetChildren()) do
        v3 = self.Model:FindFirstChild(v.Name)
        if v3 then
            v4 = v:Clone()
            v4.CastShadow = false
            v4.CanCollide = false
            v4.CanTouch = false
            v4.Anchored = false
            v4.CanQuery = false
            v4.Name = "Sleeve"
            v4.Size = Vector3.new(v3.Size.X * 1.3, v3.Size.Y * 1.4, v3.Size.Z * 0.79)
            v1 = v3.Size.Z / 2 - v4.Size.Z / 2
            v4.Parent = v3
            v2 = Instance.new("Motor6D", v4)
            v2.Part0 = v3
            v2.Part1 = v4
            v2.C1 = CFrame.new(0, -0.02, -v1)
        end
    end
end

local function resolveInventoryGlove(a1, a2) -- Line: 637 -- upvalues: Router (val) -- types: a1: userdata, a2: string
    local v1 = Router.broadcastRouter("GetInventoryItemFromIdentifier", a1, a2)
    if v1 then
        return v1.Name, v1.Skin, v1.Float
    end
    return nil, nil, nil
end

function u0:addAttachments(a2) -- Line: 645
    -- upvalues: Router (val), u113 (val), Skins (val), u114 (ref), AttachGlovesToViewmodel (val)
    debug.profilebegin("Viewmodel.addAttachments")
    local Name_4 = nil
    local Skin_4 = nil
    local Float_4 = nil
    if type(a2) == "string" then
        local Float, Name, Skin
        local v1 = Router.broadcastRouter("GetInventoryItemFromIdentifier", self.Player, a2)
        if not v1 then
            Name = nil
            Skin = nil
            Float = nil
        else
            Name = v1.Name
            Skin = v1.Skin
            Float = v1.Float
        end
        Name_4 = Name
        Skin_4 = Skin
        Float_4 = Float
    elseif type(a2) == "table" then
        local SkinIdentifier = a2.SkinIdentifier
        if type(SkinIdentifier) == "string" and SkinIdentifier ~= "" then
            local Float_2, Name_2, Skin_2
            local v2 = Router.broadcastRouter("GetInventoryItemFromIdentifier", self.Player, SkinIdentifier)
            if not v2 then
                Name_2 = nil
                Skin_2 = nil
                Float_2 = nil
            else
                Name_2 = v2.Name
                Skin_2 = v2.Skin
                Float_2 = v2.Float
            end
            Name_4 = Name_2
            Skin_4 = Skin_2
            Float_4 = Float_2
        end
        if not Name_4 and type(a2.Name) == "string" and type(a2.Skin) == "string" then
            Name_4 = a2.Name
            Skin_4 = a2.Skin
            Float_4 = if typeof(a2.Float) ~= "number" then nil else a2.Float
        end
    end
    if Name_4 and Skin_4 then
        debug.profilebegin("Viewmodel.addAttachments.GetGloves")
        local v3 = ("%*|%*|%*"):format(Name_4, Skin_4, Float_4 or "")
        local v4 = u113[v3]
        if not v4 then
            v4 = Skins.GetGloves(Name_4, Skin_4, Float_4)
            local v5 = u113[v3]
            if v5 then
                if v4 then
                    v4:Destroy()
                end
                v4 = v5
            elseif v4 then
                if u114 >= 8 then
                    for i, j in u113 do
                        j:Destroy()
                    end
                    table.clear(u113)
                    u114 = 0
                end
                u113[v3] = v4
                u114 = u114 + 1
            end
        end
        debug.profileend()
        if v4 then
            debug.profilebegin("Viewmodel.addAttachments.AttachGloves")
            AttachGlovesToViewmodel(v4:GetChildren(), self.Model)
            debug.profileend()
        end
    end
    debug.profileend()
end

function u0:construct(a2, a3) -- Line: 701
    -- upvalues: Janitor (val), Skins (val), stripWeaponGeometry (val), getCharacterKey (val), HttpService (val)
    -- upvalues: GetMuzzleFlash (val), Camera (val), weldLooseParts (val), ReplicatedStorage (val), Players (val)
    -- upvalues: BakedViewmodelMirror (val)
    local v1
    debug.profilebegin("Viewmodel.construct")
    if self.ModelJanitor then
        debug.profilebegin("Viewmodel.construct.DestroyModelJanitor")
        self.ModelJanitor:Destroy()
        debug.profileend()
    end
    self.ModelJanitor = Janitor.new()
    self.Mirror = nil
    self.CharmModel = nil
    self.LargeWeaponModel = nil
    self.SmallWeaponModel = nil
    self.LargeCharmModel = nil
    self.LastViewmodelPosition = nil
    self.ChargeFillFrame = nil
    self.ChargeTextLabel = nil
    self.ChargeFillBaseSize = nil
    self.DisplayedChargeAlpha = nil
    if self.Animation then
        debug.profilebegin("Viewmodel.construct.StopAnimations")
        self.Animation:stopAnimations()
        debug.profileend()
    end
    if self.Model then
        debug.profilebegin("Viewmodel.construct.DestroyPreviousModel")
        self.Model:Destroy()
        debug.profileend()
        self.Model = nil
    end
    local CameraModelWeapon = self.CameraModelWeapon or self.Weapon
    local Team = self.Team
    debug.profilebegin("Viewmodel.construct.GetCameraModel")
    self.Model = Skins.GetCameraModel(
        CameraModelWeapon,
        self.Skin,
        self.Float,
        self.StatTrack,
        self.NameTag,
        self.Charm,
        self.Stickers,
        if CameraModelWeapon ~= "Smoke Grenade" then nil else if Team == "Counter-Terrorists" then Team else if Team ~= "Terrorists" then nil else Team
    )
    debug.profileend()
    if not self.Model and self.HideWeaponGeometry then
        debug.profilebegin("Viewmodel.construct.GetBaseWeaponModel")
        self.Model = Skins.GetBaseWeaponModel(CameraModelWeapon, "Camera")
        debug.profileend()
    end
    if not self.Model then
        debug.profileend()
        error((("Viewmodel.construct: Failed to get camera model for weapon \"%*\" with skin \"%*\""):format(CameraModelWeapon, self.Skin)))
    end
    self.Model.Name = CameraModelWeapon
    if self.HideWeaponGeometry then
        debug.profilebegin("Viewmodel.construct.StripWeaponGeometry")
        stripWeaponGeometry(self.Model)
        debug.profileend()
    end
    self.CharacterKey = getCharacterKey(a2)
    local Attribute = a2:GetAttribute("Team") or self.Team
    self.Team = Attribute
    local Attribute_2 = a2:GetAttribute("CharacterName")
    if type(Attribute_2) ~= "string" or Attribute_2 == "" then
        Attribute_2 = workspace:GetAttribute(if self.Team ~= "Counter-Terrorists" then "TCharacter" else "CTCharacter")
    end
    if type(Attribute_2) == "string" and Attribute_2 ~= "" then
        self:attachSleeves(Attribute_2)
    end
    local Attribute_3 = a2:GetAttribute("EquippedGloves")
    if type(Attribute_3) == "string" and Attribute_3 ~= "" then
        debug.profilebegin("Viewmodel.construct.DecodeEquippedGloves")
        local success, result = pcall(HttpService.JSONDecode, HttpService, Attribute_3)
        debug.profileend()
        if not success or not result then
            self:addAttachments(Attribute_3)
        else
            self:addAttachments(result)
        end
    end
    debug.profilebegin("Viewmodel.construct.SetupDescendants")
    local v2, v3, v4 = a2, self, a3
    for i, v in ipairs(self.Model:GetDescendants()) do
        if v:IsA("BasePart") then
            v.CollisionGroup = "Viewmodel"
            v.CanCollide = false
            v.CastShadow = false
            v.CanQuery = true
            v.CanTouch = false
            if v.Name == "HumanoidRootPart" or v.Name == "ViewmodelLight" then
                v.Transparency = 1
            end
        end
    end
    debug.profileend()
    debug.profilebegin("Viewmodel.construct.SetupArmColors")
    local v5 = v2:FindFirstChild("Body Colors")
    local TorsoColor3 = nil
    if not v5 then
        local Torso = v2:FindFirstChild("Torso") or v2:FindFirstChild("UpperTorso")
        if Torso and Torso:IsA("BasePart") then
            TorsoColor3 = Torso.Color
        end
    else
        TorsoColor3 = v5.TorsoColor3
    end
    if TorsoColor3 then
        for i2, i3 in ipairs({"Right Arm", "Left Arm"}) do
            v1 = v3.Model:FindFirstChild(i3)
            if v1 and v1:IsA("BasePart") then
                v1.Color = TorsoColor3
            end
        end
    end
    debug.profileend()
    debug.profilebegin("Viewmodel.construct.CacheMuzzleParts")
    local Interactables = v3.Model:FindFirstChild("Interactables")
    local MuzzlePart = Interactables and (Interactables:FindFirstChild("MuzzlePart", true) or Interactables:FindFirstChild("MuzzlePartL", true) or Interactables:FindFirstChild("MuzzlePartR", true))
    v3.MuzzlePart = MuzzlePart
    if Interactables then
        v3.MuzzlePartL = Interactables:FindFirstChild("MuzzlePartL", true)
        v3.MuzzlePartR = Interactables:FindFirstChild("MuzzlePartR", true)
        if v3.MuzzlePartL and v3.MuzzlePartL:IsA("BasePart") then
            v3.MuzzlePartL.Transparency = 1
        end
        if v3.MuzzlePartR and v3.MuzzlePartR:IsA("BasePart") then
            v3.MuzzlePartR.Transparency = 1
        end
    end
    if v3.MuzzlePart and v3.MuzzlePart:IsA("BasePart") then
        v3.MuzzlePart.Transparency = 1
    end
    debug.profileend()
    debug.profilebegin("Viewmodel.construct.ScaleTo")
    v3.Model:ScaleTo(0.1)
    debug.profileend()
    debug.profilebegin("Viewmodel.construct.CacheMuzzleWeld")
    if v3.MuzzlePart and not v3.MuzzlePart:FindFirstChild("WeldConstraint", true) then
        for i4, j in ipairs(v3.Model:GetDescendants()) do
            if j:IsA("Weld") then
                if j.Part1 ~= MuzzlePart and j.Part0 ~= MuzzlePart then
                    continue
                end
                v3.MuzzlePartWeld = j
                v3.OriginalC0 = j.C0
                break
            end
        end
    end
    debug.profileend()
    local Properties = v4.Properties
    if Properties then
        if Properties.ShootingOptions ~= "Dual" then
            local MuzzlePart_2 = v3.MuzzlePart
            if MuzzlePart_2 and Properties.MuzzleType then
                GetMuzzleFlash(MuzzlePart_2, Camera, Properties.MuzzleType, "Motor6D")
                if Properties.HasSuppressor then
                    GetMuzzleFlash(MuzzlePart_2, Camera, "Suppressor", "Motor6D")
                end
            end
        else
            local MuzzlePartL = v3.MuzzlePartL
            if MuzzlePartL and Properties.MuzzleType then
                GetMuzzleFlash(MuzzlePartL, Camera, Properties.MuzzleType, "Motor6D")
                if Properties.HasSuppressor then
                    GetMuzzleFlash(MuzzlePartL, Camera, "Suppressor", "Motor6D")
                end
            end
            local MuzzlePartR = v3.MuzzlePartR
            if MuzzlePartR and Properties.MuzzleType then
                GetMuzzleFlash(MuzzlePartR, Camera, Properties.MuzzleType, "Motor6D")
                if Properties.HasSuppressor then
                    GetMuzzleFlash(MuzzlePartR, Camera, "Suppressor", "Motor6D")
                end
            end
        end
    end
    debug.profilebegin("Viewmodel.construct.FindCharmModel")
    local CharmBase = v3.Model:FindFirstChild("CharmBase", true)
    if CharmBase and CharmBase:IsA("Model") then
        local Model = CharmBase:FindFirstChildOfClass("Model")
        if Model and Model.PrimaryPart then
            v3.CharmModel = Model
        end
    end
    debug.profileend()
    if v3.CharmModel then
        debug.profilebegin("Viewmodel.construct.SetupCharmPhysics")
        v3:setupCharmPhysics()
        debug.profileend()
    end
    debug.profilebegin("Viewmodel.construct.SetModelReferences")
    if v3.Animation then
        v3.Animation:setModel(v3.Model)
    end
    if v3.Bobble then
        local Bobble = v3.Bobble
        Bobble.Character = v2
        Bobble:setModel(v3.Model)
    end
    debug.profileend()
    weldLooseParts(v3.Model)
    local ViewmodelMirrors = ReplicatedStorage:FindFirstChild("ViewmodelMirrors")
    v1 = false
    if v3.Player == Players.LocalPlayer then
        v1 = not v4.Character and not v3.Inspecting
    end
    local v6 = ViewmodelMirrors and BakedViewmodelMirror.new(v3.Model, ViewmodelMirrors, v1)
    if v6 and v3.ModelJanitor then
        v3.Mirror = v6
        v3.ModelJanitor:Add(v6, "Destroy")
    end
    debug.profilebegin("Viewmodel.construct.FinalEquipState")
    if not v3.IsEquipped then
        v3:unequip()
    else
        v3:equip(false)
    end
    debug.profileend()
    debug.profileend()
end

function u0:setupCharmPhysics() -- Line: 953 -- upvalues: u103 (val), RunServiceController (val)
    debug.profilebegin("Viewmodel.setupCharmPhysics")
    local Parent = self.CharmModel.Parent
    if Parent and Parent.PrimaryPart then
        local Attachment0, Attachment1, Descendants, Part0, Part1, v1, v2, v3, v4
        self.CharmModel:PivotTo(Parent.PrimaryPart.CFrame * (CFrame.new(0, 0, -1)))
        local CharmModel = self.CharmModel
        local Model_2 = self.Model
        local u440 = Model_2:FindFirstChild("Weapon")
        if not u440 then
            u440 = Model_2:FindFirstChild("WeaponL")
            if not u440 then
                u440 = Model_2:FindFirstChild("WeaponR")
            end
        end
        if not u440 then
            debug.profileend()
            return
        end
        debug.profilebegin("Viewmodel.setupCharmPhysics.CloneLargeProxy")
        local Model = Instance.new("Model")
        Model.Name = self.Model.Name
        local u452 = {}
        for i, v in ipairs(u103) do
            v1 = self.Model:FindFirstChild(v)
            if v1 then
                v2 = v1:Clone()
                u452[v1] = v2
                Descendants = v2:GetDescendants()
                for i2, j in v1:GetDescendants() do
                    u452[j] = Descendants[i2]
                end
                v2.Parent = Model
            end
        end
        Model.WorldPivot = self.Model:GetPivot()
        debug.profileend()
        local Weapon = Model:FindFirstChild("Weapon")
        if not Weapon then
            Weapon = Model:FindFirstChild("WeaponL")
            if not Weapon then
                Weapon = Model:FindFirstChild("WeaponR")
            end
        end
        if not Weapon then
            Model:Destroy()
            debug.profileend()
            return
        end
        debug.profilebegin("Viewmodel.setupCharmPhysics.TrimLargeProxy")

        local function relink(a1, a2) -- Line: 999 -- upvalues: Model (val), u452 (val) -- types: a2: string
            local v1 = a1[a2]
            if v1 ~= nil and not v1:IsDescendantOf(Model) then
                local v2 = u452[v1]
                if not v2 then
                    return false
                end
                a1[a2] = v2
                return true
            end
            return true
        end

        for i3, k in ipairs(Model:GetDescendants()) do
            if k.Name == "ViewmodelLight" then
                k:Destroy()
            elseif k:IsA("JointInstance") or k:IsA("WeldConstraint") or k:IsA("NoCollisionConstraint") then
                Part0 = k.Part0
                if Part0 == nil then
                    v3 = true
                elseif not Part0:IsDescendantOf(Model) then
                    v4 = u452[Part0]
                    if not v4 then
                        v3 = false
                    else
                        k.Part0 = v4
                        v3 = true
                    end
                else
                    v3 = true
                end
                if not v3 then
                    k:Destroy()
                else
                    Part1 = k.Part1
                    if Part1 == nil then
                        v3 = true
                    elseif not Part1:IsDescendantOf(Model) then
                        v4 = u452[Part1]
                        if not v4 then
                            v3 = false
                        else
                            k.Part1 = v4
                            v3 = true
                        end
                    else
                        v3 = true
                    end
                    if not v3 then
                        k:Destroy()
                    end
                end
            elseif k:IsA("Constraint") then
                Attachment0 = k.Attachment0
                if Attachment0 == nil then
                    v3 = true
                elseif not Attachment0:IsDescendantOf(Model) then
                    v4 = u452[Attachment0]
                    if not v4 then
                        v3 = false
                    else
                        k.Attachment0 = v4
                        v3 = true
                    end
                else
                    v3 = true
                end
                if not v3 then
                    k:Destroy()
                else
                    Attachment1 = k.Attachment1
                    if Attachment1 == nil then
                        v3 = true
                    elseif not Attachment1:IsDescendantOf(Model) then
                        v4 = u452[Attachment1]
                        if not v4 then
                            v3 = false
                        else
                            k.Attachment1 = v4
                            v3 = true
                        end
                    else
                        v3 = true
                    end
                    if not v3 then
                        k:Destroy()
                    end
                end
            end
        end
        debug.profileend()
        debug.profilebegin("Viewmodel.setupCharmPhysics.ScaleAndPivotProxy")
        Model:ScaleTo(1 / (self.Model:GetScale()))
        Model:PivotTo((u440.Parent:GetPivot()))
        if Weapon.PrimaryPart then
            Weapon.PrimaryPart.Anchored = true
        end
        local BoundingBox = Model:GetBoundingBox()
        if not Model.PrimaryPart then
            Model.WorldPivot = BoundingBox
        else
            Model.PrimaryPart.PivotOffset = Model.PrimaryPart.CFrame:ToObjectSpace(BoundingBox)
        end
        Model.PrimaryPart = Weapon.PrimaryPart
        debug.profileend()
        debug.profilebegin("Viewmodel.setupCharmPhysics.ConfigureProxyDescendants")
        for i4, n in ipairs(Model:GetDescendants()) do
            if n:IsA("BasePart") then
                n.Transparency = 1
                n.CanCollide = true
            elseif n:IsA("Decal") or n:IsA("Texture") or n:IsA("Beam") then
                n.Transparency = 1
            elseif n:IsA("SurfaceGui") or n:IsA("ParticleEmitter") then
                n.Enabled = false
            end
        end
        debug.profileend()
        debug.profilebegin("Viewmodel.setupCharmPhysics.FindLargeCharm")
        local CharmBase = Model:FindFirstChild("CharmBase", true)
        local v5 = nil
        if CharmBase and CharmBase:IsA("Model") then
            v5 = CharmBase:FindFirstChildOfClass("Model")
            if v5 then
                for i5, m in ipairs(v5:GetDescendants()) do
                    if m:IsA("BasePart") then
                        m.CanCollide = true
                        m.CollisionGroup = "Charm"
                    end
                end
            end
        end
        debug.profileend()
        self.LargeWeaponModel = Weapon.Parent
        self.SmallWeaponModel = u440
        self.LargeCharmModel = v5
        if v5 and self.ModelJanitor then
            self.ModelJanitor:Add((RunServiceController.BindToPostSimulation(RunServiceController.CreateBindingName("Classes.Viewmodel.CharmSync"), function() -- Line: 1089 -- upvalues: self (val), CharmModel (val), Weapon (val), u440 (val)
                local LargeCharmModel = self.LargeCharmModel
                if self.IsEquipped and LargeCharmModel and LargeCharmModel.PrimaryPart and CharmModel.PrimaryPart then
                    local v1 = (Weapon:GetPivot()):ToObjectSpace((LargeCharmModel:GetPivot()))
                    local v2 = (CFrame.new(v1.Position / 10)) * CFrame.fromOrientation(v1:ToOrientation())
                    CharmModel:PivotTo((u440:GetPivot()) * v2)
                    return
                end
            end)))
        end
        if self.CharmModel.PrimaryPart then
            self.CharmModel.PrimaryPart.Anchored = true
        end
        if not self.ModelJanitor then
            debug.profileend()
            return
        end
        self.ModelJanitor:Add(function() -- Line: 1115 -- upvalues: Model (val), self (val)
            Model:Destroy()
            self.LargeWeaponModel = nil
            self.SmallWeaponModel = nil
            self.LargeCharmModel = nil
        end)
        debug.profileend()
        return
    end
    debug.profileend()
end

function u0.new(a1, a2, a3, a4) -- Line: 1127
    -- upvalues: u0 (val), Janitor (val), getCarryOverKey (val), Sound (val), Animation (val), Bobble (val)
    -- upvalues: CharacterResolver (val)
    debug.profilebegin("Viewmodel.new")
    local u10 = setmetatable({}, u0)
    u10.Janitor = Janitor.new()
    u10.ModelJanitor = Janitor.new()
    u10.IsDestroyed = false
    u10.Inspecting = a4
    u10.Player = a1.Player
    u10.Team = (a1.Character or u10.Player):GetAttribute("Team")
    u10.WeaponComponent = a1
    u10.Weapon = a2
    u10.CameraModelWeapon = a1.ViewmodelCameraWeapon or a2
    u10.HideWeaponGeometry = a1.ViewmodelHideWeaponGeometry == true
    u10.Skin = a3
    u10.StatTrack = a1.StatTrack
    u10.Stickers = a1.Stickers
    u10.NameTag = a1.NameTag
    u10.Float = a1.Float
    u10.Charm = a1.Charm
    u10.Hidden = false
    u10.IsEquipped = false
    u10.PivotPlans = setmetatable({}, {__mode = "k"})
    u10.CarryOverKey = if not a4 then getCarryOverKey(a1, a2, a3) else nil
    debug.profilebegin("Viewmodel.new.Sound")
    u10.Sound = Sound.new(u10.CameraModelWeapon)
    debug.profileend()
    debug.profilebegin("Viewmodel.new.Animation")
    u10.Animation = Animation.new(u10.Player, u10.Sound)
    debug.profileend()
    debug.profilebegin("Viewmodel.new.Bobble")
    u10.Bobble = Bobble.new(a1)
    debug.profileend()
    local Character_2 = a1.Character or u10.Player.Character
    if Character_2 then
        debug.profilebegin("Viewmodel.new.InitialConstruct")
        local success, result = pcall(u10.construct, u10, Character_2, a1)
        debug.profileend()
        if not success then
            debug.profileend()
            error(result, 2)
        end
    end
    if not a1.Character then
        local u117 = Character_2
        u10.Janitor:Add((CharacterResolver.observeCharacter(u10.Player, function(a1) -- Line: 1193 -- upvalues: u117 (ref), u10 (val)
            if a1 and a1 ~= u117 then
                u10:adoptCharacter(a1)
            end
            u117 = nil
            return function() end
        end)))
    end
    u10.Janitor:Add(function() -- Line: 1203 -- upvalues: u10 (val)
        if u10.ModelJanitor then
            u10.ModelJanitor:Destroy()
            u10.ModelJanitor = nil
        end
    end)
    debug.profileend()
    return u10
end

function u0:adoptCharacter(a2) -- Line: 1216 -- upvalues: getCharacterKey (val) -- types: a2: userdata
    if self.Model and self.CharacterKey == getCharacterKey(a2) then
        self.Bobble.Character = a2
        return
    end
    if self.WeaponComponent then
        self:construct(a2, self.WeaponComponent)
    end
end

function u0.release(a1) -- Line: 1227 -- upvalues: u116 (val), flushCarryOver (val)
    local CarryOverKey = a1.CarryOverKey
    if not a1.IsDestroyed and a1.Model and CarryOverKey then
        if a1.Bobble.IsAiming then
            a1:unaim()
        end
        a1:unequip()
        a1.WeaponComponent = nil
        table.insert(u116, {Viewmodel = a1, Key = CarryOverKey, ExpiresAt = os.clock() + 5})
        task.delay(5.1, flushCarryOver)
        return
    end
    a1:destroy()
end

function u0.claim(a1, a2, a3) -- Line: 1245
    -- upvalues: getCarryOverKey (val), u116 (val)
    local Character, Viewmodel
    local v1 = getCarryOverKey(a1, a2, a3)
    if not v1 then
        return nil
    end
    for i, j in u116 do
        Viewmodel = j.Viewmodel
        if j.Key == v1 and not Viewmodel.IsDestroyed then
            table.remove(u116, i)
            Viewmodel.WeaponComponent = a1
            Viewmodel.StatTrack = a1.StatTrack
            Character = Viewmodel.Player.Character
            if Character and not pcall(Viewmodel.adoptCharacter, Viewmodel, Character) then
                Viewmodel:destroy()
                return nil
            end
            return Viewmodel
        end
    end
    return nil
end

function u0:destroy() -- Line: 1270
    if not self.IsDestroyed then
        debug.profilebegin("Viewmodel.destroy")
        self.IsDestroyed = true
        if self.Animation then
            self.Animation:stopAnimations()
            self.Animation:destroy()
            self.Animation = nil
        end
        if self.Bobble then
            self.Bobble:destroy()
            self.Bobble = nil
        end
        if self.Sound then
            self.Sound:destroy()
            self.Sound = nil
        end
        if self.Model then
            self.Model.Parent = nil
            self.Model:Destroy()
            self.Model = nil
        end
        self.Janitor:Destroy()
        self.Janitor = nil
        self.StatTrack = nil
        self.Stickers = nil
        self.NameTag = nil
        self.Player = nil
        self.Weapon = nil
        self.Float = nil
        self.Charm = nil
        self.Skin = nil
        self.Team = nil
        self.MuzzlePartWeld = nil
        self.MuzzlePartL = nil
        self.MuzzlePartR = nil
        self.MuzzlePart = nil
        self.OriginalC0 = nil
        self.CharmModel = nil
        self.LargeCharmModel = nil
        self.LargeWeaponModel = nil
        debug.profileend()
    end
end

return u0