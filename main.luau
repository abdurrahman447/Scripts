-- LocalScript (StarterPlayerScripts içine koyabilirsin)
local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hum = char:WaitForChild("Humanoid")
local uis = game:GetService("UserInputService")
local runService = game:GetService("RunService")

-- ScreenGui oluştur
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "CustomMenuGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = player:WaitForChild("PlayerGui")

-- Menü açma butonu
local menuButton = Instance.new("TextButton")
menuButton.Size = UDim2.new(0,200,0,50)
menuButton.Position = UDim2.new(0.5, -100, 0, 50) -- Orta üst
menuButton.Text = "MENU"
menuButton.BackgroundColor3 = Color3.fromRGB(30,30,30)
menuButton.TextColor3 = Color3.fromRGB(255,255,255)
menuButton.ZIndex = 10
menuButton.Parent = screenGui

-- Menü frame
local menuFrame = Instance.new("Frame")
menuFrame.Size = UDim2.new(0,220,0,200)
menuFrame.Position = UDim2.new(0.5, -110, 0, 120)
menuFrame.BackgroundColor3 = Color3.fromRGB(50,50,50)
menuFrame.Visible = false
menuFrame.Parent = screenGui

-- Fly toggle
local flyButton = Instance.new("TextButton")
flyButton.Size = UDim2.new(0,200,0,40)
flyButton.Position = UDim2.new(0,10,0,10)
flyButton.Text = "Fly: OFF"
flyButton.BackgroundColor3 = Color3.fromRGB(70,70,70)
flyButton.TextColor3 = Color3.fromRGB(255,255,255)
flyButton.Parent = menuFrame

-- Speed ayarı
local speedBox = Instance.new("TextBox")
speedBox.Size = UDim2.new(0,200,0,40)
speedBox.Position = UDim2.new(0,10,0,60)
speedBox.Text = ""
speedBox.PlaceholderText = "WalkSpeed (0-500)"
speedBox.BackgroundColor3 = Color3.fromRGB(70,70,70)
speedBox.TextColor3 = Color3.fromRGB(255,255,255)
speedBox.ClearTextOnFocus = false
speedBox.Parent = menuFrame

-- Jump butonu
local jumpButton = Instance.new("TextButton")
jumpButton.Size = UDim2.new(0,200,0,40)
jumpButton.Position = UDim2.new(0,10,0,110)
jumpButton.Text = "Jump +3m"
jumpButton.BackgroundColor3 = Color3.fromRGB(70,70,70)
jumpButton.TextColor3 = Color3.fromRGB(255,255,255)
jumpButton.Parent = menuFrame

-------------------------
-- Fonksiyonellik
-------------------------
local flying = false
local holdingJump = false
local flySpeed = 16

-- Menü aç/kapa
menuButton.MouseButton1Click:Connect(function()
	menuFrame.Visible = not menuFrame.Visible
end)

-- Menü butonunu sürüklenebilir yap
local dragging = false
local dragInput, mousePos, framePos
menuButton.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = true
		mousePos = input.Position
		framePos = menuButton.Position
		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
			end
		end)
	end
end)

menuButton.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement then
		dragInput = input
	end
end)

uis.InputChanged:Connect(function(input)
	if input == dragInput and dragging then
		local delta = input.Position - mousePos
		menuButton.Position = UDim2.new(framePos.X.Scale, framePos.X.Offset + delta.X,
									   framePos.Y.Scale, framePos.Y.Offset + delta.Y)
	end
end)

-- Fly toggle
flyButton.MouseButton1Click:Connect(function()
	flying = not flying
	flyButton.Text = "Fly: " .. (flying and "ON" or "OFF")
end)

-- WalkSpeed ayarı
speedBox.FocusLost:Connect(function()
	local val = tonumber(speedBox.Text)
	if val then
		val = math.clamp(val,0,500)
		flySpeed = val
		if not flying then
			hum.WalkSpeed = val
		end
	end
end)

-- Jump +3m tek sefer
jumpButton.MouseButton1Click:Connect(function()
	local root = char:FindFirstChild("HumanoidRootPart")
	if root then
		root.CFrame = root.CFrame + Vector3.new(0,3,0)
	end
end)

-- Basılı tutunca sürekli zıplama (0.5 saniyede 3m)
jumpButton.MouseButton1Down:Connect(function()
	holdingJump = true
	spawn(function()
		while holdingJump do
			local root = char:FindFirstChild("HumanoidRootPart")
			if root then
				root.CFrame = root.CFrame + Vector3.new(0,3,0)
			end
			wait(0.5)
		end
	end)
end)

jumpButton.MouseButton1Up:Connect(function()
	holdingJump = false
end)

-- Fly mekaniği (PC + mobil, hareket speedBox'a bağlı)
local moveVector = Vector3.new(0,0,0)
local keysDown = {}

uis.InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed then return end
	keysDown[input.KeyCode.Name] = true
end)

uis.InputEnded:Connect(function(input)
	keysDown[input.KeyCode.Name] = nil
end)

runService.RenderStepped:Connect(function()
	local root = char:FindFirstChild("HumanoidRootPart")
	if flying and root then
		-- Yön hareketleri
		local cam = workspace.CurrentCamera
		local forward = cam.CFrame.LookVector
		local right = cam.CFrame.RightVector
		moveVector = Vector3.new(0,0,0)
		if keysDown["W"] then moveVector = moveVector + forward end
		if keysDown["S"] then moveVector = moveVector - forward end
		if keysDown["A"] then moveVector = moveVector - right end
		if keysDown["D"] then moveVector = moveVector + right end
		moveVector = moveVector.Unit * flySpeed
		if moveVector ~= moveVector then moveVector = Vector3.new(0,0,0) end -- NaN kontrol

		-- Yükseklik sabit (havada kal)
		local vel = moveVector + Vector3.new(0,5,0)
		root.Velocity = vel
	end
end)
