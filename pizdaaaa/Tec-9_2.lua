-- ReplicatedStorage.Shared.Managers.AnimationManager.Rigs.Weapons.Pistols.TEC-9
-- Script path: ReplicatedStorage.Shared.Managers.AnimationManager.Rigs.Weapons.Pistols.TEC-9
-- Decompile time: 4.78 ms

-- Decompiled with Potassium's decompiler.

return {
    Animations = script:GetChildren(),
    Rig = {
        name = "RootPart",
        c0 = CFrame.identity,
        c1 = CFrame.identity,
        children = {
            {
                name = "Left Arm",
                c0 = CFrame.new(
                    1.5799787,
                    -1.65987778,
                    -3.03421021,
                    0.912217677,
                    -0.149813056,
                    -0.381333113,
                    0.0580372065,
                    0.968613744,
                    -0.241700515,
                    0.405574381,
                    0.198351979,
                    0.892281294
                ),
                c1 = CFrame.new(0.263999939, 9.53674316e-7, -1.85700226)
            },
            {
                name = "Right Arm",
                c0 = CFrame.new(
                    1.50867105,
                    -1.69564629,
                    -2.34737396,
                    0.997932971,
                    -0.0181436595,
                    0.0616494343,
                    0.0272853449,
                    0.98818022,
                    -0.15084888,
                    -0.0581838004,
                    0.152219191,
                    0.986632645
                ),
                c1 = CFrame.new(
                    -0.271000862,
                    -7.62939453e-6,
                    -1.84799957,
                    1.00000024,
                    9.80682671e-7,
                    4.42564487e-6,
                    -9.96515155e-7,
                    1,
                    -0.0000174492598,
                    -4.41074371e-6,
                    0.0000174492598,
                    1
                ),
                children = {
                    {
                        name = "Handle",
                        c0 = CFrame.new(
                            -0.178833008,
                            0.248771667,
                            -2.48486328,
                            0.996375561,
                            -0.0371656194,
                            -0.0765143037,
                            0.0455397777,
                            0.992800474,
                            0.110785626,
                            0.0718460158,
                            -0.113868527,
                            0.990894675
                        ),
                        c1 = CFrame.new(0.0220340993, -0.0499630645, -0.0220338367),
                        children = {
                            {
                                name = "Mag",
                                c0 = CFrame.new(-0.00543984491, -0.39357695, -0.0599493198),
                                c1 = CFrame.identity
                            },
                            {
                                name = "Slide",
                                c0 = CFrame.new(-0.0686641634, 0.485152304, 0.12794739),
                                c1 = CFrame.identity
                            }
                        }
                    }
                }
            }
        }
    }
};