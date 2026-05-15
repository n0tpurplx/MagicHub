--====================================================
-- MAGIC HUB UNIVERSAL
-- by purplx
--====================================================

--====================================================
-- LOAD RAYFIELD
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
-- VARIABLES
--====================================================

_G.InfiniteJump = false

local Noclip = false
local FlyEnabled = false
local ESPEnabled = false
local TracersEnabled = false

local FlySpeed = 80

local BodyVelocity
local BodyGyro

local ESPCache = {}
local TracerCache = {}

local KEY_LINK = "https://loot-link.com/s?MAo6QeXU"

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

    KeySystem = true,

    KeySettings = {
        Title = "MagicHub Key System",
        Subtitle = "Get Your Key",
        Note = "Click 'Get Key Link' below",
        FileName = "MagicHubKey",
        SaveKey = true,
        GrabKeyFromSite = true,

        Key = {
            KEY_LINK,
            "KEY"
        }
    }
})

--====================================================
-- KEY TAB
--====================================================

local KeyTab = Window:CreateTab("Key System", 4483362458)

KeyTab:CreateButton({
    Name = "Copy Key Link",

    Callback = function()

        if setclipboard then
            setclipboard(KEY_LINK)
        end

        Rayfield:Notify({
            Title = "Copied",
            Content = "Key link copied to clipboard",
            Duration = 4,
            Image = 4483362458,
        })
    end,
})

KeyTab:CreateButton({
    Name = "Print Key Link",

    Callback = function()

        print(KEY_LINK)

        Rayfield:Notify({
            Title = "Printed",
            Content = "Key link printed in console",
            Duration = 4,
            Image = 4483362458,
        })
    end,
})

--====================================================
-- MOVEMENT TAB
--====================================================

local MovementTab = Window:CreateTab("Movement", 4483362458)

MovementTab:CreateSlider({
    Name = "WalkSpeed",
    Range = {16, 300},
    Increment = 1,
    CurrentValue = 16,

    Callback = function(Value)

        local Character = LocalPlayer.Character

        if Character and Character:FindFirstChild("Humanoid") then
            Character.Humanoid.WalkSpeed = Value
        end
    end,
})

MovementTab:CreateSlider({
    Name = "JumpPower",
    Range = {50, 300},
    Increment = 1,
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
            BodyVelocity.Parent = HRP

            BodyGyro = Instance.new("BodyGyro")
            BodyGyro.MaxTorque = Vector3.new(999999,999999,999999)
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
-- RENDER TAB
--====================================================

local RenderTab = Window:CreateTab("Render", 4483362458)

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

RenderTab:CreateSlider({
    Name = "FOV",
    Range = {70, 120},
    Increment = 1,
    CurrentValue = 70,

    Callback = function(Value)
        Camera.FieldOfView = Value
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

--====================================================
-- TELEPORT TAB
--====================================================

local TeleportTab = Window:CreateTab("Teleport", 4483362458)

TeleportTab:CreateInput({
    Name = "Teleport To Player",
    PlaceholderText = "Username",

    Callback = function(Text)

        local Target = Players:FindFirstChild(Text)

        if Target and Target.Character and Target.Character:FindFirstChild("HumanoidRootPart") then

            LocalPlayer.Character.HumanoidRootPart.CFrame =
                Target.Character.HumanoidRootPart.CFrame
        end
    end,
})

--====================================================
-- WORLD TAB
--====================================================

local WorldTab = Window:CreateTab("World", 4483362458)

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

        Rayfield:Notify({
            Title = "Anti Lag",
            Content = "World optimized",
            Duration = 3,
            Image = 4483362458,
        })
    end,
})

--====================================================
-- MISC TAB
--====================================================

local MiscTab = Window:CreateTab("Misc", 4483362458)

MiscTab:CreateButton({
    Name = "Rejoin Server",

    Callback = function()
        TeleportService:Teleport(game.PlaceId, LocalPlayer)
    end,
})

MiscTab:CreateButton({
    Name = "Copy JobId",

    Callback = function()

        if setclipboard then
            setclipboard(game.JobId)
        end

        Rayfield:Notify({
            Title = "Copied",
            Content = "JobId copied",
            Duration = 3,
            Image = 4483362458,
        })
    end,
})

--====================================================
-- PLAYER JOIN
--====================================================

Players.PlayerAdded:Connect(function(Player)

    if ESPEnabled then
        CreateESP(Player)
    end
end)

--====================================================
-- LOADED
--====================================================

Rayfield:Notify({
    Title = "MagicHub Loaded!",
    Content = "Universal Loaded Successfully",
    Duration = 5,
    Image = 4483362458,
})
