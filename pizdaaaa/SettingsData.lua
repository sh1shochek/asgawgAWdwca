-- ReplicatedStorage.Shared.Data.SettingsData
-- Script path: ReplicatedStorage.Shared.Data.SettingsData
-- Decompile time: 21.80 ms

-- Decompiled with Potassium's decompiler.

local u1 = {};
local u2 = {
    Game = {
        Crosshair = {
            ["Crosshair Preset"] = {
                LayoutOrder = 1,
                Default = "Default",
                Section = "Crosshair Preset",
                Description = "Default is the standard crosshair. Presets 1-5 each keep their own crosshair: pick one and edit your crosshair to save it into it.",
                Dropdown = { "Default", "Preset 1", "Preset 2", "Preset 3", "Preset 4", "Preset 5" }
            },
            ["Crosshair Image"] = {
                LayoutOrder = 2,
                Default = "",
                Section = "Crosshair Image",
                Description = "Paste a Roblox image or decal ID to use it as your crosshair. Leave it empty to use the classic crosshair.",
                TextBox = {
                    Input = "Numbers",
                    MaxLength = 19,
                    Placeholder = "IMAGE ID"
                }
            },
            ["Crosshair Image Size"] = {
                LayoutOrder = 3,
                Default = 32,
                Section = "Crosshair Image",
                Description = "Changes how big your crosshair image is on screen.",
                HideIf = { "Crosshair Image", "" },
                Slider = {
                    Min = 4,
                    Max = 128
                }
            },
            ["Crosshair Image Color"] = {
                LayoutOrder = 4,
                Section = "Crosshair Image",
                Description = "Tints your crosshair image. White keeps the original colors of the image.",
                ColorPicker = true,
                Default = { 255, 255, 255 },
                HideIf = { "Crosshair Image", "" }
            },
            ["Crosshair Image Transparency"] = {
                LayoutOrder = 5,
                Default = 0,
                Section = "Crosshair Image",
                Description = "Changes how visible or see-through your crosshair image is.",
                Percent = true,
                HideIf = { "Crosshair Image", "" },
                Slider = {
                    Min = 0,
                    Max = 1
                }
            },
            ["Crosshair Image Rotation"] = {
                LayoutOrder = 6,
                Default = 0,
                Section = "Crosshair Image",
                Description = "Rotates your crosshair image around its center.",
                HideIf = { "Crosshair Image", "" },
                Slider = {
                    Min = 0,
                    Max = 360
                }
            },
            ["Pixelated Crosshair Image"] = {
                LayoutOrder = 7,
                Default = false,
                Section = "Crosshair Image",
                Description = "Keeps hard pixel edges when the image is scaled. Best for small pixel art crosshairs.",
                Toggle = true,
                HideIf = { "Crosshair Image", "" }
            },
            ["Crosshair Color"] = {
                LayoutOrder = 8,
                Section = "Crosshair Color & Center Dot",
                Description = "Sets the primary color of your crosshair.",
                ColorPicker = true,
                Default = { 22, 122, 255 },
                ShowIf = { "Crosshair Image", "" }
            },
            ["Crosshair Dot Enabled"] = {
                LayoutOrder = 9,
                Default = true,
                Section = "Crosshair Color & Center Dot",
                Description = "Places a solid aim dot right in the center of your crosshair.",
                Toggle = true,
                ShowIf = { "Crosshair Image", "" }
            },
            ["Use Crosshair Color for Scope Dot"] = {
                LayoutOrder = 10,
                Default = false,
                Section = "Crosshair Color & Center Dot",
                Description = "Forces the red dot inside sniper scopes to match your custom crosshair color.",
                Toggle = true,
                ShowIf = { "Crosshair Image", "" }
            },
            ["Crosshair Length"] = {
                LayoutOrder = 11,
                Default = 2,
                Section = "Crosshair Size & Shape",
                Description = "Adjusts how long the individual lines of your crosshair are.",
                ShowIf = { "Crosshair Image", "" },
                Slider = {
                    Min = 2,
                    Max = 50
                }
            },
            ["Crosshair Thickness"] = {
                LayoutOrder = 12,
                Default = 4,
                Section = "Crosshair Size & Shape",
                Description = "Changes how wide or thick the crosshair lines are.",
                ShowIf = { "Crosshair Image", "" },
                Slider = {
                    Min = 2,
                    Max = 100
                }
            },
            ["Crosshair Gap"] = {
                LayoutOrder = 13,
                Default = 4,
                Section = "Crosshair Size & Shape",
                Description = "Adjusts the amount of open space in the dead-center of your crosshair.",
                ShowIf = { "Crosshair Image", "" },
                Slider = {
                    Min = 0,
                    Max = 50
                }
            },
            ["Crosshair Transparency"] = {
                LayoutOrder = 14,
                Default = 0,
                Section = "Crosshair Size & Shape",
                Description = "Changes how visible or see-through your crosshair is.",
                Percent = true,
                ShowIf = { "Crosshair Image", "" },
                Slider = {
                    Min = 0,
                    Max = 1
                }
            },
            ["Crosshair T Style"] = {
                LayoutOrder = 15,
                Default = false,
                Section = "Crosshair Size & Shape",
                Description = "Removes the top line of the crosshair (\'T\' shape) to keep your view of enemy heads clear.",
                Toggle = true,
                ShowIf = { "Crosshair Image", "" }
            },
            ["Crosshair Outline"] = {
                LayoutOrder = 16,
                Default = 1,
                Section = "Dark Outline",
                Description = "Draws a dark border around your crosshair so you never lose sight of it against bright backgrounds.",
                Percent = true,
                ShowIf = { "Crosshair Image", "" },
                Slider = {
                    Min = 0,
                    Max = 10
                }
            },
            ["Crosshair Outline Color"] = {
                LayoutOrder = 17,
                Section = "Dark Outline",
                Description = "Sets the color of the border surrounding your crosshair.",
                ColorPicker = true,
                Default = { 0, 0, 0 },
                HideIf = { "Crosshair Outline", 0 }
            },
            ["Crosshair Outline Transparency"] = {
                LayoutOrder = 18,
                Default = 0,
                Section = "Dark Outline",
                Description = "Changes how visible or see-through the dark border is.",
                Percent = true,
                HideIf = { "Crosshair Outline", 0 },
                Slider = {
                    Min = 0,
                    Max = 1
                }
            },
            ["Crosshair Follow Recoil"] = {
                LayoutOrder = 19,
                Default = true,
                Section = "Aim & Recoil Behavior",
                Description = "Makes the crosshair follow your weapon spray, showing exactly where bullets will land.",
                Toggle = true
            },
            ["Crosshair Style"] = {
                LayoutOrder = 20,
                Default = "Dynamic",
                Section = "Aim & Recoil Behavior",
                Description = "Dynamic expands when you move and shoot. Static remains completely still.",
                Dropdown = { "Dynamic", "Static" }
            },
            ["Deployed Weapon Gap"] = {
                LayoutOrder = 21,
                Default = false,
                Section = "Aim & Recoil Behavior",
                Description = "Dynamically adjusts the center gap size based on the accuracy of the weapon you are holding.",
                Toggle = true
            }
        },
        Gameplay = {
            ["Field Of View"] = {
                LayoutOrder = 1,
                Default = 70,
                Section = "Camera & View",
                Description = "How much you see on screen. Higher values give you wider vision (like fish-eye).",
                Slider = {
                    Min = 60,
                    Max = 90
                }
            },
            ["Preferred Viewmodel Left/Right Handedness"] = {
                LayoutOrder = 2,
                Default = "Right",
                Section = "Camera & View",
                Description = "Swaps which hand your character holds weapons in (Right or Left).",
                Dropdown = { "Left", "Right" }
            },
            ["Camera Aspect Ratio"] = {
                LayoutOrder = 3,
                Default = 1,
                Section = "Camera & View",
                Description = "Stretches or squishes the game view for a 4:3 stretched resolution feel.",
                Percent = true,
                Slider = {
                    Min = 0.5,
                    Max = 1.2
                }
            },
            ["Auto Re-Zoom Sniper Rifle after Shot"] = {
                LayoutOrder = 4,
                Default = true,
                Section = "Sniper Rifles",
                Group = "Sniper Rifle Options",
                Option = "Auto Re-Zoom",
                GroupDescription = "Scope behaviour for bolt-action sniper rifles.",
                Description = "Automatically zooms back into the scope after firing a bolt-action sniper rifle.",
                Toggle = true
            },
            ["Delay Sniper Rifle Un-Scope after Shot"] = {
                LayoutOrder = 5,
                Default = false,
                Section = "Sniper Rifles",
                Group = "Sniper Rifle Options",
                Option = "Delay Un-Scope",
                Description = "Keeps you looking through the scope a fraction of a second longer after shooting.",
                Toggle = true
            },
            ["Show Scoped Sniper Rifle Inaccuracy"] = {
                LayoutOrder = 6,
                Default = true,
                Section = "Sniper Rifles",
                Group = "Sniper Rifle Options",
                Option = "Show Scoped Inaccuracy",
                Description = "Blurs the sniper scope when moving or jumping to warn you that your shot will miss.",
                Toggle = true
            },
            ["Predict Head Shot Effects"] = {
                LayoutOrder = 7,
                Default = true,
                Section = "Instant Hit Feedback",
                Group = "Predict Hits Instantly",
                Option = "Head Shots",
                GroupDescription = "Plays hit effects the moment you land a shot instead of waiting for the server.",
                Description = "Shows headshot blood and sparks instantly for responsive, satisfying hits.",
                Toggle = true
            },
            ["Predict Body Shot Effects"] = {
                LayoutOrder = 8,
                Default = true,
                Section = "Instant Hit Feedback",
                Group = "Predict Hits Instantly",
                Option = "Body Shots",
                Description = "Shows hit blood and sparks instantly when you shoot an enemy.",
                Toggle = true
            },
            ["Predict Headshot Sound"] = {
                LayoutOrder = 9,
                Default = false,
                Section = "Instant Hit Feedback",
                Group = "Predict Hits Instantly",
                Option = "Headshot Sound",
                Description = "Plays the headshot sound instantly instead of waiting for the server.",
                Toggle = true
            },
            ["Predict Body Sound"] = {
                LayoutOrder = 10,
                Default = false,
                Section = "Instant Hit Feedback",
                Group = "Predict Hits Instantly",
                Option = "Body Sound",
                Description = "Plays the body hit sound instantly instead of waiting for the server.",
                Toggle = true
            },
            ["Predict Kill Ragdolls"] = {
                LayoutOrder = 11,
                Default = false,
                Section = "Instant Hit Feedback",
                Group = "Predict Hits Instantly",
                Option = "Kill Ragdolls",
                Description = "Makes defeated enemies drop instantly the moment you eliminate them.",
                Toggle = true
            },
            ["Smooth Spectator Camera"] = {
                LayoutOrder = 12,
                Default = true,
                Section = "Spectator Camera",
                Description = "Smooths out camera movements when watching other players so it doesn\'t shake.",
                Toggle = true
            },
            ["Smooth Spectator Camera Speed"] = {
                LayoutOrder = 13,
                Default = 3,
                Section = "Spectator Camera",
                Description = "Adjusts how quickly the smoothed spectator camera catches up to the player\'s aim.",
                ShowIf = { "Smooth Spectator Camera", true },
                Slider = {
                    Min = 1,
                    Max = 10
                }
            },
            ["Use Own Settings While Spectating"] = {
                LayoutOrder = 14,
                Default = false,
                Section = "Spectator Camera",
                Description = "Shows your personal crosshair and weapon position instead of the other player\'s when spectating.",
                Toggle = true
            },
            ["Detach Silencer on M4A1-S and USP-S"] = {
                LayoutOrder = 15,
                Default = false,
                Section = "Weapon Mechanics",
                Description = "Allows you to manually unscrew silencers from weapons using the right-click button.",
                Toggle = true
            },
            ["Auto-Equip Picked Up Weapons"] = {
                LayoutOrder = 16,
                Default = false,
                Section = "Weapon Mechanics",
                Description = "Automatically equips any weapon the moment you pick it up from the ground.",
                Toggle = true
            },
            ["Aim Assist"] = {
                LayoutOrder = 17,
                Default = true,
                Mobile = true,
                Section = "Assists",
                Description = "Gently pulls your aim toward the nearest enemy in view and slows your look speed over targets.",
                Toggle = true
            },
            ["Recoil Assist"] = {
                LayoutOrder = 18,
                Default = true,
                Mobile = true,
                Section = "Assists",
                Description = "Reduces the on-screen recoil kick so your aim stays closer to where you point.",
                Toggle = true
            },
            ["Jump Crouch Assist"] = {
                LayoutOrder = 19,
                Default = false,
                Section = "Assists",
                Description = "Automatically crouches mid-jump so you can climb onto ledges that need a jump and crouch together.",
                Toggle = true
            },
            ["Interpolation Ticks"] = {
                LayoutOrder = 20,
                Default = 2,
                Section = "Network",
                Description = "How many snapshots other players are drawn behind. Lower shows them sooner but stutters more on unstable connections. Capped at the server\'s value.",
                Slider = {
                    Min = 0,
                    Max = 3
                }
            }
        },
        Viewmodel = {
            ["Viewmodel Preset"] = {
                LayoutOrder = 0,
                Default = "All",
                Section = "Weapon Position on Screen",
                Description = "All moves every weapon. Pick a weapon to give it its own position: editing the offsets while it is selected saves them only for that weapon.",
                Dropdown = { "All" }
            },
            ["Viewmodel Offset X"] = {
                LayoutOrder = 1,
                Default = 0,
                Section = "Weapon Position on Screen",
                Description = "Moves your weapon further to the left or right side of your screen.",
                Percent = true,
                Slider = {
                    Min = -5,
                    Max = 5
                }
            },
            ["Viewmodel Offset Y"] = {
                LayoutOrder = 2,
                Default = 0,
                Section = "Weapon Position on Screen",
                Description = "Moves your weapon higher up or lower down on your screen.",
                Percent = true,
                Slider = {
                    Min = -5,
                    Max = 5
                }
            },
            ["Viewmodel Offset Z"] = {
                LayoutOrder = 3,
                Default = 0,
                Section = "Weapon Position on Screen",
                Description = "Moves your weapon closer to you or further away (stretched arms).",
                Percent = true,
                Slider = {
                    Min = -5,
                    Max = 5
                }
            },
            ["Remove Viewmodel Bobbing"] = {
                LayoutOrder = 4,
                Default = false,
                Section = "Movement & Sway",
                Group = "Remove Viewmodel Motion",
                Option = "Bobbing",
                GroupDescription = "Stops your weapon from bouncing while you move (Bobbing) or swinging behind when you turn (Sway).",
                Description = "Stops your weapon from bouncing up and down while walking or running.",
                Toggle = true
            },
            ["Remove Viewmodel Sway"] = {
                LayoutOrder = 5,
                Default = false,
                Section = "Movement & Sway",
                Group = "Remove Viewmodel Motion",
                Option = "Sway",
                Description = "Stops your weapon from swinging behind when you turn your camera quickly.",
                Toggle = true
            },
            ["Remove Viewmodel Texture"] = {
                LayoutOrder = 6,
                Default = false,
                Section = "Model & Texture Overrides",
                Group = "Remove from Viewmodel",
                Option = "Texture",
                GroupDescription = "Strips parts of your first-person hands and weapon for a cleaner look and higher FPS.",
                Description = "Strips painted textures from weapons and hands, making them smooth plastic for maximum FPS.",
                Toggle = true
            },
            ["Remove Viewmodel Sleeves"] = {
                LayoutOrder = 7,
                Default = false,
                Section = "Model & Texture Overrides",
                Group = "Remove from Viewmodel",
                Option = "Sleeves",
                Description = "Hides clothing sleeves on your arms for a clean first-person look.",
                Toggle = true
            },
            ["Remove Viewmodel Gloves"] = {
                LayoutOrder = 8,
                Default = false,
                Section = "Model & Texture Overrides",
                Group = "Remove from Viewmodel",
                Option = "Gloves",
                Description = "Hides equipped gloves to show bare hands in first-person.",
                Toggle = true
            },
            ["Remove PBR Textures on Viewmodel"] = {
                LayoutOrder = 9,
                Default = false,
                Section = "Model & Texture Overrides",
                Group = "Remove from Viewmodel",
                Option = "PBR Textures",
                Description = "Disables realistic surface reflections on hands and weapons to boost performance.",
                Toggle = true
            },
            ["Remove Equip Animation on Hand Switch"] = {
                LayoutOrder = 10,
                Default = false,
                Section = "Animations",
                Description = "Switching hands just moves the weapon across instead of replaying its draw animation.",
                Toggle = true
            }
        },
        ["Graphics & Visuals"] = {
            ["Character Shadows"] = {
                LayoutOrder = 1,
                Default = "Default",
                Section = "Shadows",
                Description = "Shadows under players. Turn off to boost FPS, or turn up to spot enemies around corners.",
                Dropdown = { "No Shadows", "Default", "Highest" }
            },
            ["Dropped Weapon Shadows"] = {
                LayoutOrder = 2,
                Default = true,
                Section = "Shadows",
                Description = "Draws shadows under weapons dropped on the ground.",
                Toggle = true
            },
            ["Remove Post Processing Effects"] = {
                LayoutOrder = 3,
                Default = false,
                Section = "Visual Effects & FPS",
                Group = "Remove Effects",
                Option = "Post Processing",
                GroupDescription = "Turns off heavy visual effects for clearer vision and higher FPS.",
                Description = "Turns off screen glow and color effects to maximize FPS and clarity.",
                Toggle = true
            },
            ["Remove Muzzle Flash"] = {
                LayoutOrder = 4,
                Default = false,
                Section = "Visual Effects & FPS",
                Group = "Remove Effects",
                Option = "Muzzle Flash",
                Description = "Hides the bright fire and smoke from gun barrels when shooting for clear vision.",
                Toggle = true
            },
            ["Remove Tracers"] = {
                LayoutOrder = 5,
                Default = false,
                Section = "Visual Effects & FPS",
                Group = "Remove Effects",
                Option = "Tracers",
                Description = "Hides glowing bullet trails in the air. Helps boost FPS in intense firefights.",
                Toggle = true
            },
            ["Tracer Every Bullet"] = {
                LayoutOrder = 6,
                Default = false,
                Section = "Visual Effects & FPS",
                Description = "Shows a glowing tracer trail on every single shot you fire.",
                Toggle = true,
                HideIf = { "Remove Tracers", true }
            },
            ["Remove Character Accessories"] = {
                LayoutOrder = 7,
                Default = false,
                Section = "Visual Effects & FPS",
                Group = "Remove Effects",
                Option = "Character Accessories",
                Description = "Hides extra hats and gear on player models for a clean, distraction-free view.",
                Toggle = true
            },
            ["Remove Character Textures"] = {
                LayoutOrder = 8,
                Section = "Visual Effects & FPS",
                Description = "Disables textures on models to heavily boost framerate on slow computers.",
                Default = {},
                MultiDropdown = { "Weapon Textures", "Character Textures", "Glove Textures", "Accessory Textures" }
            },
            ["Remove Ragdolls"] = {
                LayoutOrder = 9,
                Default = false,
                Section = "Bodies & Blood",
                Description = "Deletes defeated players instantly instead of letting bodies flop on the ground.",
                Toggle = true
            },
            ["Limit number of ragdolls"] = {
                LayoutOrder = 10,
                Default = true,
                Section = "Bodies & Blood",
                Description = "Caps the number of fallen bodies so your game doesn\'t lag in long rounds.",
                Toggle = true,
                HideIf = { "Remove Ragdolls", true }
            },
            ["Maximum number of ragdolls"] = {
                LayoutOrder = 11,
                Default = 8,
                Section = "Bodies & Blood",
                Description = "Sets the strict limit on how many fallen bodies can exist on the map at once.",
                ShowIf = { "Limit number of ragdolls", true },
                Slider = {
                    Min = 1,
                    Max = 20
                }
            },
            ["Lifetime of ragdolls"] = {
                LayoutOrder = 12,
                Default = false,
                Section = "Bodies & Blood",
                Description = "Makes fallen bodies disappear automatically after a set amount of time.",
                Toggle = true,
                HideIf = { "Remove Ragdolls", true }
            },
            ["Ragdoll Life time"] = {
                LayoutOrder = 13,
                Default = 10,
                Section = "Bodies & Blood",
                Description = "How many seconds a fallen body stays on the floor before dissolving.",
                ShowIf = { "Lifetime of ragdolls", true },
                Slider = {
                    Min = 1,
                    Max = 30
                }
            },
            Blood = {
                LayoutOrder = 14,
                Default = true,
                Section = "Bullet Holes & Marks",
                Group = "Impact Effects",
                Option = "Blood",
                GroupDescription = "Choose which effects appear when bullets and blades hit players and surfaces.",
                Description = "Shows blood splatters on walls when players are shot. Turn off for higher FPS.",
                Toggle = true
            },
            ["Surface Marks"] = {
                LayoutOrder = 15,
                Default = true,
                Section = "Bullet Holes & Marks",
                Group = "Impact Effects",
                Option = "Surface Marks",
                Description = "Shows explosion scorches and knife slash marks on walls and floors.",
                Toggle = true
            },
            ["Impact Smoke & Sparks"] = {
                LayoutOrder = 16,
                Default = true,
                Section = "Bullet Holes & Marks",
                Group = "Impact Effects",
                Option = "Smoke & Sparks",
                Description = "Shows tiny dust puffs and metallic sparks when bullets strike surfaces.",
                Toggle = true
            },
            ["Limit Bullet Holes"] = {
                LayoutOrder = 17,
                Default = true,
                Section = "Bullet Holes & Marks",
                Description = "Caps bullet holes so old ones disappear, saving computer memory.",
                Toggle = true
            },
            ["Maximum Bullet Holes"] = {
                LayoutOrder = 18,
                Default = 128,
                Section = "Bullet Holes & Marks",
                Description = "The maximum amount of bullet holes visible at once on the map.",
                ShowIf = { "Limit Bullet Holes", true },
                Slider = {
                    Min = 1,
                    Max = 128
                }
            },
            ["Limit Bullet Hole Lifetime"] = {
                LayoutOrder = 19,
                Default = true,
                Section = "Bullet Holes & Marks",
                Description = "Makes bullet holes fade away naturally over time.",
                Toggle = true
            },
            ["Maximum Bullet Hole Lifetime"] = {
                LayoutOrder = 20,
                Default = 30,
                Section = "Bullet Holes & Marks",
                Description = "How many seconds a bullet hole remains visible on walls.",
                ShowIf = { "Limit Bullet Hole Lifetime", true },
                Slider = {
                    Min = 0,
                    Max = 30
                }
            },
            ["Show NameTag"] = {
                LayoutOrder = 21,
                Default = true,
                Section = "Player Nametags",
                Description = "Shows player names floating above teammates and enemies.",
                Toggle = true
            },
            ["Show Nametag"] = {
                LayoutOrder = 22,
                Section = "Player Nametags",
                Description = "Select what info appears above players: Names, Health bars, Armor, and Icons.",
                Default = { "Pips", "Names", "Health", "Equipment" },
                ShowIf = { "Show NameTag", true },
                MultiDropdown = { "Pips", "Names", "Health", "Equipment" }
            },
            ["Nametag Draw Distance"] = {
                LayoutOrder = 23,
                Default = 0,
                Section = "Player Nametags",
                Description = "How close a player must be to see their name (0 = always visible from any distance).",
                ShowIf = { "Show NameTag", true },
                Slider = {
                    Min = 0,
                    Max = 300
                }
            }
        },
        ["HUD & UI"] = {
            ["HUD Color Style"] = {
                LayoutOrder = 1,
                Default = "Team Color",
                Section = "HUD Appearance & Colors",
                Description = "Choose whether UI elements match your team\'s color (Blue/Orange) or your custom color.",
                Dropdown = { "Team Color", "Dynamic" }
            },
            ["HUD Color"] = {
                LayoutOrder = 2,
                Section = "HUD Appearance & Colors",
                Description = "Custom color for your Health, Armor, and Ammo counters (if Dynamic is selected).",
                ColorPicker = true,
                Default = { 22, 122, 255 },
                HideIf = { "HUD Color Style", "Team Color" }
            },
            ["HUD Scale"] = {
                LayoutOrder = 3,
                Default = 1,
                Section = "HUD Appearance & Colors",
                Description = "Increases or decreases the overall size of all on-screen interface elements.",
                Percent = true,
                Slider = {
                    Min = 0.8,
                    Max = 1.2
                }
            },
            ["Topbar Scale"] = {
                LayoutOrder = 4,
                Default = 1,
                Section = "HUD Appearance & Colors",
                Description = "Changes the size of the match timer and score bar at the top of the screen.",
                Percent = true,
                Slider = {
                    Min = 0.8,
                    Max = 1.5
                }
            },
            ["Large Player Count"] = {
                LayoutOrder = 5,
                Default = false,
                Section = "HUD Appearance & Colors",
                Description = "Replaces the player avatars on the top bar with a large alive count while the round is live. Avatars still show during preparation.",
                Toggle = true
            },
            ["Glow Weapon with Rarity Color"] = {
                LayoutOrder = 5,
                Default = false,
                Section = "HUD Appearance & Colors",
                Description = "Outlines your equipped weapon in the inventory HUD with the rarity color of its skin.",
                Toggle = true
            },
            ["Show Tooltips"] = {
                LayoutOrder = 6,
                Default = true,
                Section = "HUD Appearance & Colors",
                Description = "Shows helpful button hints and key reminders on your screen.",
                Toggle = true
            },
            ["HUD Edges Horizontal"] = {
                LayoutOrder = 7,
                Default = 1,
                Section = "Screen Margins",
                Description = "Pushes HUD elements inward from the left and right sides of your monitor.",
                Percent = true,
                Slider = {
                    Min = 0.7,
                    Max = 1
                }
            },
            ["HUD Edges Vertical"] = {
                LayoutOrder = 8,
                Default = 1,
                Section = "Screen Margins",
                Description = "Pushes HUD elements inward from the top and bottom of your monitor.",
                Percent = true,
                Slider = {
                    Min = 0.7,
                    Max = 1
                }
            },
            ["Item Stacking"] = {
                LayoutOrder = 9,
                Default = true,
                Section = "Menu & Inventory",
                Description = "Groups identical items together in your inventory display to keep it neat.",
                Toggle = true
            },
            ["Free Inspect"] = {
                LayoutOrder = 10,
                Default = false,
                Section = "Menu & Inventory",
                Description = "Allows you to rotate your character and inspect weapons freely in menus.",
                Toggle = true
            },
            ["Use Current Map Scene"] = {
                LayoutOrder = 11,
                Default = true,
                Section = "Menu & Inventory",
                Description = "Automatically changes the main menu map scene to match the current map, if a scene for it exists.",
                Toggle = true
            },
            ["Main Menu Map Scene"] = {
                LayoutOrder = 12,
                Default = "de_dust2",
                Section = "Menu & Inventory",
                Description = "Selects which 3D map is showcased dynamically in the background of the main menu.",
                Dropdown = { "de_dust2", "de_seaside", "de_vertigo" }
            },
            ["Hide Menu Notifications In Game"] = {
                LayoutOrder = 13,
                Default = false,
                Section = "Menu & Inventory",
                Description = "Hides menu notifications while you are playing with the menu closed. They still show whenever the menu is open.",
                Toggle = true
            },
            ["Chat Prefix"] = {
                LayoutOrder = 14,
                Default = true,
                Section = "Developer Tools",
                Description = "Enables or disables your role prefix tag (DEV, COLLAB, MOD, STAR, MEDIA, TEST) in chat.",
                Toggle = true,
                Role = { "Developer", "Admin", "Moderator", "Collaborator", "Star", "Media", "Tester" }
            },
            Vanish = {
                LayoutOrder = 14,
                Default = false,
                Section = "Developer Tools",
                Description = "Hides your joined / left the game and team-join messages from other players\' chat.",
                Toggle = true,
                Role = "Moderator"
            },
            ["Debug Mode"] = {
                LayoutOrder = 15,
                Default = false,
                Section = "Developer Tools",
                Description = "Enables on-screen FPS, ping, hitboxes, and developer console outputs for testing.",
                Toggle = true,
                Role = "Admin"
            },
            ["Net Graph"] = {
                LayoutOrder = 16,
                Default = "Off",
                Section = "Net Graph",
                Description = "Displays real-time network and client performance statistics (FPS, ping, loss, choke, tick, server framerate) styled after CS:GO 2019.",
                Dropdown = { "Off", "1: Text", "2: Detailed Text" }
            },
            ["Net Graph Alignment"] = {
                LayoutOrder = 16,
                Default = "Right",
                Section = "Net Graph",
                Description = "Positions the Net Graph on the Right, Center, or Left side of the screen (matching net_graphpos in CS:GO).",
                HideIf = { "Net Graph", "Off" },
                Dropdown = { "Right", "Center", "Left" }
            },
            ["Net Graph Position X"] = {
                LayoutOrder = 17,
                Default = 0,
                Section = "Net Graph",
                Description = "Horizontal pixel offset from the screen edge or center anchor.",
                HideIf = { "Net Graph", "Off" },
                Slider = {
                    Min = 0,
                    Max = 1000
                }
            },
            ["Net Graph Position Y"] = {
                LayoutOrder = 18,
                Default = 64,
                Section = "Net Graph",
                Description = "Height from the bottom of the screen in pixels (matching net_graphheight in CS:GO, default 64).",
                HideIf = { "Net Graph", "Off" },
                Slider = {
                    Min = 0,
                    Max = 1000
                }
            },
            ["Net Graph Proportional Font"] = {
                LayoutOrder = 19,
                Default = false,
                Section = "Net Graph",
                Group = "Net Graph Options",
                Option = "Proportional Font",
                GroupDescription = "Extra Net Graph display options: proportional font, text fields and camera info.",
                Description = "Scales the Net Graph font proportionally to your screen resolution (matching net_graphproportionalfont in CS:GO).",
                Toggle = true,
                HideIf = { "Net Graph", "Off" }
            },
            ["Net Graph Text"] = {
                LayoutOrder = 20,
                Default = true,
                Section = "Net Graph",
                Group = "Net Graph Options",
                Option = "Text",
                Description = "Toggles visibility of the text fields in the Net Graph overlay.",
                Toggle = true,
                HideIf = { "Net Graph", "Off" }
            },
            ["Net Graph Show Camera Info"] = {
                LayoutOrder = 21,
                Default = true,
                Section = "Net Graph",
                Group = "Net Graph Options",
                Option = "Camera Info",
                Description = "Displays live camera position coordinates (X, Y, Z) and view angles (yaw, pitch) in the Net Graph.",
                Toggle = true,
                HideIf = { "Net Graph", "Off" }
            }
        },
        Radar = {
            ["Radar Enabled"] = {
                LayoutOrder = 1,
                Default = true,
                Section = "Radar",
                Description = "Turns the minimap in the corner of your screen on or off.",
                Toggle = true
            },
            ["Radar Shape"] = {
                LayoutOrder = 2,
                Default = "Circle",
                Section = "Radar",
                Description = "Changes the minimap frame to either a fixed Square or a traditional Circle.",
                ShowIf = { "Radar Enabled", true },
                Dropdown = { "Square", "Circle" }
            },
            ["Radar Rotation"] = {
                LayoutOrder = 3,
                Default = true,
                Section = "Radar",
                Description = "Makes the minimap rotate to match the direction you are currently looking.",
                Toggle = true,
                ShowIf = { "Radar Enabled", true }
            },
            ["Radar Scale"] = {
                LayoutOrder = 4,
                Default = 1,
                Section = "Radar",
                Description = "Makes the minimap larger or smaller on your screen.",
                Percent = true,
                ShowIf = { "Radar Enabled", true },
                Slider = {
                    Min = 0.5,
                    Max = 2
                }
            },
            ["Radar Zoom Level"] = {
                LayoutOrder = 5,
                Default = 1,
                Section = "Radar",
                Description = "Zooms in to see nearby alleys or zooms out to view the entire map.",
                Percent = true,
                ShowIf = { "Radar Enabled", true },
                Slider = {
                    Min = 0.5,
                    Max = 2
                }
            },
            ["Radar Transparency"] = {
                LayoutOrder = 6,
                Default = 0,
                Section = "Radar",
                Description = "Makes the map see-through so enemies cannot hide behind your radar.",
                Percent = true,
                ShowIf = { "Radar Enabled", true },
                Slider = {
                    Min = 0,
                    Max = 0.9
                }
            },
            ["Radar Background Transparency"] = {
                LayoutOrder = 7,
                Default = 0,
                Section = "Radar",
                Description = "Makes the dark box behind your radar transparent.",
                Percent = true,
                ShowIf = { "Radar Enabled", true },
                Slider = {
                    Min = 0,
                    Max = 1
                }
            },
            ["Radar FPS Cap"] = {
                LayoutOrder = 8,
                Default = 60,
                Section = "Radar",
                Description = "Limits the refresh rate of the minimap to save performance on low-end hardware.",
                ShowIf = { "Radar Enabled", true },
                Slider = {
                    Min = 15,
                    Max = 240
                }
            }
        }
    },
    Audio = {
        ["Volume & Sound"] = {
            ["Master Volume"] = {
                LayoutOrder = 1,
                Default = 1,
                Section = "Audio Volume Levels",
                Description = "Controls the overall loudness of the entire game.",
                Percent = true,
                Slider = {
                    Min = 0,
                    Max = 10
                }
            },
            ["Master Music Volume"] = {
                LayoutOrder = 10,
                Default = 1,
                Section = "Music",
                Description = "Scales every music track in the game.",
                Percent = true,
                Slider = {
                    Min = 0,
                    Max = 1
                }
            },
            ["Main Menu Volume"] = {
                LayoutOrder = 11,
                Default = 0.2,
                Section = "Music",
                Description = "Controls the loudness of the music in the lobby and menus.",
                Percent = true,
                Slider = {
                    Min = 0,
                    Max = 1
                }
            },
            ["UI Volume"] = {
                LayoutOrder = 3,
                Default = 1,
                Section = "Audio Volume Levels",
                Description = "Controls the loudness of button clicks and menu sounds.",
                Percent = true,
                Slider = {
                    Min = 0,
                    Max = 10
                }
            }
        }
    },
    Maps = {
        de_dust2 = {
            ["Potato Environment"] = {
                LayoutOrder = 20,
                Default = false,
                Section = "Map Optimizations",
                Description = "Simplifies map details, props, and lighting to boost FPS on weak computers.",
                Toggle = true
            },
            ["Map Settings"] = {
                LayoutOrder = 21,
                Section = "Map Optimizations",
                Description = "Select specific visual tweaks for Dust II to maximize performance.",
                Default = { "Remove Window Reflectance", "Remove Window Transparency" },
                MultiDropdown = { "No Texture", "Remove Bloom", "No Shadows", "Remove Window Reflectance", "Remove Window Transparency" }
            },
            ["Override Fog"] = {
                LayoutOrder = 1001,
                Default = false,
                Section = "Fog",
                Description = "Bypasses the map\'s default fog settings, allowing you to use your own custom fog values.",
                Toggle = true
            },
            ["Fog Color"] = {
                LayoutOrder = 1002,
                Section = "Fog",
                Description = "Changes the color tint of the atmospheric fog in the distance.",
                ColorPicker = true,
                Default = { 255, 255, 255 }
            },
            ["Fog Start"] = {
                LayoutOrder = 1003,
                Default = 0,
                Section = "Fog",
                Description = "Sets how far away from your camera the fog begins to render.",
                Slider = {
                    Min = 0,
                    Max = 10000
                }
            },
            ["Fog End"] = {
                LayoutOrder = 1004,
                Default = 0,
                Section = "Fog",
                Description = "Sets the distance at which the fog becomes completely solid and blocks vision.",
                Slider = {
                    Min = 0,
                    Max = 10000
                }
            },
            ["Override Ambient"] = {
                LayoutOrder = 1005,
                Default = false,
                Section = "Ambient",
                Description = "Bypasses the map\'s default ambient lighting, letting you set your own global lighting rules.",
                Toggle = true
            },
            Ambient = {
                LayoutOrder = 1006,
                Section = "Ambient",
                Description = "Changes the base color of light applied to everything in indoor or shaded areas.",
                ColorPicker = true,
                Default = { 255, 255, 255 }
            },
            ["Outdoor Ambient"] = {
                LayoutOrder = 1007,
                Section = "Ambient",
                Description = "Changes the base color of light applied to surfaces directly exposed to the sky.",
                ColorPicker = true,
                Default = { 255, 255, 255 }
            },
            ["Color Shift Bottom"] = {
                LayoutOrder = 1008,
                Section = "Ambient",
                Description = "Tints the lighting that bounces up from the floor.",
                ColorPicker = true,
                Default = { 255, 255, 255 }
            },
            ["Color Shift Top"] = {
                LayoutOrder = 1009,
                Section = "Ambient",
                Description = "Tints the lighting that shines down from the sky.",
                ColorPicker = true,
                Default = { 255, 255, 255 }
            },
            ["Override Time"] = {
                LayoutOrder = 1010,
                Default = false,
                Section = "Clock Time",
                Description = "Bypasses the map\'s default time of day, letting you manually set the sun\'s position.",
                Toggle = true
            },
            ["Clock Time"] = {
                LayoutOrder = 1011,
                Default = 0,
                Section = "Clock Time",
                Description = "Sets the server time (0-24), smoothly rotating the sun and moon across the sky.",
                Percent = true,
                Slider = {
                    Min = 0,
                    Max = 24
                }
            },
            ["Override Shadow Angle"] = {
                LayoutOrder = 1012,
                Default = false,
                Section = "Shadow",
                Description = "Disconnects shadow casting from the sun\'s actual position, letting you aim shadows manually.",
                Toggle = true
            },
            ["Shadow Angle"] = {
                LayoutOrder = 1013,
                Default = 0,
                Section = "Shadow",
                Description = "Rotates the direction all shadows are cast in degrees (0-360).",
                Percent = true,
                Slider = {
                    Min = 0,
                    Max = 360
                }
            },
            ["Override Brightness"] = {
                LayoutOrder = 1014,
                Default = false,
                Section = "Brightness",
                Description = "Bypasses the default global sun brightness parameter.",
                Toggle = true
            },
            Brightness = {
                LayoutOrder = 1015,
                Default = 0,
                Section = "Brightness",
                Description = "Multiplies the intensity of direct sunlight hitting surfaces.",
                Percent = true,
                Slider = {
                    Min = 0,
                    Max = 10
                }
            },
            ["Override Exposure Compensation"] = {
                LayoutOrder = 1016,
                Default = false,
                Section = "Exposure",
                Description = "Bypasses default exposure settings to manually manage how the camera handles light and dark areas.",
                Toggle = true
            },
            ["Exposure Compensation"] = {
                LayoutOrder = 1017,
                Default = 0,
                Section = "Exposure",
                Description = "Artificially brightens or darkens the entire screen, similar to a real-life camera setting.",
                Percent = true,
                Slider = {
                    Min = -3,
                    Max = 3
                }
            },
            ["Override Environment Scales"] = {
                LayoutOrder = 1018,
                Default = false,
                Section = "Environment",
                Description = "Overrides how intensely textures reflect light and the environment.",
                Toggle = true
            },
            ["Diffuse Scale"] = {
                LayoutOrder = 1019,
                Default = 0,
                Section = "Environment",
                Description = "Adjusts how much ambient light is scattered by rough surfaces.",
                Percent = true,
                Slider = {
                    Min = 0,
                    Max = 1
                }
            },
            ["Specular Scale"] = {
                LayoutOrder = 1020,
                Default = 0,
                Section = "Environment",
                Description = "Adjusts how intensely shiny surfaces (like metals or water) reflect light sources.",
                Percent = true,
                Slider = {
                    Min = 0,
                    Max = 1
                }
            },
            ["Override Atmosphere"] = {
                LayoutOrder = 1021,
                Default = false,
                Section = "Atmosphere",
                Description = "Overrides volumetric scattering (advanced fog/sky blending).",
                Toggle = true
            },
            ["Atmosphere Density"] = {
                LayoutOrder = 1022,
                Default = 0.395,
                Section = "Atmosphere",
                Description = "Controls how thick the volumetric atmosphere appears in the distance.",
                Percent = true,
                Slider = {
                    Min = 0,
                    Max = 1
                }
            },
            ["Atmosphere Offset"] = {
                LayoutOrder = 1023,
                Default = 0,
                Section = "Atmosphere",
                Description = "Adjusts the horizon line blending point for the skybox.",
                Percent = true,
                Slider = {
                    Min = 0,
                    Max = 1
                }
            },
            ["Atmosphere Glare"] = {
                LayoutOrder = 1024,
                Default = 0,
                Section = "Atmosphere",
                Description = "Increases how intensely the sun washes out the sky when you look towards it.",
                Percent = true,
                Slider = {
                    Min = 0,
                    Max = 10
                }
            },
            ["Atmosphere Haze"] = {
                LayoutOrder = 1025,
                Default = 0,
                Section = "Atmosphere",
                Description = "Adds a polluted or dusty look to the air in the distance.",
                Percent = true,
                Slider = {
                    Min = 0,
                    Max = 10
                }
            },
            ["Atmosphere Color"] = {
                LayoutOrder = 1026,
                Section = "Atmosphere",
                Description = "Sets the base color of the volumetric haze.",
                ColorPicker = true,
                Default = { 255, 255, 255 }
            },
            ["Atmosphere Decay"] = {
                LayoutOrder = 1027,
                Section = "Atmosphere",
                Description = "Sets the color that light shifts into as it scatters away from the sun.",
                ColorPicker = true,
                Default = { 255, 255, 255 }
            },
            ["Override Bloom"] = {
                LayoutOrder = 1028,
                Default = false,
                Section = "Bloom",
                Description = "Allows manual control over the glowing effect around bright lights.",
                Toggle = true
            },
            ["Bloom Intensity"] = {
                LayoutOrder = 1029,
                Default = 1,
                Section = "Bloom",
                Description = "Adjusts how overwhelmingly bright and punchy glowing lights appear.",
                Percent = true,
                Slider = {
                    Min = 0,
                    Max = 1
                }
            },
            ["Bloom Size"] = {
                LayoutOrder = 1030,
                Default = 24,
                Section = "Bloom",
                Description = "Adjusts how far the light bleeds out from the source of the glow.",
                Percent = true,
                Slider = {
                    Min = 0,
                    Max = 56
                }
            },
            ["Bloom Threshold"] = {
                LayoutOrder = 1031,
                Default = 2,
                Section = "Bloom",
                Description = "Determines how bright a surface must be before it starts triggering the bloom effect.",
                Percent = true,
                Slider = {
                    Min = 0,
                    Max = 4
                }
            },
            ["Override Blur"] = {
                LayoutOrder = 1032,
                Default = false,
                Section = "Blur",
                Description = "Manually override screen blur effects.",
                Toggle = true
            },
            ["Blur Size"] = {
                LayoutOrder = 1033,
                Default = 24,
                Section = "Blur",
                Description = "Increases the intensity of overall screen blur.",
                Percent = true,
                Slider = {
                    Min = 0,
                    Max = 56
                }
            },
            ["Override Color Correction"] = {
                LayoutOrder = 1034,
                Default = false,
                Section = "Color Correction",
                Description = "Bypasses map filters to let you manually adjust screen contrast and saturation.",
                Toggle = true
            },
            ["Color Correction Brightness"] = {
                LayoutOrder = 1035,
                Default = 0,
                Section = "Color Correction",
                Description = "A flat adjustment making all colors on the screen uniformly brighter or darker.",
                Percent = true,
                Slider = {
                    Min = -1,
                    Max = 1
                }
            },
            ["Color Correction Contrast"] = {
                LayoutOrder = 1036,
                Default = 0,
                Section = "Color Correction",
                Description = "Increases the difference between dark and light areas, making the image pop more.",
                Percent = true,
                Slider = {
                    Min = -1,
                    Max = 1
                }
            },
            ["Color Correction Saturation"] = {
                LayoutOrder = 1037,
                Default = 0,
                Section = "Color Correction",
                Description = "Controls color vividness. -1 turns the game black and white, 1 makes colors extremely vibrant.",
                Percent = true,
                Slider = {
                    Min = -1,
                    Max = 1
                }
            },
            ["Color Correction Tint Color"] = {
                LayoutOrder = 1038,
                Section = "Color Correction",
                Description = "Applies an overarching color filter (tint) over the entire screen.",
                ColorPicker = true,
                Default = { 255, 255, 255 }
            },
            ["Override Sun Rays"] = {
                LayoutOrder = 1039,
                Default = false,
                Section = "Sun Rays",
                Description = "Overrides the map\'s default \'god rays\' setting.",
                Toggle = true
            },
            ["Sun Rays Intensity"] = {
                LayoutOrder = 1040,
                Default = 0.25,
                Section = "Sun Rays",
                Description = "Adjusts how distinctly you can see the beams of light shining down from the sun.",
                Percent = true,
                Slider = {
                    Min = 0,
                    Max = 1
                }
            },
            ["Sun Rays Spread"] = {
                LayoutOrder = 1041,
                Default = 1,
                Section = "Sun Rays",
                Description = "Adjusts how wide the light beams scatter out as they hit objects.",
                Percent = true,
                Slider = {
                    Min = 0,
                    Max = 1
                }
            },
            ["Override Color Grading"] = {
                LayoutOrder = 1042,
                Default = false,
                Section = "Color Grading",
                Description = "Overrides the cinematic lighting profile of the map.",
                Toggle = true
            },
            ["Color Grading Tone Map"] = {
                LayoutOrder = 1043,
                Default = "Default",
                Section = "Color Grading",
                Description = "Applies pre-set cinematic color filters to the game view.",
                Dropdown = { "Default", "Retro" }
            },
            ["Override Depth Of Field"] = {
                LayoutOrder = 1044,
                Default = false,
                Section = "Depth Of Field",
                Description = "Manually controls camera focusing effects (blurring foreground or background).",
                Toggle = true
            },
            ["Depth Of Field Far Intensity"] = {
                LayoutOrder = 1045,
                Default = 0.75,
                Section = "Depth Of Field",
                Description = "Adjusts how heavily objects in the distance are blurred.",
                Percent = true,
                Slider = {
                    Min = 0,
                    Max = 1
                }
            },
            ["Depth Of Field Focus Distance"] = {
                LayoutOrder = 1046,
                Default = 0.05,
                Section = "Depth Of Field",
                Description = "Sets the specific distance from the camera where objects appear perfectly sharp.",
                Percent = true,
                Slider = {
                    Min = 0,
                    Max = 200
                }
            },
            ["Depth Of Field In Focus Radius"] = {
                LayoutOrder = 1047,
                Default = 10,
                Section = "Depth Of Field",
                Description = "Adjusts the size of the \'sweet spot\' where things remain perfectly in focus.",
                Percent = true,
                Slider = {
                    Min = 0,
                    Max = 50
                }
            },
            ["Depth Of Field Near Intensity"] = {
                LayoutOrder = 1048,
                Default = 0.75,
                Section = "Depth Of Field",
                Description = "Adjusts how heavily objects sitting directly against the camera are blurred.",
                Percent = true,
                Slider = {
                    Min = 0,
                    Max = 1
                }
            },
            ["Override Clouds"] = {
                LayoutOrder = 1050,
                Default = false,
                Section = "Clouds",
                Description = "Bypasses the map\'s default skybox clouds.",
                Toggle = true
            },
            ["Clouds Cover"] = {
                LayoutOrder = 1051,
                Default = 0.5,
                Section = "Clouds",
                Description = "Increases the amount of clouds in the sky, from clear skies to completely overcast.",
                Percent = true,
                Slider = {
                    Min = 0,
                    Max = 1
                }
            },
            ["Clouds Density"] = {
                LayoutOrder = 1052,
                Default = 0.7,
                Section = "Clouds",
                Description = "Makes clouds appear thicker and fluffier, blocking out more sunlight.",
                Percent = true,
                Slider = {
                    Min = 0,
                    Max = 1
                }
            },
            ["Clouds Color"] = {
                LayoutOrder = 1053,
                Section = "Clouds",
                Description = "Changes the actual color of the volumetric clouds.",
                ColorPicker = true,
                Default = { 255, 255, 255 }
            }
        },
        de_seaside = {
            ["Potato Environment"] = {
                LayoutOrder = 20,
                Default = false,
                Section = "Map Optimizations",
                Description = "Simplifies map details and lighting to boost FPS on weak computers.",
                Toggle = true
            },
            ["Map Settings"] = {
                LayoutOrder = 21,
                Section = "Map Optimizations",
                Description = "Select specific visual tweaks for Seaside to maximize performance.",
                Default = { "Remove Water Animation" },
                MultiDropdown = { "No Texture", "Remove Bloom", "No Shadows", "Remove Water Animation" }
            },
            ["Override Fog"] = {
                LayoutOrder = 1001,
                Default = false,
                Section = "Fog",
                Description = "Bypasses the map\'s default fog settings, allowing you to use your own custom fog values.",
                Toggle = true
            },
            ["Fog Color"] = {
                LayoutOrder = 1002,
                Section = "Fog",
                Description = "Changes the color tint of the atmospheric fog in the distance.",
                ColorPicker = true,
                Default = { 255, 255, 255 }
            },
            ["Fog Start"] = {
                LayoutOrder = 1003,
                Default = 0,
                Section = "Fog",
                Description = "Sets how far away from your camera the fog begins to render.",
                Slider = {
                    Min = 0,
                    Max = 10000
                }
            },
            ["Fog End"] = {
                LayoutOrder = 1004,
                Default = 0,
                Section = "Fog",
                Description = "Sets the distance at which the fog becomes completely solid and blocks vision.",
                Slider = {
                    Min = 0,
                    Max = 10000
                }
            },
            ["Override Ambient"] = {
                LayoutOrder = 1005,
                Default = false,
                Section = "Ambient",
                Description = "Bypasses the map\'s default ambient lighting, letting you set your own global lighting rules.",
                Toggle = true
            },
            Ambient = {
                LayoutOrder = 1006,
                Section = "Ambient",
                Description = "Changes the base color of light applied to everything in indoor or shaded areas.",
                ColorPicker = true,
                Default = { 255, 255, 255 }
            },
            ["Outdoor Ambient"] = {
                LayoutOrder = 1007,
                Section = "Ambient",
                Description = "Changes the base color of light applied to surfaces directly exposed to the sky.",
                ColorPicker = true,
                Default = { 255, 255, 255 }
            },
            ["Color Shift Bottom"] = {
                LayoutOrder = 1008,
                Section = "Ambient",
                Description = "Tints the lighting that bounces up from the floor.",
                ColorPicker = true,
                Default = { 255, 255, 255 }
            },
            ["Color Shift Top"] = {
                LayoutOrder = 1009,
                Section = "Ambient",
                Description = "Tints the lighting that shines down from the sky.",
                ColorPicker = true,
                Default = { 255, 255, 255 }
            },
            ["Override Time"] = {
                LayoutOrder = 1010,
                Default = false,
                Section = "Clock Time",
                Description = "Bypasses the map\'s default time of day, letting you manually set the sun\'s position.",
                Toggle = true
            },
            ["Clock Time"] = {
                LayoutOrder = 1011,
                Default = 0,
                Section = "Clock Time",
                Description = "Sets the server time (0-24), smoothly rotating the sun and moon across the sky.",
                Percent = true,
                Slider = {
                    Min = 0,
                    Max = 24
                }
            },
            ["Override Shadow Angle"] = {
                LayoutOrder = 1012,
                Default = false,
                Section = "Shadow",
                Description = "Disconnects shadow casting from the sun\'s actual position, letting you aim shadows manually.",
                Toggle = true
            },
            ["Shadow Angle"] = {
                LayoutOrder = 1013,
                Default = 0,
                Section = "Shadow",
                Description = "Rotates the direction all shadows are cast in degrees (0-360).",
                Percent = true,
                Slider = {
                    Min = 0,
                    Max = 360
                }
            },
            ["Override Brightness"] = {
                LayoutOrder = 1014,
                Default = false,
                Section = "Brightness",
                Description = "Bypasses the default global sun brightness parameter.",
                Toggle = true
            },
            Brightness = {
                LayoutOrder = 1015,
                Default = 0,
                Section = "Brightness",
                Description = "Multiplies the intensity of direct sunlight hitting surfaces.",
                Percent = true,
                Slider = {
                    Min = 0,
                    Max = 10
                }
            },
            ["Override Exposure Compensation"] = {
                LayoutOrder = 1016,
                Default = false,
                Section = "Exposure",
                Description = "Bypasses default exposure settings to manually manage how the camera handles light and dark areas.",
                Toggle = true
            },
            ["Exposure Compensation"] = {
                LayoutOrder = 1017,
                Default = 0,
                Section = "Exposure",
                Description = "Artificially brightens or darkens the entire screen, similar to a real-life camera setting.",
                Percent = true,
                Slider = {
                    Min = -3,
                    Max = 3
                }
            },
            ["Override Environment Scales"] = {
                LayoutOrder = 1018,
                Default = false,
                Section = "Environment",
                Description = "Overrides how intensely textures reflect light and the environment.",
                Toggle = true
            },
            ["Diffuse Scale"] = {
                LayoutOrder = 1019,
                Default = 0,
                Section = "Environment",
                Description = "Adjusts how much ambient light is scattered by rough surfaces.",
                Percent = true,
                Slider = {
                    Min = 0,
                    Max = 1
                }
            },
            ["Specular Scale"] = {
                LayoutOrder = 1020,
                Default = 0,
                Section = "Environment",
                Description = "Adjusts how intensely shiny surfaces (like metals or water) reflect light sources.",
                Percent = true,
                Slider = {
                    Min = 0,
                    Max = 1
                }
            },
            ["Override Atmosphere"] = {
                LayoutOrder = 1021,
                Default = false,
                Section = "Atmosphere",
                Description = "Overrides volumetric scattering (advanced fog/sky blending).",
                Toggle = true
            },
            ["Atmosphere Density"] = {
                LayoutOrder = 1022,
                Default = 0.395,
                Section = "Atmosphere",
                Description = "Controls how thick the volumetric atmosphere appears in the distance.",
                Percent = true,
                Slider = {
                    Min = 0,
                    Max = 1
                }
            },
            ["Atmosphere Offset"] = {
                LayoutOrder = 1023,
                Default = 0,
                Section = "Atmosphere",
                Description = "Adjusts the horizon line blending point for the skybox.",
                Percent = true,
                Slider = {
                    Min = 0,
                    Max = 1
                }
            },
            ["Atmosphere Glare"] = {
                LayoutOrder = 1024,
                Default = 0,
                Section = "Atmosphere",
                Description = "Increases how intensely the sun washes out the sky when you look towards it.",
                Percent = true,
                Slider = {
                    Min = 0,
                    Max = 10
                }
            },
            ["Atmosphere Haze"] = {
                LayoutOrder = 1025,
                Default = 0,
                Section = "Atmosphere",
                Description = "Adds a polluted or dusty look to the air in the distance.",
                Percent = true,
                Slider = {
                    Min = 0,
                    Max = 10
                }
            },
            ["Atmosphere Color"] = {
                LayoutOrder = 1026,
                Section = "Atmosphere",
                Description = "Sets the base color of the volumetric haze.",
                ColorPicker = true,
                Default = { 255, 255, 255 }
            },
            ["Atmosphere Decay"] = {
                LayoutOrder = 1027,
                Section = "Atmosphere",
                Description = "Sets the color that light shifts into as it scatters away from the sun.",
                ColorPicker = true,
                Default = { 255, 255, 255 }
            },
            ["Override Bloom"] = {
                LayoutOrder = 1028,
                Default = false,
                Section = "Bloom",
                Description = "Allows manual control over the glowing effect around bright lights.",
                Toggle = true
            },
            ["Bloom Intensity"] = {
                LayoutOrder = 1029,
                Default = 1,
                Section = "Bloom",
                Description = "Adjusts how overwhelmingly bright and punchy glowing lights appear.",
                Percent = true,
                Slider = {
                    Min = 0,
                    Max = 1
                }
            },
            ["Bloom Size"] = {
                LayoutOrder = 1030,
                Default = 24,
                Section = "Bloom",
                Description = "Adjusts how far the light bleeds out from the source of the glow.",
                Percent = true,
                Slider = {
                    Min = 0,
                    Max = 56
                }
            },
            ["Bloom Threshold"] = {
                LayoutOrder = 1031,
                Default = 2,
                Section = "Bloom",
                Description = "Determines how bright a surface must be before it starts triggering the bloom effect.",
                Percent = true,
                Slider = {
                    Min = 0,
                    Max = 4
                }
            },
            ["Override Blur"] = {
                LayoutOrder = 1032,
                Default = false,
                Section = "Blur",
                Description = "Manually override screen blur effects.",
                Toggle = true
            },
            ["Blur Size"] = {
                LayoutOrder = 1033,
                Default = 24,
                Section = "Blur",
                Description = "Increases the intensity of overall screen blur.",
                Percent = true,
                Slider = {
                    Min = 0,
                    Max = 56
                }
            },
            ["Override Color Correction"] = {
                LayoutOrder = 1034,
                Default = false,
                Section = "Color Correction",
                Description = "Bypasses map filters to let you manually adjust screen contrast and saturation.",
                Toggle = true
            },
            ["Color Correction Brightness"] = {
                LayoutOrder = 1035,
                Default = 0,
                Section = "Color Correction",
                Description = "A flat adjustment making all colors on the screen uniformly brighter or darker.",
                Percent = true,
                Slider = {
                    Min = -1,
                    Max = 1
                }
            },
            ["Color Correction Contrast"] = {
                LayoutOrder = 1036,
                Default = 0,
                Section = "Color Correction",
                Description = "Increases the difference between dark and light areas, making the image pop more.",
                Percent = true,
                Slider = {
                    Min = -1,
                    Max = 1
                }
            },
            ["Color Correction Saturation"] = {
                LayoutOrder = 1037,
                Default = 0,
                Section = "Color Correction",
                Description = "Controls color vividness. -1 turns the game black and white, 1 makes colors extremely vibrant.",
                Percent = true,
                Slider = {
                    Min = -1,
                    Max = 1
                }
            },
            ["Color Correction Tint Color"] = {
                LayoutOrder = 1038,
                Section = "Color Correction",
                Description = "Applies an overarching color filter (tint) over the entire screen.",
                ColorPicker = true,
                Default = { 255, 255, 255 }
            },
            ["Override Sun Rays"] = {
                LayoutOrder = 1039,
                Default = false,
                Section = "Sun Rays",
                Description = "Overrides the map\'s default \'god rays\' setting.",
                Toggle = true
            },
            ["Sun Rays Intensity"] = {
                LayoutOrder = 1040,
                Default = 0.25,
                Section = "Sun Rays",
                Description = "Adjusts how distinctly you can see the beams of light shining down from the sun.",
                Percent = true,
                Slider = {
                    Min = 0,
                    Max = 1
                }
            },
            ["Sun Rays Spread"] = {
                LayoutOrder = 1041,
                Default = 1,
                Section = "Sun Rays",
                Description = "Adjusts how wide the light beams scatter out as they hit objects.",
                Percent = true,
                Slider = {
                    Min = 0,
                    Max = 1
                }
            },
            ["Override Color Grading"] = {
                LayoutOrder = 1042,
                Default = false,
                Section = "Color Grading",
                Description = "Overrides the cinematic lighting profile of the map.",
                Toggle = true
            },
            ["Color Grading Tone Map"] = {
                LayoutOrder = 1043,
                Default = "Default",
                Section = "Color Grading",
                Description = "Applies pre-set cinematic color filters to the game view.",
                Dropdown = { "Default", "Retro" }
            },
            ["Override Depth Of Field"] = {
                LayoutOrder = 1044,
                Default = false,
                Section = "Depth Of Field",
                Description = "Manually controls camera focusing effects (blurring foreground or background).",
                Toggle = true
            },
            ["Depth Of Field Far Intensity"] = {
                LayoutOrder = 1045,
                Default = 0.75,
                Section = "Depth Of Field",
                Description = "Adjusts how heavily objects in the distance are blurred.",
                Percent = true,
                Slider = {
                    Min = 0,
                    Max = 1
                }
            },
            ["Depth Of Field Focus Distance"] = {
                LayoutOrder = 1046,
                Default = 0.05,
                Section = "Depth Of Field",
                Description = "Sets the specific distance from the camera where objects appear perfectly sharp.",
                Percent = true,
                Slider = {
                    Min = 0,
                    Max = 200
                }
            },
            ["Depth Of Field In Focus Radius"] = {
                LayoutOrder = 1047,
                Default = 10,
                Section = "Depth Of Field",
                Description = "Adjusts the size of the \'sweet spot\' where things remain perfectly in focus.",
                Percent = true,
                Slider = {
                    Min = 0,
                    Max = 50
                }
            },
            ["Depth Of Field Near Intensity"] = {
                LayoutOrder = 1048,
                Default = 0.75,
                Section = "Depth Of Field",
                Description = "Adjusts how heavily objects sitting directly against the camera are blurred.",
                Percent = true,
                Slider = {
                    Min = 0,
                    Max = 1
                }
            },
            ["Override Clouds"] = {
                LayoutOrder = 1050,
                Default = false,
                Section = "Clouds",
                Description = "Bypasses the map\'s default skybox clouds.",
                Toggle = true
            },
            ["Clouds Cover"] = {
                LayoutOrder = 1051,
                Default = 0.5,
                Section = "Clouds",
                Description = "Increases the amount of clouds in the sky, from clear skies to completely overcast.",
                Percent = true,
                Slider = {
                    Min = 0,
                    Max = 1
                }
            },
            ["Clouds Density"] = {
                LayoutOrder = 1052,
                Default = 0.7,
                Section = "Clouds",
                Description = "Makes clouds appear thicker and fluffier, blocking out more sunlight.",
                Percent = true,
                Slider = {
                    Min = 0,
                    Max = 1
                }
            },
            ["Clouds Color"] = {
                LayoutOrder = 1053,
                Section = "Clouds",
                Description = "Changes the actual color of the volumetric clouds.",
                ColorPicker = true,
                Default = { 255, 255, 255 }
            }
        },
        de_vertigo = {
            ["Potato Environment"] = {
                LayoutOrder = 20,
                Default = false,
                Section = "Map Optimizations",
                Description = "Simplifies map details and lighting to boost FPS on weak computers.",
                Toggle = true
            },
            ["Map Settings"] = {
                LayoutOrder = 21,
                Section = "Map Optimizations",
                Description = "Select specific visual tweaks for Vertigo to maximize performance.",
                Default = { "Remove Fan Animation" },
                MultiDropdown = { "No Texture", "Remove Bloom", "No Shadows", "Remove Fan Animation" }
            },
            ["Override Fog"] = {
                LayoutOrder = 1001,
                Default = false,
                Section = "Fog",
                Description = "Bypasses the map\'s default fog settings, allowing you to use your own custom fog values.",
                Toggle = true
            },
            ["Fog Color"] = {
                LayoutOrder = 1002,
                Section = "Fog",
                Description = "Changes the color tint of the atmospheric fog in the distance.",
                ColorPicker = true,
                Default = { 255, 255, 255 }
            },
            ["Fog Start"] = {
                LayoutOrder = 1003,
                Default = 0,
                Section = "Fog",
                Description = "Sets how far away from your camera the fog begins to render.",
                Slider = {
                    Min = 0,
                    Max = 10000
                }
            },
            ["Fog End"] = {
                LayoutOrder = 1004,
                Default = 0,
                Section = "Fog",
                Description = "Sets the distance at which the fog becomes completely solid and blocks vision.",
                Slider = {
                    Min = 0,
                    Max = 10000
                }
            },
            ["Override Ambient"] = {
                LayoutOrder = 1005,
                Default = false,
                Section = "Ambient",
                Description = "Bypasses the map\'s default ambient lighting, letting you set your own global lighting rules.",
                Toggle = true
            },
            Ambient = {
                LayoutOrder = 1006,
                Section = "Ambient",
                Description = "Changes the base color of light applied to everything in indoor or shaded areas.",
                ColorPicker = true,
                Default = { 255, 255, 255 }
            },
            ["Outdoor Ambient"] = {
                LayoutOrder = 1007,
                Section = "Ambient",
                Description = "Changes the base color of light applied to surfaces directly exposed to the sky.",
                ColorPicker = true,
                Default = { 255, 255, 255 }
            },
            ["Color Shift Bottom"] = {
                LayoutOrder = 1008,
                Section = "Ambient",
                Description = "Tints the lighting that bounces up from the floor.",
                ColorPicker = true,
                Default = { 255, 255, 255 }
            },
            ["Color Shift Top"] = {
                LayoutOrder = 1009,
                Section = "Ambient",
                Description = "Tints the lighting that shines down from the sky.",
                ColorPicker = true,
                Default = { 255, 255, 255 }
            },
            ["Override Time"] = {
                LayoutOrder = 1010,
                Default = false,
                Section = "Clock Time",
                Description = "Bypasses the map\'s default time of day, letting you manually set the sun\'s position.",
                Toggle = true
            },
            ["Clock Time"] = {
                LayoutOrder = 1011,
                Default = 0,
                Section = "Clock Time",
                Description = "Sets the server time (0-24), smoothly rotating the sun and moon across the sky.",
                Percent = true,
                Slider = {
                    Min = 0,
                    Max = 24
                }
            },
            ["Override Shadow Angle"] = {
                LayoutOrder = 1012,
                Default = false,
                Section = "Shadow",
                Description = "Disconnects shadow casting from the sun\'s actual position, letting you aim shadows manually.",
                Toggle = true
            },
            ["Shadow Angle"] = {
                LayoutOrder = 1013,
                Default = 0,
                Section = "Shadow",
                Description = "Rotates the direction all shadows are cast in degrees (0-360).",
                Percent = true,
                Slider = {
                    Min = 0,
                    Max = 360
                }
            },
            ["Override Brightness"] = {
                LayoutOrder = 1014,
                Default = false,
                Section = "Brightness",
                Description = "Bypasses the default global sun brightness parameter.",
                Toggle = true
            },
            Brightness = {
                LayoutOrder = 1015,
                Default = 0,
                Section = "Brightness",
                Description = "Multiplies the intensity of direct sunlight hitting surfaces.",
                Percent = true,
                Slider = {
                    Min = 0,
                    Max = 10
                }
            },
            ["Override Exposure Compensation"] = {
                LayoutOrder = 1016,
                Default = false,
                Section = "Exposure",
                Description = "Bypasses default exposure settings to manually manage how the camera handles light and dark areas.",
                Toggle = true
            },
            ["Exposure Compensation"] = {
                LayoutOrder = 1017,
                Default = 0,
                Section = "Exposure",
                Description = "Artificially brightens or darkens the entire screen, similar to a real-life camera setting.",
                Percent = true,
                Slider = {
                    Min = -3,
                    Max = 3
                }
            },
            ["Override Environment Scales"] = {
                LayoutOrder = 1018,
                Default = false,
                Section = "Environment",
                Description = "Overrides how intensely textures reflect light and the environment.",
                Toggle = true
            },
            ["Diffuse Scale"] = {
                LayoutOrder = 1019,
                Default = 0,
                Section = "Environment",
                Description = "Adjusts how much ambient light is scattered by rough surfaces.",
                Percent = true,
                Slider = {
                    Min = 0,
                    Max = 1
                }
            },
            ["Specular Scale"] = {
                LayoutOrder = 1020,
                Default = 0,
                Section = "Environment",
                Description = "Adjusts how intensely shiny surfaces (like metals or water) reflect light sources.",
                Percent = true,
                Slider = {
                    Min = 0,
                    Max = 1
                }
            },
            ["Override Atmosphere"] = {
                LayoutOrder = 1021,
                Default = false,
                Section = "Atmosphere",
                Description = "Overrides volumetric scattering (advanced fog/sky blending).",
                Toggle = true
            },
            ["Atmosphere Density"] = {
                LayoutOrder = 1022,
                Default = 0.395,
                Section = "Atmosphere",
                Description = "Controls how thick the volumetric atmosphere appears in the distance.",
                Percent = true,
                Slider = {
                    Min = 0,
                    Max = 1
                }
            },
            ["Atmosphere Offset"] = {
                LayoutOrder = 1023,
                Default = 0,
                Section = "Atmosphere",
                Description = "Adjusts the horizon line blending point for the skybox.",
                Percent = true,
                Slider = {
                    Min = 0,
                    Max = 1
                }
            },
            ["Atmosphere Glare"] = {
                LayoutOrder = 1024,
                Default = 0,
                Section = "Atmosphere",
                Description = "Increases how intensely the sun washes out the sky when you look towards it.",
                Percent = true,
                Slider = {
                    Min = 0,
                    Max = 10
                }
            },
            ["Atmosphere Haze"] = {
                LayoutOrder = 1025,
                Default = 0,
                Section = "Atmosphere",
                Description = "Adds a polluted or dusty look to the air in the distance.",
                Percent = true,
                Slider = {
                    Min = 0,
                    Max = 10
                }
            },
            ["Atmosphere Color"] = {
                LayoutOrder = 1026,
                Section = "Atmosphere",
                Description = "Sets the base color of the volumetric haze.",
                ColorPicker = true,
                Default = { 255, 255, 255 }
            },
            ["Atmosphere Decay"] = {
                LayoutOrder = 1027,
                Section = "Atmosphere",
                Description = "Sets the color that light shifts into as it scatters away from the sun.",
                ColorPicker = true,
                Default = { 255, 255, 255 }
            },
            ["Override Bloom"] = {
                LayoutOrder = 1028,
                Default = false,
                Section = "Bloom",
                Description = "Allows manual control over the glowing effect around bright lights.",
                Toggle = true
            },
            ["Bloom Intensity"] = {
                LayoutOrder = 1029,
                Default = 1,
                Section = "Bloom",
                Description = "Adjusts how overwhelmingly bright and punchy glowing lights appear.",
                Percent = true,
                Slider = {
                    Min = 0,
                    Max = 1
                }
            },
            ["Bloom Size"] = {
                LayoutOrder = 1030,
                Default = 24,
                Section = "Bloom",
                Description = "Adjusts how far the light bleeds out from the source of the glow.",
                Percent = true,
                Slider = {
                    Min = 0,
                    Max = 56
                }
            },
            ["Bloom Threshold"] = {
                LayoutOrder = 1031,
                Default = 2,
                Section = "Bloom",
                Description = "Determines how bright a surface must be before it starts triggering the bloom effect.",
                Percent = true,
                Slider = {
                    Min = 0,
                    Max = 4
                }
            },
            ["Override Blur"] = {
                LayoutOrder = 1032,
                Default = false,
                Section = "Blur",
                Description = "Manually override screen blur effects.",
                Toggle = true
            },
            ["Blur Size"] = {
                LayoutOrder = 1033,
                Default = 24,
                Section = "Blur",
                Description = "Increases the intensity of overall screen blur.",
                Percent = true,
                Slider = {
                    Min = 0,
                    Max = 56
                }
            },
            ["Override Color Correction"] = {
                LayoutOrder = 1034,
                Default = false,
                Section = "Color Correction",
                Description = "Bypasses map filters to let you manually adjust screen contrast and saturation.",
                Toggle = true
            },
            ["Color Correction Brightness"] = {
                LayoutOrder = 1035,
                Default = 0,
                Section = "Color Correction",
                Description = "A flat adjustment making all colors on the screen uniformly brighter or darker.",
                Percent = true,
                Slider = {
                    Min = -1,
                    Max = 1
                }
            },
            ["Color Correction Contrast"] = {
                LayoutOrder = 1036,
                Default = 0,
                Section = "Color Correction",
                Description = "Increases the difference between dark and light areas, making the image pop more.",
                Percent = true,
                Slider = {
                    Min = -1,
                    Max = 1
                }
            },
            ["Color Correction Saturation"] = {
                LayoutOrder = 1037,
                Default = 0,
                Section = "Color Correction",
                Description = "Controls color vividness. -1 turns the game black and white, 1 makes colors extremely vibrant.",
                Percent = true,
                Slider = {
                    Min = -1,
                    Max = 1
                }
            },
            ["Color Correction Tint Color"] = {
                LayoutOrder = 1038,
                Section = "Color Correction",
                Description = "Applies an overarching color filter (tint) over the entire screen.",
                ColorPicker = true,
                Default = { 255, 255, 255 }
            },
            ["Override Sun Rays"] = {
                LayoutOrder = 1039,
                Default = false,
                Section = "Sun Rays",
                Description = "Overrides the map\'s default \'god rays\' setting.",
                Toggle = true
            },
            ["Sun Rays Intensity"] = {
                LayoutOrder = 1040,
                Default = 0.25,
                Section = "Sun Rays",
                Description = "Adjusts how distinctly you can see the beams of light shining down from the sun.",
                Percent = true,
                Slider = {
                    Min = 0,
                    Max = 1
                }
            },
            ["Sun Rays Spread"] = {
                LayoutOrder = 1041,
                Default = 1,
                Section = "Sun Rays",
                Description = "Adjusts how wide the light beams scatter out as they hit objects.",
                Percent = true,
                Slider = {
                    Min = 0,
                    Max = 1
                }
            },
            ["Override Color Grading"] = {
                LayoutOrder = 1042,
                Default = false,
                Section = "Color Grading",
                Description = "Overrides the cinematic lighting profile of the map.",
                Toggle = true
            },
            ["Color Grading Tone Map"] = {
                LayoutOrder = 1043,
                Default = "Default",
                Section = "Color Grading",
                Description = "Applies pre-set cinematic color filters to the game view.",
                Dropdown = { "Default", "Retro" }
            },
            ["Override Depth Of Field"] = {
                LayoutOrder = 1044,
                Default = false,
                Section = "Depth Of Field",
                Description = "Manually controls camera focusing effects (blurring foreground or background).",
                Toggle = true
            },
            ["Depth Of Field Far Intensity"] = {
                LayoutOrder = 1045,
                Default = 0.75,
                Section = "Depth Of Field",
                Description = "Adjusts how heavily objects in the distance are blurred.",
                Percent = true,
                Slider = {
                    Min = 0,
                    Max = 1
                }
            },
            ["Depth Of Field Focus Distance"] = {
                LayoutOrder = 1046,
                Default = 0.05,
                Section = "Depth Of Field",
                Description = "Sets the specific distance from the camera where objects appear perfectly sharp.",
                Percent = true,
                Slider = {
                    Min = 0,
                    Max = 200
                }
            },
            ["Depth Of Field In Focus Radius"] = {
                LayoutOrder = 1047,
                Default = 10,
                Section = "Depth Of Field",
                Description = "Adjusts the size of the \'sweet spot\' where things remain perfectly in focus.",
                Percent = true,
                Slider = {
                    Min = 0,
                    Max = 50
                }
            },
            ["Depth Of Field Near Intensity"] = {
                LayoutOrder = 1048,
                Default = 0.75,
                Section = "Depth Of Field",
                Description = "Adjusts how heavily objects sitting directly against the camera are blurred.",
                Percent = true,
                Slider = {
                    Min = 0,
                    Max = 1
                }
            },
            ["Override Clouds"] = {
                LayoutOrder = 1050,
                Default = false,
                Section = "Clouds",
                Description = "Bypasses the map\'s default skybox clouds.",
                Toggle = true
            },
            ["Clouds Cover"] = {
                LayoutOrder = 1051,
                Default = 0.5,
                Section = "Clouds",
                Description = "Increases the amount of clouds in the sky, from clear skies to completely overcast.",
                Percent = true,
                Slider = {
                    Min = 0,
                    Max = 1
                }
            },
            ["Clouds Density"] = {
                LayoutOrder = 1052,
                Default = 0.7,
                Section = "Clouds",
                Description = "Makes clouds appear thicker and fluffier, blocking out more sunlight.",
                Percent = true,
                Slider = {
                    Min = 0,
                    Max = 1
                }
            },
            ["Clouds Color"] = {
                LayoutOrder = 1053,
                Section = "Clouds",
                Description = "Changes the actual color of the volumetric clouds.",
                ColorPicker = true,
                Default = { 255, 255, 255 }
            }
        }
    },
    Controls = {
        Keybinds = {
            ["Reverse Mouse"] = {
                LayoutOrder = 1,
                Default = false,
                Section = "Mouse & Aim Preferences",
                Description = "Inverts your vertical mouse aiming. Moving the mouse up makes you look down.",
                Toggle = true
            },
            ["Duck Mode"] = {
                LayoutOrder = 2,
                Default = "Hold",
                Section = "Mouse & Aim Preferences",
                Description = "Choose whether you must hold the key to stay crouched, or press once to toggle crouching.",
                Dropdown = { "Hold", "Toggle" }
            },
            ["Walk Mode"] = {
                LayoutOrder = 3,
                Default = "Hold",
                Section = "Mouse & Aim Preferences",
                Description = "Choose whether you must hold the key to walk quietly, or press once to toggle walking.",
                Dropdown = { "Hold", "Toggle" }
            },
            ["Zoom Button Hold"] = {
                LayoutOrder = 4,
                Default = "Repeat Disabled",
                Section = "Mouse & Aim Preferences",
                Description = "Determines if holding the zoom button continuously cycles sniper zoom levels.",
                Dropdown = { "Repeat Disabled", "Repeat Enabled" }
            },
            ["Character Forward"] = {
                LayoutOrder = 5,
                Section = "Movement Keys",
                Description = "Walk forward.",
                Keybind = true,
                Default = { { "KeyCode", "W" }, { "KeyCode", "Up" } }
            },
            ["Character Backward"] = {
                LayoutOrder = 6,
                Section = "Movement Keys",
                Description = "Walk backward.",
                Keybind = true,
                Default = { { "KeyCode", "S" }, { "KeyCode", "Down" } }
            },
            ["Character Left"] = {
                LayoutOrder = 7,
                Section = "Movement Keys",
                Description = "Strafe left.",
                Keybind = true,
                Default = { { "KeyCode", "A" }, { "KeyCode", "Left" } }
            },
            ["Character Right"] = {
                LayoutOrder = 8,
                Section = "Movement Keys",
                Description = "Strafe right.",
                Keybind = true,
                Default = { { "KeyCode", "D" }, { "KeyCode", "Right" } }
            },
            ["Character Jump"] = {
                LayoutOrder = 9,
                Section = "Movement Keys",
                Description = "Jump in the air.",
                Keybind = true,
                Default = { { "KeyCode", "Space" }, { "None", "None" } }
            },
            ["Character Duck"] = {
                LayoutOrder = 10,
                Section = "Movement Keys",
                Description = "Crouch down low to hide or increase accuracy.",
                Keybind = true,
                Default = { { "KeyCode", "LeftControl" }, { "None", "None" } }
            },
            ["Character Walk"] = {
                LayoutOrder = 11,
                Section = "Movement Keys",
                Description = "Walk slowly to make zero footstep noise.",
                Keybind = true,
                Default = { { "KeyCode", "LeftShift" }, { "None", "None" } }
            },
            ["Character Use"] = {
                LayoutOrder = 12,
                Section = "Movement Keys",
                Description = "Interact with doors, defuse/plant bombs, and pick up weapons.",
                Keybind = true,
                Default = { { "KeyCode", "E" }, { "None", "None" } }
            },
            ["Left Arm Bind"] = {
                LayoutOrder = 13,
                Section = "Movement Keys",
                Description = "Quick key to toggle left/right hand holding.",
                Keybind = true,
                Default = { { "KeyCode", "H" }, { "None", "None" } }
            },
            ["Weapon Fire"] = {
                LayoutOrder = 14,
                Section = "Combat & Weapon Keys",
                Description = "Shoot your weapon or swing your knife.",
                Keybind = true,
                Default = { { "UserInputType", "MouseButton1" }, { "None", "None" } }
            },
            ["Weapon Alt Function"] = {
                LayoutOrder = 15,
                Section = "Combat & Weapon Keys",
                Description = "Aim down sniper scopes, attach silencers, or secondary knife stab.",
                Keybind = true,
                Default = { { "UserInputType", "MouseButton2" }, { "None", "None" } }
            },
            ["Weapon Reload"] = {
                LayoutOrder = 16,
                Section = "Combat & Weapon Keys",
                Description = "Reload your weapon with a fresh magazine.",
                Keybind = true,
                Default = { { "KeyCode", "R" }, { "None", "None" } }
            },
            ["Weapon Inspect"] = {
                LayoutOrder = 17,
                Section = "Combat & Weapon Keys",
                Description = "Show off and inspect your cool weapon skin in first-person.",
                Keybind = true,
                Default = { { "KeyCode", "F" }, { "None", "None" } }
            },
            ["Weapon Drop"] = {
                LayoutOrder = 18,
                Section = "Combat & Weapon Keys",
                Description = "Throw your currently held weapon on the ground for a teammate.",
                Keybind = true,
                Default = { { "KeyCode", "G" }, { "None", "None" } }
            },
            ["Equip Previous Weapon"] = {
                LayoutOrder = 19,
                Section = "Combat & Weapon Keys",
                Description = "Quickly switch back to the last weapon you were holding.",
                Keybind = true,
                Default = { { "KeyCode", "Q" }, { "None", "None" } }
            },
            ["Weapon Switch Up"] = {
                LayoutOrder = 20,
                Section = "Combat & Weapon Keys",
                Description = "Scroll forward through your weapons.",
                Keybind = true,
                Default = { { "MouseWheel", "WheelForward" }, { "None", "None" } }
            },
            ["Weapon Switch Down"] = {
                LayoutOrder = 21,
                Section = "Combat & Weapon Keys",
                Description = "Scroll backward through your weapons.",
                Keybind = true,
                Default = { { "MouseWheel", "WheelBackward" }, { "None", "None" } }
            },
            ["Equip Primary"] = {
                LayoutOrder = 22,
                Section = "Combat & Weapon Keys",
                Description = "Instantly pull out your main rifle, shotgun, or SMG.",
                Keybind = true,
                Default = { { "KeyCode", "One" }, { "None", "None" } }
            },
            ["Equip Secondary"] = {
                LayoutOrder = 23,
                Section = "Combat & Weapon Keys",
                Description = "Instantly pull out your pistol.",
                Keybind = true,
                Default = { { "KeyCode", "Two" }, { "None", "None" } }
            },
            ["Equip Melee"] = {
                LayoutOrder = 24,
                Section = "Combat & Weapon Keys",
                Description = "Instantly pull out your knife to run at maximum speed.",
                Keybind = true,
                Default = { { "KeyCode", "Three" }, { "None", "None" } }
            },
            ["Cycle Grenades"] = {
                LayoutOrder = 25,
                Section = "Combat & Weapon Keys",
                Description = "Cycle through all your grenades (Smoke, Flash, HE, Molotov).",
                Keybind = true,
                Default = { { "KeyCode", "Four" }, { "None", "None" } }
            },
            ["Equip Bomb"] = {
                LayoutOrder = 26,
                Section = "Combat & Weapon Keys",
                Description = "Pull out the C4 explosive to plant.",
                Keybind = true,
                Default = { { "KeyCode", "Five" }, { "None", "None" } }
            },
            ["Equip First Grenade"] = {
                LayoutOrder = 27,
                Section = "Combat & Weapon Keys",
                Description = "Direct keybind to pull out your first grenade slot.",
                Keybind = true,
                Default = { { "KeyCode", "Six" }, { "None", "None" } }
            },
            ["Equip Second Grenade"] = {
                LayoutOrder = 28,
                Section = "Combat & Weapon Keys",
                Description = "Direct keybind to pull out your second grenade slot.",
                Keybind = true,
                Default = { { "KeyCode", "Seven" }, { "None", "None" } }
            },
            ["Equip Third Grenade"] = {
                LayoutOrder = 29,
                Section = "Combat & Weapon Keys",
                Description = "Direct keybind to pull out your third grenade slot.",
                Keybind = true,
                Default = { { "KeyCode", "Eight" }, { "None", "None" } }
            },
            ["Equip Fourth Grenade"] = {
                LayoutOrder = 30,
                Section = "Combat & Weapon Keys",
                Description = "Direct keybind to pull out your fourth grenade slot.",
                Keybind = true,
                Default = { { "KeyCode", "Nine" }, { "None", "None" } }
            },
            ["Ping Marker"] = {
                LayoutOrder = 31,
                Section = "Interface & Team Keys",
                Description = "Place a 3D ping marker on screen to alert your teammates.",
                Keybind = true,
                Default = { { "UserInputType", "MouseButton3" }, { "None", "None" } }
            },
            Scoreboard = {
                LayoutOrder = 32,
                Section = "Interface & Team Keys",
                Description = "View live player scores, kills, deaths, and ping.",
                Keybind = true,
                Default = { { "KeyCode", "Tab" }, { "None", "None" } }
            },
            Chat = {
                LayoutOrder = 33,
                Section = "Interface & Team Keys",
                Description = "Open global text chat to talk to all players.",
                Keybind = true,
                Default = { { "KeyCode", "Slash" }, { "None", "None" } }
            },
            ["Team Chat"] = {
                LayoutOrder = 34,
                Section = "Interface & Team Keys",
                Description = "Open team-only text chat to talk privately with teammates.",
                Keybind = true,
                Default = { { "KeyCode", "T" }, { "None", "None" } }
            },
            Buymenu = {
                LayoutOrder = 35,
                Section = "Interface & Team Keys",
                Description = "Open the weapon shop menu while in spawn.",
                Keybind = true,
                Default = { { "KeyCode", "B" }, { "None", "None" } }
            },
            ["Team Selection"] = {
                LayoutOrder = 36,
                Section = "Interface & Team Keys",
                Description = "Open the menu to switch between Counter-Terrorists and Terrorists.",
                Keybind = true,
                Default = { { "KeyCode", "N" }, { "None", "None" } }
            },
            MainMenu = {
                LayoutOrder = 37,
                Section = "Interface & Team Keys",
                Description = "Return to the main home screen.",
                Keybind = true,
                Default = { { "KeyCode", "M" }, { "None", "None" } }
            },
            Console = {
                LayoutOrder = 38,
                Section = "Interface & Team Keys",
                Description = "Open the developer console window.",
                Keybind = true,
                Default = { { "KeyCode", "Backquote" }, { "None", "None" } }
            },
            ["Hide HUD"] = {
                LayoutOrder = 39,
                Section = "Interface & Team Keys",
                Description = "Instantly hide all on-screen UI for taking clean screenshots.",
                Keybind = true,
                Default = { { "KeyCode", "P" }, { "None", "None" } }
            },
            ["Spectate Next"] = {
                LayoutOrder = 40,
                Section = "Spectator Keys",
                Description = "Switch to watching the next player while eliminated.",
                Keybind = true,
                Default = { { "UserInputType", "MouseButton1" }, { "None", "None" } }
            },
            ["Spectate Previous"] = {
                LayoutOrder = 41,
                Section = "Spectator Keys",
                Description = "Switch to watching the previous player while eliminated.",
                Keybind = true,
                Default = { { "UserInputType", "MouseButton2" }, { "None", "None" } }
            },
            ["Spectate Mode"] = {
                LayoutOrder = 42,
                Section = "Spectator Keys",
                Description = "Cycle between first-person, third-person, and free camera.",
                Keybind = true,
                Default = { { "KeyCode", "Space" }, { "None", "None" } }
            },
            ["Freecam Forward"] = {
                LayoutOrder = 43,
                Section = "Developer Camera (Freecam)",
                Description = "Fly developer camera forward.",
                Keybind = true,
                Default = { { "KeyCode", "W" }, { "None", "None" } }
            },
            ["Freecam Backward"] = {
                LayoutOrder = 44,
                Section = "Developer Camera (Freecam)",
                Description = "Fly developer camera backward.",
                Keybind = true,
                Default = { { "KeyCode", "S" }, { "None", "None" } }
            },
            ["Freecam Left"] = {
                LayoutOrder = 45,
                Section = "Developer Camera (Freecam)",
                Description = "Fly developer camera left.",
                Keybind = true,
                Default = { { "KeyCode", "A" }, { "None", "None" } }
            },
            ["Freecam Right"] = {
                LayoutOrder = 46,
                Section = "Developer Camera (Freecam)",
                Description = "Fly developer camera right.",
                Keybind = true,
                Default = { { "KeyCode", "D" }, { "None", "None" } }
            },
            ["Freecam Up"] = {
                LayoutOrder = 47,
                Section = "Developer Camera (Freecam)",
                Description = "Fly developer camera upward.",
                Keybind = true,
                Default = { { "KeyCode", "E" }, { "None", "None" } }
            },
            ["Freecam Down"] = {
                LayoutOrder = 48,
                Section = "Developer Camera (Freecam)",
                Description = "Fly developer camera downward.",
                Keybind = true,
                Default = { { "KeyCode", "Q" }, { "None", "None" } }
            },
            ["Freecam Walk"] = {
                LayoutOrder = 49,
                Section = "Developer Camera (Freecam)",
                Description = "Slow down flying speed for smooth cinematic camera panning.",
                Keybind = true,
                Default = { { "KeyCode", "LeftShift" }, { "None", "None" } }
            },
            ["Freecam Up Speed"] = {
                LayoutOrder = 50,
                Section = "Developer Camera (Freecam)",
                Description = "Increase camera flying speed.",
                Keybind = true,
                Default = { { "KeyCode", "Up" }, { "None", "None" } }
            },
            ["Freecam Down Speed"] = {
                LayoutOrder = 51,
                Section = "Developer Camera (Freecam)",
                Description = "Decrease camera flying speed.",
                Keybind = true,
                Default = { { "KeyCode", "Down" }, { "None", "None" } }
            },
            ["Freecam Mouse Wheel Up"] = {
                LayoutOrder = 52,
                Section = "Developer Camera (Freecam)",
                Description = "Smoothly speed up camera flight.",
                Keybind = true,
                Default = { { "MouseWheel", "WheelForward" }, { "None", "None" } }
            },
            ["Freecam Mouse Wheel Down"] = {
                LayoutOrder = 53,
                Section = "Developer Camera (Freecam)",
                Description = "Smoothly slow down camera flight.",
                Keybind = true,
                Default = { { "MouseWheel", "WheelBackward" }, { "None", "None" } }
            },
            ["Freecam Field Of View Increase"] = {
                LayoutOrder = 54,
                Section = "Developer Camera (Freecam)",
                Description = "Zoom camera FOV out.",
                Keybind = true,
                Default = { { "KeyCode", "Z" }, { "None", "None" } }
            },
            ["Freecam Field Of View Decrease"] = {
                LayoutOrder = 55,
                Section = "Developer Camera (Freecam)",
                Description = "Zoom camera FOV in for close-up shots.",
                Keybind = true,
                Default = { { "KeyCode", "X" }, { "None", "None" } }
            }
        },
        ["Controller Binds"] = {
            ["Character Jump"] = {
                LayoutOrder = 1,
                Section = "Movement Controls",
                Description = "Controller button to jump.",
                Keybind = true,
                Default = { { "KeyCode", "ButtonA" }, { "None", "None" } }
            },
            ["Character Duck"] = {
                LayoutOrder = 2,
                Section = "Movement Controls",
                Description = "Controller button to crouch.",
                Keybind = true,
                Default = { { "KeyCode", "ButtonB" }, { "None", "None" } }
            },
            ["Crouch Mode"] = {
                LayoutOrder = 3,
                Default = "Toggle",
                Section = "Movement Controls",
                Description = "Toggle crouches on the first press and stands up on the next, so your thumb stays free to aim. Hold keeps you crouched only while the button is held.",
                Dropdown = { "Hold", "Toggle" }
            },
            ["Character Walk"] = {
                LayoutOrder = 4,
                Section = "Movement Controls",
                Description = "Controller button to walk quietly.",
                Keybind = true,
                Default = { { "KeyCode", "ButtonL3" }, { "None", "None" } }
            },
            ["Character Use"] = {
                LayoutOrder = 5,
                Section = "Movement Controls",
                Description = "Controller button to interact and pick up weapons.",
                Keybind = true,
                Default = { { "KeyCode", "ButtonY" }, { "None", "None" } }
            },
            ["Weapon Fire"] = {
                LayoutOrder = 6,
                Section = "Combat & Weapon Controls",
                Description = "Controller button to shoot or attack.",
                Keybind = true,
                Default = { { "KeyCode", "ButtonR2" }, { "None", "None" } }
            },
            ["Weapon Alt Function"] = {
                LayoutOrder = 7,
                Section = "Combat & Weapon Controls",
                Description = "Controller button for sniper scopes and alternate fire.",
                Keybind = true,
                Default = { { "KeyCode", "ButtonL2" }, { "None", "None" } }
            },
            ["Weapon Reload"] = {
                LayoutOrder = 8,
                Section = "Combat & Weapon Controls",
                Description = "Controller button to reload.",
                Keybind = true,
                Default = { { "KeyCode", "ButtonX" }, { "None", "None" } }
            },
            ["Weapon Switch Up"] = {
                LayoutOrder = 9,
                Section = "Combat & Weapon Controls",
                Description = "Controller button to cycle weapons forward.",
                Keybind = true,
                Default = { { "KeyCode", "ButtonR1" }, { "None", "None" } }
            },
            ["Weapon Switch Down"] = {
                LayoutOrder = 10,
                Section = "Combat & Weapon Controls",
                Description = "Controller button to cycle weapons backward.",
                Keybind = true,
                Default = { { "KeyCode", "ButtonL1" }, { "None", "None" } }
            },
            ["Weapon Inspect"] = {
                LayoutOrder = 11,
                Section = "Combat & Weapon Controls",
                Description = "Controller button to inspect weapon skins.",
                Keybind = true,
                Default = { { "KeyCode", "DPadLeft" }, { "None", "None" } }
            },
            ["Weapon Drop"] = {
                LayoutOrder = 12,
                Section = "Combat & Weapon Controls",
                Description = "Controller button to drop your weapon.",
                Keybind = true,
                Default = { { "KeyCode", "DPadDown" }, { "None", "None" } }
            },
            ["Ping Marker"] = {
                LayoutOrder = 13,
                Section = "Interface Controls",
                Description = "Controller button to place a ping marker.",
                Keybind = true,
                Default = { { "KeyCode", "ButtonB" }, { "None", "None" } }
            },
            Scoreboard = {
                LayoutOrder = 14,
                Section = "Interface Controls",
                Description = "Controller button to show the scoreboard.",
                Keybind = true,
                Default = { { "KeyCode", "ButtonSelect" }, { "None", "None" } }
            },
            MainMenu = {
                LayoutOrder = 15,
                Section = "Interface Controls",
                Description = "Controller button to open the main menu.",
                Keybind = true,
                Default = { { "KeyCode", "DPadRight" }, { "None", "None" } }
            },
            Buymenu = {
                LayoutOrder = 16,
                Section = "Interface Controls",
                Description = "Controller button to open the buy menu.",
                Keybind = true,
                Default = { { "KeyCode", "DPadUp" }, { "None", "None" } }
            },
            ["Team Selection"] = {
                LayoutOrder = 17,
                Section = "Interface Controls",
                Description = "Controller button to open team selection.",
                Keybind = true,
                Default = { { "KeyCode", "ButtonStart" }, { "None", "None" } }
            },
            ["Spectate Next"] = {
                LayoutOrder = 18,
                Section = "Spectator Controls",
                Description = "Controller button to spectate the next player.",
                Keybind = true,
                Default = { { "KeyCode", "ButtonR1" }, { "None", "None" } }
            },
            ["Spectate Previous"] = {
                LayoutOrder = 19,
                Section = "Spectator Controls",
                Description = "Controller button to spectate the previous player.",
                Keybind = true,
                Default = { { "KeyCode", "ButtonL1" }, { "None", "None" } }
            },
            ["Spectate Mode"] = {
                LayoutOrder = 20,
                Section = "Spectator Controls",
                Description = "Controller button to change spectator camera mode.",
                Keybind = true,
                Default = { { "KeyCode", "ButtonA" }, { "None", "None" } }
            },
            ["Freecam Up"] = {
                LayoutOrder = 21,
                Section = "Freecam Controls",
                Description = "Controller button to fly the free camera up. Move it with the left stick and look with the right stick.",
                Keybind = true,
                Default = { { "KeyCode", "ButtonR2" }, { "None", "None" } }
            },
            ["Freecam Down"] = {
                LayoutOrder = 22,
                Section = "Freecam Controls",
                Description = "Controller button to fly the free camera down.",
                Keybind = true,
                Default = { { "KeyCode", "ButtonL2" }, { "None", "None" } }
            },
            ["Freecam Walk"] = {
                LayoutOrder = 23,
                Section = "Freecam Controls",
                Description = "Controller button to slow the free camera down for smooth panning.",
                Keybind = true,
                Default = { { "KeyCode", "ButtonL3" }, { "None", "None" } }
            },
            ["Freecam Up Speed"] = {
                LayoutOrder = 24,
                Section = "Freecam Controls",
                Description = "Controller button to increase free camera flying speed while held.",
                Keybind = true,
                Default = { { "KeyCode", "ButtonY" }, { "None", "None" } }
            },
            ["Freecam Down Speed"] = {
                LayoutOrder = 25,
                Section = "Freecam Controls",
                Description = "Controller button to decrease free camera flying speed while held.",
                Keybind = true,
                Default = { { "KeyCode", "ButtonX" }, { "None", "None" } }
            },
            ["Freecam Field Of View Increase"] = {
                LayoutOrder = 26,
                Section = "Freecam Controls",
                Description = "Controller button to zoom the free camera out.",
                Keybind = true,
                Default = { { "KeyCode", "DPadLeft" }, { "None", "None" } }
            },
            ["Freecam Field Of View Decrease"] = {
                LayoutOrder = 27,
                Section = "Freecam Controls",
                Description = "Controller button to zoom the free camera in.",
                Keybind = true,
                Default = { { "KeyCode", "DPadDown" }, { "None", "None" } }
            },
            ["Controller Vibration"] = {
                LayoutOrder = 28,
                Default = true,
                Section = "Vibration",
                Description = "Rumbles the controller on shots, hits, kills, damage, explosions and menu navigation.",
                Toggle = true
            },
            ["Menu Navigation"] = {
                LayoutOrder = 30,
                Default = "Selection",
                Section = "Menus",
                Description = "Selection jumps between buttons with the D-pad and left stick. Cursor gives you a pointer you move with the left stick, click with A and scroll with the right stick, like a mouse.",
                Dropdown = { "Selection", "Cursor" }
            },
            ["Vibration Strength"] = {
                LayoutOrder = 29,
                Default = 1,
                Section = "Vibration",
                Description = "How strong the controller rumble feels.",
                Percent = true,
                Slider = {
                    Min = 0.1,
                    Max = 1
                }
            }
        },
        ["Mobile Buttons"] = {
            ["Mobile Preset"] = {
                LayoutOrder = 2,
                Default = "Default",
                Section = "Layout",
                Touch = true,
                Description = "Default is the standard layout. Presets 1-5 each keep their own layout: pick one and edit your controls to save them into it.",
                Dropdown = { "Default", "Preset 1", "Preset 2", "Preset 3", "Preset 4", "Preset 5" }
            },
            ["Thumbstick Style"] = {
                LayoutOrder = 10,
                Default = "Classic",
                Section = "Thumbstick",
                Touch = true,
                Description = "Classic is the ring stick. Dynamic is the Roblox style stick: it lights up with a trail while you move and fades back when you let go.",
                Dropdown = { "Classic", "Dynamic" }
            },
            ["Thumbstick Position"] = {
                LayoutOrder = 11,
                Default = "Fixed",
                Section = "Thumbstick",
                Touch = true,
                Description = "Fixed keeps the stick where you placed it. Dynamic moves it under your thumb wherever you touch the left side of the screen.",
                Dropdown = { "Fixed", "Dynamic" }
            },
            ["Follow Stick"] = {
                LayoutOrder = 12,
                Default = false,
                Section = "Thumbstick",
                Touch = true,
                Description = "When your thumb slides past the edge of the stick, the stick follows it instead of stopping at the ring.",
                Toggle = true
            },
            ["Fire Mode"] = {
                LayoutOrder = 21,
                Default = "Button",
                Section = "Combat",
                Touch = true,
                Description = "Button uses the fire button. Zone fires while you hold anywhere inside the fire zone and still aims when you drag. Both keeps the two. Move and resize the zone in Mobile Controls.",
                Dropdown = { "Button", "Zone", "Both" }
            },
            ["Interact Button"] = {
                LayoutOrder = 22,
                Default = "Both",
                Section = "Combat",
                Touch = true,
                Description = "Pulse makes the E button pulse and show Pick Up, Defuse or Plant when you can use it. Auto Hide only shows the button then. Both only shows it then and pulses it. Off keeps it as a plain button.",
                Dropdown = { "Both", "Pulse", "Auto Hide", "Off" }
            },
            ["Rotate Camera with Fire Button"] = {
                LayoutOrder = 23,
                Default = true,
                Section = "Combat",
                Touch = true,
                Description = "Allows your camera to rotate when dragging your finger across the fire button or fire zone.",
                Toggle = true
            },
            ["Death Vibration"] = {
                LayoutOrder = 30,
                Default = true,
                Section = "Feedback",
                Touch = true,
                Description = "Vibrates your phone when you die.",
                Toggle = true
            },
            ["Weapon Switching"] = {
                LayoutOrder = 20,
                Default = "Weapon Bar",
                Section = "Combat",
                Touch = true,
                Description = "Weapon Bar shows every weapon you carry: tap one to equip it or swipe across to switch. Swipe Button keeps one compact button, tap or swipe it to cycle. Number Buttons are the classic 1-5 buttons.",
                Dropdown = { "Weapon Bar", "Swipe Button", "Number Buttons" }
            },
            ["Crouch Mode"] = {
                LayoutOrder = 13,
                Default = "Hold",
                Section = "Movement",
                Touch = true,
                Description = "Hold keeps you crouched only while the crouch button is held. Toggle crouches on the first tap and stands up on the next.",
                Dropdown = { "Hold", "Toggle" }
            },
            ["Slow Walk Mode"] = {
                LayoutOrder = 14,
                Default = "Hold",
                Section = "Movement",
                Touch = true,
                Description = "Hold keeps you walking slowly only while the walk button is held. Toggle starts slow walking on the first tap and stops on the next.",
                Dropdown = { "Hold", "Toggle" }
            },
            ["Weapon Alt Function"] = {
                Default = {
                    Position = { 0.78, 0.32 },
                    Size = 0.18,
                    Transparency = 0.5,
                    Hidden = false
                },
                MobileControls = true,
                Title = "ACT",
                DisabledByDefault = true,
                Description = "On-screen mobile button assigned to weapon alt functions (like scoping)."
            },
            Buymenu = {
                Decal = "rbxassetid://104500205160173",
                Default = {
                    Position = { 0.051, 0.221 },
                    Size = 0.21,
                    Transparency = 0.5,
                    Hidden = false
                },
                MobileControls = true,
                DisabledByDefault = true,
                Description = "On-screen mobile button that opens the shop."
            },
            Chat = {
                Default = {
                    Position = { 0.25, 0.065 },
                    Size = 0.11,
                    Transparency = 0.5,
                    Hidden = false
                },
                MobileControls = true,
                Title = "CHAT",
                DisabledByDefault = true,
                Description = "On-screen mobile button to open the global text chat."
            },
            ["Cycle Grenades"] = {
                Default = {
                    Position = { 0.746, 0.065 },
                    Size = 0.11,
                    Transparency = 0.5,
                    Hidden = false
                },
                MobileControls = true,
                Title = "4",
                Description = "On-screen mobile button to cycle through utility items."
            },
            ["Weapon Drop"] = {
                Decal = "rbxassetid://121691461487057",
                Default = {
                    Position = { 0.92, 0.28 },
                    Size = 0.15,
                    Transparency = 0.5,
                    Hidden = false
                },
                MobileControls = true,
                Description = "On-screen mobile button to throw your equipped weapon."
            },
            ["Character Duck"] = {
                Decal = "rbxassetid://16150525174",
                Default = {
                    Position = { 0.91, 0.82 },
                    Size = 0.19,
                    Transparency = 0.5,
                    Hidden = false
                },
                MobileControls = true,
                Description = "On-screen mobile button dedicated to crouching."
            },
            ["Equip Melee"] = {
                Default = {
                    Position = { 0.69, 0.065 },
                    Size = 0.11,
                    Transparency = 0.5,
                    Hidden = false
                },
                MobileControls = true,
                Title = "3",
                Description = "On-screen mobile button to quickly pull out your knife."
            },
            ["Equip Bomb"] = {
                Default = {
                    Position = { 0.801, 0.065 },
                    Size = 0.11,
                    Transparency = 0.5,
                    Hidden = false
                },
                MobileControls = true,
                Title = "5",
                Description = "On-screen mobile button to select the C4 explosive."
            },
            ["Equip Primary"] = {
                Default = {
                    Position = { 0.58, 0.065 },
                    Size = 0.11,
                    Transparency = 0.5,
                    Hidden = false
                },
                MobileControls = true,
                Title = "1",
                Description = "On-screen mobile button to select your primary rifle."
            },
            ["Equip Secondary"] = {
                Default = {
                    Position = { 0.635, 0.065 },
                    Size = 0.11,
                    Transparency = 0.5,
                    Hidden = false
                },
                MobileControls = true,
                Title = "2",
                Description = "On-screen mobile button to select your pistol."
            },
            ["Weapon Fire"] = {
                Decal = "rbxassetid://89962106200469",
                Default = {
                    Position = { 0.78, 0.58 },
                    Size = 0.3,
                    Transparency = 0.5,
                    Hidden = false
                },
                MobileControls = true,
                Description = "The main on-screen mobile button for firing your weapon."
            },
            ["Weapon Inspect"] = {
                Default = {
                    Position = { 0.84, 0.22 },
                    Size = 0.14,
                    Transparency = 0.5,
                    Hidden = false
                },
                MobileControls = true,
                Title = "F",
                Description = "On-screen mobile button to trigger the weapon inspect animation."
            },
            ["Character Jump"] = {
                Decal = "rbxassetid://104041797612633",
                Default = {
                    Position = { 0.91, 0.6 },
                    Size = 0.2,
                    Transparency = 0.5,
                    Hidden = false
                },
                MobileControls = true,
                Description = "On-screen mobile button dedicated to jumping."
            },
            MainMenu = {
                Default = {
                    Position = { 0.971, 0.065 },
                    Size = 0.11,
                    Transparency = 0.5,
                    Hidden = false
                },
                MobileControls = true,
                Title = "M",
                Description = "On-screen mobile button to return to the game\'s home screen."
            },
            ["Ping Marker"] = {
                Decal = "rbxassetid://74381166786167",
                Default = {
                    Position = { 0.361, 0.065 },
                    Size = 0.11,
                    Transparency = 0.5,
                    Hidden = false
                },
                MobileControls = true,
                Description = "On-screen mobile button to place a 3D ping for your team."
            },
            ["Weapon Reload"] = {
                Default = {
                    Position = { 0.64, 0.44 },
                    Size = 0.17,
                    Transparency = 0.5,
                    Hidden = false
                },
                MobileControls = true,
                Title = "R",
                Description = "On-screen mobile button to reload your active weapon."
            },
            Scoreboard = {
                Default = {
                    Position = { 0.871, 0.065 },
                    Size = 0.11,
                    Transparency = 0.5,
                    Hidden = false
                },
                MobileControls = true,
                Title = "TAB",
                Description = "On-screen mobile button to view player stats and scores."
            },
            ["Team Chat"] = {
                Default = {
                    Position = { 0.306, 0.065 },
                    Size = 0.11,
                    Transparency = 0.5,
                    Hidden = false
                },
                MobileControls = true,
                Title = "T CHAT",
                DisabledByDefault = true,
                Description = "On-screen mobile button to open the team-exclusive text chat."
            },
            ["Team Selection"] = {
                Default = {
                    Position = { 0.921, 0.065 },
                    Size = 0.11,
                    Transparency = 0.5,
                    Hidden = false
                },
                MobileControls = true,
                Title = "N",
                Description = "On-screen mobile button to open the team swap menu."
            },
            ["Character Pickup"] = {
                Default = {
                    Position = { 0.253, 0.322 },
                    Size = 0.16,
                    Transparency = 0.5,
                    Hidden = false
                },
                MobileControls = true,
                Title = "E",
                Description = "On-screen mobile button to interact with doors, bombs, and weapons."
            },
            ["Character Walk"] = {
                Decal = "rbxassetid://74145063383811",
                Default = {
                    Position = { 0.68, 0.82 },
                    Size = 0.17,
                    Transparency = 0.5,
                    Hidden = false
                },
                MobileControls = true,
                Description = "On-screen mobile button to move slowly and silently."
            },
            ["Weapon Bar"] = {
                Default = {
                    Position = { 0.6, 0.16 },
                    Size = 0.1,
                    Transparency = 0.5,
                    Hidden = false
                },
                MobileControls = true,
                Aspect = 6.6,
                Description = "On-screen weapon bar. Tap a weapon to equip it, or swipe across the bar to switch."
            },
            Thumbstick = {
                Default = {
                    Position = { 0.08, 0.8 },
                    Size = 0.2,
                    Transparency = 0.5,
                    Hidden = false
                },
                MobileControls = true,
                Description = "The on-screen virtual joystick used for player movement on mobile."
            },
            ["Fire Zone"] = {
                Default = {
                    Position = { 0.7, 0.45 },
                    Size = 0.4,
                    Transparency = 0.5,
                    Hidden = false
                },
                MobileControls = true,
                Zone = true,
                Bind = "Weapon Fire",
                Aspect = 1.6,
                AllowCameraDrag = true,
                Description = "Area that fires while you hold it and aims while you drag. Shown when Fire Mode is Zone or Both."
            },
            ["Spectate Mode"] = {
                Default = {
                    Position = { 0.5, 0.9 },
                    Size = 0.1,
                    Transparency = 0.5,
                    Hidden = false
                },
                MobileControls = true,
                Decal = "rbxassetid://83297557835292",
                DisabledByDefault = true,
                Description = "On-screen mobile button to cycle through camera views while spectating."
            },
            ["Spectate Previous"] = {
                Default = {
                    Position = { 0.425, 0.9 },
                    Size = 0.1,
                    Transparency = 0.5,
                    Hidden = false
                },
                MobileControls = true,
                Decal = "rbxassetid://132893141770727",
                DisabledByDefault = true,
                Description = "On-screen mobile button to spectate the previous player."
            },
            ["Spectate Next"] = {
                Default = {
                    Position = { 0.575, 0.9 },
                    Size = 0.1,
                    Transparency = 0.5,
                    Hidden = false
                },
                MobileControls = true,
                Decal = "rbxassetid://138596213783550",
                DisabledByDefault = true,
                Description = "On-screen mobile button to spectate the next player."
            }
        },
        Sensitivity = {
            Sensitivity = {
                LayoutOrder = 1,
                Default = 1,
                Section = "Mouse Sensitivity",
                Description = "Adjusts how fast your camera rotates when you move your mouse normally.",
                Percent = true,
                Slider = {
                    Min = 0,
                    Max = 10
                }
            },
            ["Zoom Sensitivity"] = {
                LayoutOrder = 2,
                Default = 0.7,
                Section = "Mouse Sensitivity",
                Description = "Multiplier for your mouse speed while aiming down a sniper scope.",
                Percent = true,
                Slider = {
                    Min = 0,
                    Max = 10
                }
            },
            ["CS Sensitivity Enabled"] = {
                LayoutOrder = 3,
                Default = false,
                Section = "Mouse Sensitivity",
                Description = "Converts your sensitivity slider mathematically to match Counter-Strike.",
                Toggle = true
            }
        }
    }
};
local u3 = nil;
local u4 = nil;
local u5 = {
    Letters = "%a",
    Numbers = "%d",
    Both = "%w"
};

function u1.GetData() -- Line: 4609
    -- upvalues: u2 (copy)
    return u2;
end;

function u1.CleanText(p6: any, p7: string) -- Line: 4613
    -- upvalues: u5 (copy)
    local string_gsub_ret = string.gsub(p7, `[^{u5[p6.Input]}{p6.Spaces and " " or ""}]`, "");

    return string.sub(string_gsub_ret, 1, p6.MaxLength);
end;

function u1.ValidText(p8: any, p9: string) -- Line: 4619
    -- upvalues: u1 (copy)
    local v10;

    if u1.CleanText(p8, p9) == p9 then
        v10 = p9 == "" and true or #p9 >= (p8.MinLength or 1);
    else
        v10 = false;
    end;

    return v10;
end;

function u1.Init(p11) -- Line: 4625
    -- upvalues: u3 (ref), u4 (ref), u2 (copy)
    u3 = p11:GetModule("Enums");
    u4 = p11:GetModule("Table");
    local Dropdown = u2.Game.Viewmodel["Viewmodel Preset"].Dropdown;
    local v12 = {};

    for i, v in p11:GetModule("WeaponManager").GetAllWeapons() do
        if v.Assets and v.Assets.Viewmodel then
            table.insert(v12, i);
        end;
    end;

    table.sort(v12);
    local table_clone_ret = table.clone(u3.SettingsDropdownNum);

    for i, v in v12 do
        table.insert(Dropdown, v);
        u3.SettingsDropdown[1000 + i] = v;
        table_clone_ret[v] = 1000 + i;
    end;

    u3.SettingsDropdownNum = table.freeze(table_clone_ret);
    local v13 = {};

    for _, v in u2 do
        for _, v2 in v do
            for i, v3 in v2 do
                if v3.LayoutOrder then
                    table.insert(v13, i);
                end;
            end;
        end;
    end;

    table.sort(v13);
    local v14 = {};
    local v15 = {};

    for i, v in v13 do
        v14[i] = v;
        v15[v] = i;
    end;

    u3.Settings = table.freeze(v14);
    u3.SettingsNum = table.freeze(v15);
end;

return u1;