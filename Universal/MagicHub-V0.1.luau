-- 1. Load the Rayfield UI Library
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- Services
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer

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

----------------------------------------------------
-- MOVEMENT TAB
----------------------------------------------------

local MovementTab = Window:CreateTab("Movement", 4483362458)

MovementTab:CreateLabel("WIP!!!")

-- Speed Slider
MovementTab:CreateSlider({
   Name = "Adjust Speed",
   Range = {16, 250},
   Increment = 1,
   Suffix = " Studs/sec",
   CurrentValue = 16,
   Flag = "SpeedSlider",

   Callback = function(Value)
      local Character = LocalPlayer.Character
      if Character and Character:FindFirstChild("Humanoid") then
         Character.Humanoid.WalkSpeed = Value
      end
   end,
})

----------------------------------------------------
-- INFINITE JUMP
----------------------------------------------------

_G.InfiniteJump = false

UserInputService.JumpRequest:Connect(function()
   if _G.InfiniteJump then
      local Character = LocalPlayer.Character

      if Character then
         local Humanoid = Character:FindFirstChildOfClass("Humanoid")

         if Humanoid then
            Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
         end
      end
   end
end)

MovementTab:CreateToggle({
   Name = "Infinite Jump",
   CurrentValue = false,
   Flag = "InfJumpToggle",

   Callback = function(Value)
      _G.InfiniteJump = Value
   end,
})

----------------------------------------------------
-- RESET BUTTON
----------------------------------------------------

MovementTab:CreateButton({
   Name = "Reset Speed to Normal",

   Callback = function()
      local Character = LocalPlayer.Character

      if Character and Character:FindFirstChild("Humanoid") then
         Character.Humanoid.WalkSpeed = 16
      end

      Rayfield:Notify({
         Title = "Speed Reset",
         Content = "Your WalkSpeed has been set back to 16.",
         Duration = 3,
         Image = 4483362458,
      })
   end,
})

----------------------------------------------------
-- RENDER TAB
----------------------------------------------------

local RenderTab = Window:CreateTab("Render", 4483362458)

RenderTab:CreateButton({
   Name = "Enable ESP",

   Callback = function()

      -- ESP code would go here

      Rayfield:Notify({
         Title = "ESP Enabled",
         Content = "ESP has been enabled",
         Duration = 3,
         Image = 4483362458,
      })
   end,
})

----------------------------------------------------
-- LOADED NOTIFICATION
----------------------------------------------------

Rayfield:Notify({
   Title = "MagicHub Loaded!",
   Content = "Using MagicHub-FREE V0.1 by purplx",
   Duration = 5,
   Image = 4483362458,
})
