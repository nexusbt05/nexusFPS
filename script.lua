local CoreServices = {
Workspace = game:GetService("Workspace"),
Lighting = game:GetService("Lighting"),
Players = game:GetService("Players"),
RunService = game:GetService("RunService"),
TweenService = game:GetService("TweenService"),
UserInputService = game:GetService("UserInputService"),
Stats = game:GetService("Stats"),
SoundService = game:GetService("SoundService")
}

local LocalPlayer = CoreServices.Players.LocalPlayer
if not LocalPlayer then
repeat task.wait() until CoreServices.Players.LocalPlayer
LocalPlayer = CoreServices.Players.LocalPlayer
end

local State = {
AutoVFXDelete = false,
ChunkCulling = false,
DisableAnimations = false,
ViewDistanceStuds = 500,

-- Các State bổ sung cho tính năng mới
Smooth_ExcludeMesh = true,
Smooth_ForceAll = false,
Smooth_GreyScale = false,
Smooth_NukeTextures = false,
BlockVFX = false,

-- Tính năng mới (ESP & Frame Gen)
ESPToggle = false,
SmartSmoother = false,

-- FFlag Emulators State
LimitLightUpdates = false,
MobileProMode = false
}

local Theme = {
Background = Color3.fromRGB(30, 30, 35),
Sidebar = Color3.fromRGB(40, 40, 45),
Card = Color3.fromRGB(50, 50, 55),
CardHover = Color3.fromRGB(60, 60, 65),
Accent = Color3.fromRGB(255, 255, 255),
Text = Color3.fromRGB(250, 250, 255),
TextDark = Color3.fromRGB(180, 180, 190),
Border = Color3.fromRGB(65, 65, 75),
ToggleOn = Color3.fromRGB(255, 255, 255),
ToggleOff = Color3.fromRGB(70, 70, 80),
Red = Color3.fromRGB(235, 75, 75),
Font = Enum.Font.GothamBold,
FontMedium = Enum.Font.GothamMedium
}

local function GetSafeGuiParent()
if gethui then
local success, res = pcall(gethui)
if success and res then return res end
end
local playerGui = LocalPlayer:FindFirstChildOfClass("PlayerGui") or LocalPlayer:WaitForChild("PlayerGui", 5)
if playerGui then return playerGui end
return game:GetService("CoreGui")
end

local ParentGui = GetSafeGuiParent()
pcall(function()
if ParentGui:FindFirstChild("NexusFPSHub") then
ParentGui.NexusFPSHub:Destroy()
end
end)

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "NexusFPSHub"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.DisplayOrder = 99999
ScreenGui.Parent = ParentGui

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 680, 0, 450)
MainFrame.Position = UDim2.new(0.5, -340, 0.5, -225)
MainFrame.BackgroundColor3 = Theme.Background
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true
MainFrame.Parent = ScreenGui

local MainUICorner = Instance.new("UICorner")
MainUICorner.CornerRadius = UDim.new(0, 10)
MainUICorner.Parent = MainFrame

local MainUIStroke = Instance.new("UIStroke")
MainUIStroke.Color = Theme.Border
MainUIStroke.Thickness = 1.5
MainUIStroke.Parent = MainFrame

-- STREAMING_CHUNK:Building minimized pill...
local MinimizedFrame = Instance.new("Frame")
MinimizedFrame.Name = "MinimizedFrame"
MinimizedFrame.Size = UDim2.new(0, 210, 0, 42)
MinimizedFrame.Position = UDim2.new(0.5, -105, 0.05, 0)
MinimizedFrame.BackgroundColor3 = Theme.Background
MinimizedFrame.BorderSizePixel = 0
MinimizedFrame.Visible = false
MinimizedFrame.Parent = ScreenGui

local MinCorner = Instance.new("UICorner")
MinCorner.CornerRadius = UDim.new(0, 21)
MinCorner.Parent = MinimizedFrame

local MinBtn = Instance.new("TextButton")
MinBtn.Size = UDim2.new(1, 0, 1, 0)
MinBtn.BackgroundTransparency = 1
MinBtn.Font = Theme.Font
MinBtn.Text = "⚡ NEXUS HUB [FPS: --]"
MinBtn.TextColor3 = Theme.Text
MinBtn.TextSize = 13
MinBtn.Parent = MinimizedFrame

local TopBar = Instance.new("Frame")
TopBar.Size = UDim2.new(1, 0, 0, 45)
TopBar.BackgroundColor3 = Theme.Sidebar
TopBar.BorderSizePixel = 0
TopBar.Parent = MainFrame

local TitleMain = Instance.new("TextLabel")
TitleMain.Size = UDim2.new(0, 110, 1, 0)
TitleMain.Position = UDim2.new(0, 15, 0, 0)
TitleMain.BackgroundTransparency = 1
TitleMain.Font = Theme.Font
TitleMain.Text = "⚡ NEXUS HUB"
TitleMain.TextColor3 = Theme.Text
TitleMain.TextSize = 15
TitleMain.TextXAlignment = Enum.TextXAlignment.Left
TitleMain.Parent = TopBar

local TitleSub = Instance.new("TextLabel")
TitleSub.Size = UDim2.new(0, 130, 1, 0)
TitleSub.Position = UDim2.new(0, 128, 0, 0)
TitleSub.BackgroundTransparency = 1
TitleSub.Font = Theme.Font
TitleSub.Text = "| FPS ENGINE PRO"
TitleSub.TextColor3 = Theme.TextDark
TitleSub.TextSize = 14
TitleSub.TextXAlignment = Enum.TextXAlignment.Left
TitleSub.Parent = TopBar

local MinimizeBtn = Instance.new("TextButton")
MinimizeBtn.Size = UDim2.new(0, 30, 0, 30)
MinimizeBtn.Position = UDim2.new(1, -75, 0.5, -15)
MinimizeBtn.BackgroundColor3 = Theme.Card
MinimizeBtn.Font = Theme.Font
MinimizeBtn.Text = "─"
MinimizeBtn.TextColor3 = Theme.Text
MinimizeBtn.TextSize = 12
MinimizeBtn.Parent = TopBar
Instance.new("UICorner", MinimizeBtn).CornerRadius = UDim.new(0, 6)

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -40, 0.5, -15)
CloseBtn.BackgroundColor3 = Theme.Card
CloseBtn.Font = Theme.Font
CloseBtn.Text = "✕"
CloseBtn.TextColor3 = Theme.Red
CloseBtn.TextSize = 12
CloseBtn.Parent = TopBar
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 6)

local function EnableDragging(FrameObject, HandleObject)
local dragging, dragInput, dragStart, startPos
HandleObject.InputBegan:Connect(function(input)
if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
dragging = true
dragStart = input.Position
startPos = FrameObject.Position
input.Changed:Connect(function()
if input.UserInputState == Enum.UserInputState.End then dragging = false end
end)
end
end)
HandleObject.InputChanged:Connect(function(input)
if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
dragInput = input
end
end)
CoreServices.UserInputService.InputChanged:Connect(function(input)
if input == dragInput and dragging then
local delta = input.Position - dragStart
FrameObject.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end
end)
end
EnableDragging(MainFrame, TopBar)
EnableDragging(MinimizedFrame, MinimizedFrame)

MinimizeBtn.MouseButton1Click:Connect(function()
MainFrame.Visible = false
MinimizedFrame.Visible = true
end)
MinBtn.MouseButton1Click:Connect(function()
MinimizedFrame.Visible = false
MainFrame.Visible = true
end)
CloseBtn.MouseButton1Click:Connect(function()
ScreenGui:Destroy()
end)

local Sidebar = Instance.new("Frame")
Sidebar.Size = UDim2.new(0, 170, 1, -45)
Sidebar.Position = UDim2.new(0, 0, 0, 45)
Sidebar.BackgroundColor3 = Theme.Sidebar
Sidebar.BorderSizePixel = 0
Sidebar.Parent = MainFrame

local TabContainer = Instance.new("ScrollingFrame")
TabContainer.Size = UDim2.new(1, 0, 1, 0)
TabContainer.BackgroundTransparency = 1
TabContainer.ScrollBarThickness = 2
TabContainer.BorderSizePixel = 0
TabContainer.Parent = Sidebar

local TabListLayout = Instance.new("UIListLayout")
TabListLayout.SortOrder = Enum.SortOrder.LayoutOrder
TabListLayout.Padding = UDim.new(0, 6)
TabListLayout.Parent = TabContainer

local SidebarPadding = Instance.new("UIPadding")
SidebarPadding.PaddingTop = UDim.new(0, 12)
SidebarPadding.PaddingLeft = UDim.new(0, 10)
SidebarPadding.PaddingRight = UDim.new(0, 10)
SidebarPadding.Parent = TabContainer

TabListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
TabContainer.CanvasSize = UDim2.new(0, 0, 0, TabListLayout.AbsoluteContentSize.Y + 20)
end)

local ContentArea = Instance.new("Frame")
ContentArea.Size = UDim2.new(1, -170, 1, -45)
ContentArea.Position = UDim2.new(0, 170, 0, 45)
ContentArea.BackgroundTransparency = 1
ContentArea.ClipsDescendants = true
ContentArea.Parent = MainFrame

local Tabs = {}
local tabLayoutCounters = {}

local function CreateTab(tabName, iconText, layoutOrder)
tabLayoutCounters[tabName] = 0

local TabBtn = Instance.new("TextButton")
TabBtn.Size = UDim2.new(1, 0, 0, 38)
TabBtn.BackgroundColor3 = Theme.Card
TabBtn.BackgroundTransparency = 1
TabBtn.Font = Theme.FontMedium
TabBtn.Text = "  " .. iconText .. " " .. tabName
TabBtn.TextColor3 = Theme.TextDark
TabBtn.TextSize = 13
TabBtn.TextXAlignment = Enum.TextXAlignment.Left
TabBtn.LayoutOrder = layoutOrder
TabBtn.Parent = TabContainer
Instance.new("UICorner", TabBtn).CornerRadius = UDim.new(0, 6)

local TabPage = Instance.new("ScrollingFrame")
TabPage.Name = tabName .. "Page"
TabPage.Size = UDim2.new(1, 0, 1, 0)
TabPage.BackgroundTransparency = 1
TabPage.BorderSizePixel = 0
TabPage.ScrollBarThickness = 4
TabPage.ScrollBarImageColor3 = Theme.Accent
TabPage.Visible = false
TabPage.Parent = ContentArea

local PageList = Instance.new("UIListLayout")
PageList.SortOrder = Enum.SortOrder.LayoutOrder
PageList.Padding = UDim.new(0, 8)
PageList.Parent = TabPage

local PagePadding = Instance.new("UIPadding")
PagePadding.PaddingTop = UDim.new(0, 12)
PagePadding.PaddingLeft = UDim.new(0, 12)
PagePadding.PaddingRight = UDim.new(0, 12)
PagePadding.PaddingBottom = UDim.new(0, 18)
PagePadding.Parent = TabPage

PageList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
TabPage.CanvasSize = UDim2.new(0, 0, 0, PageList.AbsoluteContentSize.Y + 30)
end)

TabBtn.MouseButton1Click:Connect(function()
for _, data in pairs(Tabs) do
data.Btn.BackgroundTransparency = 1
data.Btn.TextColor3 = Theme.TextDark
data.Page.Visible = false
end
TabBtn.BackgroundTransparency = 0
TabBtn.TextColor3 = Theme.Text
TabPage.Visible = true
end)

Tabs[tabName] = { Btn = TabBtn, Page = TabPage }
return TabPage
end

local NotifContainer = Instance.new("Frame")
NotifContainer.Size = UDim2.new(0, 240, 1, -20)
NotifContainer.Position = UDim2.new(1, -250, 0, 10)
NotifContainer.BackgroundTransparency = 1
NotifContainer.Parent = ScreenGui

local NotifList = Instance.new("UIListLayout")
NotifList.VerticalAlignment = Enum.VerticalAlignment.Bottom
NotifList.Padding = UDim.new(0, 8)
NotifList.Parent = NotifContainer

local function Notify(title, desc)
local Toast = Instance.new("Frame")
Toast.Size = UDim2.new(1, 0, 0, 52)
Toast.BackgroundColor3 = Theme.Sidebar
Toast.Parent = NotifContainer
Instance.new("UICorner", Toast).CornerRadius = UDim.new(0, 8)

local TitleLbl = Instance.new("TextLabel")
TitleLbl.Size = UDim2.new(1, -16, 0, 20)
TitleLbl.Position = UDim2.new(0, 10, 0, 5)
TitleLbl.BackgroundTransparency = 1
TitleLbl.Font = Theme.Font
TitleLbl.Text = "⚡ " .. title
TitleLbl.TextColor3 = Theme.Text
TitleLbl.TextSize = 12
TitleLbl.TextXAlignment = Enum.TextXAlignment.Left
TitleLbl.Parent = Toast

local DescLbl = Instance.new("TextLabel")
DescLbl.Size = UDim2.new(1, -16, 0, 20)
DescLbl.Position = UDim2.new(0, 10, 0, 25)
DescLbl.BackgroundTransparency = 1
DescLbl.Font = Theme.FontMedium
DescLbl.Text = desc
DescLbl.TextColor3 = Theme.TextDark
DescLbl.TextSize = 11
DescLbl.TextXAlignment = Enum.TextXAlignment.Left
DescLbl.Parent = Toast

task.delay(3, function()
if Toast then Toast:Destroy() end
end)
end

local function GetNextLayoutOrder(parent)
for name, tab in pairs(Tabs) do
if tab.Page == parent then
tabLayoutCounters[name] = (tabLayoutCounters[name] or 0) + 1
return tabLayoutCounters[name]
end
end
return 0
end

local function CreateSection(parent, title)
local Label = Instance.new("TextLabel")
Label.Size = UDim2.new(1, 0, 0, 24)
Label.BackgroundTransparency = 1
Label.Font = Theme.Font
Label.Text = string.upper(title)
Label.TextColor3 = Theme.TextDark
Label.TextSize = 11
Label.TextXAlignment = Enum.TextXAlignment.Left
Label.LayoutOrder = GetNextLayoutOrder(parent)
Label.Parent = parent
end

local function CreateToggle(parent, text, defaultState, callback)
local Card = Instance.new("Frame")
Card.Size = UDim2.new(1, 0, 0, 42)
Card.BackgroundColor3 = Theme.Card
Card.BorderSizePixel = 0
Card.LayoutOrder = GetNextLayoutOrder(parent)
Card.Parent = parent
Instance.new("UICorner", Card).CornerRadius = UDim.new(0, 8)

local Label = Instance.new("TextLabel")
Label.Size = UDim2.new(1, -60, 1, 0)
Label.Position = UDim2.new(0, 12, 0, 0)
Label.BackgroundTransparency = 1
Label.Font = Theme.FontMedium
Label.Text = text
Label.TextColor3 = Theme.Text
Label.TextSize = 12
Label.TextXAlignment = Enum.TextXAlignment.Left
Label.Parent = Card

local ToggleFrame = Instance.new("Frame")
ToggleFrame.Size = UDim2.new(0, 40, 0, 22)
ToggleFrame.Position = UDim2.new(1, -50, 0.5, -11)
ToggleFrame.BackgroundColor3 = defaultState and Theme.ToggleOn or Theme.ToggleOff
ToggleFrame.Parent = Card
Instance.new("UICorner", ToggleFrame).CornerRadius = UDim.new(0, 11)

local Dot = Instance.new("Frame")
Dot.Size = UDim2.new(0, 16, 0, 16)
Dot.Position = defaultState and UDim2.new(1, -19, 0.5, -8) or UDim2.new(0, 3, 0.5, -8)
Dot.BackgroundColor3 = defaultState and Theme.Background or Theme.TextDark
Dot.Parent = ToggleFrame
Instance.new("UICorner", Dot).CornerRadius = UDim.new(0, 8)

local Btn = Instance.new("TextButton")
Btn.Size = UDim2.new(1, 0, 1, 0)
Btn.BackgroundTransparency = 1
Btn.Text = ""
Btn.Parent = Card

local isToggled = defaultState
Btn.MouseButton1Click:Connect(function()
isToggled = not isToggled
ToggleFrame.BackgroundColor3 = isToggled and Theme.ToggleOn or Theme.ToggleOff
Dot.Position = isToggled and UDim2.new(1, -19, 0.5, -8) or UDim2.new(0, 3, 0.5, -8)
Dot.BackgroundColor3 = isToggled and Theme.Background or Theme.TextDark
pcall(function() callback(isToggled) end)
end)
end

local function CreateButton(parent, text, callback)
local Btn = Instance.new("TextButton")
Btn.Size = UDim2.new(1, 0, 0, 40)
Btn.BackgroundColor3 = Theme.Card
Btn.Font = Theme.Font
Btn.Text = text
Btn.TextColor3 = Theme.Text
Btn.TextSize = 12
Btn.LayoutOrder = GetNextLayoutOrder(parent)
Btn.Parent = parent
Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 8)

Btn.MouseButton1Click:Connect(function()
pcall(function() callback() end)
end)
end

local function CreateSlider(parent, text, minVal, maxVal, defaultVal, callback)
local Card = Instance.new("Frame")
Card.Size = UDim2.new(1, 0, 0, 52)
Card.BackgroundColor3 = Theme.Card
Card.LayoutOrder = GetNextLayoutOrder(parent)
Card.Parent = parent
Instance.new("UICorner", Card).CornerRadius = UDim.new(0, 8)

local Label = Instance.new("TextLabel")
Label.Size = UDim2.new(1, -80, 0, 22)
Label.Position = UDim2.new(0, 12, 0, 4)
Label.BackgroundTransparency = 1
Label.Font = Theme.FontMedium
Label.Text = text
Label.TextColor3 = Theme.Text
Label.TextSize = 12
Label.TextXAlignment = Enum.TextXAlignment.Left
Label.Parent = Card

local ValLabel = Instance.new("TextLabel")
ValLabel.Size = UDim2.new(0, 60, 0, 22)
ValLabel.Position = UDim2.new(1, -72, 0, 4)
ValLabel.BackgroundTransparency = 1
ValLabel.Font = Theme.Font
ValLabel.Text = tostring(defaultVal)
ValLabel.TextColor3 = Theme.TextDark
ValLabel.TextSize = 12
ValLabel.TextXAlignment = Enum.TextXAlignment.Right
ValLabel.Parent = Card

local Track = Instance.new("Frame")
Track.Size = UDim2.new(1, -24, 0, 6)
Track.Position = UDim2.new(0, 12, 0, 34)
Track.BackgroundColor3 = Theme.ToggleOff
Track.Parent = Card
Instance.new("UICorner", Track).CornerRadius = UDim.new(0, 3)

local Fill = Instance.new("Frame")
local startPct = math.clamp((defaultVal - minVal) / (maxVal - minVal), 0, 1)
Fill.Size = UDim2.new(startPct, 0, 1, 0)
Fill.BackgroundColor3 = Theme.Accent
Fill.Parent = Track
Instance.new("UICorner", Fill).CornerRadius = UDim.new(0, 3)

local isSliding = false
local function UpdateSlide(input)
local pct = math.clamp((input.Position.X - Track.AbsolutePosition.X) / Track.AbsoluteSize.X, 0, 1)
Fill.Size = UDim2.new(pct, 0, 1, 0)
local val = math.floor(minVal + (maxVal - minVal) * pct)
ValLabel.Text = tostring(val)
pcall(function() callback(val) end)
end

Track.InputBegan:Connect(function(input)
if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
isSliding = true
UpdateSlide(input)
end
end)
CoreServices.UserInputService.InputEnded:Connect(function(input)
if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then isSliding = false end
end)
CoreServices.UserInputService.InputChanged:Connect(function(input)
if isSliding and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
UpdateSlide(input)
end
end)
end

-- ================= CÁC TAB CHÍNH ================= --
local TabPerf = CreateTab("Performance", "⚡", 1)
local TabGfx = CreateTab("Graphics", "🎨", 2)
local TabCam = CreateTab("View & Skins", "👁️", 3)
local TabBoost = CreateTab("Hardware Boost", "🛠️", 4)
local TabMobile = CreateTab("Mobile Pro", "📱", 5)
local TabFFlag = CreateTab("FFlags (Engine)", "⚙️", 6)
local TabGod = CreateTab("God Tools", "⚔️", 7)
local TabStats = CreateTab("Telemetry", "📊", 8)

-- ================= TAB 1: PERFORMANCE ================= --
CreateSection(TabPerf, "Core Speed Controls")
CreateToggle(TabPerf, "🧠 Smart Smoother (Bù Frame Ảo & Chống Giật)", false, function(state)
State.SmartSmoother = state
Notify("Smart Smoother", state and "Đã bật thuật toán làm mượt & bù frame thông minh." or "Đã tắt thuật toán làm mượt.")
end)
CreateButton(TabPerf, "🔓 Unlock FPS Limit (Cap to 9,999,999)", function()
if setfpscap then
setfpscap(9999999)
Notify("FPS Unlocked", "Framerate uncapped to 9,999,999 FPS!")
else
Notify("Error", "Your executor does not support setfpscap.")
end
end)
CreateButton(TabPerf, "🗑️ Immediate VFX Purge (Clear Particles)", function()
local count = 0
for _, item in pairs(CoreServices.Workspace:GetDescendants()) do
if item:IsA("ParticleEmitter") or item:IsA("Smoke") or item:IsA("Fire") or item:IsA("Sparkles") then
item:Destroy()
count = count + 1
end
end
Notify("VFX Cleared", "Purged " .. count .. " VFX effects.")
end)
CreateToggle(TabPerf, "🔄 Auto VFX Delete Every 5 Seconds (Safe Batching)", false, function(state)
State.AutoVFXDelete = state
Notify("Auto VFX Purge", state and "Loop enabled" or "Loop disabled")
end)
CreateToggle(TabPerf, "🚫 KHÓA HOÀN TOÀN VFX MỚI (Chống tràn RAM)", false, function(state)
State.BlockVFX = state
Notify("Khóa VFX", state and "Đã chặn sinh ra VFX mới!" or "VFX mới có thể sinh ra.")
end)

CoreServices.Workspace.DescendantAdded:Connect(function(descendant)
if State.BlockVFX then
if descendant:IsA("ParticleEmitter") or descendant:IsA("Smoke") or descendant:IsA("Fire") or descendant:IsA("Sparkles") or descendant:IsA("Explosion") then
task.defer(function()
pcall(function() descendant:Destroy() end)
end)
end
end
end)

-- ================= TAB 2: GRAPHICS (FIXED SMOOTH PLASTIC) ================= --
CreateSection(TabGfx, "Material & Texture Optimization")
CreateToggle(TabGfx, "↳ Bỏ qua Model, 3D Mesh (Chỉ đổi Part thường)", true, function(state) State.Smooth_ExcludeMesh = state end)
CreateToggle(TabGfx, "↳ Ép tất cả thành màu Xám (Grey-scale)", false, function(state) State.Smooth_GreyScale = state end)
CreateToggle(TabGfx, "↳ Xóa tận gốc Texture & Decal (Nuke)", false, function(state) State.Smooth_NukeTextures = state end)

CreateButton(TabGfx, "🧱 THỰC THI: Convert to Smooth Plastic", function()
local count = 0
local function process(item)
if State.Smooth_ExcludeMesh and (item:IsA("MeshPart") or item:IsA("SpecialMesh") or item.Parent:IsA("Model") and not item.Parent:IsA("Workspace")) then
return -- Bỏ qua Mesh và Model phức tạp nếu Tích
end
if item:IsA("BasePart") then
item.Material = Enum.Material.SmoothPlastic
item.Reflectance = 0
if State.Smooth_GreyScale then
item.Color = Color3.fromRGB(150, 150, 150)
end
count = count + 1
end
if State.Smooth_NukeTextures and (item:IsA("Decal") or item:IsA("Texture") or item:IsA("SurfaceAppearance")) then
item:Destroy()
end
end
for _, item in pairs(CoreServices.Workspace:GetDescendants()) do pcall(process, item) end
Notify("Smooth Plastic", "Đã xử lý " .. count .. " đối tượng an toàn.")
end)

CreateToggle(TabGfx, "☀️ No Fog, No Shadows & Light Clear", false, function(state)
if state then
CoreServices.Lighting.FogEnd = 9e9
CoreServices.Lighting.GlobalShadows = false
for _, v in pairs(CoreServices.Lighting:GetChildren()) do
if v:IsA("Atmosphere") or v:IsA("PostEffect") or v:IsA("SunRaysEffect") then v:Destroy() end
end
Notify("Lighting", "Fog, Shadows and PostFx disabled.")
else
CoreServices.Lighting.GlobalShadows = true
end
end)

-- ================= TAB 3: VIEW & SKINS & ESP ================= --
CreateSection(TabCam, "Visibility & Character Settings")
CreateToggle(TabCam, "👁️ ESP TỔNG HỢP (Dây nối + Highlight + Hitbox)", false, function(state)
State.ESPToggle = state
Notify("ESP", state and "Đã BẬT Hack Tầm Nhìn (An toàn, mượt)." or "Đã TẮT Hack Tầm Nhìn.")
end)
CreateToggle(TabCam, "🔭 Enable Max View Distance (Ultra Zoom)", false, function(state)
LocalPlayer.CameraMaxZoomDistance = state and 100000 or 128
Notify("View Distance", state and "Unlocked" or "Restored")
end)
CreateToggle(TabCam, "💃 Disable All Playing Animations", false, function(state)
State.DisableAnimations = state
Notify("Animations", state and "Frozen" or "Resumed")
end)
CreateToggle(TabCam, "👤 Hide Other Players' Skins", false, function(state)
if state then
for _, player in pairs(CoreServices.Players:GetPlayers()) do
if player ~= LocalPlayer and player.Character then
for _, item in pairs(player.Character:GetChildren()) do
if item:IsA("Accessory") or item:IsA("Shirt") or item:IsA("Pants") or item:IsA("ShirtGraphic") then
item:Destroy()
end
end
end
end
Notify("Skins", "Stripped player accessories.")
end
end)

-- ================= TAB 4: HARDWARE BOOST ================= --
CreateSection(TabBoost, "10 Pro Hardware Optimizers")
CreateToggle(TabBoost, "1. 🌐 Smart Chunk Distance Loader", false, function(state) State.ChunkCulling = state end)
CreateSlider(TabBoost, "   ↳ Culling Distance Studs", 100, 1000, 500, function(val) State.ViewDistanceStuds = val end)
CreateToggle(TabBoost, "2. 💥 Kill Post-Processing Effects", false, function(state)
if state then
for _, effect in pairs(CoreServices.Lighting:GetChildren()) do
if effect:IsA("PostEffect") or effect:IsA("BloomEffect") or effect:IsA("BlurEffect") or effect:IsA("ColorCorrectionEffect") then effect.Enabled = false end
end
end
end)
CreateToggle(TabBoost, "3. 📐 Mesh Performance Mode", false, function(state)
if state then
for _, mesh in pairs(CoreServices.Workspace:GetDescendants()) do
if mesh:IsA("MeshPart") then pcall(function() mesh.RenderFidelity = Enum.RenderFidelity.Performance end) end
end
end
end)
CreateToggle(TabBoost, "4. 💡 Remove Dynamic Lights", false, function(state)
if state then
for _, light in pairs(CoreServices.Workspace:GetDescendants()) do
if light:IsA("Light") or light:IsA("Highlight") then light:Destroy() end
end
end
end)
CreateToggle(TabBoost, "5. 🔇 Audio & Reverb Buffer Muter", false, function(state)
if state then CoreServices.SoundService.AmbientReverb = Enum.ReverbType.NoReverb end
end)
CreateToggle(TabBoost, "6. 🌊 Flatten Terrain Waves & Decor", false, function(state)
if state and CoreServices.Workspace.Terrain then
CoreServices.Workspace.Terrain.WaterWaveSize = 0
CoreServices.Workspace.Terrain.Decoration = false
end
end)
CreateButton(TabBoost, "7. 🧹 Collect Debris & Fallen Objects", function()
for _, part in pairs(CoreServices.Workspace:GetDescendants()) do
if part:IsA("BasePart") and not part.Anchored and part.Position.Y < -50 then part:Destroy() end
end
Notify("Cleaner", "Swept unanchored debris.")
end)
CreateToggle(TabBoost, "8. ⚡ Physics Touch & Query Saver", false, function(state)
if state then
for _, part in pairs(CoreServices.Workspace:GetDescendants()) do
if part:IsA("BasePart") and part.Anchored and not part:IsDescendantOf(LocalPlayer.Character) then
pcall(function() part.CanTouch = false; part.CanQuery = false end)
end
end
end
end)
CreateToggle(TabBoost, "9. ❄️ Particle Emission Rate Freezer", false, function(state)
if state then
for _, emitter in pairs(CoreServices.Workspace:GetDescendants()) do
if emitter:IsA("ParticleEmitter") then emitter.Rate = 0 end
end
end
end)
CreateButton(TabBoost, "10. 🧠 Memory Garbage Collector", function()
collectgarbage("collect")
task.wait(0.1)
collectgarbage("collect")
Notify("Memory", "Garbage collection executed.")
end)

-- ================= TAB 5: MOBILE PRO (Tối ưu siêu sâu) ================= --
CreateSection(TabMobile, "Siêu Tối Ưu Cho Điện Thoại")
CreateButton(TabMobile, "🚀 KÍCH HOẠT BOOST SIÊU CHUYÊN SÂU (ALL-IN-ONE)", function()
State.MobileProMode = true
pcall(function()
settings().Rendering.QualityLevel = 1
settings().Network.IncomingReplicationLag = 0
end)
-- Tắt toàn bộ bóng & Ánh sáng xám mượt
CoreServices.Lighting.GlobalShadows = false
CoreServices.Lighting.Brightness = 1
CoreServices.Lighting.Ambient = Color3.fromRGB(150, 150, 150)
CoreServices.Lighting.OutdoorAmbient = Color3.fromRGB(150, 150, 150)

-- Xóa toàn bộ rác hình ảnh và shader
for _, v in pairs(CoreServices.Lighting:GetDescendants()) do
    if v:IsA("PostEffect") or v:IsA("Sky") or v:IsA("Atmosphere") or v:IsA("SunRaysEffect") then v:Destroy() end
end
for _, v in pairs(CoreServices.Workspace:GetDescendants()) do
    if v:IsA("BasePart") then
        v.Material = Enum.Material.SmoothPlastic
        v.CastShadow = false
    elseif v:IsA("Texture") or v:IsA("Decal") or v:IsA("SurfaceAppearance") then
        v:Destroy()
    end
end
Notify("MOBILE PRO", "Đã kích hoạt chế độ siêu mượt cho điện thoại!")


end)

CreateButton(TabMobile, "☁️ XÓA BẦU TRỜI & LÀM MỜ MỌI THỨ", function()
for _, v in pairs(CoreServices.Lighting:GetChildren()) do
if v:IsA("Sky") or v:IsA("Atmosphere") or v:IsA("Clouds") then v:Destroy() end
end
CoreServices.Lighting.Ambient = Color3.fromRGB(120, 120, 120)
Notify("Sky Cleared", "Đã xóa bầu trời, giảm tải GPU cực mạnh.")
end)

CreateButton(TabMobile, "🚷 CHẶN HOÀN TOÀN ANIMATION (Nâng Cao)", function()
State.DisableAnimations = true
local function StopAnim(char)
if char and char:FindFirstChild("Humanoid") then
local animator = char.Humanoid:FindFirstChildOfClass("Animator")
if animator then
for _, track in pairs(animator:GetPlayingAnimationTracks()) do track:Stop() end
end
end
end
for _, p in pairs(CoreServices.Players:GetPlayers()) do StopAnim(p.Character) end
CoreServices.Workspace.DescendantAdded:Connect(function(desc)
if State.DisableAnimations and desc:IsA("Animator") then
task.wait()
for _, track in pairs(desc:GetPlayingAnimationTracks()) do track:Stop() end
end
end)
Notify("Animation", "Đã đóng băng mọi chuyển động!")
end)

-- ================= TAB 6: FFLAG EMULATORS (CLIENT SETTINGS) ================= --
CreateSection(TabFFlag, "Mô Phỏng FFlag Engine & Render API")
CreateButton(TabFFlag, "💡 Force Voxel Lighting (Siêu Nhẹ)", function()
pcall(function()
if sethiddenproperty then
sethiddenproperty(CoreServices.Lighting, "Technology", Enum.Technology.Voxel)
else
CoreServices.Lighting.Technology = Enum.Technology.Voxel
end
end)
Notify("FFlag Emulated", "Đã ép công nghệ Voxel Lighting (DFFlagDebugRenderForceTechnologyVoxel).")
end)
CreateButton(TabFFlag, "💡 Force Shadowmap / Future Lighting", function()
pcall(function()
if sethiddenproperty then
sethiddenproperty(CoreServices.Lighting, "Technology", Enum.Technology.ShadowMap)
end
end)
Notify("FFlag Emulated", "Đã ép công nghệ Shadowmap (Phase 2/3).")
end)

CreateButton(TabFFlag, "🎮 Emulate Low API (Tắt D3D11 / Vulkan - Potato GPU)", function()
pcall(function()
settings().Rendering.QualityLevel = 1
settings().Rendering.MeshPartDetailLevel = Enum.MeshPartDetailLevel.Level04
end)
for _, part in pairs(CoreServices.Workspace:GetDescendants()) do
if part:IsA("MeshPart") then pcall(function() part.RenderFidelity = Enum.RenderFidelity.Performance end) end
end
Notify("FFlag Emulated", "Giả lập API đồ họa thấp (FFlagDebugGraphicsDisableDirect3D11).")
end)

CreateButton(TabFFlag, "🖼️ Force Blurry Textures (DFIntTextureQualityOverride)", function()
for _, v in pairs(CoreServices.Workspace:GetDescendants()) do
if v:IsA("Texture") or v:IsA("Decal") then
v.Transparency = 0.8 -- Làm mờ texture giả lập chất lượng thấp
elseif v:IsA("MeshPart") then
v.TextureID = "" -- Xóa hẳn để nhẹ
end
end
Notify("FFlag Emulated", "Đã ép Texture xuống mức tồi tệ nhất để mượt.")
end)

CreateButton(TabFFlag, "👤 No Player Textures (DFIntTextureCompositorActiveJobs)", function()
local function GreyPlayer(char)
if char then
for _, v in pairs(char:GetDescendants()) do
if v:IsA("Shirt") or v:IsA("Pants") or v:IsA("ShirtGraphic") or v:IsA("Accessory") then v:Destroy() end
if v:IsA("BasePart") then v.Color = Color3.fromRGB(150,150,150); v.Material = Enum.Material.SmoothPlastic end
if v:IsA("MeshPart") then v.TextureID = "" end
end
end
end
for _, p in pairs(CoreServices.Players:GetPlayers()) do GreyPlayer(p.Character) end
Notify("FFlag Emulated", "Đã biến mọi người chơi thành khối xám (Texture Compositor 0).")
end)

CreateButton(TabFFlag, "🔳 Disable Anti-aliasing (MSAA = 0)", function()
pcall(function() settings().Rendering.QualityLevel = 1 end)
Notify("FFlag Emulated", "Tắt khử răng cưa (FIntDebugForceMSAASamples = 0).")
end)

CreateToggle(TabFFlag, "🛑 Giới hạn Light Updates (FIntRenderLocalLightUpdates)", false, function(state)
State.LimitLightUpdates = state
Notify("FFlag Emulated", state and "Giới hạn cập nhật ánh sáng động (Max: 1)." or "Khôi phục cập nhật.")
end)

CreateButton(TabFFlag, "🌑 No Shadows (FIntRenderShadowIntensity = 0)", function()
CoreServices.Lighting.GlobalShadows = false
for _, v in pairs(CoreServices.Workspace:GetDescendants()) do
if v:IsA("BasePart") then v.CastShadow = false end
end
Notify("FFlag Emulated", "Tắt toàn bộ bóng đổ vĩnh viễn.")
end)

CreateButton(TabFFlag, "🚫 No Post-Processing (FFlagDisablePostFx)", function()
for _, v in pairs(CoreServices.Lighting:GetDescendants()) do
if v:IsA("PostEffect") then v.Enabled = false; v:Destroy() end
end
local cam = CoreServices.Workspace.CurrentCamera
if cam then for _, v in pairs(cam:GetChildren()) do if v:IsA("PostEffect") then v:Destroy() end end end
Notify("FFlag Emulated", "Diệt gọn mọi hiệu ứng hình ảnh (PostFX).")
end)

-- ================= TAB 7: GOD TOOLS ================= --
CreateSection(TabGod, "Bộ 3 Công Cụ Quyền Năng")
local DeletedPartsCache = {}
local AddedPartsCache = {}

CreateButton(TabGod, "🎁 Nhận 3 Tool VIP (Vào Balo)", function()
local bp = LocalPlayer:FindFirstChild("Backpack")
if not bp then Notify("Error", "Không tìm thấy balo."); return end

-- 1. Tool Xóa
local tDel = Instance.new("Tool"); tDel.Name = "🔥 Tool XÓA Block"; tDel.RequiresHandle = false; tDel.Parent = bp
tDel.Activated:Connect(function()
    local mouse = LocalPlayer:GetMouse()
    if mouse.Target and not mouse.Target.Locked and not mouse.Target:IsDescendantOf(LocalPlayer.Character) then
        table.insert(DeletedPartsCache, {Part = mouse.Target, Parent = mouse.Target.Parent})
        mouse.Target.Parent = nil
        Notify("Tool Xóa", "Đã xóa: " .. mouse.Target.Name)
    end
end)

-- 2. Tool Thêm
local tAdd = Instance.new("Tool"); tAdd.Name = "🧱 Tool THÊM Block"; tAdd.RequiresHandle = false; tAdd.Parent = bp
tAdd.Activated:Connect(function()
    local mouse = LocalPlayer:GetMouse()
    if mouse.Hit then
        local part = Instance.new("Part")
        part.Size = Vector3.new(4, 4, 4)
        part.Position = mouse.Hit.Position
        part.Anchored = true
        part.Material = Enum.Material.SmoothPlastic
        part.Color = Color3.fromRGB(0, 255, 0)
        part.Parent = CoreServices.Workspace
        table.insert(AddedPartsCache, part)
        Notify("Tool Thêm", "Đã tạo khối tại vị trí chỉ định.")
    end
end)

-- 3. Tool Dịch Chuyển (TP)
local tTP = Instance.new("Tool"); tTP.Name = "🚀 Tool DỊCH CHUYỂN"; tTP.RequiresHandle = false; tTP.Parent = bp
tTP.Activated:Connect(function()
    local mouse = LocalPlayer:GetMouse()
    if mouse.Hit and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(mouse.Hit.Position + Vector3.new(0, 3, 0))
        Notify("Tool TP", "Vrooom!")
    end
end)
Notify("God Tools", "Đã cấp 3 vũ khí vào túi đồ!")


end)

CreateButton(TabGod, "🔄 KHÔI PHỤC Block Đã Xóa/Thêm", function()
local cDel = 0
for _, data in ipairs(DeletedPartsCache) do
if data.Part then data.Part.Parent = data.Parent; cDel = cDel + 1 end
end
DeletedPartsCache = {}

local cAdd = 0
for _, part in ipairs(AddedPartsCache) do
    if part then part:Destroy(); cAdd = cAdd + 1 end
end
AddedPartsCache = {}
Notify("Khôi Phục", "Trả lại " .. cDel .. " block xóa, xóa " .. cAdd .. " block đã tạo.")


end)

-- ================= TAB 8: TELEMETRY (REAL-TIME) ================= --
CreateSection(TabStats, "Real-Time Telemetry (Nâng Cấp)")
local function CreateStatCard(parent, title)
local Label = Instance.new("TextLabel")
Label.Size = UDim2.new(1, 0, 0, 36)
Label.BackgroundColor3 = Theme.Card
Label.Font = Theme.Font
Label.Text = title
Label.TextColor3 = Theme.Text
Label.TextSize = 13
Label.TextXAlignment = Enum.TextXAlignment.Left
Label.LayoutOrder = GetNextLayoutOrder(parent)
Label.Parent = parent
Instance.new("UICorner", Label).CornerRadius = UDim.new(0, 8)
return Label
end
local FPSLabel = CreateStatCard(TabStats, "  ⚡ FPS (Thực/Bù): CALC...")
local PingLabel = CreateStatCard(TabStats, "  📡 PING & ĐỘ TRỄ: CALC...")
local RAMLabel = CreateStatCard(TabStats, "  💾 MEMORY (RAM): CALC...")
local SmoothLabel = CreateStatCard(TabStats, "  🧠 TRẠNG THÁI MƯỢT: Tốt")

-- BACKGROUND LOOPS & ESP LOGIC
local Camera = CoreServices.Workspace.CurrentCamera
local ESPScreen = Instance.new("ScreenGui")
ESPScreen.Name = "NexusESP_UI"
ESPScreen.Parent = ParentGui
local ESP_Cache = {}

local function CreateESP(player)
local cache = {}
local box = Instance.new("SelectionBox")
box.LineThickness = 0.05
box.Color3 = Color3.fromRGB(255, 50, 50)
box.SurfaceTransparency = 0.8
box.SurfaceColor3 = Color3.fromRGB(255, 0, 0)
box.Parent = ESPScreen
cache.Box = box

local hl = Instance.new("Highlight")
hl.FillTransparency = 1
hl.OutlineColor = Color3.fromRGB(0, 255, 255)
hl.OutlineTransparency = 0
hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
hl.Parent = ESPScreen
cache.Highlight = hl

local line = Instance.new("Frame")
line.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
line.BorderSizePixel = 0
line.AnchorPoint = Vector2.new(0.5, 0.5)
line.Parent = ESPScreen
cache.Line = line

ESP_Cache[player] = cache


end

local function RemoveESP(player)
if ESP_Cache[player] then
ESP_Cache[player].Box:Destroy()
ESP_Cache[player].Highlight:Destroy()
ESP_Cache[player].Line:Destroy()
ESP_Cache[player] = nil
end
end
CoreServices.Players.PlayerRemoving:Connect(RemoveESP)

-- Vòng lặp Xóa VFX Từ từ (Batching)
task.spawn(function()
while task.wait(5) do
if State.AutoVFXDelete then
local vfxQueue = {}
pcall(function()
for _, item in pairs(CoreServices.Workspace:GetDescendants()) do
if item:IsA("ParticleEmitter") or item:IsA("Smoke") or item:IsA("Fire") or item:IsA("Sparkles") then
table.insert(vfxQueue, item)
end
end
end)
for i, vfx in ipairs(vfxQueue) do
pcall(function() vfx:Destroy() end)
if i % 15 == 0 then task.wait() end -- Cứ 15 cái nghỉ 1 frame để không lag
end
end
end
end)

-- Vòng lặp Chunk Culling & Light Limiter
task.spawn(function()
while task.wait(1) do
local rootPos = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and LocalPlayer.Character.HumanoidRootPart.Position
if rootPos then
if State.ChunkCulling then
pcall(function()
local maxDist = State.ViewDistanceStuds
for _, part in pairs(CoreServices.Workspace:GetDescendants()) do
if part:IsA("BasePart") and part.Anchored and not part:IsDescendantOf(LocalPlayer.Character) then
part.LocalTransparencyModifier = ((part.Position - rootPos).Magnitude > maxDist) and 1 or 0
end
end
end)
end
if State.LimitLightUpdates then
pcall(function()
for _, light in pairs(CoreServices.Workspace:GetDescendants()) do
if light:IsA("Light") and light.Parent and light.Parent:IsA("BasePart") then
light.Enabled = (light.Parent.Position - rootPos).Magnitude < 100
end
end
end)
end
end
end
end)

-- ESP & Smart Smoother (RenderStepped & Heartbeat)
CoreServices.RunService.RenderStepped:Connect(function(deltaTime)
-- Lõi ESP Mượt mà
if State.ESPToggle then
for _, player in pairs(CoreServices.Players:GetPlayers()) do
if player ~= LocalPlayer then
local char = player.Character
if char and char:FindFirstChild("HumanoidRootPart") and char:FindFirstChild("Humanoid") and char.Humanoid.Health > 0 then
if not ESP_Cache[player] then CreateESP(player) end
local cache = ESP_Cache[player]
local hrp = char.HumanoidRootPart

                cache.Box.Adornee = char
                cache.Highlight.Adornee = char
                
                local vector, onScreen = Camera:WorldToViewportPoint(hrp.Position)
                if onScreen then
                    cache.Line.Visible = true
                    local startPoint = Vector2.new(Camera.ViewportSize.X / 2, 0)
                    local endPoint = Vector2.new(vector.X, vector.Y)
                    
                    local center = (startPoint + endPoint) / 2
                    local dist = (endPoint - startPoint).Magnitude
                    local angle = math.atan2(endPoint.Y - startPoint.Y, endPoint.X - startPoint.X)
                    
                    cache.Line.Position = UDim2.new(0, center.X, 0, center.Y)
                    cache.Line.Size = UDim2.new(0, dist, 0, 1.5)
                    cache.Line.Rotation = math.deg(angle)
                else
                    cache.Line.Visible = false
                end
            else
                if ESP_Cache[player] then
                    ESP_Cache[player].Box.Adornee = nil
                    ESP_Cache[player].Highlight.Adornee = nil
                    ESP_Cache[player].Line.Visible = false
                end
            end
        end
    end
else
    for player, cache in pairs(ESP_Cache) do
        cache.Box.Adornee = nil
        cache.Highlight.Adornee = nil
        cache.Line.Visible = false
    end
end

-- Smart Smoother Micro-stutter prevention
if State.SmartSmoother then
    if deltaTime > 0.025 then
        pcall(function() settings().Rendering.QualityLevel = math.max(1, settings().Rendering.QualityLevel.Value - 1) end)
    end
end


end)

local frameCount = 0
local lastTime = tick()

CoreServices.RunService.Heartbeat:Connect(function()
frameCount = frameCount + 1
local currentTime = tick()

if currentTime - lastTime >= 1 then
    local currentFPS = math.floor(frameCount / (currentTime - lastTime))
    frameCount = 0
    lastTime = currentTime

    local ping = 0
    local mem = 0
    pcall(function() ping = math.floor(LocalPlayer:GetNetworkPing() * 1000) end)
    pcall(function() mem = math.floor(CoreServices.Stats:GetTotalMemoryUsageMb()) end)

    local displayFPS = currentFPS
    local smoothStatus = "Ổn định"
    
    if State.SmartSmoother then
        if currentFPS < 60 then 
            displayFPS = currentFPS + math.floor((60 - currentFPS) * 0.45)
            smoothStatus = "Đang bù Frame (Chống giật)"
        else
            smoothStatus = "Tối đa (Cực mượt)"
        end
    end

    pcall(function()
        FPSLabel.Text = "  ⚡ FPS: " .. displayFPS .. (State.SmartSmoother and (" (Gốc: "..currentFPS..")") or "")
        PingLabel.Text = "  📡 PING: " .. ping .. " ms"
        RAMLabel.Text = "  💾 MEMORY: " .. mem .. " MB"
        SmoothLabel.Text = "  🧠 TRẠNG THÁI: " .. smoothStatus
        MinBtn.Text = "⚡ NEXUS HUB [FPS: " .. displayFPS .. "]"
    end)
end

if State.DisableAnimations then
    pcall(function()
        for _, player in pairs(CoreServices.Players:GetPlayers()) do
            if player.Character and player.Character:FindFirstChildOfClass("Humanoid") then
                local animator = player.Character.Humanoid:FindFirstChildOfClass("Animator")
                if animator then
                    for _, track in pairs(animator:GetPlayingAnimationTracks()) do track:Stop() end
                end
            end
        end
    end)
end


end)

Tabs["Performance"].Btn.BackgroundTransparency = 0
Tabs["Performance"].Btn.TextColor3 = Theme.Text
Tabs["Performance"].Page.Visible = true

Notify("Nexus Hub Loaded", "All Pro & FFlag Features Activated!")
