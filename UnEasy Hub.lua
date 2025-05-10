-- Load the library (mocking OrionLib API, but using ZezumeLib source from your link)
local OrionLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/GRPGaming/Key-System/refs/heads/Xycer-Hub-Script/ZusumeLib(Slider)"))()

-- Check if the library loaded successfully
if not OrionLib or type(OrionLib) ~= "table" then
    warn("Failed to load the UI library or it's not in the expected table format. Script will not run correctly.")
    return -- Stop script execution if library failed to load
end

-- Create the Main Window for the UI
local Window = OrionLib:MakeWindow({
    Name = "UnEasy Hub",
    HidePremium = false,
    SaveConfig = true,
    ConfigFolder = "UnEasyHubConfig"
})

-- Create a Tab within the Window
local MainTab = Window:MakeTab({
    Name = "Main",
    Icon = "rbxassetid://13516625108",
    PremiumOnly = false
})

-- Create a Section within the "Main" Tab
local CharacterSection = MainTab:AddSection({
    Name = "Character"
})

-- ========== State Variables ==========
local speedHackEnabled = false
local currentSpeedValue = 16
local originalWalkSpeed = 16

local jumpPowerEnabled = false
local currentJumpPowerValue = 50
local originalJumpPower = 50

local noclipEnabled = false
local originalHumanoidPlatformStand = false -- To store original PlatformStand state

local speedSliderObject
local jumpPowerSliderObject

-- ========== Utility Functions ==========
local function getPlayerCharacterHumanoid()
    local player = game:GetService("Players").LocalPlayer
    if player then
        local character = player.Character
        if character then
            local humanoid = character:FindFirstChildOfClass("Humanoid")
            return player, character, humanoid
        end
    end
    return nil, nil, nil
end

local function setNoclipState(character, humanoid, enabled)
    if not character or not humanoid then return end

    if enabled then
        originalHumanoidPlatformStand = humanoid.PlatformStand -- Store original PlatformStand
        humanoid.PlatformStand = true -- This helps stabilize noclip and prevent ground interaction

        for _, part in ipairs(character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
        -- Forcing state to Flying can help prevent physics glitches when jumping inside objects.
        -- It might take a frame or two for the state change to fully propagate and stabilize.
        humanoid:ChangeState(Enum.HumanoidStateType.Flying)
    else
        humanoid.PlatformStand = originalHumanoidPlatformStand -- Restore original PlatformStand

        for _, part in ipairs(character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = true -- Be careful if some parts should remain non-collidable
            end
        end
        -- Attempt to revert to a normal state. GettingUp is a safe default.
        humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
    end
end

local function initializeCharacterPropertiesAndSliders()
    local player, character, humanoid = getPlayerCharacterHumanoid()
    if humanoid then
        -- Speed Properties
        if originalWalkSpeed == 16 and humanoid.WalkSpeed ~= 16 then
            originalWalkSpeed = humanoid.WalkSpeed
        end
        if currentSpeedValue == 16 and humanoid.WalkSpeed ~= 16 then
             currentSpeedValue = humanoid.WalkSpeed
             if speedSliderObject and speedSliderObject.SetValue then
                 speedSliderObject:SetValue(currentSpeedValue, false)
             end
        end

        -- JumpPower Properties
        if originalJumpPower == 50 and humanoid.JumpPower ~= 50 then
            originalJumpPower = humanoid.JumpPower
        end
        if currentJumpPowerValue == 50 and humanoid.JumpPower ~= 50 then
             currentJumpPowerValue = humanoid.JumpPower
             if jumpPowerSliderObject and jumpPowerSliderObject.SetValue then
                 jumpPowerSliderObject:SetValue(currentJumpPowerValue, false)
             end
        end
        
        -- Apply noclip if it was enabled and player respawned
        if noclipEnabled then
            setNoclipState(character, humanoid, true)
        end
    else
        currentSpeedValue = 16
        originalWalkSpeed = 16
        currentJumpPowerValue = 50
        originalJumpPower = 50
    end
end

-- ========== Speed Hack UI Controls ==========
CharacterSection:AddToggle({
    Name = "Speed Hack", Default = speedHackEnabled,
    Callback = function(value)
        speedHackEnabled = value
        local _, _, humanoid = getPlayerCharacterHumanoid()
        if not humanoid then return end
        humanoid.WalkSpeed = speedHackEnabled and currentSpeedValue or originalWalkSpeed
    end
})
speedSliderObject = CharacterSection:AddSlider({
    Name = "Speed Amount", Min = 1, Max = 200, Default = currentSpeedValue, Increment = 1, ValueName = "studs/s",
    Callback = function(value)
        currentSpeedValue = value
        if speedHackEnabled then
            local _, _, humanoid = getPlayerCharacterHumanoid()
            if humanoid then humanoid.WalkSpeed = currentSpeedValue end
        end
    end
})
CharacterSection:AddButton({
    Name = "Reset Speed",
    Callback = function()
        local _, _, humanoid = getPlayerCharacterHumanoid()
        if humanoid then
            humanoid.WalkSpeed = originalWalkSpeed; currentSpeedValue = originalWalkSpeed
            if speedSliderObject and speedSliderObject.SetValue then speedSliderObject:SetValue(originalWalkSpeed, false) end
            if OrionLib and OrionLib.MakeNotification then OrionLib:MakeNotification({ Name = "Speed Reset", Content = "WalkSpeed reset to " .. originalWalkSpeed .. " studs/s.", Time = 3 }) end
        end
    end
})

-- ========== JumpPower Hack UI Controls ==========
CharacterSection:AddToggle({
    Name = "JumpPower Hack", Default = jumpPowerEnabled,
    Callback = function(value)
        jumpPowerEnabled = value
        local _, _, humanoid = getPlayerCharacterHumanoid()
        if not humanoid then return end
        humanoid.JumpPower = jumpPowerEnabled and currentJumpPowerValue or originalJumpPower
    end
})
jumpPowerSliderObject = CharacterSection:AddSlider({
    Name = "JumpPower Amount", Min = 0, Max = 500, Default = currentJumpPowerValue, Increment = 1, ValueName = "power",
    Callback = function(value)
        currentJumpPowerValue = value
        if jumpPowerEnabled then
            local _, _, humanoid = getPlayerCharacterHumanoid()
            if humanoid then humanoid.JumpPower = currentJumpPowerValue end
        end
    end
})
CharacterSection:AddButton({
    Name = "Reset JumpPower",
    Callback = function()
        local _, _, humanoid = getPlayerCharacterHumanoid()
        if humanoid then
            humanoid.JumpPower = originalJumpPower; currentJumpPowerValue = originalJumpPower
            if jumpPowerSliderObject and jumpPowerSliderObject.SetValue then jumpPowerSliderObject:SetValue(originalJumpPower, false) end
            if OrionLib and OrionLib.MakeNotification then OrionLib:MakeNotification({ Name = "JumpPower Reset", Content = "JumpPower reset to " .. originalJumpPower .. ".", Time = 3 }) end
        end
    end
})

-- ========== Noclip UI Control ==========
CharacterSection:AddToggle({
    Name = "Noclip",
    Default = noclipEnabled,
    Callback = function(value)
        noclipEnabled = value
        print("Noclip Toggled: " .. tostring(noclipEnabled))
        local _, character, humanoid = getPlayerCharacterHumanoid()
        if character and humanoid then
            setNoclipState(character, humanoid, noclipEnabled)
        else
            print("Noclip: Character or Humanoid not found to apply state.")
        end
    end
})

-- ========== Initialization and Continuous Enforcement Logic ==========
initializeCharacterPropertiesAndSliders()

game:GetService("Players").LocalPlayer.CharacterAdded:Connect(function(character)
    task.wait(0.5)
    initializeCharacterPropertiesAndSliders()
end)

game:GetService("RunService").RenderStepped:Connect(function()
    local player, character, humanoid = getPlayerCharacterHumanoid()
    if not humanoid then return end

    if speedHackEnabled and humanoid.WalkSpeed ~= currentSpeedValue then
        humanoid.WalkSpeed = currentSpeedValue
    end

    if jumpPowerEnabled and humanoid.JumpPower ~= currentJumpPowerValue then
        humanoid.JumpPower = currentJumpPowerValue
    end
    
    if noclipEnabled then
        -- Continuously ensure noclip state if Humanoid is not in Flying state
        -- This is a more robust check for the Humanoid state during noclip.
        if humanoid:GetState() ~= Enum.HumanoidStateType.Flying then
            humanoid:ChangeState(Enum.HumanoidStateType.Flying)
        end
        -- Also, ensure PlatformStand is true during noclip
        if not humanoid.PlatformStand then
            humanoid.PlatformStand = true
        end

        -- Ensure parts remain non-collidable (can be less aggressive if state management is solid)
        for _, part in ipairs(character:GetDescendants()) do
            if part:IsA("BasePart") and part.CanCollide == true then
                part.CanCollide = false
            end
        end
    -- elseif not noclipEnabled and humanoid.PlatformStand == true and originalHumanoidPlatformStand == false then
        -- This part is tricky: if noclip is off, we want PlatformStand to be its original value.
        -- However, other scripts or game mechanics might legitimately set PlatformStand.
        -- For now, setNoclipState handles restoring PlatformStand when noclip is explicitly turned off.
    end
end)

-- ========== Initial "Loaded" Notification ==========
if OrionLib and OrionLib.MakeNotification then
    OrionLib:MakeNotification({ Name = "UnEasy Hub", Content = "Successfully Loaded!", Image = "rbxassetid://13516625108", Time = 5 })
end
print("UnEasy Hub script initialized, written for OrionLib API structure.")
