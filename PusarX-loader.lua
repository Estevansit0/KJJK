-- v4.5 (new game supported) --
-- ========================================
-- SERVICES & INITIALIZATION
-- GUI FROM SCRIPBLOX (FORGOT ORIGINAL OWNER)
if not game:IsLoaded() then game.Loaded:Wait() end
-- ========================================
local cloneref = cloneref or function(o) return o end
local Services = {
    Players = cloneref(game:GetService("Players")),
    TweenService = cloneref(game:GetService("TweenService")),
    UserInputService = cloneref(game:GetService("UserInputService")),
    RunService = cloneref(game:GetService("RunService")),
    CoreGui = cloneref(game:GetService("CoreGui"))
}

-- ========================================
-- CONFIGURATION
-- ========================================

local Config = {
    MaxKeyLength = 44,
    AnimationSpeed = 0.4,
}
local screenGui;

-- ========================================
-- COLOR SCHEME
-- ========================================

local Colors = {
    Background = Color3.fromRGB(18, 18, 22),
    Surface = Color3.fromRGB(25, 25, 30),
    Primary = Color3.fromRGB(45, 45, 50),
    Secondary = Color3.fromRGB(35, 35, 40),
    Border = Color3.fromRGB(40, 40, 45),
    TextPrimary = Color3.fromRGB(220, 220, 225),
    TextSecondary = Color3.fromRGB(140, 140, 150),
    Success = Color3.fromRGB(25, 135, 84),
    Error = Color3.fromRGB(180, 50, 50),
    Warning = Color3.fromRGB(200, 120, 30),
    Discord = Color3.fromRGB(60, 70, 180),
    GetKey = Color3.fromRGB(40, 140, 100),
    HoverPrimary = Color3.fromRGB(55, 55, 60),
    HoverGetKey = Color3.fromRGB(30, 120, 80),
    NeonWhite = Color3.fromRGB(255, 255, 255),
}

-- ========================================
-- STATE MANAGEMENT
-- ========================================

local State = {
    IsLoading = false,
    Particles = {},
    Animations = {},
    IsDestroyed = false,
    MousePosition = { X = 0, Y = 0 },
    FocusStates = {
        InputFocused = false,
        ButtonHovered = {},
        AnimationsActive = true
    }
}

local UI = {}

-- ========================================
-- LUARMOR FUNCTIONS
-- ========================================

local gameIdToURL = {
    ["6664476231"] = "5ccd093b99591486f2001c115400f454",
    ["4069560710"] = "01e31cb43a472d28871f37ee45d9f21a",
    ["7709344486"] = "51d3af0c95c2202166bf716b5a120203",
    ["7893515528"] = "a556abe9fa2b561d8192e9a158261e3f",
    ["7824062257"] = "3e2b15157055b6fe3260e664ac64561a",
    ["7332711118"] = "be874f306da8948c7636f090c7222b46",
    ["8353463684"] = "f20308f0ed1bda379499756217f0f4b5",
    ["8380556170"] = "7736dfe2074079ac0c0a6e5705af7931",
    ["6471449680"] = "45369c812f2445631b1c96bb732302b8",
    ["7907828295"] = "778f636999c65ee7519d71d01f37bdce",
    ["8421539913"] = "5f0b054d3e43988a88ff9c6b5361600a",
    ["4161970303"] = "f29ded5e442893604294a1a0cfb98a79",
    ["7882829745"] = "485ea33f832a8a3263f40fa6e12be9bb",
    ["8443571594"] = "6f8aad3aa2d60232e978e1db2f18cbb8",
    ["8674765068"] = "097edc621d46ccbef92e9f9a0e41bc61",
    ["6216468795"] = "f9ade440aa24e4ade61df9066f9b339a",
    ["8321616508"] = "68b54db197e247a94e59e2cab8617fef",
    ["8842956505"] = "331a2f8ab38bff0e9c047964ebc41ce8",
}

local errorMessages = {
    KEY_EXPIRED = "Key Expired! Please renew your key.",
    KEY_BANNED = "Your key has been blacklisted. Contact support for details.",
    KEY_HWID_LOCKED = "Key linked to a different HWID. Please reset it using our bot.",
    KEY_INCORRECT = "Key is incorrect or has been deleted.",
    KEY_INVALID = "The provided key is in an invalid format.",
    SCRIPT_ID_INCORRECT = "The provided script ID does not exist or was deleted.",
    SCRIPT_ID_INVALID = "The script ID is in an invalid format.",
    INVALID_EXECUTOR = "HWID header contains invalid data. Executor might not be supported.",
    SECURITY_ERROR = "Security error detected. Cloudflare validation failed.",
    TIME_ERROR = "Client time is invalid. Ensure your system clock is correct.",
    UNKNOWN_ERROR = "Unknown server error. Please contact support."
}

local api = loadstring(game:HttpGet("https://sdkapi-public.luarmor.net/library.lua"))()


function Validation(key, file)
    api.script_id = gameIdToURL[tostring(game.GameId)]

    local cleanedKey = key:gsub("%s", "")

    if cleanedKey ~= key then
        ShowStatus("Spaces detected in the key. Verifying the key without spaces...", false, false)
    end

    local status = api.check_key(cleanedKey)

    if status.code == "KEY_VALID" then
        pcall(function()
            if isfile and readfile and writefile then
                if isfile(file) then
                    local savedKey = readfile(file)
                    if savedKey ~= cleanedKey then
                        if delfile then
                            delfile(file)
                        end
                        writefile(file, cleanedKey)
                    end
                else
                    writefile(file, cleanedKey)
                end
            end
        end)

        if status.data then
            local expire = status.data.auth_expire
            local execCount = status.data.total_executions or 0

            if execCount > 0 then
                if expire == -1 or expire == 0 then
                    ShowStatus("🔓 Key Status: Lifetime Access", false, true)
                else
                    local timeLeft = expire - os.time()
                    if timeLeft > 0 then
                        local formattedTime = string.format(
                            "%02d:%02d:%02d",
                            math.floor(timeLeft / 3600),
                            math.floor((timeLeft % 3600) / 60),
                            timeLeft % 60
                        )
                        ShowStatus("⏳ Time Left: " .. formattedTime, false, true)
                    end
                end
            end
            ShowStatus("Total executions: " .. execCount, false, false)
        end

        script_key = cleanedKey
        return true
    end

    if errorMessages[status.code] then
        delfile(file)
        ShowStatus(errorMessages[status.code], false, false)

        if table.find({ "INVALID_EXECUTOR", "SECURITY_ERROR", "UNKNOWN_ERROR" }, status.code) then
            task.wait(1)
            pcall(function()
                Services.Players.LocalPlayer:Kick(errorMessages[status.code])
            end)
        end

        return nil
    end

    ShowStatus(
        "Key check failed: " ..
        (status.message or "no message") ..
        " Code: " .. status.code,
        true,
        false
    )
end

-- ========================================
-- UI CREATION FUNCTIONS
-- ========================================

local function CreateMainGUI()
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "KeySystemGUI"
    screenGui.ResetOnSpawn = false
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    screenGui.IgnoreGuiInset = true
    screenGui.DisplayOrder = 100
    screenGui.Enabled = false

    if get_hidden_gui or gethui then
        local hiddenUI = get_hidden_gui or gethui
        screenGui.Parent = hiddenUI()
    elseif (not is_sirhurt_closure) and (syn and syn.protect_gui) then
        syn.protect_gui(screenGui)
        screenGui.Parent = Services.CoreGui
    elseif Services.CoreGui:FindFirstChild("RobloxGui") then
        screenGui.Parent = Services.CoreGui.RobloxGui
    else
        screenGui.Parent = Services.CoreGui
    end

    pcall(function() if LuarmorGot_System then LuarmorGot_System:Destroy() end end)
    getgenv().LuarmorGot_System = screenGui

    UI.ScreenGui = screenGui
    return screenGui
end

local function CreateBackdrop(parent)
    local backdrop = Instance.new("Frame")
    backdrop.Name = "Backdrop"
    backdrop.Size = UDim2.new(1, 0, 1, 0)
    backdrop.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    backdrop.BackgroundTransparency = 0.1
    backdrop.BorderSizePixel = 0
    backdrop.ZIndex = 100
    backdrop.Parent = parent

    UI.Backdrop = backdrop
    return backdrop
end

local function CreateContainer(parent)
    local container = Instance.new("Frame")
    container.Name = "MainContainer"
    container.Size = UDim2.new(0, 420, 0, 450)
    container.Position = UDim2.new(0.5, 0, 0.5, 0)
    container.AnchorPoint = Vector2.new(0.5, 0.5)
    container.BackgroundColor3 = Colors.Background
    container.BorderSizePixel = 0
    container.ZIndex = 110
    container.Selectable = false
    container.Parent = parent

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = container

    local stroke = Instance.new("UIStroke")
    stroke.Color = Colors.Border
    stroke.Thickness = 1
    stroke.Transparency = 0.3
    stroke.Parent = container

    local uiScale = Instance.new("UIScale")
    uiScale.Parent = container
    uiScale.Scale = 0.8

    UI.Container = container
    return container
end

local function CreateAnimatedBorder(parent)
    local border = Instance.new("Frame")
    border.Name = "AnimatedBorder"
    border.Size = UDim2.new(1, 6, 1, 6)
    border.Position = UDim2.new(0, -3, 0, -3)
    border.BackgroundTransparency = 1
    border.ZIndex = 109
    border.Selectable = false
    border.Parent = parent

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 23)
    corner.Parent = border

    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(171, 0, 255)
    stroke.Thickness = 2
    stroke.Transparency = 0.3
    stroke.Parent = border

    local gradient = Instance.new("UIGradient")
    gradient.Color = ColorSequence.new {
        ColorSequenceKeypoint.new(0, Color3.fromRGB(85, 0, 255)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(171, 0, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(85, 0, 255))
    }
    gradient.Transparency = NumberSequence.new {
        NumberSequenceKeypoint.new(0, 0.9),
        NumberSequenceKeypoint.new(0.2, 0.1),
        NumberSequenceKeypoint.new(0.8, 0.1),
        NumberSequenceKeypoint.new(1, 0.9)
    }
    gradient.Parent = stroke

    UI.AnimatedBorder = { Frame = border, Gradient = gradient, Stroke = stroke }
    return border
end

-- ========================================
-- HEADER SECTION
-- ========================================

local function CreateHeader(parent)
    local header = Instance.new("Frame")
    header.Name = "Header"
    header.Size = UDim2.new(1, 0, 0, 100)
    header.BackgroundTransparency = 1
    header.ZIndex = 11
    header.Selectable = false
    header.Parent = parent

    local iconContainer = Instance.new("Frame")
    iconContainer.Size = UDim2.new(0, 56, 0, 56)
    iconContainer.Position = UDim2.new(0.5, -28, 0, 24)
    iconContainer.BackgroundColor3 = Colors.Primary
    iconContainer.BorderSizePixel = 0
    iconContainer.ZIndex = 12
    iconContainer.Selectable = false
    iconContainer.Parent = header

    local iconCorner = Instance.new("UICorner")
    iconCorner.CornerRadius = UDim.new(0, 14)
    iconCorner.Parent = iconContainer

    local iconGlow = Instance.new("Frame")
    iconGlow.Size = UDim2.new(1, 12, 1, 12)
    iconGlow.Position = UDim2.new(0, -6, 0, -6)
    iconGlow.BackgroundTransparency = 1
    iconGlow.ZIndex = 11
    iconGlow.Selectable = false
    iconGlow.Parent = iconContainer

    local glowCorner = Instance.new("UICorner")
    glowCorner.CornerRadius = UDim.new(0, 20)
    glowCorner.Parent = iconGlow

    local glowStroke = Instance.new("UIStroke")
    glowStroke.Color = Colors.NeonWhite
    glowStroke.Thickness = 3
    glowStroke.Transparency = 0.2
    glowStroke.Parent = iconGlow

    local glowGradient = Instance.new("UIGradient")
    glowGradient.Color = ColorSequence.new {
        ColorSequenceKeypoint.new(0, Color3.fromRGB(114, 137, 218)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(88, 101, 242)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(114, 137, 218))
    }
    glowGradient.Transparency = NumberSequence.new {
        NumberSequenceKeypoint.new(0, 0.8),
        NumberSequenceKeypoint.new(0.2, 0.05),
        NumberSequenceKeypoint.new(0.8, 0.05),
        NumberSequenceKeypoint.new(1, 0.8)
    }
    glowGradient.Parent = glowStroke

    local iconImage = Instance.new("ImageLabel")
    iconImage.Size = UDim2.new(1, 0, 1, 0)
    iconImage.Position = UDim2.new(0, 0, 0, 0)
    iconImage.BackgroundTransparency = 1
    iconImage.Image = "rbxassetid://125855589466752"
    iconImage.ImageColor3 = Colors.NeonWhite
    iconImage.ImageTransparency = 0.1
    iconImage.ScaleType = Enum.ScaleType.Fit
    iconImage.ZIndex = 13
    iconImage.Parent = iconContainer

    local iconImageCorner = Instance.new("UICorner")
    iconImageCorner.CornerRadius = UDim.new(0, 14)
    iconImageCorner.Parent = iconImage

    UI.Header = { Container = header, IconGlow = glowGradient, IconStroke = glowStroke }
    return header
end

-- ========================================
-- CONTENT SECTION
-- ========================================

local function CreateContent(parent)
    local content = Instance.new("Frame")
    content.Name = "Content"
    content.Size = UDim2.new(1, -64, 0, 440)
    content.Position = UDim2.new(0, 32, 0, 120)
    content.BackgroundTransparency = 1
    content.ZIndex = 11
    content.Selectable = false
    content.Parent = parent

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0, 32)
    title.BackgroundTransparency = 1
    title.Text = "Pulsar X - KeySys"
    title.TextColor3 = Colors.TextPrimary
    title.TextSize = 24
    title.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
    title.TextXAlignment = Enum.TextXAlignment.Center
    title.ZIndex = 12
    title.Parent = content

    local subtitle = Instance.new("TextLabel")
    subtitle.Size = UDim2.new(1, 0, 0, 40)
    subtitle.Position = UDim2.new(0, 0, 0, 40)
    subtitle.BackgroundTransparency = 1
    subtitle.Text = "Enter your key to continue"
    subtitle.TextColor3 = Colors.TextSecondary
    subtitle.TextSize = 16
    subtitle.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
    subtitle.TextXAlignment = Enum.TextXAlignment.Center
    subtitle.TextWrapped = true
    subtitle.ZIndex = 12
    subtitle.Parent = content

    UI.Content = content
    return content
end

-- ========================================
-- INPUT SECTION
-- ========================================

local function CreateInputSection(parent)
    local section = Instance.new("Frame")
    section.Size = UDim2.new(1, 0, 0, 100)
    section.Position = UDim2.new(0, 0, 0, 100)
    section.BackgroundTransparency = 1
    section.ZIndex = 12
    section.Selectable = false
    section.Parent = parent

    local inputContainer = Instance.new("Frame")
    inputContainer.Size = UDim2.new(1, 0, 0, 52)
    inputContainer.BackgroundColor3 = Colors.Surface
    inputContainer.BorderSizePixel = 0
    inputContainer.ZIndex = 13
    inputContainer.Selectable = false
    inputContainer.Parent = section

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 12)
    corner.Parent = inputContainer

    local stroke = Instance.new("UIStroke")
    stroke.Color = Colors.Border
    stroke.Thickness = 1
    stroke.Transparency = 0.3
    stroke.Parent = inputContainer

    local inputGlow = Instance.new("Frame")
    inputGlow.Size = UDim2.new(1, 8, 1, 8)
    inputGlow.Position = UDim2.new(0, -4, 0, -4)
    inputGlow.BackgroundTransparency = 1
    inputGlow.ZIndex = inputContainer.ZIndex - 1
    inputGlow.Visible = false
    inputGlow.Selectable = false
    inputGlow.Parent = inputContainer

    local glowCorner = Instance.new("UICorner")
    glowCorner.CornerRadius = UDim.new(0, 16)
    glowCorner.Parent = inputGlow

    local glowStroke = Instance.new("UIStroke")
    glowStroke.Color = Colors.NeonWhite
    glowStroke.Thickness = 2
    glowStroke.Transparency = 0.3
    glowStroke.Parent = inputGlow

    local glowGradient = Instance.new("UIGradient")
    glowGradient.Color = ColorSequence.new {
        ColorSequenceKeypoint.new(0, Color3.fromRGB(60, 0, 180)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(120, 0, 220)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(60, 0, 180))
    }
    glowGradient.Transparency = NumberSequence.new {
        NumberSequenceKeypoint.new(0, 0.85),
        NumberSequenceKeypoint.new(0.2, 0.2),
        NumberSequenceKeypoint.new(0.8, 0.2),
        NumberSequenceKeypoint.new(1, 0.85)
    }
    glowGradient.Parent = glowStroke

    local textInput = Instance.new("TextBox")
    textInput.Size = UDim2.new(1, -24, 1, 0)
    textInput.Position = UDim2.new(0, 12, 0, 0)
    textInput.BackgroundTransparency = 1
    textInput.Text = ""
    textInput.TextTruncate = Enum.TextTruncate.AtEnd
    textInput.PlaceholderText = "Enter key here"
    textInput.TextColor3 = Colors.TextPrimary
    textInput.PlaceholderColor3 = Colors.TextSecondary
    textInput.TextSize = 16
    textInput.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle
        .Normal)
    textInput.TextXAlignment = Enum.TextXAlignment.Left
    textInput.ClearTextOnFocus = false
    textInput.ZIndex = 14
    textInput.Selectable = true
    textInput.Parent = inputContainer

    local charCounter = Instance.new("TextLabel")
    charCounter.Size = UDim2.new(0, 80, 0, 20)
    charCounter.Position = UDim2.new(1, -85, 0, 60)
    charCounter.BackgroundTransparency = 1
    charCounter.Text = "0/" .. Config.MaxKeyLength
    charCounter.TextColor3 = Colors.TextSecondary
    charCounter.TextSize = 12
    charCounter.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold,
        Enum.FontStyle.Normal)
    charCounter.TextXAlignment = Enum.TextXAlignment.Right
    charCounter.ZIndex = 13
    charCounter.Parent = section

    UI.Input = {
        Container = inputContainer,
        TextBox = textInput,
        Counter = charCounter,
        Stroke = stroke,
        Glow = { Frame = inputGlow, Stroke = glowStroke, Gradient = glowGradient }
    }

    return section
end

-- ========================================
-- BUTTON SECTION
-- ========================================

local function CreateButtons(parent)
    local submitButton = Instance.new("TextButton")
    submitButton.Size = UDim2.new(1, 0, 0, 48)
    submitButton.Position = UDim2.new(0, 0, 0, 200)
    submitButton.BackgroundColor3 = Colors.Primary
    submitButton.BorderSizePixel = 0
    submitButton.Text = "Verify Access Key"
    submitButton.TextColor3 = Colors.TextPrimary
    submitButton.TextSize = 16
    submitButton.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold,
        Enum.FontStyle.Normal)
    submitButton.AutoButtonColor = false
    submitButton.ZIndex = 13
    submitButton.Selectable = true
    submitButton.Parent = parent

    local submitCorner = Instance.new("UICorner")
    submitCorner.CornerRadius = UDim.new(0, 12)
    submitCorner.Parent = submitButton

    local loadingContainer = Instance.new("Frame")
    loadingContainer.Size = UDim2.new(0, 24, 0, 24)
    loadingContainer.Position = UDim2.new(0.5, -12, 0, 12)
    loadingContainer.BackgroundTransparency = 1
    loadingContainer.Visible = false
    loadingContainer.ZIndex = 14
    loadingContainer.Selectable = false
    loadingContainer.Parent = submitButton

    local spinner = Instance.new("Frame")
    spinner.Size = UDim2.new(1, 0, 1, 0)
    spinner.BackgroundColor3 = Colors.TextPrimary
    spinner.BorderSizePixel = 0
    spinner.ZIndex = 15
    spinner.Selectable = false
    spinner.Parent = loadingContainer

    local spinnerCorner = Instance.new("UICorner")
    spinnerCorner.CornerRadius = UDim.new(1, 0)
    spinnerCorner.Parent = spinner

    local spinnerGradient = Instance.new("UIGradient")
    spinnerGradient.Transparency = NumberSequence.new {
        NumberSequenceKeypoint.new(0, 0),
        NumberSequenceKeypoint.new(0.8, 0.8),
        NumberSequenceKeypoint.new(1, 1)
    }
    spinnerGradient.Parent = spinner

    local buttonsContainer = Instance.new("Frame")
    buttonsContainer.Size = UDim2.new(1, 0, 0, 48)
    buttonsContainer.Position = UDim2.new(0, 0, 0, 260)
    buttonsContainer.BackgroundTransparency = 1
    buttonsContainer.ZIndex = 12
    buttonsContainer.Selectable = false
    buttonsContainer.Parent = parent

    local getKeyButton = Instance.new("TextButton")
    getKeyButton.Size = UDim2.new(1, 0, 0, 48)
    getKeyButton.BackgroundColor3 = Colors.GetKey
    getKeyButton.BorderSizePixel = 0
    getKeyButton.Text = "Get Key"
    getKeyButton.TextColor3 = Colors.TextPrimary
    getKeyButton.TextSize = 14
    getKeyButton.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold,
        Enum.FontStyle.Normal)
    getKeyButton.AutoButtonColor = false
    getKeyButton.ZIndex = 13
    getKeyButton.Selectable = true
    getKeyButton.Parent = buttonsContainer

    local getKeyCorner = Instance.new("UICorner")
    getKeyCorner.CornerRadius = UDim.new(0, 10)
    getKeyCorner.Parent = getKeyButton

    UI.Buttons = {
        Submit = submitButton,
        GetKey = getKeyButton,
        Loading = { Container = loadingContainer, Spinner = spinner }
    }

    return { submitButton, getKeyButton }
end

-- ========================================
-- STATUS SECTION
-- ========================================

local function CreateStatus(parent)
    local statusContainer = Instance.new("Frame")
    statusContainer.Size = UDim2.new(1, 0, 0, 60)
    statusContainer.Position = UDim2.new(0, 0, 0, 330)
    statusContainer.BackgroundTransparency = 1
    statusContainer.ZIndex = 12
    statusContainer.Selectable = false
    statusContainer.Parent = parent

    local statusLabel = Instance.new("TextLabel")
    statusLabel.Size = UDim2.new(1, 0, 1, 0)
    statusLabel.BackgroundTransparency = 1
    statusLabel.Text = ""
    statusLabel.TextColor3 = Colors.Error
    statusLabel.TextSize = 14
    statusLabel.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold,
        Enum.FontStyle.Normal)
    statusLabel.TextXAlignment = Enum.TextXAlignment.Center
    statusLabel.TextWrapped = true
    statusLabel.ZIndex = 13
    statusLabel.Parent = statusContainer

    UI.Status = statusLabel
    return statusLabel
end

-- ========================================
-- VISUAL EFFECTS
-- ========================================

local function CreateButtonGlow(button, hoverColor, originalColor)
    local glowBorder = Instance.new("Frame")
    glowBorder.Size = UDim2.new(1, 8, 1, 8)
    glowBorder.Position = UDim2.new(0, -4, 0, -4)
    glowBorder.BackgroundTransparency = 1
    glowBorder.ZIndex = button.ZIndex - 1
    glowBorder.Visible = false
    glowBorder.Selectable = false
    glowBorder.Parent = button

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 14)
    corner.Parent = glowBorder

    local stroke = Instance.new("UIStroke")
    stroke.Color = Colors.NeonWhite
    stroke.Thickness = 2
    stroke.Transparency = 0.3
    stroke.Parent = glowBorder

    local gradient = Instance.new("UIGradient")
    gradient.Color = ColorSequence.new {
        ColorSequenceKeypoint.new(0, Color3.fromRGB(60, 0, 180)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(120, 0, 220)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(60, 0, 180))
    }
    gradient.Transparency = NumberSequence.new {
        NumberSequenceKeypoint.new(0, 0.85),
        NumberSequenceKeypoint.new(0.2, 0.2),
        NumberSequenceKeypoint.new(0.8, 0.2),
        NumberSequenceKeypoint.new(1, 0.85)
    }
    gradient.Parent = stroke

    local currentTween = nil
    local buttonId = tostring(button)

    button.MouseEnter:Connect(function()
        State.FocusStates.ButtonHovered[buttonId] = true
        glowBorder.Visible = true

        Services.TweenService:Create(button, TweenInfo.new(0.2, Enum.EasingStyle.Quad),
            { BackgroundColor3 = hoverColor }):Play()

        Services.TweenService:Create(stroke, TweenInfo.new(0.2, Enum.EasingStyle.Quad),
            { Transparency = 0.1 }):Play()

        if currentTween then currentTween:Cancel() end
        currentTween = Services.TweenService:Create(gradient,
            TweenInfo.new(1.5, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1),
            { Rotation = 360 })
        currentTween:Play()
    end)

    button.MouseLeave:Connect(function()
        State.FocusStates.ButtonHovered[buttonId] = false

        Services.TweenService:Create(button, TweenInfo.new(0.2, Enum.EasingStyle.Quad),
            { BackgroundColor3 = originalColor }):Play()

        Services.TweenService:Create(stroke, TweenInfo.new(0.3, Enum.EasingStyle.Quad),
            { Transparency = 0.8 }):Play()

        if currentTween then
            currentTween:Cancel()
            gradient.Rotation = 0
        end

        task.spawn(function()
            task.wait(0.3)
            if glowBorder and glowBorder.Parent then
                glowBorder.Visible = false
            end
        end)
    end)

    return { glowBorder, stroke, gradient }
end

-- ========================================
-- STATUS & FEEDBACK FUNCTIONS
-- ========================================
local NotificationLibrary = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/IceMinisterq/Notification-Library/Main/Library.lua", true))()

local function Notification(Type, Message)
    if NotificationLibrary then
        pcall(NotificationLibrary.SendNotification, NotificationLibrary, Type, Message, 3)
    else
        warn("Notification: " .. Type .. " - " .. Message)
    end
end


function ShowStatus(message, isError, isSuccess)
    if not UI.Status then return end

    UI.Status.Text = message
    if not screenGui.Enabled then
        local IsWarn;
        if isSuccess then
            IsWarn = "Success"
        elseif isError then
            IsWarn = "Error"
        else
            IsWarn = "Warning"
        end

        Notification(IsWarn, message)
    else
        if isSuccess then
            UI.Status.TextColor3 = Colors.Success
        elseif isError then
            UI.Status.TextColor3 = Colors.Error
        else
            UI.Status.TextColor3 = Colors.Warning
        end

        UI.Status.TextTransparency = 1
        Services.TweenService:Create(UI.Status, TweenInfo.new(0.3, Enum.EasingStyle.Quad),
            { TextTransparency = 0 }):Play()
    end
end

local function ClearStatus()
    if UI.Status then
        Services.TweenService:Create(UI.Status, TweenInfo.new(0.3, Enum.EasingStyle.Quad),
            { TextTransparency = 1 }):Play()
    end
end

function SetLoading(isLoading)
    State.IsLoading = isLoading
    if not UI.Buttons then return end

    UI.Buttons.Loading.Container.Visible = isLoading
    UI.Buttons.Submit.Text = isLoading and "" or "Verify Access Key"

    if isLoading then
        local tween = Services.TweenService:Create(UI.Buttons.Loading.Spinner,
            TweenInfo.new(1, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1),
            { Rotation = 360 })
        tween:Play()
        State.Animations.SpinTween = tween
    else
        if State.Animations.SpinTween then
            State.Animations.SpinTween:Cancel()
            UI.Buttons.Loading.Spinner.Rotation = 0
        end
    end
end

-- ========================================
-- INPUT HANDLING
-- ========================================

local function UpdateCharCounter()
    if not UI.Input then return end

    local currentLength = string.len(UI.Input.TextBox.Text)
    UI.Input.Counter.Text = currentLength .. "/" .. Config.MaxKeyLength

    if currentLength >= Config.MaxKeyLength then
        UI.Input.Counter.TextColor3 = Colors.Error
    elseif currentLength >= Config.MaxKeyLength * 0.8 then
        UI.Input.Counter.TextColor3 = Colors.Warning
    else
        UI.Input.Counter.TextColor3 = Colors.TextSecondary
    end
end

local function CopyToClipboard(text, successMessage)
    local success = pcall(function()
        if setclipboard then
            setclipboard(text)
            ShowStatus(successMessage, false, true)
        else
            ShowStatus("Link: " .. text, false, true)
        end
    end)

    if not success then
        ShowStatus("Link: " .. text, false, true)
    end
end

-- ========================================
-- EVENT CONNECTIONS
-- ========================================

local function ConnectEvents()
    Services.UserInputService.InputChanged:Connect(function(input, gameProcessed)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            State.MousePosition.X = input.Position.X
            State.MousePosition.Y = input.Position.Y
        end
    end)

    UI.Input.TextBox:GetPropertyChangedSignal("Text"):Connect(function()
        local currentText = UI.Input.TextBox.Text

        if string.len(currentText) > Config.MaxKeyLength then
            UI.Input.TextBox.Text = string.sub(currentText, 1, Config.MaxKeyLength)
            ShowStatus("Maximum character limit reached (" .. Config.MaxKeyLength .. ")", true)
        end

        UpdateCharCounter()
        ClearStatus()
    end)

    local inputGlowTween = nil

    UI.Input.TextBox.Focused:Connect(function()
        State.FocusStates.InputFocused = true
        UI.Input.Glow.Frame.Visible = true

        Services.TweenService:Create(UI.Input.Stroke,
            TweenInfo.new(0.2, Enum.EasingStyle.Quad),
            { Color = Colors.NeonWhite, Transparency = 0.1 }):Play()

        Services.TweenService:Create(UI.Input.Glow.Stroke,
            TweenInfo.new(0.2, Enum.EasingStyle.Quad),
            { Transparency = 0.1 }):Play()

        if inputGlowTween then inputGlowTween:Cancel() end
        inputGlowTween = Services.TweenService:Create(UI.Input.Glow.Gradient,
            TweenInfo.new(2, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1),
            { Rotation = 360 })
        inputGlowTween:Play()
        State.Animations.InputGlowTween = inputGlowTween
        ClearStatus()
    end)

    UI.Input.TextBox.FocusLost:Connect(function()
        State.FocusStates.InputFocused = false

        Services.TweenService:Create(UI.Input.Stroke,
            TweenInfo.new(0.2, Enum.EasingStyle.Quad),
            { Color = Colors.Border, Transparency = 0.3 }):Play()

        Services.TweenService:Create(UI.Input.Glow.Stroke,
            TweenInfo.new(0.3, Enum.EasingStyle.Quad),
            { Transparency = 0.8 }):Play()

        if inputGlowTween then
            inputGlowTween:Cancel()
            UI.Input.Glow.Gradient.Rotation = 0
            State.Animations.InputGlowTween = nil
        end

        task.spawn(function()
            task.wait(0.3)
            if UI.Input.Glow.Frame and UI.Input.Glow.Frame.Parent then
                UI.Input.Glow.Frame.Visible = false
            end
        end)
    end)

    UI.Buttons.Submit.MouseButton1Click:Connect(function()
        if State.IsLoading then return end

        local key = UI.Input.TextBox.Text
        if key == "" then
            UI.Input.TextBox:CaptureFocus()
            return
        end

        SetLoading(true)
        ShowStatus("Validating key...", false, false)

        if not Validation(key, "PulsarKey.txt") then
            task.wait(2)
            SetLoading(false)
            ClearStatus()
            return
        end

        task.spawn(function()
            SetLoading(false)
            ShowStatus("Key validated successfully!", false, true)
            ClearStatus()
            pcall(function() if LuarmorGot_System then LuarmorGot_System:Destroy() end end)
            api.load_script()
        end)
    end)

    UI.Buttons.GetKey.MouseButton1Click:Connect(function()
        ShowStatus("Opening key website...", false, false)
        CopyToClipboard("https://pulsarx.pro/keysystem/", "Key website link copied to clipboard!")
        task.wait(2.5)
        ClearStatus()
    end)
end

-- ========================================
-- ANIMATION LOOPS
-- ========================================
local function StartAnimationLoops()
    State.Animations.BorderTween = nil
    State.Animations.IconTween = nil
    State.FocusStates.AnimationsActive = true

    task.spawn(function()
        while not State.IsDestroyed and UI.AnimatedBorder and UI.AnimatedBorder.Frame.Parent do
            if State.Animations.BorderTween then
                State.Animations.BorderTween:Cancel()
            end

            local startRotation = UI.AnimatedBorder.Gradient.Rotation
            local tween = Services.TweenService:Create(UI.AnimatedBorder.Gradient,
                TweenInfo.new(4, Enum.EasingStyle.Linear),
                { Rotation = startRotation + 360 })

            State.Animations.BorderTween = tween
            tween:Play()

            local success = pcall(function()
                tween.Completed:Wait()
            end)

            if not success then
                task.wait(4)
            end

            if UI.AnimatedBorder and UI.AnimatedBorder.Gradient and UI.AnimatedBorder.Gradient.Parent then
                UI.AnimatedBorder.Gradient.Rotation = UI.AnimatedBorder.Gradient.Rotation % 360
            end

            task.wait(0.1)
        end
    end)

    task.spawn(function()
        while not State.IsDestroyed and UI.Header and UI.Header.IconGlow and UI.Header.IconGlow.Parent do
            if State.Animations.IconTween then
                State.Animations.IconTween:Cancel()
            end

            local startRotation = UI.Header.IconGlow.Rotation
            State.Animations.IconTween = Services.TweenService:Create(UI.Header.IconGlow,
                TweenInfo.new(3, Enum.EasingStyle.Linear),
                { Rotation = startRotation + 360 })

            State.Animations.IconTween:Play()

            local success = pcall(function()
                State.Animations.IconTween.Completed:Wait()
            end)

            if not success then
                task.wait(3)
            end

            if UI.Header and UI.Header.IconGlow and UI.Header.IconGlow.Parent then
                UI.Header.IconGlow.Rotation = UI.Header.IconGlow.Rotation % 360
            end

            task.wait(0.1)
        end
    end)
end

-- ========================================
-- ENTRANCE ANIMATION
-- ========================================

local function PlayEntranceAnimation()
    UI.Container.Size = UDim2.new(0, 0, 0, 0)
    UI.Container.BackgroundTransparency = 1
    UI.Backdrop.BackgroundTransparency = 1

    Services.TweenService:Create(UI.Backdrop,
        TweenInfo.new(0.3, Enum.EasingStyle.Quad),
        { BackgroundTransparency = 0.2 }):Play()

    task.wait(0.1)

    Services.TweenService:Create(UI.Container,
        TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
        { Size = UDim2.new(0, 420, 0, 450), BackgroundTransparency = 0 }):Play()

    task.wait(0.5)
end

-- ========================================
-- MAIN INITIALIZATION
-- ========================================

local function Initialize()
    screenGui = CreateMainGUI()
    local backdrop = CreateBackdrop(screenGui)
    local container = CreateContainer(screenGui)
    CreateAnimatedBorder(container)
    CreateHeader(container)
    local content = CreateContent(container)
    CreateInputSection(content)
    CreateButtons(content)
    CreateStatus(content)

    CreateButtonGlow(UI.Buttons.Submit, Colors.HoverPrimary, Colors.Primary)
    CreateButtonGlow(UI.Buttons.GetKey, Colors.HoverGetKey, Colors.GetKey)

    UpdateCharCounter()
    ConnectEvents()
    StartAnimationLoops()
    PlayEntranceAnimation()
end

-- ========================================
-- START THE GUI
-- ========================================

Initialize()

task.spawn(function()
    local valid = false
    local key = script_key

    if key and key ~= "" then
        ShowStatus("Found key in script_key variable. Waiting for key system to fully load...", false, false)
        valid = Validation(key, "PulsarKey.txt")
    else
        local success, result = pcall(function()
            return readfile and isfile and isfile("PulsarKey.txt") and readfile("PulsarKey.txt")
        end)

        if success and result and result ~= "" then
            ShowStatus("Found saved key. Waiting for key system to fully load...", false, false)
            valid = Validation(result, "PulsarKey.txt")
        end
    end

    if not valid and screenGui then
        screenGui.Enabled = true
        task.wait(1.5)
        ClearStatus()
        return
    else
        api.load_script()
    end

    pcall(function() if LuarmorGot_System then LuarmorGot_System:Destroy() end end)
end)
