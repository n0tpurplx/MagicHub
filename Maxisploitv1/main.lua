local ObsidianURL = "https://raw.githubusercontent.com/deividcomsono/Obsidian/refs/heads/main/Library.lua"

local Success, Result = pcall(function()
    local Source = game:HttpGet(ObsidianURL)
    local Loader = loadstring(Source)

    if not Loader then
        error("loadstring failed")
    end

    return Loader()
end)

if not Success then
    warn("[maxisploit] Obsidian failed to load:")
    warn(Result)
    return
end

local Library = Result

if not Library then
    warn("[maxisploit] Obsidian returned nil")
    return
end

Library.Scheme = {
    BackgroundColor = Color3.fromRGB(15, 15, 18),
    MainColor = Color3.fromRGB(22, 22, 27),
    AccentColor = Color3.fromRGB(110, 65, 180),
    OutlineColor = Color3.fromRGB(55, 55, 65),
    FontColor = Color3.fromRGB(255, 255, 255),
    Font = Font.fromEnum(Enum.Font.Gotham)
}

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

local FeatureBox = MainTab:AddLeftGroupbox("Features")

FeatureBox:AddLabel("maxisploit")
FeatureBox:AddLabel("Obsidian loaded successfully")

local SettingsTab = Window:AddTab("Settings", "settings")

local SettingsBox = SettingsTab:AddLeftGroupbox("Settings")

SettingsBox:AddButton({
    Text = "Unload",
    Func = function()
        Library:Unload()
    end
})
