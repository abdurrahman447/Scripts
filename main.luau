-- LocalScript (StarterPlayerScripts içine koyabilirsin)

-- Hizmetler
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

-- GUI oluşturma
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = player:WaitForChild("PlayerGui")

-- Menü açma butonu
local OpenButton = Instance.new("TextButton")
OpenButton.Size = UDim2.new(0, 100, 0, 40)
OpenButton.Position = UDim2.new(1, -110, 0, 10) -- Sağ üst
OpenButton.Text = "Menü"
OpenButton.Parent = ScreenGui

-- Menü Frame
local MenuFrame = Instance.new("Frame")
MenuFrame.Size = UDim2.new(0, 200, 0, 150)
MenuFrame.Position = UDim2.new(0.5, -100, 0.5, -75)
MenuFrame.Visible = false
MenuFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
MenuFrame.Parent = ScreenGui

-- Kapat butonu
local CloseButton = Instance.new("TextButton")
CloseButton.Size = UDim2.new(0, 80, 0, 30)
CloseButton.Position = UDim2.new(0.5, -40, 0, 10)
CloseButton.Text = "Kapat"
CloseButton.Parent = MenuFrame

-- Teleport butonu
local TeleportButton = Instance.new("TextButton")
TeleportButton.Size = UDim2.new(0, 120, 0, 40)
TeleportButton.Position = UDim2.new(0.5, -60, 0, 60)
TeleportButton.Text = "Teleport"
TeleportButton.Parent = MenuFrame

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
