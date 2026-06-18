--! NEW BAD GAME

if not LPH_OBFUSCATED then
    LPH_JIT = function(...) return (...) end;
    LPH_ENCSTR = function(...) return (...) end;
    LPH_NO_VIRTUALIZE = function(...) return (...) end;
end

if not game:IsLoaded() then game.Loaded:Wait() end

local cloneref = cloneref or function(o) return o end
local function safe_service(name)
    return cloneref(game:GetService(name))
end

local CoreGui = safe_service("CoreGui")
local TweenService = safe_service("TweenService")
local HttpService = safe_service("HttpService")
local Players = safe_service("Players")
local UserInputService = safe_service("UserInputService")
local Lighting = safe_service("Lighting")
local LocalPlayer = Players.LocalPlayer

local function SafeJSONDecode(str)
    local s, r = pcall(function() return HttpService:JSONDecode(str) end)
    if s then return r end
end

local FolderImage = "PulsarAssets"
if makefolder and not isfolder(FolderImage) then
    makefolder(FolderImage)
end

local Colors = {
    MainBG = Color3.fromRGB(12, 12, 16),
    SecondaryBG = Color3.fromRGB(18, 18, 24),
    TertiaryBG = Color3.fromRGB(24, 24, 32),
    Accent = Color3.fromRGB(220, 20, 60),
    AccentGlow = Color3.fromRGB(255, 50, 90),
    TextPrimary = Color3.fromRGB(255, 255, 255),
    TextSecondary = Color3.fromRGB(140, 150, 170),
    Stroke = Color3.fromRGB(35, 35, 45),
    Success = Color3.fromRGB(40, 220, 140),
    Warn = Color3.fromRGB(255, 170, 40),
    Error = Color3.fromRGB(255, 70, 90)
}

pcall(function() 
    if getgenv().LuarmorGot_System then 
        getgenv().LuarmorGot_System:Destroy() 
    end 
    local oldBlur = Lighting:FindFirstChild("PulsarBlur")
    if oldBlur then oldBlur:Destroy() end
end)

local PulsarBlur = Instance.new("BlurEffect")
PulsarBlur.Name = "PulsarBlur"
PulsarBlur.Size = 0
PulsarBlur.Parent = Lighting

TweenService:Create(PulsarBlur, TweenInfo.new(0.6, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {Size = 20}):Play()

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "PulsarKeySystem"
ScreenGui.IgnoreGuiInset = true
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
getgenv().LuarmorGot_System = ScreenGui

if gethui then
    ScreenGui.Parent = gethui()
else
    ScreenGui.Parent = CoreGui
end

local AssetsToLoad = {
    {Name = "pulsarx", Type = "discord", Id = "BhWcbQbHFF"},
    {Name = "key", Type = "icon"},
    {Name = "book-lock", Type = "icon"},
    {Name = "gamepad-2", Type = "icon"},
    {Name = "loader-2", Type = "icon"},
    {Name = "check", Type = "icon"},
    {Name = "wifi-off", Type = "icon"},
    {Name = "alert-circle", Type = "icon"},
    {Name = "lock-keyhole-open", Type = "icon"},
    {Name = "x", Type = "icon"},
    {Name = "book-key", Type = "icon"},
    {Name = "external-link", Type = "icon"},
    {Name = "shield", Type = "icon"},
    {Name = "user", Type = "icon"},
    {Name = "copy", Type = "icon"},
    {Name = "clock", Type = "icon"}
}

local function ProcessAssets()
    for _, asset in ipairs(AssetsToLoad) do
        local ext = asset.Type == "discord" and ".jpg" or ".png"
        local path = FolderImage .. "/" .. asset.Name .. ext
        
        if not isfile(path) then
            local url
            if asset.Type == "icon" then
                url = "https://raw.githubusercontent.com/latte-soft/lucide-roblox/master/icons/compiled/256px/" .. asset.Name .. ".png"
            elseif asset.Type == "discord" then
                local s, r = pcall(function() 
                    return game:HttpGet("https://discord.com/api/v10/invites/" .. asset.Id .. "?with_counts=false&with_expiration=false") 
                end)
                if s and r then
                    local decoded = SafeJSONDecode(r)
                    if decoded and decoded.guild and decoded.guild.icon then
                        url = ("https://cdn.discordapp.com/icons/%s/%s.png?size=256"):format(decoded.guild.id, decoded.guild.icon)
                    end
                end
            end
            
            if url then
                local s, data = pcall(function() return game:HttpGet(url) end)
                if s and data and #data > 100 then 
                    writefile(path, data) 
                end
            end
        end
    end
end

ProcessAssets()

local asset_mgr = {
    get = function(x)
        local ext = x == "pulsarx" and ".jpg" or ".png"
        local path = FolderImage .. "/" .. x .. ext
        if isfile(path) then
            return getcustomasset(path)
        end
        return "rbxassetid://0"
    end
}

local gameIdToURL = {
    ["6664476231"] = "5ccd093b99591486f2001c115400f454",
    ["4069560710"] = "01e31cb43a472d28871f37ee45d9f21a",
    ["7709344486"] = "51d3af0c95c2202166bf716b5a120203",
    ["7332711118"] = "be874f306da8948c7636f090c7222b46",
    ["4161970303"] = "f29ded5e442893604294a1a0cfb98a79",
    ["8443571594"] = "6f8aad3aa2d60232e978e1db2f18cbb8",
    ["6216468795"] = "f9ade440aa24e4ade61df9066f9b339a",
    ["8321616508"] = "68b54db197e247a94e59e2cab8617fef",
    ["8832884753"] = "660505cd7637b83d8d3d88ecc3882cd9",
    ["8779464785"] = "0c16aabca6ba4f89d5a4fb232eb39f65",
    ["8916375040"] = "6c5fef915a2939142f857fd8098662d4",
    ["9186719164"] = "13d1621b60dce0465d5baea7ffc9c9f7",
    ["9671940985"] = "27a561f5e2606ee11865ef31ead65df1",
    ["9679625425"] = "1f9877cc257889d71f46c554915d07eb",
    ["9510293839"] = "928d148d9d15c8151cc73dded45f6975",
    ["9709606565"] = "f7e40f1ac25c05097c992e5b1f14def9",
    ["9133163823"] = "31d50c8ffbeaa38a577f38e279cc81be",
    ["9751761702"] = "2edbe1c84f93b1f80ee4889915bfdcb1",
    ["7178032757"] = "577218de3c588c3ef155af46262499e2",
    ["9917246399"] = "a62365c7600cc42338fc374e0924a98c",
    ["10004244222"] = "ac39eac78e792f40d363716be26d5047",
    ["9792947201"] = "b9a6c6d6349c51c5bf0be33b37d80974",
    ["6409513651"] = "8daa812353e296b08bcc6bb18c2aed15",
    ["9654716970"] = "0cfec26e9dffcd02142df0dfa1205e9f",
    ["10143502462"] = "49d9e8f6d939bb2e3c30b4c4029f2b0b",
    ["9860860377"] = "e89b2a9d39319e9db2caba7c3df6d279",
    ["6391458589"] = "626411dc79e5f5381fd7ec25c8e10553",
    ["10093833731"] = "cb12c13a7e923106310362b89f94beb8",
    ["10067868611"] = "67abdc09ec99469ba156d58aaa2de054",
    ["9907432116"] = "0fcf18c1d274f94ede49b84def65c62b",
    ["8931286822"] = "f377b5fd4da9b8c9adb92cb0e8afdecb",
}

local Config = {
    HeaderTitle = LPH_ENCSTR("PULSAR X"),
    Subtitle = LPH_ENCSTR("Authentication System"),
    KeyLink = LPH_ENCSTR("https://pulsarx.net/"),
    DiscordLink = LPH_ENCSTR("https://discord.gg/BhWcbQbHFF"),
    ResetHWIDLink = LPH_ENCSTR("https://pulsarx.net/resethwid/"),
    FileName = LPH_ENCSTR("PulsarKey_Save.txt")
}

local api = LPH_NO_VIRTUALIZE(function() return loadstring(game:HttpGet("https://sdkapi-public.luarmor.net/library.lua"))() end)()
local currentScriptId = gameIdToURL[tostring(game.GameId)]
local isSupported = false

if api and currentScriptId then
    api.script_id = currentScriptId
    isSupported = true
end

local NotificationContainer = Instance.new("Frame")
NotificationContainer.Size = UDim2.new(0, 300, 1, 0)
NotificationContainer.AnchorPoint = Vector2.new(1, 1)
NotificationContainer.Position = UDim2.new(1, -20, 1, -20)
NotificationContainer.BackgroundTransparency = 1
NotificationContainer.Parent = ScreenGui

local ActiveNotifications = {}

local UpdateNotifications = LPH_JIT(function()
    for i, note in ipairs(ActiveNotifications) do
        local targetY = 0
        for j = 1, i - 1 do
            if ActiveNotifications[j] and ActiveNotifications[j].Instance then
                targetY = targetY + ActiveNotifications[j].Instance.Size.Y.Offset + 12
            end
        end
        TweenService:Create(note.Instance, TweenInfo.new(0.5, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {Position = UDim2.new(0, 0, 1, -targetY)}):Play()
    end
end)

local function Notify(title, message, type, duration)
    local accentColor = Colors.Success
    local iconId = "check"
    
    if type == "Warn" then 
        accentColor = Colors.Warn
        iconId = "alert-circle"
    elseif type == "Error" then 
        accentColor = Colors.Error
        iconId = "x"
    elseif type == "Info" then
        accentColor = Colors.Accent
        iconId = "shield"
    end

    local Toast = Instance.new("Frame")
    Toast.Size = UDim2.new(1, 0, 0, 60)
    Toast.AnchorPoint = Vector2.new(0, 1)
    Toast.Position = UDim2.new(1, 350, 1, 0)
    Toast.BackgroundColor3 = Colors.MainBG
    Toast.BorderSizePixel = 0
    Toast.Parent = NotificationContainer

    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 8)
    UICorner.Parent = Toast

    local UIStroke = Instance.new("UIStroke")
    UIStroke.Color = Colors.Stroke
    UIStroke.Thickness = 1
    UIStroke.Parent = Toast

    local LeftBar = Instance.new("Frame")
    LeftBar.Size = UDim2.new(0, 3, 1, -16)
    LeftBar.Position = UDim2.new(0, 8, 0.5, 0)
    LeftBar.AnchorPoint = Vector2.new(0, 0.5)
    LeftBar.BackgroundColor3 = accentColor
    LeftBar.BorderSizePixel = 0
    LeftBar.Parent = Toast

    local LeftBarCorner = Instance.new("UICorner")
    LeftBarCorner.CornerRadius = UDim.new(1, 0)
    LeftBarCorner.Parent = LeftBar

    local Icon = Instance.new("ImageLabel")
    Icon.Size = UDim2.new(0, 18, 0, 18)
    Icon.Position = UDim2.new(0, 20, 0.5, 0)
    Icon.AnchorPoint = Vector2.new(0, 0.5)
    Icon.BackgroundTransparency = 1
    Icon.Image = asset_mgr.get(iconId)
    Icon.ImageColor3 = accentColor
    Icon.Parent = Toast

    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Size = UDim2.new(1, -60, 0, 18)
    TitleLabel.Position = UDim2.new(0, 48, 0, 10)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Text = title
    TitleLabel.TextColor3 = Colors.TextPrimary
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.TextSize = 13
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.Parent = Toast

    local MsgLabel = Instance.new("TextLabel")
    MsgLabel.Size = UDim2.new(1, -60, 0, 16)
    MsgLabel.Position = UDim2.new(0, 48, 0, 30)
    MsgLabel.BackgroundTransparency = 1
    MsgLabel.Text = message
    MsgLabel.TextColor3 = Colors.TextSecondary
    MsgLabel.Font = Enum.Font.Gotham
    MsgLabel.TextSize = 11
    MsgLabel.TextXAlignment = Enum.TextXAlignment.Left
    MsgLabel.TextWrapped = true
    MsgLabel.Parent = Toast

    local notiData = {Instance = Toast}
    table.insert(ActiveNotifications, 1, notiData)
    
    if #ActiveNotifications > 4 then
        local old = table.remove(ActiveNotifications, #ActiveNotifications)
        if old and old.Instance then
            TweenService:Create(old.Instance, TweenInfo.new(0.4, Enum.EasingStyle.Exponential, Enum.EasingDirection.In), {Position = UDim2.new(1, 350, 1, old.Instance.Position.Y.Offset)}):Play()
            task.delay(0.4, function() old.Instance:Destroy() end)
        end
    end

    UpdateNotifications()

    task.spawn(function()
        task.wait(duration or 4)
        if Toast and Toast.Parent then
            local foundIdx = nil
            for i, v in ipairs(ActiveNotifications) do
                if v.Instance == Toast then
                    foundIdx = i
                    break
                end
            end
            
            if foundIdx then
                table.remove(ActiveNotifications, foundIdx)
                TweenService:Create(Toast, TweenInfo.new(0.4, Enum.EasingStyle.Exponential, Enum.EasingDirection.In), {Position = UDim2.new(1, 350, 1, Toast.Position.Y.Offset)}):Play()
                task.delay(0.4, function() Toast:Destroy() end)
                UpdateNotifications()
            end
        end
    end)
end

local MainContainer = Instance.new("Frame")
MainContainer.Size = UDim2.new(0, 360, 0, 380)
MainContainer.Position = UDim2.new(0.5, 0, 0.5, 0)
MainContainer.AnchorPoint = Vector2.new(0.5, 0.5)
MainContainer.BackgroundTransparency = 1
MainContainer.Parent = ScreenGui

local MainCard = Instance.new("Frame")
MainCard.Size = UDim2.new(1, 0, 1, 0)
MainCard.Position = UDim2.new(0.5, 0, 0.5, 0)
MainCard.AnchorPoint = Vector2.new(0.5, 0.5)
MainCard.BackgroundColor3 = Colors.MainBG
MainCard.BorderSizePixel = 0
MainCard.BackgroundTransparency = 1
MainCard.Parent = MainContainer

local CardCorner = Instance.new("UICorner")
CardCorner.CornerRadius = UDim.new(0, 12)
CardCorner.Parent = MainCard

local CardStroke = Instance.new("UIStroke")
CardStroke.Color = Colors.Stroke
CardStroke.Thickness = 1
CardStroke.Transparency = 1
CardStroke.Parent = MainCard

local UserPanel = Instance.new("Frame")
UserPanel.Size = UDim2.new(0, 0, 1, 0)
UserPanel.Position = UDim2.new(1, 10, 0, 0)
UserPanel.BackgroundColor3 = Colors.MainBG
UserPanel.BorderSizePixel = 0
UserPanel.ClipsDescendants = true
UserPanel.Parent = MainCard

local UserPanelCorner = Instance.new("UICorner")
UserPanelCorner.CornerRadius = UDim.new(0, 12)
UserPanelCorner.Parent = UserPanel

local UserPanelStroke = Instance.new("UIStroke")
UserPanelStroke.Color = Colors.Stroke
UserPanelStroke.Thickness = 1
UserPanelStroke.Transparency = 1
UserPanelStroke.Parent = UserPanel

local UserPanelLayout = Instance.new("UIListLayout")
UserPanelLayout.SortOrder = Enum.SortOrder.LayoutOrder
UserPanelLayout.Padding = UDim.new(0, 0)
UserPanelLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
UserPanelLayout.Parent = UserPanel

local UserPanelPadding = Instance.new("UIPadding")
UserPanelPadding.PaddingTop = UDim.new(0, 20)
UserPanelPadding.PaddingBottom = UDim.new(0, 20)
UserPanelPadding.PaddingLeft = UDim.new(0, 15)
UserPanelPadding.PaddingRight = UDim.new(0, 15)
UserPanelPadding.Parent = UserPanel

local AvatarImg = Instance.new("ImageLabel")
AvatarImg.Size = UDim2.new(0, 56, 0, 56)
AvatarImg.BackgroundColor3 = Colors.TertiaryBG
AvatarImg.LayoutOrder = 1
AvatarImg.Parent = UserPanel

local AvatarCorner = Instance.new("UICorner")
AvatarCorner.CornerRadius = UDim.new(0, 8)
AvatarCorner.Parent = AvatarImg

local AvatarStroke = Instance.new("UIStroke")
AvatarStroke.Color = Colors.Accent
AvatarStroke.Thickness = 2
AvatarStroke.Parent = AvatarImg

pcall(function()
    AvatarImg.Image = Players:GetUserThumbnailAsync(LocalPlayer.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size150x150)
end)

local DisplayNameText = Instance.new("TextLabel")
DisplayNameText.Size = UDim2.new(1, 0, 0, 30)
DisplayNameText.BackgroundTransparency = 1
DisplayNameText.Text = "Welcome, " .. LocalPlayer.DisplayName
DisplayNameText.TextColor3 = Colors.TextPrimary
DisplayNameText.Font = Enum.Font.GothamBold
DisplayNameText.TextSize = 13
DisplayNameText.LayoutOrder = 2
DisplayNameText.Parent = UserPanel

local function CreateDivider(order)
    local divWrapper = Instance.new("Frame")
    divWrapper.Size = UDim2.new(1, 30, 0, 15)
    divWrapper.BackgroundTransparency = 1
    divWrapper.LayoutOrder = order
    
    local divLine = Instance.new("Frame")
    divLine.Size = UDim2.new(1, 0, 0, 1)
    divLine.Position = UDim2.new(0.5, 0, 0.5, 0)
    divLine.AnchorPoint = Vector2.new(0.5, 0.5)
    divLine.BackgroundColor3 = Colors.Stroke
    divLine.BorderSizePixel = 0
    divLine.Parent = divWrapper
    
    return divWrapper
end

local function GetExecutor()
    local s, n = pcall(identifyexecutor)
    if s and n then return tostring(n) end
    return "Unknown"
end

local function GetDevice()
    if UserInputService.GamepadEnabled then return "Console" end
    if UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled then return "Mobile" end
    return "PC"
end

local function CreateInfoField(title, value, order)
    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, 0, 0, 36)
    container.BackgroundTransparency = 1
    container.LayoutOrder = order

    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, 0, 0, 14)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = title
    titleLabel.TextColor3 = Colors.TextSecondary
    titleLabel.Font = Enum.Font.GothamMedium
    titleLabel.TextSize = 11
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = container

    local valueLabel = Instance.new("TextLabel")
    valueLabel.Size = UDim2.new(1, 0, 0, 18)
    valueLabel.Position = UDim2.new(0, 0, 0, 16)
    valueLabel.BackgroundTransparency = 1
    valueLabel.Text = value
    valueLabel.TextColor3 = Colors.Accent
    valueLabel.Font = Enum.Font.GothamBold
    valueLabel.TextSize = 13
    valueLabel.TextXAlignment = Enum.TextXAlignment.Left
    valueLabel.Parent = container

    return container
end

CreateDivider(3).Parent = UserPanel
CreateInfoField("Executor", GetExecutor(), 4).Parent = UserPanel
CreateInfoField("Device", GetDevice(), 5).Parent = UserPanel
CreateDivider(6).Parent = UserPanel

local HwidContainer = Instance.new("Frame")
HwidContainer.Size = UDim2.new(1, 0, 0, 36)
HwidContainer.BackgroundTransparency = 1
HwidContainer.LayoutOrder = 7
HwidContainer.Parent = UserPanel

local HwidTitle = Instance.new("TextLabel")
HwidTitle.Size = UDim2.new(1, 0, 0, 14)
HwidTitle.BackgroundTransparency = 1
HwidTitle.Text = "HWID"
HwidTitle.TextColor3 = Colors.TextSecondary
HwidTitle.Font = Enum.Font.GothamMedium
HwidTitle.TextSize = 11
HwidTitle.TextXAlignment = Enum.TextXAlignment.Left
HwidTitle.Parent = HwidContainer

local fullHWID = "Unknown"
pcall(function() fullHWID = gethwid() end)

local HwidValue = Instance.new("TextLabel")
HwidValue.Size = UDim2.new(1, -24, 0, 18)
HwidValue.Position = UDim2.new(0, 0, 0, 16)
HwidValue.BackgroundTransparency = 1
HwidValue.Text = string.rep("•", 18)
HwidValue.TextColor3 = Colors.TextSecondary
HwidValue.Font = Enum.Font.GothamBold
HwidValue.TextSize = 16
HwidValue.TextXAlignment = Enum.TextXAlignment.Left
HwidValue.Parent = HwidContainer

local CopyHwidBtn = Instance.new("ImageButton")
CopyHwidBtn.Size = UDim2.new(0, 18, 0, 18)
CopyHwidBtn.Position = UDim2.new(1, 0, 0, 16)
CopyHwidBtn.AnchorPoint = Vector2.new(1, 0)
CopyHwidBtn.BackgroundTransparency = 1
CopyHwidBtn.Image = asset_mgr.get("copy")
CopyHwidBtn.ImageColor3 = Colors.TextSecondary
CopyHwidBtn.Parent = HwidContainer

CopyHwidBtn.MouseEnter:Connect(function()
    TweenService:Create(CopyHwidBtn, TweenInfo.new(0.2), {ImageColor3 = Colors.Accent}):Play()
end)
CopyHwidBtn.MouseLeave:Connect(function()
    TweenService:Create(CopyHwidBtn, TweenInfo.new(0.2), {ImageColor3 = Colors.TextSecondary}):Play()
end)
CopyHwidBtn.MouseButton1Click:Connect(function()
    setclipboard(fullHWID)
    TweenService:Create(CopyHwidBtn, TweenInfo.new(0.1), {ImageColor3 = Colors.Success}):Play()
    task.delay(0.3, function()
        TweenService:Create(CopyHwidBtn, TweenInfo.new(0.2), {ImageColor3 = Colors.TextSecondary}):Play()
    end)
    Notify("Copied", "HWID has been copied to your clipboard.", "Info", 3)
end)

CreateDivider(8).Parent = UserPanel

local ClockContainer = Instance.new("Frame")
ClockContainer.Size = UDim2.new(1, 0, 0, 40)
ClockContainer.BackgroundTransparency = 1
ClockContainer.LayoutOrder = 9
ClockContainer.Parent = UserPanel

local ClockRow = Instance.new("Frame")
ClockRow.Size = UDim2.new(1, 0, 0, 20)
ClockRow.BackgroundTransparency = 1
ClockRow.Parent = ClockContainer

local ClockLayout = Instance.new("UIListLayout")
ClockLayout.FillDirection = Enum.FillDirection.Horizontal
ClockLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
ClockLayout.VerticalAlignment = Enum.VerticalAlignment.Center
ClockLayout.Padding = UDim.new(0, 6)
ClockLayout.Parent = ClockRow

local ClockIcon = Instance.new("ImageLabel")
ClockIcon.Size = UDim2.new(0, 18, 0, 18)
ClockIcon.BackgroundTransparency = 1
ClockIcon.Image = asset_mgr.get("clock")
ClockIcon.ImageColor3 = Colors.Accent
ClockIcon.Parent = ClockRow

local ClockTime = Instance.new("TextLabel")
ClockTime.Size = UDim2.new(0, 0, 1, 0)
ClockTime.AutomaticSize = Enum.AutomaticSize.X
ClockTime.BackgroundTransparency = 1
ClockTime.Text = "00:00:00 AM"
ClockTime.TextColor3 = Colors.Accent
ClockTime.Font = Enum.Font.GothamBold
ClockTime.TextSize = 18
ClockTime.Parent = ClockRow

local ClockDate = Instance.new("TextLabel")
ClockDate.Size = UDim2.new(1, 0, 0, 14)
ClockDate.Position = UDim2.new(0, 0, 0, 24)
ClockDate.BackgroundTransparency = 1
ClockDate.Text = "Loading..."
ClockDate.TextColor3 = Colors.TextSecondary
ClockDate.Font = Enum.Font.GothamMedium
ClockDate.TextSize = 12
ClockDate.TextXAlignment = Enum.TextXAlignment.Center
ClockDate.Parent = ClockContainer

local isClockRunning = true
task.spawn(function()
    while isClockRunning do
        if not ClockTime.Parent then isClockRunning = false break end
        local timeT = os.date("*t")
        local ampm = timeT.hour >= 12 and "PM" or "AM"
        local h = timeT.hour % 12
        if h == 0 then h = 12 end
        ClockTime.Text = string.format("%d:%02d:%02d %s", h, timeT.min, timeT.sec, ampm)
        ClockDate.Text = os.date("%b %d, %Y")
        task.wait(1)
    end
end)

local TopBar = Instance.new("Frame")
TopBar.Size = UDim2.new(1, 0, 0, 3)
TopBar.Position = UDim2.new(0, 0, 0, 0)
TopBar.BackgroundColor3 = Colors.Accent
TopBar.BorderSizePixel = 0
TopBar.ZIndex = 2
TopBar.Parent = MainCard

local UIScale = Instance.new("UIScale")
UIScale.Scale = 0.8
UIScale.Parent = MainContainer

local function UpdateScale()
    local viewport = workspace.CurrentCamera.ViewportSize
    local width = viewport.X
    local height = viewport.Y
    if width < 500 or height < 500 then
        UIScale.Scale = math.clamp(math.min(width / 380, height / 380), 0.6, 0.9)
    else
        UIScale.Scale = 1
    end
end
workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(UpdateScale)

TweenService:Create(UIScale, TweenInfo.new(0.6, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Scale = 1}):Play()
TweenService:Create(MainCard, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 0}):Play()
TweenService:Create(CardStroke, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Transparency = 0}):Play()

UpdateScale()

local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, 80)
Header.Position = UDim2.new(0, 0, 0, 0)
Header.BackgroundTransparency = 1
Header.Parent = MainCard

local ServerIcon = Instance.new("ImageLabel")
ServerIcon.Size = UDim2.new(0, 42, 0, 42)
ServerIcon.Position = UDim2.new(0, 20, 0.5, 0)
ServerIcon.AnchorPoint = Vector2.new(0, 0.5)
ServerIcon.BackgroundTransparency = 1
ServerIcon.Image = asset_mgr.get("pulsarx")
ServerIcon.Parent = Header

local ServerIconCorner = Instance.new("UICorner")
ServerIconCorner.CornerRadius = UDim.new(0, 10)
ServerIconCorner.Parent = ServerIcon

local HeaderTitleText = Instance.new("TextLabel")
HeaderTitleText.Position = UDim2.new(0, 75, 0.5, -10)
HeaderTitleText.AnchorPoint = Vector2.new(0, 0.5)
HeaderTitleText.Size = UDim2.new(0, 200, 0, 20)
HeaderTitleText.BackgroundTransparency = 1
HeaderTitleText.Text = Config.HeaderTitle
HeaderTitleText.TextColor3 = Colors.TextPrimary
HeaderTitleText.Font = Enum.Font.GothamBlack
HeaderTitleText.TextSize = 18
HeaderTitleText.TextXAlignment = Enum.TextXAlignment.Left
HeaderTitleText.Parent = Header

local SubText = Instance.new("TextLabel")
SubText.Position = UDim2.new(0, 75, 0.5, 10)
SubText.AnchorPoint = Vector2.new(0, 0.5)
SubText.Size = UDim2.new(0, 200, 0, 14)
SubText.BackgroundTransparency = 1
SubText.Text = Config.Subtitle
SubText.TextColor3 = Colors.TextSecondary
SubText.Font = Enum.Font.GothamMedium
SubText.TextSize = 11
SubText.TextXAlignment = Enum.TextXAlignment.Left
SubText.Parent = Header

local CustomCloseBtn = Instance.new("TextButton")
CustomCloseBtn.Size = UDim2.new(0, 26, 0, 26)
CustomCloseBtn.Position = UDim2.new(1, -20, 0.5, 0)
CustomCloseBtn.AnchorPoint = Vector2.new(1, 0.5)
CustomCloseBtn.BackgroundColor3 = Colors.SecondaryBG
CustomCloseBtn.Text = ""
CustomCloseBtn.AutoButtonColor = false
CustomCloseBtn.Parent = Header

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 6)
CloseCorner.Parent = CustomCloseBtn

local CloseStroke = Instance.new("UIStroke")
CloseStroke.Color = Colors.Stroke
CloseStroke.Thickness = 1
CloseStroke.Parent = CustomCloseBtn

local CloseIcon = Instance.new("ImageLabel")
CloseIcon.Size = UDim2.new(0, 14, 0, 14)
CloseIcon.Position = UDim2.new(0.5, 0, 0.5, 0)
CloseIcon.AnchorPoint = Vector2.new(0.5, 0.5)
CloseIcon.BackgroundTransparency = 1
CloseIcon.Image = asset_mgr.get("x")
CloseIcon.ImageColor3 = Colors.TextSecondary
CloseIcon.Parent = CustomCloseBtn

local isUserPanelOpen = false

local function CleanDestroy()
    if isUserPanelOpen then
        TweenService:Create(UserPanel, TweenInfo.new(0.3, Enum.EasingStyle.Exponential, Enum.EasingDirection.In), {Size = UDim2.new(0, 0, 1, 0)}):Play()
        TweenService:Create(UserPanelStroke, TweenInfo.new(0.3), {Transparency = 1}):Play()
    end
    TweenService:Create(UIScale, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.In), {Scale = 0.8}):Play()
    TweenService:Create(MainCard, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {BackgroundTransparency = 1}):Play()
    TweenService:Create(CardStroke, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Transparency = 1}):Play()
    TweenService:Create(PulsarBlur, TweenInfo.new(0.5, Enum.EasingStyle.Exponential, Enum.EasingDirection.In), {Size = 0}):Play()
    
    task.wait(0.5)
    if PulsarBlur then PulsarBlur:Destroy() end
    ScreenGui:Destroy()
end

CustomCloseBtn.MouseButton1Click:Connect(CleanDestroy)

CustomCloseBtn.MouseEnter:Connect(function()
    TweenService:Create(CustomCloseBtn, TweenInfo.new(0.2), {BackgroundColor3 = Colors.Error}):Play()
    TweenService:Create(CloseIcon, TweenInfo.new(0.2), {ImageColor3 = Colors.TextPrimary}):Play()
    TweenService:Create(CloseStroke, TweenInfo.new(0.2), {Transparency = 1}):Play()
end)
CustomCloseBtn.MouseLeave:Connect(function()
    TweenService:Create(CustomCloseBtn, TweenInfo.new(0.2), {BackgroundColor3 = Colors.SecondaryBG}):Play()
    TweenService:Create(CloseIcon, TweenInfo.new(0.2), {ImageColor3 = Colors.TextSecondary}):Play()
    TweenService:Create(CloseStroke, TweenInfo.new(0.2), {Transparency = 0}):Play()
end)

local BodyFrame = Instance.new("Frame")
BodyFrame.Size = UDim2.new(1, -40, 1, -80)
BodyFrame.Position = UDim2.new(0, 20, 0, 80)
BodyFrame.BackgroundTransparency = 1
BodyFrame.Parent = MainCard

local StatusFrame = Instance.new("Frame")
StatusFrame.Size = UDim2.new(1, 0, 0, 40)
StatusFrame.Position = UDim2.new(0, 0, 0, 0)
StatusFrame.BackgroundColor3 = Colors.SecondaryBG
StatusFrame.BorderSizePixel = 0
StatusFrame.Parent = BodyFrame

local StatusCorner = Instance.new("UICorner")
StatusCorner.CornerRadius = UDim.new(0, 8)
StatusCorner.Parent = StatusFrame

local StatusStroke = Instance.new("UIStroke")
StatusStroke.Color = Colors.Stroke
StatusStroke.Thickness = 1
StatusStroke.Parent = StatusFrame

local StatusIcon = Instance.new("ImageLabel")
StatusIcon.Size = UDim2.new(0, 16, 0, 16)
StatusIcon.Position = UDim2.new(0, 12, 0.5, 0)
StatusIcon.AnchorPoint = Vector2.new(0, 0.5)
StatusIcon.BackgroundTransparency = 1
StatusIcon.Image = asset_mgr.get("shield")
StatusIcon.ImageColor3 = Colors.Warn
StatusIcon.Parent = StatusFrame

local StatusText = Instance.new("TextLabel")
StatusText.Size = UDim2.new(1, -40, 1, 0)
StatusText.Position = UDim2.new(0, 36, 0, 0)
StatusText.BackgroundTransparency = 1
StatusText.Text = "Waiting for authorization..."
StatusText.TextColor3 = Colors.TextSecondary
StatusText.Font = Enum.Font.GothamMedium
StatusText.TextSize = 12
StatusText.TextXAlignment = Enum.TextXAlignment.Left
StatusText.Parent = StatusFrame

local InputLabel = Instance.new("TextLabel")
InputLabel.Size = UDim2.new(1, 0, 0, 20)
InputLabel.Position = UDim2.new(0, 2, 0, 50)
InputLabel.BackgroundTransparency = 1
InputLabel.Text = "LICENSE KEY"
InputLabel.TextColor3 = Colors.TextSecondary
InputLabel.Font = Enum.Font.GothamBold
InputLabel.TextSize = 10
InputLabel.TextXAlignment = Enum.TextXAlignment.Left
InputLabel.Parent = BodyFrame

local InputFrame = Instance.new("Frame")
InputFrame.Size = UDim2.new(1, 0, 0, 46)
InputFrame.Position = UDim2.new(0, 0, 0, 70)
InputFrame.BackgroundColor3 = Colors.TertiaryBG
InputFrame.BorderSizePixel = 0
InputFrame.Parent = BodyFrame

local InputCorner = Instance.new("UICorner")
InputCorner.CornerRadius = UDim.new(0, 8)
InputCorner.Parent = InputFrame

local InputStroke = Instance.new("UIStroke")
InputStroke.Color = Colors.Stroke
InputStroke.Thickness = 1
InputStroke.Parent = InputFrame

local KeyIcon = Instance.new("ImageLabel")
KeyIcon.Size = UDim2.new(0, 18, 0, 18)
KeyIcon.Position = UDim2.new(0, 12, 0.5, 0)
KeyIcon.AnchorPoint = Vector2.new(0, 0.5)
KeyIcon.BackgroundTransparency = 1
KeyIcon.Image = asset_mgr.get("key")
KeyIcon.ImageColor3 = Colors.TextSecondary
KeyIcon.Parent = InputFrame

local KeyInput = Instance.new("TextBox")
KeyInput.Size = UDim2.new(1, -40, 1, 0)
KeyInput.Position = UDim2.new(0, 38, 0, 0)
KeyInput.BackgroundTransparency = 1
KeyInput.Text = ""
KeyInput.PlaceholderText = "Paste your key here..."
KeyInput.PlaceholderColor3 = Color3.fromRGB(100, 110, 130)
KeyInput.TextColor3 = Colors.TextPrimary
KeyInput.Font = Enum.Font.GothamMedium
KeyInput.TextSize = 13
KeyInput.TextXAlignment = Enum.TextXAlignment.Left
KeyInput.ClearTextOnFocus = false
KeyInput.Parent = InputFrame

KeyInput:GetPropertyChangedSignal("Text"):Connect(function()
    if #KeyInput.Text > 32 then
        KeyInput.Text = string.sub(KeyInput.Text, 1, 32)
    end
end)

KeyInput.Focused:Connect(function()
    TweenService:Create(InputStroke, TweenInfo.new(0.3, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {Color = Colors.Accent}):Play()
    TweenService:Create(KeyIcon, TweenInfo.new(0.3), {ImageColor3 = Colors.Accent}):Play()
end)

KeyInput.FocusLost:Connect(function()
    TweenService:Create(InputStroke, TweenInfo.new(0.3, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {Color = Colors.Stroke}):Play()
    TweenService:Create(KeyIcon, TweenInfo.new(0.3), {ImageColor3 = Colors.TextSecondary}):Play()
end)

local AcquireBtn = Instance.new("TextButton")
AcquireBtn.Size = UDim2.new(1, 0, 0, 42)
AcquireBtn.Position = UDim2.new(0, 0, 0, 130)
AcquireBtn.BackgroundColor3 = Colors.SecondaryBG
AcquireBtn.Text = ""
AcquireBtn.AutoButtonColor = false
AcquireBtn.Parent = BodyFrame

local AcquireCorner = Instance.new("UICorner")
AcquireCorner.CornerRadius = UDim.new(0, 8)
AcquireCorner.Parent = AcquireBtn

local AcquireStroke = Instance.new("UIStroke")
AcquireStroke.Color = Colors.Stroke
AcquireStroke.Thickness = 1
AcquireStroke.Parent = AcquireBtn

local AcquireContent = Instance.new("Frame")
AcquireContent.Size = UDim2.new(1, 0, 1, 0)
AcquireContent.BackgroundTransparency = 1
AcquireContent.Parent = AcquireBtn

local AcquireLayout = Instance.new("UIListLayout")
AcquireLayout.FillDirection = Enum.FillDirection.Horizontal
AcquireLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
AcquireLayout.VerticalAlignment = Enum.VerticalAlignment.Center
AcquireLayout.Padding = UDim.new(0, 8)
AcquireLayout.Parent = AcquireContent

local AcquireIcon = Instance.new("ImageLabel")
AcquireIcon.Size = UDim2.new(0, 16, 0, 16)
AcquireIcon.BackgroundTransparency = 1
AcquireIcon.Image = asset_mgr.get("external-link")
AcquireIcon.ImageColor3 = Colors.TextPrimary
AcquireIcon.LayoutOrder = 1
AcquireIcon.Parent = AcquireContent

local AcquireText = Instance.new("TextLabel")
AcquireText.Size = UDim2.new(0, 0, 0, 20)
AcquireText.AutomaticSize = Enum.AutomaticSize.X
AcquireText.BackgroundTransparency = 1
AcquireText.Text = "Get Key"
AcquireText.TextColor3 = Colors.TextPrimary
AcquireText.Font = Enum.Font.GothamBold
AcquireText.TextSize = 13
AcquireText.LayoutOrder = 2
AcquireText.Parent = AcquireContent

AcquireBtn.MouseEnter:Connect(function()
    TweenService:Create(AcquireBtn, TweenInfo.new(0.3), {BackgroundColor3 = Colors.TertiaryBG}):Play()
    TweenService:Create(AcquireStroke, TweenInfo.new(0.3), {Color = Colors.TextSecondary}):Play()
end)
AcquireBtn.MouseLeave:Connect(function()
    TweenService:Create(AcquireBtn, TweenInfo.new(0.3), {BackgroundColor3 = Colors.SecondaryBG}):Play()
    TweenService:Create(AcquireStroke, TweenInfo.new(0.3), {Color = Colors.Stroke}):Play()
end)

AcquireBtn.MouseButton1Click:Connect(function()
    setclipboard(Config.KeyLink)
    SpamSafeNotify("Link Copied", "The key link has been copied to your clipboard.", "Success", 3)
end)

local RedeemBtn = Instance.new("TextButton")
RedeemBtn.Size = UDim2.new(1, 0, 0, 42)
RedeemBtn.Position = UDim2.new(0, 0, 0, 180)
RedeemBtn.BackgroundColor3 = Colors.Accent
RedeemBtn.Text = ""
RedeemBtn.AutoButtonColor = false
RedeemBtn.Parent = BodyFrame

local RedeemCorner = Instance.new("UICorner")
RedeemCorner.CornerRadius = UDim.new(0, 8)
RedeemCorner.Parent = RedeemBtn

local RedeemContent = Instance.new("Frame")
RedeemContent.Size = UDim2.new(1, 0, 1, 0)
RedeemContent.BackgroundTransparency = 1
RedeemContent.Parent = RedeemBtn

local RedeemLayout = Instance.new("UIListLayout")
RedeemLayout.FillDirection = Enum.FillDirection.Horizontal
RedeemLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
RedeemLayout.VerticalAlignment = Enum.VerticalAlignment.Center
RedeemLayout.Padding = UDim.new(0, 8)
RedeemLayout.Parent = RedeemContent

local RedeemIcon = Instance.new("ImageLabel")
RedeemIcon.Size = UDim2.new(0, 16, 0, 16)
RedeemIcon.BackgroundTransparency = 1
RedeemIcon.Image = asset_mgr.get("book-key")
RedeemIcon.ImageColor3 = Colors.TextPrimary
RedeemIcon.LayoutOrder = 1
RedeemIcon.Parent = RedeemContent

local RedeemText = Instance.new("TextLabel")
RedeemText.Size = UDim2.new(0, 0, 0, 20)
RedeemText.AutomaticSize = Enum.AutomaticSize.X
RedeemText.BackgroundTransparency = 1
RedeemText.Text = "Verify Key"
RedeemText.TextColor3 = Colors.TextPrimary
RedeemText.Font = Enum.Font.GothamBold
RedeemText.TextSize = 13
RedeemText.LayoutOrder = 2
RedeemText.Parent = RedeemContent

RedeemBtn.MouseEnter:Connect(function()
    TweenService:Create(RedeemBtn, TweenInfo.new(0.3, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {BackgroundColor3 = Colors.AccentGlow}):Play()
end)
RedeemBtn.MouseLeave:Connect(function()
    TweenService:Create(RedeemBtn, TweenInfo.new(0.3, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {BackgroundColor3 = Colors.Accent}):Play()
end)

local Divider = Instance.new("Frame")
Divider.Size = UDim2.new(1, 0, 0, 1)
Divider.Position = UDim2.new(0, 0, 1, -45)
Divider.BackgroundColor3 = Colors.Stroke
Divider.BorderSizePixel = 0
Divider.Parent = BodyFrame

local LinksContainer = Instance.new("Frame")
LinksContainer.Size = UDim2.new(1, 0, 0, 30)
LinksContainer.Position = UDim2.new(0, 0, 1, -35)
LinksContainer.BackgroundTransparency = 1
LinksContainer.Parent = BodyFrame

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.FillDirection = Enum.FillDirection.Horizontal
UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 10)
UIListLayout.Parent = LinksContainer

local function CreateLinkButton(text, iconId)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 70, 1, 0)
    btn.BackgroundTransparency = 1
    btn.Text = ""
    
    local layout = Instance.new("UIListLayout")
    layout.FillDirection = Enum.FillDirection.Horizontal
    layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    layout.VerticalAlignment = Enum.VerticalAlignment.Center
    layout.Padding = UDim.new(0, 6)
    layout.Parent = btn
    
    local icon = Instance.new("ImageLabel")
    icon.Size = UDim2.new(0, 14, 0, 14)
    icon.BackgroundTransparency = 1
    icon.Image = asset_mgr.get(iconId)
    icon.ImageColor3 = Colors.TextSecondary
    icon.Parent = btn
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0, 0, 1, 0)
    label.AutomaticSize = Enum.AutomaticSize.X
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Colors.TextSecondary
    label.Font = Enum.Font.GothamMedium
    label.TextSize = 11
    label.Parent = btn

    btn.MouseEnter:Connect(function()
        TweenService:Create(icon, TweenInfo.new(0.2), {ImageColor3 = Colors.TextPrimary}):Play()
        TweenService:Create(label, TweenInfo.new(0.2), {TextColor3 = Colors.TextPrimary}):Play()
    end)
    btn.MouseLeave:Connect(function()
        TweenService:Create(icon, TweenInfo.new(0.2), {ImageColor3 = Colors.TextSecondary}):Play()
        TweenService:Create(label, TweenInfo.new(0.2), {TextColor3 = Colors.TextSecondary}):Play()
    end)
    
    return btn
end

local ResetHwidBtn = CreateLinkButton("Reset HWID", "book-lock")
ResetHwidBtn.Parent = LinksContainer

local DiscordBtn = CreateLinkButton("Discord", "gamepad-2")
DiscordBtn.Parent = LinksContainer

local ProfileBtn = CreateLinkButton("User Info", "user")
ProfileBtn.Parent = LinksContainer

local lastNotifyTime = 0
local function SpamSafeNotify(title, msg, type, dur)
    if os.clock() - lastNotifyTime < 2 then return end
    lastNotifyTime = os.clock()
    Notify(title, msg, type, dur)
end

ResetHwidBtn.MouseButton1Click:Connect(function()
    setclipboard(Config.ResetHWIDLink)
    SpamSafeNotify("Link Copied", "Reset HWID URL copied to clipboard.", "Warn", 3)
end)

DiscordBtn.MouseButton1Click:Connect(function()
    setclipboard(Config.DiscordLink)
    SpamSafeNotify("Discord Copied", "Join our community! Link copied.", "Success", 3)
end)

ProfileBtn.MouseButton1Click:Connect(function()
    isUserPanelOpen = not isUserPanelOpen
    if isUserPanelOpen then
        TweenService:Create(UserPanelStroke, TweenInfo.new(0.2), {Transparency = 0}):Play()
        TweenService:Create(UserPanel, TweenInfo.new(0.5, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {Size = UDim2.new(0, 200, 1, 0)}):Play()
        TweenService:Create(MainContainer, TweenInfo.new(0.5, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {Position = UDim2.new(0.5, -100, 0.5, 0)}):Play()
    else
        TweenService:Create(UserPanelStroke, TweenInfo.new(0.2), {Transparency = 1}):Play()
        TweenService:Create(UserPanel, TweenInfo.new(0.5, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {Size = UDim2.new(0, 0, 1, 0)}):Play()
        TweenService:Create(MainContainer, TweenInfo.new(0.5, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {Position = UDim2.new(0.5, 0, 0.5, 0)}):Play()
    end
end)

local StatusSpinTween = nil

local function ResetStatus()
    if StatusSpinTween then StatusSpinTween:Cancel() end
    TweenService:Create(StatusIcon, TweenInfo.new(0.3), {Rotation = 0}):Play()
    StatusText.Text = "Waiting for authorization..."
    StatusText.TextColor3 = Colors.TextSecondary
    StatusIcon.Image = asset_mgr.get("shield")
    StatusIcon.ImageColor3 = Colors.Warn
    TweenService:Create(StatusStroke, TweenInfo.new(0.3), {Color = Colors.Stroke}):Play()
end

local function SetStatusLoading()
    StatusText.Text = "Authenticating with server..."
    StatusText.TextColor3 = Colors.TextPrimary
    StatusIcon.Image = asset_mgr.get("loader-2")
    StatusIcon.ImageColor3 = Colors.Accent
    TweenService:Create(StatusStroke, TweenInfo.new(0.3), {Color = Colors.Accent}):Play()
    StatusSpinTween = TweenService:Create(StatusIcon, TweenInfo.new(1, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1), {Rotation = 360})
    StatusSpinTween:Play()
end

local isShaking = false
local function ShakeInput()
    if isShaking then return end
    isShaking = true
    local originalPos = UDim2.new(0, 0, 0, 70)
    for i = 1, 4 do
        TweenService:Create(InputFrame, TweenInfo.new(0.05), {Position = originalPos + UDim2.new(0, (i % 2 == 0) and -6 or 6, 0, 0)}):Play()
        task.wait(0.05)
    end
    TweenService:Create(InputFrame, TweenInfo.new(0.05), {Position = originalPos}):Play()
    TweenService:Create(InputStroke, TweenInfo.new(0.3), {Color = Colors.Error}):Play()
    task.delay(1.5, function()
        TweenService:Create(InputStroke, TweenInfo.new(0.3), {Color = Colors.Stroke}):Play()
        isShaking = false
    end)
end

local isAuthenticating = false
local function ValidateKey(userKey)
    if isAuthenticating then return end
    isAuthenticating = true
    
    if not isSupported then
        Notify("Unsupported", "This game is not currently supported by Pulsar X.", "Error", 5)
        return
    end

    if typeof(userKey) ~= "string" or #userKey < 10 then
        Notify("Invalid Input", "Please enter a valid key format.", "Error", 4)
        ShakeInput()
        isAuthenticating = false
        return
    end

    userKey = userKey:gsub('"', ""):gsub("^%s+", ""):gsub("%s+$", "")

    RedeemText.Text = "Verifying..."
    SetStatusLoading()

    local success, status = pcall(function()
        return api.check_key(userKey)
    end)

    if not success then
        if StatusSpinTween then StatusSpinTween:Cancel() end
        StatusIcon.Rotation = 0
        Notify("Connection Error", "Failed to reach the authentication servers.", "Error", 4)
        StatusText.Text = "Connection Failed"
        StatusText.TextColor3 = Colors.Error
        StatusIcon.Image = asset_mgr.get("wifi-off")
        StatusIcon.ImageColor3 = Colors.Error
        TweenService:Create(StatusStroke, TweenInfo.new(0.3), {Color = Colors.Error}):Play()
        
        task.delay(3, ResetStatus)
        RedeemText.Text = "Verify Key"
        ShakeInput()
        isAuthenticating = false
        return
    end

    if status.code == "KEY_VALID" then
        if StatusSpinTween then StatusSpinTween:Cancel() end
        StatusIcon.Rotation = 0
        
        Notify("Access Granted", "Welcome back. Initiating systems...", "Success", 5)
        RedeemText.Text = "Success!"
        StatusText.Text = "Key Verified. Loading script..."
        StatusText.TextColor3 = Colors.Success
        StatusIcon.Image = asset_mgr.get("check")
        StatusIcon.ImageColor3 = Colors.Success
        
        TweenService:Create(StatusStroke, TweenInfo.new(0.5), {Color = Colors.Success}):Play()
        TweenService:Create(TopBar, TweenInfo.new(0.5), {BackgroundColor3 = Colors.Success}):Play()

        if writefile then
            writefile(Config.FileName, userKey)
        end

        task.spawn(function()
            getgenv().script_key = userKey
            if not getgenv().script_key then
                script_key = userKey
            end
            api.load_script()
        end)

        task.wait(1.5)
        CleanDestroy()
    else
        local errorMap = {
            ["KEY_EXPIRED"] = "Your key has expired.",
            ["KEY_HWID_LOCKED"] = "Key locked to another HWID.",
            ["KEY_INCORRECT"] = "The key provided is incorrect.",
            ["KEY_BANNED"] = "This key has been blacklisted.",
            ["KEY_INVALID"] = "Invalid key format detected."
        }
        
        local errorText = errorMap[status.code] or "Unknown Validation Error"
        
        if StatusSpinTween then StatusSpinTween:Cancel() end
        StatusIcon.Rotation = 0
        RedeemText.Text = "Verify Key"

        Notify("Authentication Failed", errorText, "Error", 5)
        StatusText.Text = errorText
        StatusText.TextColor3 = Colors.Error
        StatusIcon.Image = asset_mgr.get("alert-circle")
        StatusIcon.ImageColor3 = Colors.Error
        TweenService:Create(StatusStroke, TweenInfo.new(0.3), {Color = Colors.Error}):Play()
        
        ShakeInput()
        task.delay(3, ResetStatus)
        isAuthenticating = false
    end
end

RedeemBtn.MouseButton1Click:Connect(function()
    local userKey = KeyInput.Text:gsub(" ", "")
    ValidateKey(userKey)
end)

task.spawn(function()
    local foundKey = nil
    if getgenv().script_key and #getgenv().script_key > 0 then
        foundKey = getgenv().script_key
    elseif script_key and #script_key > 0 then
        foundKey = script_key
    elseif isfile and isfile(Config.FileName) then
        local content = readfile(Config.FileName)
        if content and #content > 0 then
            foundKey = content
        end
    end

    if foundKey and #foundKey > 0 then
        KeyInput.Text = foundKey
        Notify("Auto-Login", "Found saved key, validating...", "Warn", 3)
        ValidateKey(foundKey)
    end
end)
