local ObsidianURL = "https://raw.githubusercontent.com/deividcomsono/Obsidian/refs/heads/main/Library.lua"

local Library = loadstring(game:HttpGet(ObsidianURL))()

local Window = Library:CreateWindow({
    Title = "maxisploit",
    Footer = "purplxdevs",
    Center = true,
    AutoShow = true,
    Resizable = true,
    ToggleKeybind = Enum.KeyCode.RightControl,
    MobileButtonsSide = "Right"
})

local MainTab = Window:AddTab("Main", "home")
local Features = MainTab:AddLeftGroupbox("Features")

local Running = false

Features:AddToggle("AutoTrain", {
    Text = "Auto Train",
    Default = false,

    Callback = function(Value)
        Running = Value

        if Value then
            task.spawn(function()
                while Running do
                    task.wait(0.1)

                    local Event = game:GetService("ReplicatedStorage")
                        .SharedModules
                        .Network
                        .Remotes["Activate Dumbell"]

                    Event:FireServer()
                end
            end)
        end
    end
})

local SettingsTab = Window:AddTab("Settings", "settings")
local Settings = SettingsTab:AddLeftGroupbox("Settings")

Settings:AddButton({
    Text = "Unload",
    Func = function()
        Running = false
        Library:Unload()
    end
})
