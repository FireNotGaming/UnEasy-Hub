-- Enable Secure Mode for Rayfield
getgenv().SecureMode = true

-- Load Rayfield Library
local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()

-- Create Main Window
local Window = Rayfield:CreateWindow({
    Name = "UnEasy Hub",
    LoadingTitle = "UnEasy Hub",
    LoadingSubtitle = "By FireNotGaming",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "UnEasyHubConfig",
        FileName = "UnEasyHub"
    },
    Discord = {
        Enabled = false,
        Invite = "noinvitelink",
        RememberJoins = true
    },
    KeySystem = false,
    KeySettings = {
        Title = "Untitled",
        Subtitle = "Key System",
        Note = "No method of obtaining the key is provided",
        FileName = "Key",
        SaveKey = true,
        GrabKeyFromSite = false,
        Key = {"Hello"}
    }
})

-- Main Tab & Section
local MainTab = Window:CreateTab("Main", 13516625108)
local CharacterSection = MainTab:CreateSection("Character")

-- Speed Hack
local speedHackEnabled = false
local currentSpeedValue = 16
local originalWalkSpeed = 16

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

-- Jump Hack
local jumpHackEnabled = false
local currentJumpValue = 50
local originalJumpPower = 50

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

-- Noclip
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

-- Fly (Infinite Yield Style)
local UIS = game:GetService("UserInputService")
local flyToggle = false
local flying = false
local flySpeed = 50
local flyVelocity, flyGyro

CharacterSection:CreateToggle({
    Name = "Fly",
    CurrentValue = false,
    Callback = function(value)
        local player = game.Players.LocalPlayer
        local char = player.Character or player.CharacterAdded:Wait()
        local root = char:FindFirstChild("HumanoidRootPart")

        if value then
            flyToggle = true
            flying = true

            flyVelocity = Instance.new("BodyVelocity")
            flyVelocity.Velocity = Vector3.new(0, 0, 0)
            flyVelocity.MaxForce = Vector3.new(9e9, 9e9, 9e9)
            flyVelocity.P = 1250
            flyVelocity.Parent = root

            flyGyro = Instance.new("BodyGyro")
            flyGyro.D = 10
            flyGyro.P = 10000
            flyGyro.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
            flyGyro.CFrame = root.CFrame
            flyGyro.Parent = root

            task.spawn(function()
                while flyToggle do
                    local cam = workspace.CurrentCamera
                    flyVelocity.Velocity = 
                        (cam.CFrame.LookVector * (UIS:IsKeyDown(Enum.KeyCode.W) and flySpeed or 0)) +
                        (cam.CFrame.RightVector * ((UIS:IsKeyDown(Enum.KeyCode.D) and flySpeed or 0) - (UIS:IsKeyDown(Enum.KeyCode.A) and flySpeed or 0))) +
                        (cam.CFrame.UpVector * ((UIS:IsKeyDown(Enum.KeyCode.Space) and flySpeed or 0) - (UIS:IsKeyDown(Enum.KeyCode.LeftControl) and flySpeed or 0)))
                    flyGyro.CFrame = cam.CFrame
                    task.wait()
                end
            end)
        else
            flyToggle = false
            flying = false
            if flyVelocity then flyVelocity:Destroy() end
            if flyGyro then flyGyro:Destroy() end
        end
    end
})

CharacterSection:CreateSlider({
    Name = "Fly Speed",
    Range = {10, 200},
    Increment = 5,
    Suffix = "speed",
    CurrentValue = 50,
    Callback = function(value)
        flySpeed = value
    end
})

-- Notification
Rayfield:Notify({
    Title = "UnEasy Hub",
    Content = "All features prepared!",
    Duration = 2
})
