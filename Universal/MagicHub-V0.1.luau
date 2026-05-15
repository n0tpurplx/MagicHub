-- 1. Load the Rayfield UI Library
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- 2. Create the Main Window
local Window = Rayfield:CreateWindow({
   Name = "MagicHub",
   LoadingTitle = "Loading MagicHub...",
   LoadingSubtitle = "by purplx",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = "MagicHubConfig", 
      FileName = "BigHub"
   },
   KeySystem = false,
})

-- 3. Create a Tab
local MainTab = Window:CreateTab("Main Cheats", 4483362458)

-- 4. Add a Label (Informational text)
local Label = MainTab:CreateLabel("Testing environment active - Enjoy experimenting!")

-- 5. Add a Slider (Smoothly adjust your WalkSpeed)
local Slider = MainTab:CreateSlider({
   Name = "Adjust Speed",
   Range = {16, 250}, -- 16 is default Roblox speed
   Increment = 1,
   Suffix = " Studs/sec",
   CurrentValue = 16,
   Flag = "SpeedSlider", 
   Callback = function(Value)
      game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = Value
   end,
})

-- 6. Add a Toggle Element (Infinite Jump)
local Toggle = MainTab:CreateToggle({
   Name = "Infinite Jump",
   CurrentValue = false,
   Flag = "InfJumpToggle", 
   Callback = function(Value)
       _G.InfiniteJump = Value
       
       game:GetService("UserInputService").JumpRequest:Connect(function()
           if _G.InfiniteJump then
               game.Players.LocalPlayer.Character:FindFirstChildOfClass('Humanoid'):ChangeState("Jumping")
           end
       end)
   end,
})

-- 7. Add a Button Element (Quick Reset)
local Button = MainTab:CreateButton({
   Name = "Reset Speed to Normal",
   Callback = function()
       game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 16
       Rayfield:Notify({
          Title = "Speed Reset",
          Content = "Your WalkSpeed has been set back to 16.",
          Duration = 3,
          Image = 4483362458,
       })
   end,
})

-- 8. Finish loading notification
Rayfield:Notify({
    Title = "MagicHub Loaded!",
    Content = "Using MagicHub-FREE V0.1 by purplx",
    Duration = 5,
    Image = 4483362458,
})
