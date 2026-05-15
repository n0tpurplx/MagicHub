-- // Rayfield UI Library Initialization
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- // Core Roblox Services
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")

local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- // Main Window Setup
local Window = Rayfield:CreateWindow({
    Name = "Phantom Hub",
    LoadingTitle = "Loading Phantom Hub...",
    LoadingSubtitle = "by PhantomDev",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "PhantomHubConfigs",
        FileName = "PhantomHub"
    },
    Discord = {
        Enabled = false,
        Invite = "noinv",
        RememberJoins = true
    },
    KeySystem = false
})

-- // ============================================================
-- //  TAB: MOVEMENT
-- // ============================================================
local MovementTab = Window:CreateTab("Movement", nil)

-- // --- Infinite Jump ---
local InfiniteJumpEnabled = false

UserInputService.JumpRequest:Connect(function()
    if InfiniteJumpEnabled then
        local character = LocalPlayer.Character
        if character then
            local humanoid = character:FindFirstChildOfClass("Humanoid")
            if humanoid and humanoid:GetState() ~= Enum.HumanoidStateType.Dead then
                humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end
    end
end)

Rayfield:CreateToggle({
    Name = "Infinite Jump",
    Title = "Infinite Jump",
    CurrentValue = false,
    Flag = "InfiniteJump",
    Callback = function(Value)
        InfiniteJumpEnabled = Value
    end,
}, MovementTab)

-- // --- Walk Speed ---
Rayfield:CreateSlider({
    Name = "Walk Speed",
    Title = "Walk Speed",
    Range = {16, 300},
    Increment = 1,
    Suffix = "Speed",
    CurrentValue = 16,
    Flag = "WalkSpeed",
    Callback = function(Value)
        local character = LocalPlayer.Character
        if character then
            local humanoid = character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid.WalkSpeed = Value
            end
        end
    end,
}, MovementTab)

-- // --- Jump Power ---
Rayfield:CreateSlider({
    Name = "Jump Power",
    Title = "Jump Power",
    Range = {50, 300},
    Increment = 5,
    Suffix = "Power",
    CurrentValue = 50,
    Flag = "JumpPower",
    Callback = function(Value)
        local character = LocalPlayer.Character
        if character then
            local humanoid = character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid.JumpPower = Value
            end
        end
    end,
}, MovementTab)

-- // --- Fly Feature ---
local FlyEnabled = false
local FlySpeed = 50
local FlyConnection = nil
local BodyVelocity = nil
local BodyGyro = nil

local function EnableFly()
    local character = LocalPlayer.Character
    if not character then return end
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    if not rootPart then return end

    -- Create physics objects for flight
    BodyVelocity = Instance.new("BodyVelocity")
    BodyVelocity.Velocity = Vector3.zero
    BodyVelocity.MaxForce = Vector3.new(1e5, 1e5, 1e5)
    BodyVelocity.Parent = rootPart

    BodyGyro = Instance.new("BodyGyro")
    BodyGyro.MaxTorque = Vector3.new(1e5, 1e5, 1e5)
    BodyGyro.P = 1e4
    BodyGyro.Parent = rootPart

    FlyConnection = RunService.Heartbeat:Connect(function()
        if not FlyEnabled then return end
        local character2 = LocalPlayer.Character
        if not character2 then return end
        local root = character2:FindFirstChild("HumanoidRootPart")
        if not root then return end

        local camCF = Camera.CFrame
        local direction = Vector3.zero

        if UserInputService:IsKeyDown(Enum.KeyCode.W) then
            direction = direction + camCF.LookVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then
            direction = direction - camCF.LookVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then
            direction = direction - camCF.RightVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then
            direction = direction + camCF.RightVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
            direction = direction + Vector3.new(0, 1, 0)
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
            direction = direction - Vector3.new(0, 1, 0)
        end

        if BodyVelocity and BodyVelocity.Parent then
            BodyVelocity.Velocity = direction.Magnitude > 0
                and direction.Unit * FlySpeed
                or Vector3.zero
        end

        if BodyGyro and BodyGyro.Parent then
            BodyGyro.CFrame = camCF
        end
    end)
end

local function DisableFly()
    if FlyConnection then
        FlyConnection:Disconnect()
        FlyConnection = nil
    end
    if BodyVelocity then
        BodyVelocity:Destroy()
        BodyVelocity = nil
    end
    if BodyGyro then
        BodyGyro:Destroy()
        BodyGyro = nil
    end
end

Rayfield:CreateToggle({
    Name = "Fly (WASD + Space/Shift)",
    Title = "Fly",
    CurrentValue = false,
    Flag = "Fly",
    Callback = function(Value)
        FlyEnabled = Value
        if Value then
            EnableFly()
        else
            DisableFly()
        end
    end,
}, MovementTab)

Rayfield:CreateSlider({
    Name = "Fly Speed",
    Title = "Fly Speed",
    Range = {10, 300},
    Increment = 5,
    Suffix = "Speed",
    CurrentValue = 50,
    Flag = "FlySpeed",
    Callback = function(Value)
        FlySpeed = Value
    end,
}, MovementTab)

-- // --- Noclip ---
local NoclipEnabled = false
local NoclipConnection = nil

Rayfield:CreateToggle({
    Name = "Noclip",
    Title = "Noclip",
    CurrentValue = false,
    Flag = "Noclip",
    Callback = function(Value)
        NoclipEnabled = Value
        if Value then
            NoclipConnection = RunService.Stepped:Connect(function()
                local character = LocalPlayer.Character
                if character then
                    for _, part in ipairs(character:GetDescendants()) do
                        if part:IsA("BasePart") and part.CanCollide then
                            part.CanCollide = false
                        end
                    end
                end
            end)
        else
            if NoclipConnection then
                NoclipConnection:Disconnect()
                NoclipConnection = nil
            end
            -- Restore collision on character parts
            local character = LocalPlayer.Character
            if character then
                for _, part in ipairs(character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = true
                    end
                end
            end
        end
    end,
}, MovementTab)

-- // ============================================================
-- //  TAB: VISUALS
-- // ============================================================
local VisualsTab = Window:CreateTab("Visuals", nil)

-- // --- ESP (Player Highlights) ---
local ESPEnabled = false
local ESPHighlights = {}

local function CreateESP(player)
    if player == LocalPlayer then return end
    -- Remove existing ESP for this player first
    if ESPHighlights[player] then
        ESPHighlights[player]:Destroy()
        ESPHighlights[player] = nil
    end

    local character = player.Character
    if not character then return end

    local highlight = Instance.new("Highlight")
    highlight.Name = "PhantomESP"
    highlight.FillColor = Color3.fromRGB(255, 50, 50)
    highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
    highlight.FillTransparency = 0.5
    highlight.OutlineTransparency = 0
    highlight.Adornee = character
    highlight.Parent = character

    ESPHighlights[player] = highlight
end

local function RemoveESP(player)
    if ESPHighlights[player] then
        ESPHighlights[player]:Destroy()
        ESPHighlights[player] = nil
    end
end

local function ClearAllESP()
    for player, highlight in pairs(ESPHighlights) do
        if highlight then highlight:Destroy() end
        ESPHighlights[player] = nil
    end
end

-- Track character additions for each player while ESP is active
local ESPCharacterConnections = {}

Rayfield:CreateToggle({
    Name = "Player ESP (Highlight)",
    Title = "Player ESP",
    CurrentValue = false,
    Flag = "PlayerESP",
    Callback = function(Value)
        ESPEnabled = Value
        if Value then
            -- Apply ESP to all current players
            for _, player in ipairs(Players:GetPlayers()) do
                CreateESP(player)
                -- Watch for character respawns
                ESPCharacterConnections[player] = player.CharacterAdded:Connect(function()
                    if ESPEnabled then
                        task.wait(0.1) -- Brief wait for character to load
                        CreateESP(player)
                    end
                end)
            end
            -- Handle new players joining
            ESPCharacterConnections["PlayerAdded"] = Players.PlayerAdded:Connect(function(player)
                if ESPEnabled then
                    CreateESP(player)
                    ESPCharacterConnections[player] = player.CharacterAdded:Connect(function()
                        if ESPEnabled then
                            task.wait(0.1)
                            CreateESP(player)
                        end
                    end)
                end
            end)
        else
            -- Clean up all ESP and connections
            ClearAllESP()
            for key, conn in pairs(ESPCharacterConnections) do
                conn:Disconnect()
                ESPCharacterConnections[key] = nil
            end
        end
    end,
}, VisualsTab)

-- // --- Fullbright ---
local OriginalBrightness = Lighting.Brightness
local OriginalAmbient = Lighting.Ambient
local OriginalOutdoorAmbient = Lighting.OutdoorAmbient

Rayfield:CreateToggle({
    Name = "Fullbright",
    Title = "Fullbright",
    CurrentValue = false,
    Flag = "Fullbright",
    Callback = function(Value)
        if Value then
            Lighting.Brightness = 2
            Lighting.Ambient = Color3.fromRGB(178, 178, 178)
            Lighting.OutdoorAmbient = Color3.fromRGB(178, 178, 178)
        else
            Lighting.Brightness = OriginalBrightness
            Lighting.Ambient = OriginalAmbient
            Lighting.OutdoorAmbient = OriginalOutdoorAmbient
        end
    end,
}, VisualsTab)

-- // --- FOV Changer ---
Rayfield:CreateSlider({
    Name = "Field of View",
    Title = "Field of View",
    Range = {70, 120},
    Increment = 1,
    Suffix = "FOV",
    CurrentValue = 70,
    Flag = "FOVChanger",
    Callback = function(Value)
        Camera.FieldOfView = Value
    end,
}, VisualsTab)

-- // ============================================================
-- //  TAB: PLAYER
-- // ============================================================
local PlayerTab = Window:CreateTab("Player", nil)

-- // --- God Mode (Anti-Damage via Humanoid) ---
local GodModeEnabled = false
local GodModeConnection = nil

Rayfield:CreateToggle({
    Name = "God Mode (Anti-Damage)",
    Title = "God Mode",
    CurrentValue = false,
    Flag = "GodMode",
    Callback = function(Value)
        GodModeEnabled = Value
        if Value then
            GodModeConnection = RunService.Heartbeat:Connect(function()
                local character = LocalPlayer.Character
                if character then
                    local humanoid = character:FindFirstChildOfClass("Humanoid")
                    if humanoid and humanoid.Health < humanoid.MaxHealth then
                        humanoid.Health = humanoid.MaxHealth
                    end
                end
            end)
        else
            if GodModeConnection then
                GodModeConnection:Disconnect()
                GodModeConnection = nil
            end
        end
    end,
}, PlayerTab)

-- // --- Anti-AFK ---
local AntiAFKConnection = nil

Rayfield:CreateToggle({
    Name = "Anti-AFK",
    Title = "Anti-AFK",
    CurrentValue = false,
    Flag = "AntiAFK",
    Callback = function(Value)
        if Value then
            AntiAFKConnection = LocalPlayer.Idled:Connect(function()
                -- Fire a virtual input to prevent AFK kick
                local VIM = game:GetService("VirtualInputManager")
                if VIM then
                    VIM:SendKeyEvent(true, Enum.KeyCode.W, false, game)
                    VIM:SendKeyEvent(false, Enum.KeyCode.W, false, game)
                end
            end)
        else
            if AntiAFKConnection then
                AntiAFKConnection:Disconnect()
                AntiAFKConnection = nil
            end
        end
    end,
}, PlayerTab)

-- // --- Teleport to Players ---
Rayfield:CreateDropdown({
    Name = "Teleport to Player",
    Title = "Teleport to Player",
    Values = (function()
        local names = {}
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LocalPlayer then
                table.insert(names, p.Name)
            end
        end
        return names
    end)(),
    Multi = false,
    Flag = "TeleportPlayer",
    Callback = function(Value)
        local targetPlayer = Players:FindFirstChild(Value)
        if targetPlayer and targetPlayer.Character then
            local targetRoot = targetPlayer.Character:FindFirstChild("HumanoidRootPart")
            local myCharacter = LocalPlayer.Character
            local myRoot = myCharacter and myCharacter:FindFirstChild("HumanoidRootPart")
            if targetRoot and myRoot then
                myRoot.CFrame = targetRoot.CFrame + Vector3.new(3, 0, 0)
            end
        end
    end,
}, PlayerTab)

-- // ============================================================
-- //  Notify user that the hub has loaded
-- // ============================================================
Rayfield:Notify({
    Title = "Phantom Hub",
    Content = "Successfully loaded! Enjoy your features.",
    Duration = 5,
    Image = nil,
})
