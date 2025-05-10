-- Load Rayfield Library
local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()

-- Create Window
local Window = Rayfield:CreateWindow({
   Name = "UnEasy Hub",
   LoadingTitle = "UnEasy Hub",
   LoadingSubtitle = "by FireNot9Gaming",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = nil,
      FileName = "UnEasyHub"
   },
   Discord = {
      Enabled = false,
      Invite = "",
      RememberJoins = false
   },
   KeySystem = false
})

-- Main Tab
local MainTab = Window:CreateTab("Main Scripts", 4483362458)

MainTab:CreateButton({
   Name = "Infinite Yield",
   Callback = function()
      loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))()
   end,
})

MainTab:CreateButton({
   Name = "CMD-X Admin",
   Callback = function()
      loadstring(game:HttpGet("https://raw.githubusercontent.com/CMD-X/CMD-X/master/Source"))()
   end,
})

-- Fun Tab
local FunTab = Window:CreateTab("Fun Scripts", 4483362458)

FunTab:CreateButton({
   Name = "Chat Trolling",
   Callback = function()
      loadstring(game:HttpGet("https://pastebin.com/raw/HNqZHZ9m"))()
   end,
})
