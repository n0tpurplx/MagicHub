--// Load Rayfield UI Library
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

--// Create Main Window
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

--// Services
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")

local LocalPlayer = Players.LocalPlayer

--// Create Main Tab
local MainTab = Window:CreateTab("Main", nil)

--////////////////////////////////////////////////////////--
--// Infinite Jump
--////////////////////////////////////////////////////////--

local InfiniteJumpEnabled = false

MainTab:CreateToggle({
    Name = "Infinite Jump",
    CurrentValue = false,
    Flag = "InfiniteJump",
    Callback = function(Value)
        InfiniteJumpEnabled = Value
    end
})

UserInputService.JumpRequest:Connect(function()
    if InfiniteJumpEnabled then
        local Character = LocalPlayer.Character
        if Character then
            local Humanoid = Character:FindFirstChildOfClass("Humanoid")
            if Humanoid then
                Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end
    end
end)

--////////////////////////////////////////////////////////--
--// ESP System
--////////////////////////////////////////////////////////--

local ESPEnabled = false
local ESPHighlights = {}

local function CreateESP(Player)
    if Player == LocalPlayer then
        return
    end

    local function ApplyESP(Character)
        if not ESPEnabled then
            return
        end

        if Character and not Character:FindFirstChild("AI_ESP") then
            local Highlight = Instance.new("Highlight")
            Highlight.Name = "AI_ESP"
            Highlight.FillColor = Color3.fromRGB(255, 0, 0)
            Highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
            Highlight.FillTransparency = 0.5
            Highlight.OutlineTransparency = 0
            Highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
            Highlight.Parent = Character

            ESPHighlights[Player] = Highlight
        end
    end

    if Player.Character then
        ApplyESP(Player.Character)
    end

    Player.CharacterAdded:Connect(function(Character)
        task.wait(1)
        ApplyESP(Character)
    end)
end

local function ClearESP()
    for _, Highlight in pairs(ESPHighlights) do
        if Highlight then
            Highlight:Destroy()
        end
    end
    ESPHighlights = {}
end

MainTab:CreateToggle({
    Name = "Player ESP",
    CurrentValue = false,
    Flag = "ESP",
    Callback = function(Value)
        ESPEnabled = Value

        if Value then
            for _, Player in pairs(Players:GetPlayers()) do
                CreateESP(Player)
            end
        else
            ClearESP()
        end
    end
})

Players.PlayerAdded:Connect(function(Player)
    if ESPEnabled then
        CreateESP(Player)
    end
end)

--////////////////////////////////////////////////////////--
--// Noclip
--////////////////////////////////////////////////////////--

local NoclipEnabled = false

MainTab:CreateToggle({
    Name = "Noclip",
    CurrentValue = false,
    Flag = "Noclip",
    Callback = function(Value)
        NoclipEnabled = Value
    end
})

RunService.Stepped:Connect(function()
    if NoclipEnabled then
        local Character = LocalPlayer.Character
        if Character then
            for _, Part in pairs(Character:GetDescendants()) do
                if Part:IsA("BasePart") then
                    Part.CanCollide = false
                end
            end
        end
    end
end)

--////////////////////////////////////////////////////////--
--// WalkSpeed Slider
--////////////////////////////////////////////////////////--

local WalkSpeedValue = 16

MainTab:CreateSlider({
    Name = "WalkSpeed",
    Range = {16, 100},
    Increment = 1,
    Suffix = "Speed",
    CurrentValue = 16,
    Flag = "WalkSpeed",
    Callback = function(Value)
        WalkSpeedValue = Value

        local Character = LocalPlayer.Character
        if Character then
            local Humanoid = Character:FindFirstChildOfClass("Humanoid")
            if Humanoid then
                Humanoid.WalkSpeed = WalkSpeedValue
            end
        end
    end
})

LocalPlayer.CharacterAdded:Connect(function(Character)
    local Humanoid = Character:WaitForChild("Humanoid")
    Humanoid.WalkSpeed = WalkSpeedValue
end)

--////////////////////////////////////////////////////////--
--// Fullbright
--////////////////////////////////////////////////////////--

local FullbrightEnabled = false

local OriginalBrightness = Lighting.Brightness
local OriginalClockTime = Lighting.ClockTime
local OriginalFogEnd = Lighting.FogEnd
local OriginalGlobalShadows = Lighting.GlobalShadows

MainTab:CreateToggle({
    Name = "Fullbright",
    CurrentValue = false,
    Flag = "Fullbright",
    Callback = function(Value)
        FullbrightEnabled = Value

        if Value then
            Lighting.Brightness = 5
            Lighting.ClockTime = 14
            Lighting.FogEnd = 100000
            Lighting.GlobalShadows = false
        else
            Lighting.Brightness = OriginalBrightness
            Lighting.ClockTime = OriginalClockTime
            Lighting.FogEnd = OriginalFogEnd
            Lighting.GlobalShadows = OriginalGlobalShadows
        end
    end
})

--////////////////////////////////////////////////////////--
--// Fly System
--////////////////////////////////////////////////////////--

local FlyEnabled = false
local FlySpeed = 50
local FlyConnection

MainTab:CreateSlider({
    Name = "Fly Speed",
    Range = {10, 200},
    Increment = 5,
    Suffix = "Speed",
    CurrentValue = 50,
    Flag = "FlySpeed",
    Callback = function(Value)
        FlySpeed = Value
    end
})

MainTab:CreateToggle({
    Name = "Fly",
    CurrentValue = false,
    Flag = "Fly",
    Callback = function(Value)
        FlyEnabled = Value

        local Character = LocalPlayer.Character
        if not Character then return end

        local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")
        if not HumanoidRootPart then return end

        if Value then
            local BodyVelocity = Instance.new("BodyVelocity")
            BodyVelocity.Name = "FlyVelocity"
            BodyVelocity.MaxForce = Vector3.new(1e9, 1e9, 1e9)
            BodyVelocity.Velocity = Vector3.zero
            BodyVelocity.Parent = HumanoidRootPart

            FlyConnection = RunService.RenderStepped:Connect(function()
                local MoveDirection = Vector3.zero

                if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                    MoveDirection += workspace.CurrentCamera.CFrame.LookVector
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                    MoveDirection -= workspace.CurrentCamera.CFrame.LookVector
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                    MoveDirection -= workspace.CurrentCamera.CFrame.RightVector
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                    MoveDirection += workspace.CurrentCamera.CFrame.RightVector
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                    MoveDirection += Vector3.new(0, 1, 0)
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
                    MoveDirection -= Vector3.new(0, 1, 0)
                end

                BodyVelocity.Velocity = MoveDirection.Unit * FlySpeed
                if MoveDirection.Magnitude == 0 then
                    BodyVelocity.Velocity = Vector3.zero
                end
            end)
        else
            if FlyConnection then
                FlyConnection:Disconnect()
                FlyConnection = nil
            end

            local ExistingVelocity = HumanoidRootPart:FindFirstChild("FlyVelocity")
            if ExistingVelocity then
                ExistingVelocity:Destroy()
            end
        end
    end
})

--// Notification
Rayfield:Notify({
    Title = "Premium Hub",
    Content = "Loaded Successfully!",
    Duration = 5,
    Image = nil
})
