-- LocalScript (StarterPlayerScripts içine koy)

-- Hizmetler
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

-- GUI oluşturma
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = player:WaitForChild("PlayerGui")

-- Modern Açma butonu
local OpenButton = Instance.new("TextButton")
OpenButton.Size = UDim2.new(0, 120, 0, 45)
OpenButton.Position = UDim2.new(1, -130, 0, 10) -- Sağ üst
OpenButton.Text = "☰ Menü"
OpenButton.TextScaled = true
OpenButton.Font = Enum.Font.GothamBold
OpenButton.TextColor3 = Color3.fromRGB(255, 255, 255)
OpenButton.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
OpenButton.AutoButtonColor = true
OpenButton.Parent = ScreenGui
OpenButton.BorderSizePixel = 0
OpenButton.UICorner = Instance.new("UICorner", OpenButton)
OpenButton.UICorner.CornerRadius = UDim.new(0, 10)

-- Menü Frame
local MenuFrame = Instance.new("Frame")
MenuFrame.Size = UDim2.new(0, 300, 0, 200)
MenuFrame.Position = UDim2.new(0.5, -150, 0.5, -100)
MenuFrame.Visible = false
MenuFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MenuFrame.BackgroundTransparency = 0.1
MenuFrame.BorderSizePixel = 0
MenuFrame.Parent = ScreenGui
local corner = Instance.new("UICorner", MenuFrame)
corner.CornerRadius = UDim.new(0, 12)

-- Başlık
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Position = UDim2.new(0, 0, 0, 0)
Title.Text = "⚙ Menü"
Title.Font = Enum.Font.GothamBold
Title.TextScaled = true
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.BackgroundTransparency = 1
Title.Parent = MenuFrame

-- Kapat butonu
local CloseButton = Instance.new("TextButton")
CloseButton.Size = UDim2.new(0, 100, 0, 40)
CloseButton.Position = UDim2.new(0.5, -50, 1, -50)
CloseButton.Text = "✖ Kapat"
CloseButton.TextScaled = true
CloseButton.Font = Enum.Font.Gotham
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
CloseButton.Parent = MenuFrame
CloseButton.BorderSizePixel = 0
local closeCorner = Instance.new("UICorner", CloseButton)
closeCorner.CornerRadius = UDim.new(0, 8)

-- Teleport butonu
local TeleportButton = Instance.new("TextButton")
TeleportButton.Size = UDim2.new(0, 160, 0, 50)
TeleportButton.Position = UDim2.new(0.5, -80, 0.5, -25)
TeleportButton.Text = "🚀 Teleport"
TeleportButton.TextScaled = true
TeleportButton.Font = Enum.Font.GothamBold
TeleportButton.TextColor3 = Color3.fromRGB(255, 255, 255)
TeleportButton.BackgroundColor3 = Color3.fromRGB(0, 170, 90)
TeleportButton.Parent = MenuFrame
TeleportButton.BorderSizePixel = 0
local tpCorner = Instance.new("UICorner", TeleportButton)
tpCorner.CornerRadius = UDim.new(0, 10)

-- Açma butonuna tıklayınca menüyü aç
OpenButton.MouseButton1Click:Connect(function()
	MenuFrame.Visible = true
end)

-- Kapat butonuna tıklayınca menüyü kapat
CloseButton.MouseButton1Click:Connect(function()
	MenuFrame.Visible = false
end)

-- Teleport butonuna tıklayınca karakteri ışınla
TeleportButton.MouseButton1Click:Connect(function()
	if humanoidRootPart then
		humanoidRootPart.CFrame = CFrame.new(-4.98, 20.50, 473.27)
	end
end)
