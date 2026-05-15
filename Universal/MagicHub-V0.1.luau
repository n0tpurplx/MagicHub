--====================================================
-- MAGIC HUB UNIVERSAL
-- by purplx
--====================================================

--====================================================
-- LOAD UI
--====================================================

local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()

--====================================================
-- SERVICES
--====================================================

local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TeleportService = game:GetService("TeleportService")

local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

--====================================================
-- WINDOW
--====================================================

local Window = Rayfield:CreateWindow({
    Name = "MagicHub Universal",
    LoadingTitle = "Loading MagicHub...",
    LoadingSubtitle = "by purplx",

    ConfigurationSaving = {
        Enabled = true,
        FolderName = "MagicHub",
        FileName = "Universal"
    },

    KeySystem = false,
})

--====================================================
-- VARIABLES
--====================================================

_G.InfiniteJump = false
local Noclip = false
local ESPEnabled = false
local TracersEnabled = false
local FlyEnabled = false

local FlySpeed = 80
local BodyVelocity
local BodyGyro

local ESPCache = {}
local TracerCache = {}

--====================================================
-- MOVEMENT TAB
--====================================================

local MovementTab = Window:CreateTab("Movement", 4483362458)

MovementTab:CreateLabel("Movement Features")

-- WalkSpeed
MovementTab:CreateSlider({
    Name = "WalkSpeed",
    Range = {16, 300},
    Increment = 1,
    Suffix = " Speed",
    CurrentValue = 16,

    Callback = function(Value)
        local Character = LocalPlayer.Character
        if Character and Character:FindFirstChild("Humanoid") then
            Character.Humanoid.WalkSpeed = Value
        end
    end,
})

-- Jump Power
MovementTab:CreateSlider({
    Name = "JumpPower",
    Range = {50, 300},
    Increment = 1,
    Suffix = " Jump",
    CurrentValue = 50,

    Callback = function(Value)
        local Character = LocalPlayer.Character
        if Character and Character:FindFirstChild("Humanoid") then
            Character.Humanoid.JumpPower = Value
        end
    end,
})

-- Infinite Jump
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

    Callback = function(Value)
        _G.InfiniteJump = Value
    end,
})

-- Noclip
RunService.Stepped:Connect(function()
    if Noclip and LocalPlayer.Character then
        for _, v in pairs(LocalPlayer.Character:GetDescendants()) do
            if v:IsA("BasePart") then
                v.CanCollide = false
            end
        end
    end
end)

MovementTab:CreateToggle({
    Name = "Noclip",
    CurrentValue = false,

    Callback = function(Value)
        Noclip = Value
    end,
})

-- Fly
MovementTab:CreateToggle({
    Name = "Fly",
    CurrentValue = false,

    Callback = function(Value)

        FlyEnabled = Value

        local Character = LocalPlayer.Character
        if not Character then return end

        local HRP = Character:FindFirstChild("HumanoidRootPart")
        if not HRP then return end

        if Value then

            BodyVelocity = Instance.new("BodyVelocity")
            BodyVelocity.MaxForce = Vector3.new(999999,999999,999999)
            BodyVelocity.Velocity = Vector3.new(0,0,0)
            BodyVelocity.Parent = HRP

            BodyGyro = Instance.new("BodyGyro")
            BodyGyro.MaxTorque = Vector3.new(999999,999999,999999)
            BodyGyro.CFrame = HRP.CFrame
            BodyGyro.Parent = HRP

        else

            if BodyVelocity then
                BodyVelocity:Destroy()
            end

            if BodyGyro then
                BodyGyro:Destroy()
            end
        end
    end,
})

-- Fly Speed
MovementTab:CreateSlider({
    Name = "Fly Speed",
    Range = {20, 200},
    Increment = 5,
    CurrentValue = 80,

    Callback = function(Value)
        FlySpeed = Value
    end,
})

RunService.RenderStepped:Connect(function()

    if FlyEnabled then

        local Character = LocalPlayer.Character
        if not Character then return end

        local HRP = Character:FindFirstChild("HumanoidRootPart")
        if not HRP then return end

        local MoveDirection = Vector3.zero

        if UserInputService:IsKeyDown(Enum.KeyCode.W) then
            MoveDirection += Camera.CFrame.LookVector
        end

        if UserInputService:IsKeyDown(Enum.KeyCode.S) then
            MoveDirection -= Camera.CFrame.LookVector
        end

        if UserInputService:IsKeyDown(Enum.KeyCode.A) then
            MoveDirection -= Camera.CFrame.RightVector
        end

        if UserInputService:IsKeyDown(Enum.KeyCode.D) then
            MoveDirection += Camera.CFrame.RightVector
        end

        if BodyVelocity then
            BodyVelocity.Velocity = MoveDirection * FlySpeed
        end

        if BodyGyro then
            BodyGyro.CFrame = Camera.CFrame
        end
    end
end)

--====================================================
-- PLAYER TAB
--====================================================

local PlayerTab = Window:CreateTab("Player", 4483362458)

-- Gravity
PlayerTab:CreateSlider({
    Name = "Gravity",
    Range = {0, 196},
    Increment = 1,
    CurrentValue = workspace.Gravity,

    Callback = function(Value)
        workspace.Gravity = Value
    end,
})

-- Reset Character
PlayerTab:CreateButton({
    Name = "Reset Character",

    Callback = function()
        LocalPlayer.Character:BreakJoints()
    end,
})

-- Anti AFK
PlayerTab:CreateButton({
    Name = "Anti AFK",

    Callback = function()

        local VirtualUser = game:GetService("VirtualUser")

        LocalPlayer.Idled:Connect(function()
            VirtualUser:CaptureController()
            VirtualUser:ClickButton2(Vector2.new())
        end)

        Rayfield:Notify({
            Title = "Anti AFK",
            Content = "Anti AFK Enabled",
            Duration = 3,
            Image = 4483362458,
        })
    end,
})

--====================================================
-- RENDER TAB
--====================================================

local RenderTab = Window:CreateTab("Render", 4483362458)

-- FullBright
RenderTab:CreateToggle({
    Name = "FullBright",
    CurrentValue = false,

    Callback = function(Value)

        if Value then
            Lighting.Brightness = 5
            Lighting.ClockTime = 12
            Lighting.FogEnd = 100000
            Lighting.GlobalShadows = false
        else
            Lighting.Brightness = 1
            Lighting.GlobalShadows = true
        end
    end,
})

-- FOV
RenderTab:CreateSlider({
    Name = "Field Of View",
    Range = {70, 120},
    Increment = 1,
    CurrentValue = 70,

    Callback = function(Value)
        Camera.FieldOfView = Value
    end,
})

-- Remove Fog
RenderTab:CreateButton({
    Name = "Remove Fog",

    Callback = function()
        Lighting.FogEnd = 100000
    end,
})

-- ESP
local function CreateESP(Player)

    if Player == LocalPlayer then return end

    local function CharacterAdded(Character)

        local Highlight = Instance.new("Highlight")
        Highlight.FillColor = Color3.fromRGB(255,0,0)
        Highlight.OutlineColor = Color3.fromRGB(255,255,255)
        Highlight.FillTransparency = 0.5
        Highlight.Parent = Character

        ESPCache[Player] = Highlight
    end

    if Player.Character then
        CharacterAdded(Player.Character)
    end

    Player.CharacterAdded:Connect(CharacterAdded)
end

RenderTab:CreateToggle({
    Name = "Player ESP",
    CurrentValue = false,

    Callback = function(Value)

        ESPEnabled = Value

        if Value then

            for _, Player in pairs(Players:GetPlayers()) do
                CreateESP(Player)
            end

        else

            for _, ESP in pairs(ESPCache) do
                if ESP then
                    ESP:Destroy()
                end
            end
        end
    end,
})

-- Tracers
RenderTab:CreateToggle({
    Name = "Tracers",
    CurrentValue = false,

    Callback = function(Value)
        TracersEnabled = Value
    end,
})

RunService.RenderStepped:Connect(function()

    if not TracersEnabled then

        for _, line in pairs(TracerCache) do
            line.Visible = false
        end

        return
    end

    for _, Player in pairs(Players:GetPlayers()) do

        if Player ~= LocalPlayer and Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then

            local HRP = Player.Character.HumanoidRootPart

            local Position, OnScreen = Camera:WorldToViewportPoint(HRP.Position)

            if not TracerCache[Player] then

                local Line = Drawing.new("Line")
                Line.Thickness = 2
                Line.Transparency = 1

                TracerCache[Player] = Line
            end

            local Line = TracerCache[Player]

            if OnScreen then

                Line.Visible = true
                Line.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
                Line.To = Vector2.new(Position.X, Position.Y)

            else
                Line.Visible = false
            end
        end
    end
end)

--====================================================
-- TELEPORT TAB
--====================================================

local TeleportTab = Window:CreateTab("Teleport", 4483362458)

TeleportTab:CreateButton({
    Name = "Teleport To Spawn",

    Callback = function()

        local Character = LocalPlayer.Character

        if Character and Character:FindFirstChild("HumanoidRootPart") then
            Character.HumanoidRootPart.CFrame = CFrame.new(0,10,0)
        end
    end,
})

TeleportTab:CreateInput({
    Name = "Teleport To Player",
    PlaceholderText = "Enter Username",

    Callback = function(Text)

        local Target = Players:FindFirstChild(Text)

        if Target and Target.Character and Target.Character:FindFirstChild("HumanoidRootPart") then

            LocalPlayer.Character.HumanoidRootPart.CFrame =
                Target.Character.HumanoidRootPart.CFrame
        end
    end,
})

--====================================================
-- COMBAT TAB
--====================================================

local CombatTab = Window:CreateTab("Combat", 4483362458)

CombatTab:CreateToggle({
    Name = "Hitbox Expander",
    CurrentValue = false,

    Callback = function(Value)

        for _, Player in pairs(Players:GetPlayers()) do

            if Player ~= LocalPlayer and Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then

                local HRP = Player.Character.HumanoidRootPart

                if Value then

                    HRP.Size = Vector3.new(10,10,10)
                    HRP.Transparency = 0.5
                    HRP.Material = Enum.Material.Neon
                    HRP.CanCollide = false

                else

                    HRP.Size = Vector3.new(2,2,1)
                    HRP.Transparency = 1
                end
            end
        end
    end,
})

--====================================================
-- WORLD TAB
--====================================================

local WorldTab = Window:CreateTab("World", 4483362458)

-- Anti Lag
WorldTab:CreateButton({
    Name = "Anti Lag",

    Callback = function()

        for _, v in pairs(workspace:GetDescendants()) do

            if v:IsA("Texture") or v:IsA("Decal") then
                v:Destroy()
            end

            if v:IsA("ParticleEmitter") then
                v.Enabled = false
            end
        end
    end,
})

-- Destroy Kill Bricks
WorldTab:CreateButton({
    Name = "Destroy Kill Bricks",

    Callback = function()

        for _, v in pairs(workspace:GetDescendants()) do

            if v:IsA("BasePart") and string.find(v.Name:lower(), "kill") then
                v:Destroy()
            end
        end
    end,
})

--====================================================
-- MISC TAB
--====================================================

local MiscTab = Window:CreateTab("Misc", 4483362458)

-- Rejoin
MiscTab:CreateButton({
    Name = "Rejoin Server",

    Callback = function()
        TeleportService:Teleport(game.PlaceId, LocalPlayer)
    end,
})

-- Copy JobId
MiscTab:CreateButton({
    Name = "Copy JobId",

    Callback = function()

        if setclipboard then
            setclipboard(game.JobId)
        end

        Rayfield:Notify({
            Title = "Copied",
            Content = "Server JobId copied",
            Duration = 3,
            Image = 4483362458,
        })
    end,
})

-- FPS Unlock Notice
MiscTab:CreateButton({
    Name = "FPS Unlocker Info",

    Callback = function()

        Rayfield:Notify({
            Title = "FPS Unlocker",
            Content = "Use an external FPS Unlocker.",
            Duration = 5,
            Image = 4483362458,
        })
    end,
})

--====================================================
-- PLAYER ADDED
--====================================================

Players.PlayerAdded:Connect(function(Player)

    if ESPEnabled then
        CreateESP(Player)
    end
end)

--====================================================
-- LOADED NOTIFICATION
--====================================================

Rayfield:Notify({
    Title = "MagicHub Loaded!",
    Content = "Universal Script Loaded Successfully",
    Duration = 5,
    Image = 4483362458,
})
