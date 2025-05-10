-- Enable Secure Mode for Rayfield
getgenv().SecureMode = true

-- Load Rayfield Library
local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()

-- Create Main Window
local Window = Rayfield:CreateWindow({
    Name = "UnEasy Hub",
    LoadingTitle = "UnEasy Hub",
    LoadingSubtitle = "by FireNotGaming",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "UnEasyHubConfig",
        FileName = "UnEasyHub"
    },
    Discord = {
        Enabled = false
    },
    KeySystem = false
})

-- Create Main Tab and Character Section
local MainTab = Window:CreateTab("Main", 13516625108) -- Title, Icon ID
local CharacterSection = MainTab:CreateSection("Character")

-- Variables for Speed Hack
local speedHackEnabled = false
local currentSpeedValue = 16
local originalWalkSpeed = 16

-- Speed Hack Toggle
CharacterSection:CreateToggle({
    Name = "Speed Hack",
    CurrentValue = false,
    Callback = function(value)
        speedHackEnabled = value
        local humanoid = game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.WalkSpeed = value and currentSpeedValue or originalWalkSpeed
        end
    end
})

-- Speed Amount Slider
CharacterSection:CreateSlider({
    Name = "Speed Amount",
    Range = {16, 200},
    Increment = 1,
    Suffix = "studs",
    CurrentValue = 16,
    Callback = function(value)
        currentSpeedValue = value
        if speedHackEnabled then
            local humanoid = game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid.WalkSpeed = value
            end
        end
    end
})

-- Variables for Jump Hack
local jumpHackEnabled = false
local currentJumpValue = 50
local originalJumpPower = 50

-- Jump Hack Toggle
CharacterSection:CreateToggle({
    Name = "Jump Hack",
    CurrentValue = false,
    Callback = function(value)
        jumpHackEnabled = value
        local humanoid = game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.JumpPower = value and currentJumpValue or originalJumpPower
        end
    end
})

-- Jump Amount Slider
CharacterSection:CreateSlider({
    Name = "Jump Amount",
    Range = {50, 200},
    Increment = 1,
    Suffix = "power",
    CurrentValue = 50,
    Callback = function(value)
        currentJumpValue = value
        if jumpHackEnabled then
            local humanoid = game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid.JumpPower = value
            end
        end
    end
})

-- Noclip Toggle
local noclipEnabled = false
CharacterSection:CreateToggle({
    Name = "Noclip",
    CurrentValue = false,
    Callback = function(value)
        noclipEnabled = value
        local player = game.Players.LocalPlayer
        local character = player.Character
        if character then
            for _, part in pairs(character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = not value
                end
            end
        end
    end
})

-- Fly Toggle
local flyEnabled = false
CharacterSection:CreateToggle({
    Name = "Fly",
    CurrentValue = false,
    Callback = function(value)
        flyEnabled = value
        local player = game.Players.LocalPlayer
        local character = player.Character
        if character then
            local humanoid = character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                if value then
                    -- Enable fly by setting PlatformStand to true
                    humanoid.PlatformStand = true
                    -- Additional fly logic can be implemented here
                else
                    -- Disable fly
                    humanoid.PlatformStand = false
                end
            end
        end
    end
})

-- Notification
Rayfield:Notify({
    Title = "UnEasy Hub",
    Content = "All features prepared!",
    Duration = 2
})
