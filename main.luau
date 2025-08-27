-- ScreenGui içine LocalScript olarak koy
local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hum = char:WaitForChild("Humanoid")

-- ScreenGui referansı
local screenGui = script.Parent

-- Menü açma butonu
local menuButton = Instance.new("TextButton")
menuButton.Size = UDim2.new(0,120,0,40)
menuButton.Position = UDim2.new(0.5, -60, 0, 10) -- Orta üst
menuButton.Text = "MENU"
menuButton.BackgroundColor3 = Color3.fromRGB(30,30,30)
menuButton.TextColor3 = Color3.fromRGB(255,255,255)
menuButton.Parent = screenGui

-- Menü frame
local menuFrame = Instance.new("Frame")
menuFrame.Size = UDim2.new(0,200,0,150)
menuFrame.Position = UDim2.new(0.5, -100, 0, 60)
menuFrame.BackgroundColor3 = Color3.fromRGB(50,50,50)
menuFrame.Visible = false
menuFrame.Parent = screenGui

-- Fly toggle
local flyButton = Instance.new("TextButton")
flyButton.Size = UDim2.new(0,180,0,40)
flyButton.Position = UDim2.new(0,10,0,10)
flyButton.Text = "Fly: OFF"
flyButton.BackgroundColor3 = Color3.fromRGB(70,70,70)
flyButton.TextColor3 = Color3.fromRGB(255,255,255)
flyButton.Parent = menuFrame

-- Speed ayarı
local speedBox = Instance.new("TextBox")
speedBox.Size = UDim2.new(0,180,0,40)
speedBox.Position = UDim2.new(0,10,0,60)
speedBox.Text = "WalkSpeed"
speedBox.PlaceholderText = "0 - 500"
speedBox.BackgroundColor3 = Color3.fromRGB(70,70,70)
speedBox.TextColor3 = Color3.fromRGB(255,255,255)
speedBox.ClearTextOnFocus = false
speedBox.Parent = menuFrame

-- Jump butonu
local jumpButton = Instance.new("TextButton")
jumpButton.Size = UDim2.new(0,180,0,40)
jumpButton.Position = UDim2.new(0,10,0,110)
jumpButton.Text = "Jump +1m"
jumpButton.BackgroundColor3 = Color3.fromRGB(70,70,70)
jumpButton.TextColor3 = Color3.fromRGB(255,255,255)
jumpButton.Parent = menuFrame

-------------------------
-- Fonksiyonellik
-------------------------
local flying = false

menuButton.MouseButton1Click:Connect(function()
	menuFrame.Visible = not menuFrame.Visible
end)

flyButton.MouseButton1Click:Connect(function()
	flying = not flying
	flyButton.Text = "Fly: " .. (flying and "ON" or "OFF")
end)

-- speed ayarı
speedBox.FocusLost:Connect(function(enterPressed)
	local val = tonumber(speedBox.Text)
	if val then
		val = math.clamp(val,0,500)
		hum.WalkSpeed = val
	end
end)

-- jump
jumpButton.MouseButton1Click:Connect(function()
	local root = char:FindFirstChild("HumanoidRootPart")
	if root then
		root.CFrame = root.CFrame + Vector3.new(0,1,0) -- 1 metre yukarı
	end
end)

-- basılı tutarak sürekli zıplama
local uis = game:GetService("UserInputService")
local holding = false

jumpButton.MouseButton1Down:Connect(function()
	holding = true
	while holding do
		local root = char:FindFirstChild("HumanoidRootPart")
		if root then
			root.CFrame = root.CFrame + Vector3.new(0,1,0)
		end
		wait(0.2) -- her 0.2s'de 1m yukarı
	end
end)

jumpButton.MouseButton1Up:Connect(function()
	holding = false
end)

-- Fly mekaniği (telefon + PC için)
game:GetService("RunService").RenderStepped:Connect(function()
	if flying then
		local root = char:FindFirstChild("HumanoidRootPart")
		if root then
			root.Velocity = Vector3.new(0,5,0) -- sürekli yukarıda kalma
		end
	end
end)
