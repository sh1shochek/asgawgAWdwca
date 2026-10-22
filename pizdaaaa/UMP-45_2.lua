-- ReplicatedStorage.Shared.Managers.AnimationManager.Rigs.Weapons.SMG.UMP-45
-- Script path: ReplicatedStorage.Shared.Managers.AnimationManager.Rigs.Weapons.SMG.UMP-45
-- Decompile time: 11.20 ms

-- Decompiled with Potassium's decompiler.

return {
    Animations = script:GetChildren(),
    Rig = {
        name = "RootPart",
        c0 = CFrame.identity,
        c1 = CFrame.identity,
        children = {
            {
                name = "Right Arm",
                c0 = CFrame.new(
                    1.36171,
                    -1.69938,
                    -1.997314,
                    0.9988851,
                    -0.0009836206,
                    -0.0471965,
                    -0.0007365507,
                    0.9993365,
                    -0.03641579,
                    0.04720099,
                    0.03640995,
                    0.9982216
                ),
                c1 = CFrame.new(-0.2690277, 0.00001144409, -1.863068),
                children = {
                    {
                        name = "Handle",
                        c0 = CFrame.new(
                            -0.2416687,
                            0.5054722,
                            -1.741791,
                            0.9998463,
                            -0.0000125128,
                            0.01753262,
                            0.00001269912,
                            1,
                            -0.00001051574,
                            -0.01753262,
                            0.00001073678,
                            0.9998463
                        ),
                        c1 = CFrame.new(-7.629395e-6, -0.04299736, 0.02798462),
                        children = {
                            {
                                name = "Slide2",
                                c0 = CFrame.new(0.08789825, 0.2592735, -0.8306885),
                                c1 = CFrame.new(0.07499695, -0.0739994, -0.1530151)
                            },
                            {
                                name = "Slide1",
                                c0 = CFrame.new(-0.1206436, 0.4308891, -1.659546),
                                c1 = CFrame.identity
                            },
                            {
                                name = "Mag",
                                c0 = CFrame.new(0.01287079, -0.5839005, -0.9093018),
                                c1 = CFrame.identity
                            }
                        }
                    }
                }
            },
            {
                name = "Left Arm",
                c0 = CFrame.new(
                    1.503632,
                    -1.58704,
                    -3.521652,
                    0.851844,
                    -0.08992583,
                    -0.5160187,
                    -0.056308,
                    0.9637223,
                    -0.2608997,
                    0.5207604,
                    0.2513018,
                    0.8158774
                ),
                c1 = CFrame.new(
                    0.2680054,
                    -7.629395e-6,
                    -1.840057,
                    1,
                    -6.378082e-6,
                    -0.00001412607,
                    6.377675e-6,
                    1,
                    -0.0000287742,
                    0.00001412625,
                    0.0000287741,
                    1
                )
            }
        }
    }
};