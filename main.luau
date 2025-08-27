-- LocalScript (StarterPlayerScripts içine koy)
local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hum = char:WaitForChild("Humanoid")
local root = char:WaitForChild("HumanoidRootPart")
local uis = game:GetService("UserInputService")
local runService = game:GetService("RunService")

-- ScreenGui oluştur
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "CustomMenuGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = player:WaitForChild("PlayerGui")

-- Menü butonu
local menuButton = Instance.new("TextButton")
menuButton.Size = UDim2.new(0,200,0,50)
menuButton.Position = UDim2.new(0.5, -100, 0, 50)
menuButton.Text = "MENU"
menuButton.BackgroundColor3 = Color3.fromRGB(30,30,30)
menuButton.TextColor3 = Color3.fromRGB(255,255,255)
menuButton.ZIndex = 10
menuButton.Parent = screenGui

-- Menü frame
local menuFrame = Instance.new("Frame")
menuFrame.Size = UDim2.new(0,220,0,150)
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
speedBox.PlaceholderText = "WalkSpeed (0-500)"
speedBox.BackgroundColor3 = Color3.fromRGB(70,70,70)
speedBox.TextColor3 = Color3.fromRGB(255,255,255)
speedBox.ClearTextOnFocus = false
speedBox.Parent = menuFrame

-------------------------
-- Değişkenler
-------------------------
local flying = false
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

-- SpeedBox ayarı
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

-- Fly hareketi (speedBox ile uyumlu)
runService.RenderStepped:Connect(function()
	if flying then
		local cam = workspace.CurrentCamera
		local moveVector = Vector3.new(0,0,0)

		if uis:IsKeyDown(Enum.KeyCode.W) then moveVector = moveVector + cam.CFrame.LookVector end
		if uis:IsKeyDown(Enum.KeyCode.S) then moveVector = moveVector - cam.CFrame.LookVector end
		if uis:IsKeyDown(Enum.KeyCode.A) then moveVector = moveVector - cam.CFrame.RightVector end
		if uis:IsKeyDown(Enum.KeyCode.D) then moveVector = moveVector + cam.CFrame.RightVector end

		if moveVector.Magnitude > 0 then
			moveVector = moveVector.Unit * flySpeed
		end

		-- Fly yukarıda sabit kalsın
		root.Velocity = moveVector + Vector3.new(0, hum.JumpHeight, 0)
		hum.WalkSpeed = flySpeed
	end
end)
