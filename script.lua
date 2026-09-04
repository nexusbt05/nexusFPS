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
ViewDistanceStuds = 500
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
TitleSub.Text = "| FPS ENGINE"
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

local TabContainer = Instance.new("UIListLayout")
TabContainer.SortOrder = Enum.SortOrder.LayoutOrder
TabContainer.Padding = UDim.new(0, 6)
TabContainer.Parent = Sidebar

local SidebarPadding = Instance.new("UIPadding")
SidebarPadding.PaddingTop = UDim.new(0, 12)
SidebarPadding.PaddingLeft = UDim.new(0, 10)
SidebarPadding.PaddingRight = UDim.new(0, 10)
SidebarPadding.Parent = Sidebar

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
TabBtn.Parent = Sidebar
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
Card.BorderSizePixel = 0 -- LOẠI BỎ UISTROKE ĐỂ CHỐNG LỖI MÀN ĐEN
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

local TabPerf = CreateTab("Performance", "⚡", 1)
local TabGfx = CreateTab("Graphics", "🎨", 2)
local TabCam = CreateTab("View & Skins", "👁️", 3)
local TabBoost = CreateTab("Hardware Boost", "🛠️", 4)
local TabStats = CreateTab("Telemetry", "📊", 5)

CreateSection(TabPerf, "Core Speed Controls")
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
CreateToggle(TabPerf, "🔄 Auto VFX Delete Every 5 Seconds", false, function(state)
State.AutoVFXDelete = state
Notify("Auto VFX Purge", state and "Loop enabled" or "Loop disabled")
end)

-- Tab 2: Graphics
CreateSection(TabGfx, "Material & Lighting Optimization")
CreateButton(TabGfx, "🧱 Convert All Textures to Smooth Plastic", function()
local count = 0
for _, item in pairs(CoreServices.Workspace:GetDescendants()) do
if item:IsA("BasePart") or item:IsA("MeshPart") then
item.Material = Enum.Material.SmoothPlastic
item.Reflectance = 0
count = count + 1
elseif item:IsA("Decal") or item:IsA("Texture") then
item:Destroy()
end
end
Notify("Smooth Plastic", "Converted " .. count .. " parts.")
end)
CreateToggle(TabGfx, "☀️ No Fog, No Shadows & Smooth Light", false, function(state)
if state then
CoreServices.Lighting.FogEnd = 9e9
CoreServices.Lighting.GlobalShadows = false
for _, v in pairs(CoreServices.Lighting:GetChildren()) do
if v:IsA("Atmosphere") then v:Destroy() end
end
Notify("Lighting", "Fog and Shadows disabled.")
else
CoreServices.Lighting.GlobalShadows = true
end
end)

CreateSection(TabCam, "Visibility & Character Settings")
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
if item:IsA("Accessory") or item:IsA("Shirt") or item:IsA("Pants") then item:Destroy() end
end
end
end
Notify("Skins", "Stripped player accessories.")
end
end)

CreateSection(TabBoost, "10 Pro Hardware Optimizers")
CreateToggle(TabBoost, "1. 🌐 Smart Chunk Distance Loader", false, function(state) State.ChunkCulling = state end)
CreateSlider(TabBoost, "   ↳ Culling Distance Studs", 100, 1000, 500, function(val) State.ViewDistanceStuds = val end)
CreateToggle(TabBoost, "2. 💥 Kill Post-Processing Effects", false, function(state)
if state then
for _, effect in pairs(CoreServices.Lighting:GetChildren()) do
if effect:IsA("PostEffect") or effect:IsA("BloomEffect") or effect:IsA("BlurEffect") then effect.Enabled = false end
end
end
end)
CreateToggle(TabBoost, "3. 📐 Mesh Performance Mode", false, function(state)
if state then
for _, mesh in pairs(CoreServices.Workspace:GetDescendants()) do
if mesh:IsA("MeshPart") then mesh.RenderFidelity = Enum.RenderFidelity.Performance end
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
part.CanTouch = false
part.CanQuery = false
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

CreateSection(TabStats, "Real-Time Telemetry")
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
local FPSLabel = CreateStatCard(TabStats, "  ⚡ FPS: CALC...")
local PingLabel = CreateStatCard(TabStats, "  📡 PING: CALC...")
local RAMLabel = CreateStatCard(TabStats, "  💾 MEMORY: CALC...")

task.spawn(function()
while task.wait(5) do
if State.AutoVFXDelete then
pcall(function()
for _, item in pairs(CoreServices.Workspace:GetDescendants()) do
if item:IsA("ParticleEmitter") or item:IsA("Smoke") or item:IsA("Fire") or item:IsA("Sparkles") then item:Destroy() end
end
end)
end
end
end)

task.spawn(function()
while task.wait(1) do
if State.ChunkCulling and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
pcall(function()
local rootPos = LocalPlayer.Character.HumanoidRootPart.Position
local maxDist = State.ViewDistanceStuds
for _, part in pairs(CoreServices.Workspace:GetDescendants()) do
if part:IsA("BasePart") and part.Anchored and not part:IsDescendantOf(LocalPlayer.Character) then
part.LocalTransparencyModifier = ((part.Position - rootPos).Magnitude > maxDist) and 1 or 0
end
end
end)
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

    pcall(function()
        FPSLabel.Text = "  ⚡ FPS: " .. currentFPS
        PingLabel.Text = "  📡 PING: " .. ping .. " ms"
        RAMLabel.Text = "  💾 MEMORY: " .. mem .. " MB"
        MinBtn.Text = "⚡ NEXUS HUB [FPS: " .. currentFPS .. "]"
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

Notify("Nexus Hub Loaded", "100% Fixed & Stable Version Ready!")
