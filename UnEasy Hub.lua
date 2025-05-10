-- UnEasy Hub (Using Zesume Library)
local OrionLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/GRPGaming/Key-System/refs/heads/Xycer-Hub-Script/ZusumeLib(Slider)"))()

-- Original Variables
local speedHackEnabled = false
local currentSpeedValue = 16
local originalWalkSpeed = 16

local jumpPowerEnabled = false
local currentJumpPowerValue = 50
local originalJumpPower = 50

local noclipEnabled = false
local flyEnabled = false
local flySpeed = 25
local bodyVelocity

-- Main Window (Zesume Style)
local Window = OrionLib:MakeWindow({
    Name = "UnEasy Hub",
    HidePremium = false,
    SaveConfig = true,
    ConfigFolder = "UnEasyHubConfig",
    IntroEnabled = false -- Disable Zesume intro if exists
})

-- Main Tab
local MainTab = Window:MakeTab({
    Name = "Main",
    Icon = "rbxassetid://13516625108",
    PremiumOnly = false
})

-- Force Section Visibility
local CharacterSection = MainTab:AddSection({
    Name = "Character",
    Visible = true -- Ensures section is expanded
})

----------------------
-- SPEED HACK (VISIBLE)
----------------------
CharacterSection:AddToggle({
    Name = "Speed Hack",
    Default = false,
    Callback = function(value)
        speedHackEnabled = value
        local humanoid = game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.WalkSpeed = value and currentSpeedValue or originalWalkSpeed
        end
    end
})

CharacterSection:AddSlider({
    Name = "Speed Amount",
    Min = 16,
    Max = 200,
    Default = 16,
    Increment = 1,
    ValueName = "studs",
    Callback = function(value)
        currentSpeedValue = value
        if speedHackEnabled then
            local humanoid = game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then humanoid.WalkSpeed = value end
        end
    end
})

-----------------------
-- JUMP HACK (VISIBLE)
-----------------------
CharacterSection:AddToggle({
    Name = "Jump Hack",
    Default = false,
    Callback = function(value)
        jumpPowerEnabled = value
        local humanoid = game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.JumpPower = value and currentJumpPowerValue or originalJumpPower
        end
    end
})

CharacterSection:AddSlider({
    Name = "Jump Power",
    Min = 50,
    Max = 500,
    Default = 50,
    Increment = 5,
    ValueName = "power",
    Callback = function(value)
        currentJumpPowerValue = value
        if jumpPowerEnabled then
            local humanoid = game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then humanoid.JumpPower = value end
        end
    end
})

--------------------
-- NO CLIP (ORIGINAL)
--------------------
CharacterSection:AddToggle({
    Name = "Noclip",
    Default = false,
    Callback = function(value)
        noclipEnabled = value
        local character = game.Players.LocalPlayer.Character
        if character then
            for _, part in ipairs(character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = not value
                end
            end
        end
    end
})

----------------
-- FLY (NEW)
----------------
CharacterSection:AddToggle({
    Name = "Fly",
    Default = false,
    Callback = function(value)
        flyEnabled = value
        local character = game.Players.LocalPlayer.Character
        local root = character and character:FindFirstChild("HumanoidRootPart")

        if value and root then
            -- Mobile-friendly fly
            bodyVelocity = Instance.new("BodyVelocity")
            bodyVelocity.Velocity = Vector3.new(0, 0.5, 0) -- Auto-hover
            bodyVelocity.MaxForce = Vector3.new(0, 9e9, 0)
            bodyVelocity.P = 1250 -- Smoother for mobile
            bodyVelocity.Parent = root
        elseif bodyVelocity then
            bodyVelocity:Destroy()
            bodyVelocity = nil
        end
    end
})

-- Success notification
OrionLib:MakeNotification({
    Name = "UnEasy Hub",
    Content = "All features loaded successfully!",
    Time = 3,
    Image = "rbxassetid://13516625108"
})
