-- Rayfield UI Library Initialization
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- Main Window Creation
local Window = Rayfield:CreateWindow({
    Name = "Premium Hub",
    LoadingTitle = "Loading Elements...",
    LoadingSubtitle = "by AI",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "RayfieldConfigs",
        FileName = "PremiumHub"
    },
    Discord = {
        Enabled = false,
        Invite = "noinv",
        RememberJoins = true
    },
    KeySystem = false
})

-- Services
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")

local LocalPlayer = Players.LocalPlayer

-- Feature Variables
local InfiniteJumpEnabled = false
local EspEnabled = false
local NoclipEnabled = false
local FullbrightEnabled = false

local OriginalAmbient = Lighting.Ambient
local OriginalOutdoorAmbient = Lighting.OutdoorAmbient

-- Elements Dictionary for Dynamic Management
local ESP_Highlights = {}

-- Create Tabs
local MainTab = Window:CreateTab("Main Features", nil)
local VisualsTab = Window:CreateTab("Visuals", nil)

--- // Main Features Tab // ---

-- Infinite Jump Feature
MainTab:CreateToggle({
    Name = "Infinite Jump",
    CurrentValue = false,
    Callback = function(Value)
        InfiniteJumpEnabled = Value
    end
})

UserInputService.JumpRequest:Connect(function()
    if InfiniteJumpEnabled and LocalPlayer.Character then
        local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end)

-- Noclip Feature (AI's Choice 1)
MainTab:CreateToggle({
    Name = "Noclip",
    CurrentValue = false,
    Callback = function(Value)
        NoclipEnabled = Value
    end
})

RunService.Stepped:Connect(function()
    if NoclipEnabled and LocalPlayer.Character then
        for _, part in ipairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") and part.CanCollide then
                part.CanCollide = false
            end
        end
    end
end)

--- // Visuals Tab // ---

-- Helper functions for ESP management
local function applyESP(player)
    if player == LocalPlayer then return end
    
    local function setupHighlight(character)
        if not EspEnabled then return end
        if ESP_Highlights[player] then ESP_Highlights[player]:Destroy() end
        
        local highlight = Instance.new("Highlight")
        highlight.Name = "ESPHighlight"
        highlight.FillColor = Color3.fromRGB(255, 0, 0)
        highlight.FillTransparency = 0.5
        highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
        highlight.OutlineTransparency = 0
        highlight.Adornee = character
        highlight.Parent = character
        
        ESP_Highlights[player] = highlight
    end

    if player.Character then
        setupHighlight(player.Character)
    end
    player.CharacterAdded:Connect(setupHighlight)
end

local function clearESP()
    for player, highlight in pairs(ESP_Highlights) do
        if highlight and highlight.Parent then
            highlight:Destroy()
        end
        ESP_Highlights[player] = nil
    end
end

-- ESP Feature
VisualsTab:CreateToggle({
    Name = "Player ESP",
    CurrentValue = false,
    Callback = function(Value)
        EspEnabled = Value
        if EspEnabled then
            for _, player in ipairs(Players:GetPlayers()) do
                applyESP(player)
            end
            Players.PlayerAdded:Connect(applyESP)
        else
            clearESP()
        end
    end
})

-- Clean up ESP references if a player leaves
Players.PlayerRemoving:Connect(function(player)
    if ESP_Highlights[player] then
        ESP_Highlights[player]:Destroy()
        ESP_Highlights[player] = nil
    end
end)

-- Fullbright Feature (AI's Choice 2)
VisualsTab:CreateToggle({
    Name = "Fullbright",
    CurrentValue = false,
    Callback = function(Value)
        FullbrightEnabled = Value
        if FullbrightEnabled then
            Lighting.Ambient = Color3.fromRGB(255, 255, 255)
            Lighting.OutdoorAmbient = Color3.fromRGB(255, 255, 255)
        else
            Lighting.Ambient = OriginalAmbient
            Lighting.OutdoorAmbient = OriginalOutdoorAmbient
        end
    end
})

-- Ensure correct cleanup on environment events or property changes
Lighting:GetPropertyChangedSignal("Ambient"):Connect(function()
    if FullbrightEnabled and Lighting.Ambient ~= Color3.fromRGB(255, 255, 255) then
        Lighting.Ambient = Color3.fromRGB(255, 255, 255)
    end
end)

Lighting:GetPropertyChangedSignal("OutdoorAmbient"):Connect(function()
    if FullbrightEnabled and Lighting.OutdoorAmbient ~= Color3.fromRGB(255, 255, 255) then
        Lighting.OutdoorAmbient = Color3.fromRGB(255, 255, 255)
    end
end)
