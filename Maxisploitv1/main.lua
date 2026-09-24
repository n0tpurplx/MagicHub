local Config = {
    Key = "key",
    Title = "maxisploit",
    Subtitle = "Welcome to maxisploit",
    UnlockText = "Unlock",
    GetKeyText = "Get Key",
    Footer = "purplxdevs",
    KeyURL = "coming soon!",
    ObsidianURL = "https://raw.githubusercontent.com/deividcomsono/Obsidian/main/Library.lua"
}

local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Player = Players.LocalPlayer

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "maxisploit_KeySystem"
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

pcall(function()
    if syn and syn.protect_gui then
        syn.protect_gui(ScreenGui)
    elseif protectgui then
        protectgui(ScreenGui)
    end

    ScreenGui.Parent = CoreGui
end)

if not ScreenGui.Parent then
    ScreenGui.Parent = Player:WaitForChild("PlayerGui")
end

local Main = Instance.new("Frame")
Main.Name = "Main"
Main.Size = UDim2.fromOffset(420, 290)
Main.Position = UDim2.fromScale(0.5, 0.5)
Main.AnchorPoint = Vector2.new(0.5, 0.5)
Main.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
Main.BorderSizePixel = 0
Main.Parent = ScreenGui

local Corner = Instance.new("UICorner")
Corner.CornerRadius = UDim.new(0, 10)
Corner.Parent = Main

local Stroke = Instance.new("UIStroke")
Stroke.Color = Color3.fromRGB(70, 70, 80)
Stroke.Thickness = 1
Stroke.Parent = Main

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -40, 0, 35)
Title.Position = UDim2.fromOffset(20, 18)
Title.BackgroundTransparency = 1
Title.Text = Config.Title
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 24
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Main

local Subtitle = Instance.new("TextLabel")
Subtitle.Size = UDim2.new(1, -40, 0, 25)
Subtitle.Position = UDim2.fromOffset(20, 55)
Subtitle.BackgroundTransparency = 1
Subtitle.Text = Config.Subtitle
Subtitle.TextColor3 = Color3.fromRGB(160, 160, 170)
Subtitle.TextSize = 14
Subtitle.Font = Enum.Font.Gotham
Subtitle.TextXAlignment = Enum.TextXAlignment.Left
Subtitle.Parent = Main

local KeyBox = Instance.new("TextBox")
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
KeyBox.Parent = Main

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
UnlockButton.Size = UDim2.new(1, -40, 0, 42)
UnlockButton.Position = UDim2.fromOffset(20, 150)
UnlockButton.BackgroundColor3 = Color3.fromRGB(110, 65, 180)
UnlockButton.BorderSizePixel = 0
UnlockButton.Text = Config.UnlockText
UnlockButton.TextColor3 = Color3.fromRGB(255, 255, 255)
UnlockButton.TextSize = 14
UnlockButton.Font = Enum.Font.GothamBold
UnlockButton.Parent = Main

local UnlockCorner = Instance.new("UICorner")
UnlockCorner.CornerRadius = UDim.new(0, 7)
UnlockCorner.Parent = UnlockButton

local GetKeyButton = Instance.new("TextButton")
GetKeyButton.Size = UDim2.new(1, -40, 0, 42)
GetKeyButton.Position = UDim2.fromOffset(20, 200)
GetKeyButton.BackgroundColor3 = Color3.fromRGB(35, 35, 42)
GetKeyButton.BorderSizePixel = 0
GetKeyButton.Text = Config.GetKeyText
GetKeyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
GetKeyButton.TextSize = 14
GetKeyButton.Font = Enum.Font.GothamBold
GetKeyButton.Parent = Main

local GetKeyCorner = Instance.new("UICorner")
GetKeyCorner.CornerRadius = UDim.new(0, 7)
GetKeyCorner.Parent = GetKeyButton

local Status = Instance.new("TextLabel")
Status.Size = UDim2.new(1, -40, 0, 25)
Status.Position = UDim2.fromOffset(20, 250)
Status.BackgroundTransparency = 1
Status.Text = Config.Footer
Status.TextColor3 = Color3.fromRGB(120, 120, 130)
Status.TextSize = 12
Status.Font = Enum.Font.Gotham
Status.TextXAlignment = Enum.TextXAlignment.Left
Status.Parent = Main

local Dragging = false
local DragStart
local StartPosition

Title.InputBegan:Connect(function(Input)
    if Input.UserInputType == Enum.UserInputType.MouseButton1
        or Input.UserInputType == Enum.UserInputType.Touch then

        Dragging = true
        DragStart = Input.Position
        StartPosition = Main.Position

        Input.Changed:Connect(function()
            if Input.UserInputState == Enum.UserInputState.End then
                Dragging = false
            end
        end)
    end
end)

UserInputService.InputChanged:Connect(function(Input)
    if not Dragging then
        return
    end

    if Input.UserInputType ~= Enum.UserInputType.MouseMovement
        and Input.UserInputType ~= Enum.UserInputType.Touch then
        return
    end

    local Delta = Input.Position - DragStart

    Main.Position = UDim2.new(
        StartPosition.X.Scale,
        StartPosition.X.Offset + Delta.X,
        StartPosition.Y.Scale,
        StartPosition.Y.Offset + Delta.Y
    )
end)

local function SetStatus(Text, Color)
    Status.Text = Text
    Status.TextColor3 = Color
end

local function GetKey()
    if setclipboard then
        return pcall(setclipboard, Config.KeyURL)
    end

    if toclipboard then
        return pcall(toclipboard, Config.KeyURL)
    end

    if syn and syn.write_clipboard then
        return pcall(syn.write_clipboard, Config.KeyURL)
    end

    return false
end

local function LoadObsidian()
    SetStatus(
        "Loading Obsidian...",
        Color3.fromRGB(255, 200, 100)
    )

    local LoadSuccess, LibraryOrError = pcall(function()
        local Source = game:HttpGet(Config.ObsidianURL)

        if not Source or Source == "" then
            error("Obsidian source was empty")
        end

        local Loader = loadstring(Source)

        if not Loader then
            error("loadstring failed")
        end

        return Loader()
    end)

    if not LoadSuccess then
        SetStatus(
            "Obsidian: " .. tostring(LibraryOrError),
            Color3.fromRGB(255, 90, 90)
        )
        return false
    end

    local Library = LibraryOrError

    if not Library then
        SetStatus(
            "Obsidian returned no library.",
            Color3.fromRGB(255, 90, 90)
        )
        return false
    end

    local WindowSuccess, WindowOrError = pcall(function()
        Library.Scheme = {
            BackgroundColor = Color3.fromRGB(15, 15, 18),
            MainColor = Color3.fromRGB(22, 22, 27),
            AccentColor = Color3.fromRGB(110, 65, 180),
            OutlineColor = Color3.fromRGB(55, 55, 65),
            FontColor = Color3.fromRGB(255, 255, 255),
            Font = Font.fromEnum(Enum.Font.Gotham)
        }

        return Library:CreateWindow({
            Title = Config.Title,
            Footer = Config.Footer,
            Center = true,
            AutoShow = true,
            Resizable = true,
            ToggleKeybind = Enum.KeyCode.RightControl,
            MobileButtonsSide = "Right"
        })
    end)

    if not WindowSuccess then
        SetStatus(
            "Window: " .. tostring(WindowOrError),
            Color3.fromRGB(255, 90, 90)
        )
        return false
    end

    local Window = WindowOrError

    local SetupSuccess, SetupError = pcall(function()
        local MainTab = Window:AddTab("Main", "home")

        local FeatureBox = MainTab:AddLeftGroupbox("Features")

        FeatureBox:AddLabel(Config.Title)
        FeatureBox:AddLabel("Game testing features")

        local AutoTrainRunning = false

        local function StopAutoTrain()
            AutoTrainRunning = false
        end

        local function StartAutoTrain()
            if AutoTrainRunning then
                return
            end

            AutoTrainRunning = true

            task.spawn(function()
                while AutoTrainRunning do
                    task.wait(0.1)

                    if not AutoTrainRunning then
                        break
                    end

                    local SharedModules = ReplicatedStorage:FindFirstChild("SharedModules")

                    if not SharedModules then
                        continue
                    end

                    local Network = SharedModules:FindFirstChild("Network")

                    if not Network then
                        continue
                    end

                    local Remotes = Network:FindFirstChild("Remotes")

                    if not Remotes then
                        continue
                    end

                    local Event = Remotes:FindFirstChild("Activate Dumbell")

                    if Event and Event:IsA("RemoteEvent") then
                        pcall(function()
                            Event:FireServer()
                        end)
                    end
                end
            end)
        end

        FeatureBox:AddToggle("AutoTrain", {
            Text = "Auto Train",
            Default = false,

            Callback = function(Value)
                if Value then
                    StartAutoTrain()
                else
                    StopAutoTrain()
                end
            end
        })

        local SettingsTab = Window:AddTab("Settings", "settings")

        local SettingsBox = SettingsTab:AddLeftGroupbox("Settings")

        SettingsBox:AddButton({
            Text = "Unload",

            Func = function()
                StopAutoTrain()
                Library:Unload()
            end
        })

        Library:OnUnload(function()
            StopAutoTrain()
        end)
    end)

    if not SetupSuccess then
        pcall(function()
            Library:Unload()
        end)

        SetStatus(
            "Setup: " .. tostring(SetupError),
            Color3.fromRGB(255, 90, 90)
        )

        return false
    end

    return true
end

local Unlocking = false

local function Unlock()
    if Unlocking then
        return
    end

    if KeyBox.Text ~= Config.Key then
        SetStatus(
            "Invalid key.",
            Color3.fromRGB(255, 90, 90)
        )
        return
    end

    Unlocking = true
    UnlockButton.Active = false
    UnlockButton.AutoButtonColor = false

    local Success = LoadObsidian()

    if Success then
        ScreenGui:Destroy()
    else
        Unlocking = false
        UnlockButton.Active = true
        UnlockButton.AutoButtonColor = true
    end
end

UnlockButton.MouseButton1Click:Connect(Unlock)

GetKeyButton.MouseButton1Click:Connect(function()
    if GetKey() then
        SetStatus(
            "Key copied!",
            Color3.fromRGB(100, 220, 130)
        )
    else
        SetStatus(
            "Clipboard unavailable.",
            Color3.fromRGB(255, 90, 90)
        )
    end

    task.delay(2, function()
        if Status and Status.Parent then
            Status.Text = Config.Footer
            Status.TextColor3 = Color3.fromRGB(120, 120, 130)
        end
    end)
end)

KeyBox.FocusLost:Connect(function(EnterPressed)
    if EnterPressed then
        Unlock()
    end
end)
