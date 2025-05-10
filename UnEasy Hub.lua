-- Load the library (EXACT original version)
local OrionLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/GRPGaming/Key-System/refs/heads/Xycer-Hub-Script/ZusumeLib(Slider)"))()

-- Create the Main Window (original config)
local Window = OrionLib:MakeWindow({
    Name = "UnEasy Hub",
    HidePremium = false,
    SaveConfig = true,
    ConfigFolder = "UnEasyHubConfig"
})

-- Original Tab/Section Structure
local MainTab = Window:MakeTab({
    Name = "Main",
    Icon = "rbxassetid://13516625108",
    PremiumOnly = false
})

local CharacterSection = MainTab:AddSection({
    Name = "Character" -- Original section name
})

-- ===== ORIGINAL NO CLIP TOGGLE (UNCHANGED) =====
local noclipEnabled = false
CharacterSection:AddToggle({
    Name = "Noclip", -- Original button name
    Default = false,
    Callback = function(value)
        noclipEnabled = value
        local player = game:GetService("Players").LocalPlayer
        if player.Character then
            for _, v in ipairs(player.Character:GetDescendants()) do
                if v:IsA("BasePart") then
                    v.CanCollide = not value
                end
            end
        end
    end
})

-- ===== NEW FLY TOGGLE (ADDED UNDER ORIGINAL NO CLIP) =====
local flyEnabled = false
local flySpeed = 25 -- Optimal for mobile
local bodyVelocity

CharacterSection:AddToggle({
    Name = "Fly", -- Matching original naming style
    Default = false,
    Callback = function(value)
        flyEnabled = value
        local player = game:GetService("Players").LocalPlayer
        local character = player.Character or player.CharacterAdded:Wait()
        local root = character:WaitForChild("HumanoidRootPart")

        if flyEnabled then
            -- Mobile fly activation
            bodyVelocity = Instance.new("BodyVelocity")
            bodyVelocity.Velocity = Vector3.new(0, 0.5, 0) -- Slight upward bias for mobile
            bodyVelocity.MaxForce = Vector3.new(0, 9e9, 0)
            bodyVelocity.P = 1250 -- Smoother for touch
            bodyVelocity.Parent = root

            -- Touch control connection
            local flyCon
            flyCon = game:GetService("RunService").Heartbeat:Connect(function()
                if not flyEnabled or not bodyVelocity or not bodyVelocity.Parent then
                    flyCon:Disconnect()
                    return
                end

                -- Default hover behavior for mobile
                bodyVelocity.Velocity = Vector3.new(0, 0.5, 0)
            end)
        else
            -- Cleanup
            if bodyVelocity then
                bodyVelocity:Destroy()
                bodyVelocity = nil
            end
        end
    end
})

-- Original notification
OrionLib:MakeNotification({
    Name = "UnEasy Hub",
    Content = "Loaded successfully!",
    Time = 3
})
