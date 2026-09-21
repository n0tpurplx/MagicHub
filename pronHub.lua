local REQUIRED_KEY = "freepron-universal"
local KEY_URL = "https://discord.gg/HJj6hhQfdZ"

local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer

local function GetExecutor()
    if identifyexecutor then
        local success, name = pcall(identifyexecutor)
        if success and name then
            return tostring(name)
        end
    end

    if getexecutorname then
        local success, name = pcall(getexecutorname)
        if success and name then
            return tostring(name)
        end
    end

    return "Unknown"
end

local ExecutorName = GetExecutor()

local KeyGui = Instance.new("ScreenGui")
KeyGui.Name = "pronHub_KeySystem"
KeyGui.ResetOnSpawn = false
KeyGui.IgnoreGuiInset = true
KeyGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

pcall(function()
    KeyGui.Parent = CoreGui
end)

if not KeyGui.Parent then
    KeyGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
end

local KeyFrame = Instance.new("Frame")
KeyFrame.Name = "KeyWindow"
KeyFrame.Size = UDim2.fromOffset(420, 290)
KeyFrame.Position = UDim2.fromScale(0.5, 0.5)
KeyFrame.AnchorPoint = Vector2.new(0.5, 0.5)
KeyFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
KeyFrame.BorderSizePixel = 0
KeyFrame.Parent = KeyGui

local KeyCorner = Instance.new("UICorner")
KeyCorner.CornerRadius = UDim.new(0, 10)
KeyCorner.Parent = KeyFrame

local KeyStroke = Instance.new("UIStroke")
KeyStroke.Color = Color3.fromRGB(70, 70, 80)
KeyStroke.Thickness = 1
KeyStroke.Parent = KeyFrame

local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Size = UDim2.new(1, -40, 0, 35)
Title.Position = UDim2.fromOffset(20, 18)
Title.BackgroundTransparency = 1
Title.Text = "pronHub"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 24
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = KeyFrame

local Subtitle = Instance.new("TextLabel")
Subtitle.Name = "Subtitle"
Subtitle.Size = UDim2.new(1, -40, 0, 25)
Subtitle.Position = UDim2.fromOffset(20, 55)
Subtitle.BackgroundTransparency = 1
Subtitle.Text = "Enter your key to continue"
Subtitle.TextColor3 = Color3.fromRGB(160, 160, 170)
Subtitle.TextSize = 14
Subtitle.Font = Enum.Font.Gotham
Subtitle.TextXAlignment = Enum.TextXAlignment.Left
Subtitle.Parent = KeyFrame

local KeyBox = Instance.new("TextBox")
KeyBox.Name = "KeyInput"
KeyBox.Size = UDim2.new(1, -40, 0, 45)
KeyBox.Position = UDim2.fromOffset(20, 95)
KeyBox.BackgroundColor3 = Color3.fromRGB(27, 27, 32)
KeyBox.BorderSizePixel = 0
KeyBox.ClearTextOnFocus = false
KeyBox.PlaceholderText = "Enter key..."
KeyBox.PlaceholderColor3 = Color3.fromRGB(100, 100, 110)
KeyBox.Text = ""
KeyBox.TextColor3 = Color3.fromRGB(255, 255, 255)
KeyBox.TextSize = 14
KeyBox.Font = Enum.Font.Gotham
KeyBox.TextXAlignment = Enum.TextXAlignment.Left
KeyBox.Parent = KeyFrame

local InputPadding = Instance.new("UIPadding")
InputPadding.PaddingLeft = UDim.new(0, 14)
InputPadding.PaddingRight = UDim.new(0, 14)
InputPadding.Parent = KeyBox

local InputCorner = Instance.new("UICorner")
InputCorner.CornerRadius = UDim.new(0, 7)
InputCorner.Parent = KeyBox

local InputStroke = Instance.new("UIStroke")
InputStroke.Color = Color3.fromRGB(55, 55, 65)
InputStroke.Thickness = 1
InputStroke.Parent = KeyBox

local UnlockButton = Instance.new("TextButton")
UnlockButton.Name = "Unlock"
UnlockButton.Size = UDim2.new(1, -40, 0, 42)
UnlockButton.Position = UDim2.fromOffset(20, 150)
UnlockButton.BackgroundColor3 = Color3.fromRGB(110, 65, 180)
UnlockButton.BorderSizePixel = 0
UnlockButton.Text = "Unlock"
UnlockButton.TextColor3 = Color3.fromRGB(255, 255, 255)
UnlockButton.TextSize = 14
UnlockButton.Font = Enum.Font.GothamBold
UnlockButton.AutoButtonColor = true
UnlockButton.Parent = KeyFrame

local ButtonCorner = Instance.new("UICorner")
ButtonCorner.CornerRadius = UDim.new(0, 7)
ButtonCorner.Parent = UnlockButton

local GetKeyButton = Instance.new("TextButton")
GetKeyButton.Name = "GetKey"
GetKeyButton.Size = UDim2.new(1, -40, 0, 42)
GetKeyButton.Position = UDim2.fromOffset(20, 200)
GetKeyButton.BackgroundColor3 = Color3.fromRGB(35, 35, 42)
GetKeyButton.BorderSizePixel = 0
GetKeyButton.Text = "Get Key"
GetKeyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
GetKeyButton.TextSize = 14
GetKeyButton.Font = Enum.Font.GothamBold
GetKeyButton.AutoButtonColor = true
GetKeyButton.Parent = KeyFrame

local GetKeyCorner = Instance.new("UICorner")
GetKeyCorner.CornerRadius = UDim.new(0, 7)
GetKeyCorner.Parent = GetKeyButton

local Status = Instance.new("TextLabel")
Status.Name = "Status"
Status.Size = UDim2.new(1, -40, 0, 25)
Status.Position = UDim2.fromOffset(20, 250)
Status.BackgroundTransparency = 1
Status.Text = "Made by purplx"
Status.TextColor3 = Color3.fromRGB(120, 120, 130)
Status.TextSize = 12
Status.Font = Enum.Font.Gotham
Status.TextXAlignment = Enum.TextXAlignment.Left
Status.Parent = KeyFrame

local dragging = false
local dragStart
local startPosition

Title.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then

        dragging = true
        dragStart = input.Position
        startPosition = KeyFrame.Position

        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if not dragging then
        return
    end

    if input.UserInputType ~= Enum.UserInputType.MouseMovement
        and input.UserInputType ~= Enum.UserInputType.Touch then
        return
    end

    local delta = input.Position - dragStart

    KeyFrame.Position = UDim2.new(
        startPosition.X.Scale,
        startPosition.X.Offset + delta.X,
        startPosition.Y.Scale,
        startPosition.Y.Offset + delta.Y
    )
end)

GetKeyButton.MouseButton1Click:Connect(function()
    if setclipboard then
        local success = pcall(setclipboard, KEY_URL)

        if success then
            Status.Text = "Key link copied!"
            Status.TextColor3 = Color3.fromRGB(100, 220, 120)
        else
            Status.Text = "Clipboard unavailable."
            Status.TextColor3 = Color3.fromRGB(255, 90, 90)
        end
    else
        Status.Text = "Clipboard unavailable."
        Status.TextColor3 = Color3.fromRGB(255, 90, 90)
    end

    task.delay(2, function()
        if Status and Status.Parent then
            Status.Text = "Made by purplx"
            Status.TextColor3 = Color3.fromRGB(120, 120, 130)
        end
    end)
end)

local function LoadObsidian()
    local success, result = pcall(function()
        return loadstring(game:HttpGet(
            "https://raw.githubusercontent.com/deividcomsono/Obsidian/main/Library.lua"
        ))()
    end)

    if not success then
        warn("pronHub: Failed to load Obsidian:", result)
        return nil
    end

    return result
end

local Unlocked = false

local function Unlock()
    if Unlocked then
        return
    end

    local enteredKey = tostring(KeyBox.Text)

    if enteredKey ~= REQUIRED_KEY then
        Status.Text = "Invalid key."
        Status.TextColor3 = Color3.fromRGB(255, 90, 90)

        task.delay(1, function()
            if Status and Status.Parent then
                Status.Text = "Made by purplx"
                Status.TextColor3 = Color3.fromRGB(120, 120, 130)
            end
        end)

        return
    end

    Unlocked = true

    Status.Text = "Unlocked!"
    Status.TextColor3 = Color3.fromRGB(100, 220, 120)

    task.wait(0.2)

    KeyGui:Destroy()

    local Library = LoadObsidian()

    if not Library then
        return
    end

    local ThemeManager = loadstring(game:HttpGet(
        "https://raw.githubusercontent.com/deividcomsono/Obsidian/main/addons/ThemeManager.lua"
    ))()

    local SaveManager = loadstring(game:HttpGet(
        "https://raw.githubusercontent.com/deividcomsono/Obsidian/main/addons/SaveManager.lua"
    ))()

    local Window = Library:CreateWindow({
        Title = "pronHub",
        Footer = "Made by purplxExploits",
        Icon = 95816097006870,
        NotifySide = "Right",
        ShowCustomCursor = true,
        Size = UDim2.fromOffset(650, 500),
    })

    local Tabs = {
        Home = Window:AddTab("Home", "home"),
        Visuals = Window:AddTab("Visuals", "eye"),
        Settings = Window:AddTab("Settings", "settings"),
    }

    local HomeGroup = Tabs.Home:AddLeftGroupbox("pronHub")

    HomeGroup:AddLabel("pronHub")
    HomeGroup:AddLabel("Made by purplx")
    HomeGroup:AddDivider()

    HomeGroup:AddLabel("Debug visualization hub")
    HomeGroup:AddLabel("Executor: " .. ExecutorName)
    HomeGroup:AddLabel("Game: " .. game.Name)
    HomeGroup:AddLabel("Place ID: " .. tostring(game.PlaceId))
    HomeGroup:AddLabel("Player: " .. LocalPlayer.Name)

    local ESP = {
        Chams = false,
        Name = false,
        Distance = false,
        Health = false,
        Skeleton = false,
    }

    local ESPObjects = {}
    local ESPConnections = {}

    local ESPGui = Instance.new("ScreenGui")
    ESPGui.Name = "pronHub_ESP"
    ESPGui.ResetOnSpawn = false
    ESPGui.IgnoreGuiInset = true
    ESPGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    pcall(function()
        ESPGui.Parent = CoreGui
    end)

    if not ESPGui.Parent then
        ESPGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
    end

    local function GetRoot(character)
        return character:FindFirstChild("HumanoidRootPart")
            or character:FindFirstChild("UpperTorso")
            or character:FindFirstChild("Torso")
    end

    local function CreateLine()
        local line = Instance.new("Frame")
        line.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        line.BorderSizePixel = 0
        line.AnchorPoint = Vector2.new(0.5, 0.5)
        line.Visible = false
        line.Parent = ESPGui
        return line
    end

    local function SetLine(line, from, to, visible)
        local delta = to - from
        local length = delta.Magnitude

        line.Position = UDim2.fromOffset(
            (from.X + to.X) / 2,
            (from.Y + to.Y) / 2
        )

        line.Size = UDim2.fromOffset(1.5, length)
        line.Rotation = math.deg(math.atan2(delta.Y, delta.X)) + 90
        line.Visible = visible
    end

    local R6Connections = {
        {"Head", "Torso"},
        {"Torso", "Left Arm"},
        {"Torso", "Right Arm"},
        {"Torso", "Left Leg"},
        {"Torso", "Right Leg"},
    }

    local R15Connections = {
        {"Head", "UpperTorso"},
        {"UpperTorso", "LeftUpperArm"},
        {"LeftUpperArm", "LeftLowerArm"},
        {"LeftLowerArm", "LeftHand"},
        {"UpperTorso", "RightUpperArm"},
        {"RightUpperArm", "RightLowerArm"},
        {"RightLowerArm", "RightHand"},
        {"UpperTorso", "LowerTorso"},
        {"LowerTorso", "LeftUpperLeg"},
        {"LeftUpperLeg", "LeftLowerLeg"},
        {"LeftLowerLeg", "LeftFoot"},
        {"LowerTorso", "RightUpperLeg"},
        {"RightUpperLeg", "RightLowerLeg"},
        {"RightLowerLeg", "RightFoot"},
    }

    local function CreateESP(player)
        if player == LocalPlayer or ESPObjects[player] then
            return
        end

        local data = {
            Highlight = nil,
            Billboard = nil,
            NameLabel = nil,
            DistanceLabel = nil,
            HealthBar = nil,
            HealthFill = nil,
            Lines = {},
            Connections = {},
        }

        ESPObjects[player] = data

        local function SetupCharacter(character)
            if data.Highlight then
                data.Highlight:Destroy()
            end

            if data.Billboard then
                data.Billboard:Destroy()
            end

            for _, lineData in ipairs(data.Lines) do
                if lineData.Object then
                    lineData.Object:Destroy()
                end
            end

            data.Lines = {}

            local highlight = Instance.new("Highlight")
            highlight.Name = "pronHub_Chams"
            highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
            highlight.FillColor = Color3.fromRGB(150, 80, 255)
            highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
            highlight.FillTransparency = 0.5
            highlight.OutlineTransparency = 0
            highlight.Enabled = ESP.Chams
            highlight.Adornee = character
            highlight.Parent = character

            data.Highlight = highlight

            local root = GetRoot(character)

            if root then
                local billboard = Instance.new("BillboardGui")
                billboard.Name = "pronHub_ESP"
                billboard.Size = UDim2.fromOffset(180, 70)
                billboard.StudsOffset = Vector3.new(0, 3, 0)
                billboard.AlwaysOnTop = true
                billboard.Adornee = root
                billboard.Enabled = ESP.Name or ESP.Distance or ESP.Health
                billboard.Parent = root

                data.Billboard = billboard

                local nameLabel = Instance.new("TextLabel")
                nameLabel.BackgroundTransparency = 1
                nameLabel.Size = UDim2.new(1, 0, 0, 20)
                nameLabel.Text = player.Name
                nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
                nameLabel.TextStrokeTransparency = 0
                nameLabel.TextSize = 13
                nameLabel.Font = Enum.Font.GothamBold
                nameLabel.Visible = ESP.Name
                nameLabel.Parent = billboard

                data.NameLabel = nameLabel

                local distanceLabel = Instance.new("TextLabel")
                distanceLabel.BackgroundTransparency = 1
                distanceLabel.Size = UDim2.new(1, 0, 0, 18)
                distanceLabel.Position = UDim2.fromOffset(0, 20)
                distanceLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
                distanceLabel.TextStrokeTransparency = 0
                distanceLabel.TextSize = 11
                distanceLabel.Font = Enum.Font.Gotham
                distanceLabel.Visible = ESP.Distance
                distanceLabel.Parent = billboard

                data.DistanceLabel = distanceLabel

                local healthBar = Instance.new("Frame")
                healthBar.Size = UDim2.fromOffset(5, 35)
                healthBar.Position = UDim2.fromOffset(-10, 2)
                healthBar.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
                healthBar.BorderSizePixel = 0
                healthBar.Visible = ESP.Health
                healthBar.Parent = billboard

                local healthCorner = Instance.new("UICorner")
                healthCorner.CornerRadius = UDim.new(0, 3)
                healthCorner.Parent = healthBar

                data.HealthBar = healthBar

                local healthFill = Instance.new("Frame")
                healthFill.AnchorPoint = Vector2.new(0, 1)
                healthFill.Position = UDim2.fromScale(0, 1)
                healthFill.Size = UDim2.fromScale(1, 1)
                healthFill.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
                healthFill.BorderSizePixel = 0
                healthFill.Parent = healthBar

                local fillCorner = Instance.new("UICorner")
                fillCorner.CornerRadius = UDim.new(0, 3)
                fillCorner.Parent = healthFill

                data.HealthFill = healthFill
            end

            local humanoid = character:FindFirstChildOfClass("Humanoid")

            if humanoid then
                local connections =
                    humanoid.RigType == Enum.HumanoidRigType.R6
                    and R6Connections
                    or R15Connections

                for _, pair in ipairs(connections) do
                    table.insert(data.Lines, {
                        Object = CreateLine(),
                        From = pair[1],
                        To = pair[2],
                    })
                end
            end
        end

        if player.Character then
            SetupCharacter(player.Character)
        end

        table.insert(
            data.Connections,
            player.CharacterAdded:Connect(function(character)
                task.wait(0.5)

                if ESPObjects[player] then
                    SetupCharacter(character)
                end
            end)
        )
    end

    local function RemoveESP(player)
        local data = ESPObjects[player]

        if not data then
            return
        end

        for _, connection in ipairs(data.Connections) do
            pcall(function()
                connection:Disconnect()
            end)
        end

        if data.Highlight then
            data.Highlight:Destroy()
        end

        if data.Billboard then
            data.Billboard:Destroy()
        end

        for _, lineData in ipairs(data.Lines) do
            if lineData.Object then
                lineData.Object:Destroy()
            end
        end

        ESPObjects[player] = nil
    end

    table.insert(
        ESPConnections,
        RunService.RenderStepped:Connect(function()
            for player, data in pairs(ESPObjects) do
                local character = player.Character

                if not character then
                    continue
                end

                local humanoid = character:FindFirstChildOfClass("Humanoid")
                local root = GetRoot(character)

                if not humanoid or not root then
                    continue
                end

                if data.Highlight then
                    data.Highlight.Enabled = ESP.Chams
                end

                if data.Billboard then
                    data.Billboard.Enabled =
                        ESP.Name
                        or ESP.Distance
                        or ESP.Health
                end

                if data.NameLabel then
                    data.NameLabel.Visible = ESP.Name
                end

                if data.DistanceLabel then
                    data.DistanceLabel.Visible = ESP.Distance

                    if ESP.Distance then
                        local localCharacter = LocalPlayer.Character
                        local localRoot =
                            localCharacter and GetRoot(localCharacter)

                        if localRoot then
                            local distance =
                                (localRoot.Position - root.Position).Magnitude

                            data.DistanceLabel.Text =
                                string.format("%d studs", distance)
                        end
                    end
                end

                if data.HealthBar and data.HealthFill then
                    data.HealthBar.Visible = ESP.Health

                    if ESP.Health then
                        local health =
                            math.clamp(
                                humanoid.Health / humanoid.MaxHealth,
                                0,
                                1
                            )

                        data.HealthFill.Size =
                            UDim2.fromScale(1, health)

                        data.HealthFill.BackgroundColor3 =
                            Color3.fromRGB(
                                math.floor(255 * (1 - health)),
                                math.floor(255 * health),
                                0
                            )
                    end
                end

                local camera = workspace.CurrentCamera

                for _, lineData in ipairs(data.Lines) do
                    local line = lineData.Object

                    local fromPart =
                        character:FindFirstChild(lineData.From)

                    local toPart =
                        character:FindFirstChild(lineData.To)

                    if ESP.Skeleton
                        and fromPart
                        and toPart
                        and camera then

                        local fromPosition, fromVisible =
                            camera:WorldToViewportPoint(
                                fromPart.Position
                            )

                        local toPosition, toVisible =
                            camera:WorldToViewportPoint(
                                toPart.Position
                            )

                        if fromVisible or toVisible then
                            SetLine(
                                line,
                                Vector2.new(
                                    fromPosition.X,
                                    fromPosition.Y
                                ),
                                Vector2.new(
                                    toPosition.X,
                                    toPosition.Y
                                ),
                                true
                            )
                        else
                            line.Visible = false
                        end
                    else
                        line.Visible = false
                    end
                end
            end
        end)
    )

    for _, player in ipairs(Players:GetPlayers()) do
        CreateESP(player)
    end

    table.insert(
        ESPConnections,
        Players.PlayerAdded:Connect(function(player)
            CreateESP(player)
        end)
    )

    table.insert(
        ESPConnections,
        Players.PlayerRemoving:Connect(function(player)
            RemoveESP(player)
        end)
    )

    local VisualGroup = Tabs.Visuals:AddLeftGroupbox("ESP")

    VisualGroup:AddToggle("Chams", {
        Text = "Chams",
        Default = false,
        Callback = function(value)
            ESP.Chams = value
        end,
    })

    VisualGroup:AddToggle("NameESP", {
        Text = "Name ESP",
        Default = false,
        Callback = function(value)
            ESP.Name = value
        end,
    })

    VisualGroup:AddToggle("DistanceESP", {
        Text = "Distance ESP",
        Default = false,
        Callback = function(value)
            ESP.Distance = value
        end,
    })

    VisualGroup:AddToggle("HealthESP", {
        Text = "Health ESP",
        Default = false,
        Callback = function(value)
            ESP.Health = value
        end,
    })

    VisualGroup:AddToggle("SkeletonESP", {
        Text = "Skeleton ESP",
        Default = false,
        Callback = function(value)
            ESP.Skeleton = value
        end,
    })

    local SettingsGroup = Tabs.Settings:AddLeftGroupbox("Settings")

    SettingsGroup:AddButton({
        Text = "Unload pronHub",
        Func = function()
            Library:Unload()
        end,
    })

    SaveManager:SetLibrary(Library)
    SaveManager:IgnoreThemeSettings()
    SaveManager:SetIgnoreIndexes({
        "MenuKeybind",
    })

    SaveManager:SetFolder("pronHub")
    SaveManager:SetSubFolder(tostring(game.PlaceId))

    SaveManager:BuildConfigSection(Tabs.Settings)
    SaveManager:LoadAutoloadConfig()

    ThemeManager:SetLibrary(Library)
    ThemeManager:SetFolder("pronHub")
    ThemeManager:ApplyToTab(Tabs.Settings)

    Library:OnUnload(function()
        for _, connection in ipairs(ESPConnections) do
            pcall(function()
                connection:Disconnect()
            end)
        end

        for player in pairs(ESPObjects) do
            RemoveESP(player)
        end

        if ESPGui then
            ESPGui:Destroy()
        end
    end)

    Library:Notify({
        Title = "pronHub",
        Description = "Successfully unlocked.",
        Time = 3,
    })
end

UnlockButton.MouseButton1Click:Connect(Unlock)

KeyBox.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        Unlock()
    end
end)
