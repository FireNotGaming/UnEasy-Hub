-- Load Rayfield Library
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- Create the main window
local Window = Rayfield:CreateWindow({
    Name = "UnEasy Hub",
    LoadingTitle = "Loading...",
    LoadingSubtitle = "Please wait...",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "UnEasyHub",
        FileName = "Config"
    },
    Discord = {
        Enabled = false,
        Invite = "discord.gg/your-invite",
        RememberJoins = true
    },
    KeySystem = false
})

-- Create main tab
local MainTab = Window:CreateTab("Main", 4483362458)

-- Create section for character-related features
local CharacterSection = MainTab:CreateSection("Character", {["Collapsible"] = true, ["Sorted"] = true, ["Collapsed"] = false})

-- Variables to hold the speed and jump values
local originalWalkSpeed = 16
local originalJumpPower = 50
local currentSpeedValue = 16
local currentJumpPowerValue = 50
local speedHackEnabled = false
local jumpPowerEnabled = false
local noclipEnabled = false
local flyEnabled = false
local bodyVelocity = nil

-- Speed Hack Toggle
local SpeedToggle = CharacterSection:CreateToggle({
    Name = "Speed Hack",
    CurrentValue = false,
    Flag = "SpeedHack",
    Callback = function(Value)
        speedHackEnabled = Value
        local humanoid = game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.WalkSpeed = Value and currentSpeedValue or originalWalkSpeed
        end
    end
})

-- Speed Slider
CharacterSection:CreateSlider({
    Name = "Speed Amount",
    Range = {16, 200},
    Increment = 1,
    Suffix = "stud/s",
    CurrentValue = 16,
    Flag = "SpeedAmount",
    Callback = function(Value)
        currentSpeedValue = Value
        if speedHackEnabled then
            local humanoid = game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid.WalkSpeed = Value
            end
        end
    end
})

-- Jump Hack Toggle
local JumpToggle = CharacterSection:CreateToggle({
    Name = "Jump Hack",
    CurrentValue = false,
    Flag = "JumpHack",
    Callback = function(Value)
        jumpPowerEnabled = Value
        local humanoid = game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.JumpPower = Value and currentJumpPowerValue or originalJumpPower
        end
    end
})

-- Jump Slider
CharacterSection:CreateSlider({
    Name = "Jump Power",
    Range = {50, 500},
    Increment = 5,
    Suffix = "power",
    CurrentValue = 50,
    Flag = "JumpPower",
    Callback = function(Value)
        currentJumpPowerValue = Value
        if jumpPowerEnabled then
            local humanoid = game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid.JumpPower = Value
            end
        end
    end
})

-- Noclip Toggle
local NoclipToggle = CharacterSection:CreateToggle({
    Name = "Noclip",
    CurrentValue = false,
    Flag = "Noclip",
    Callback = function(Value)
        noclipEnabled = Value
        local character = game.Players.LocalPlayer.Character
        if character then
            for _, part in ipairs(character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = not Value
                end
            end
        end
    end
})

-- Fly Toggle
local FlyToggle = CharacterSection:CreateToggle({
    Name = "Fly",
    CurrentValue = false,
    Flag = "Fly",
    Callback = function(Value)
        flyEnabled = Value
        local character = game.Players.LocalPlayer.Character
        local root = character and character:FindFirstChild("HumanoidRootPart")
        if Value and root then
            bodyVelocity = Instance.new("BodyVelocity")
            bodyVelocity.Velocity = Vector3.new(0, 0.5, 0)
            bodyVelocity.MaxForce = Vector3.new(0, 9e9, 0)
            bodyVelocity.P = 1250
            bodyVelocity.Parent = root
        elseif bodyVelocity then
            bodyVelocity:Destroy()
            bodyVelocity = nil
        end
    end
})

-- Initialize the UI
Rayfield:Init()
