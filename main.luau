-- LocalScript

local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hum = char:WaitForChild("Humanoid")
local root = char:WaitForChild("HumanoidRootPart")
local uis = game:GetService("UserInputService")
local runService = game:GetService("RunService")

-- ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "CustomMenuGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = player:WaitForChild("PlayerGui")

-------------------------
-- Menü Butonu ve Frame
-------------------------
local menuButton = Instance.new("TextButton")
menuButton.Size = UDim2.new(0,200,0,50)
menuButton.Position = UDim2.new(0.5, -100, 0, 50)
menuButton.Text = "MENU"
menuButton.BackgroundColor3 = Color3.fromRGB(30,30,30)
menuButton.TextColor3 = Color3.fromRGB(255,255,255)
menuButton.ZIndex = 10
menuButton.Parent = screenGui

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

-- SpeedBox
local speedBox = Instance.new("TextBox")
speedBox.Size = UDim2.new(0,200,0,40)
speedBox.Position = UDim2.new(0,10,0,60)
speedBox.PlaceholderText = "Fly Speed (0-500)"
speedBox.BackgroundColor3 = Color3.fromRGB(70,70,70)
speedBox.TextColor3 = Color3.fromRGB(255,255,255)
speedBox.ClearTextOnFocus = false
speedBox.Parent = menuFrame

-------------------------
-- Joystick ve Jump Button
-------------------------
local joystickFrame = Instance.new("Frame")
joystickFrame.Size = UDim2.new(0,150,0,150)
joystickFrame.Position = UDim2.new(0,50,1,-200)
joystickFrame.BackgroundTransparency = 0.5
joystickFrame.BackgroundColor3 = Color3.fromRGB(50,50,50)
joystickFrame.Visible = true
joystickFrame.Parent = screenGui

local joystick = Instance.new("Frame")
joystick.Size = UDim2.new(0,60,0,60)
joystick.Position = UDim2.new(0.5,-30,0.5,-30)
joystick.BackgroundColor3 = Color3.fromRGB(150,150,150)
joystick.AnchorPoint = Vector2.new(0.5,0.5)
joystick.Parent = joystickFrame

local jumpButton = Instance.new("TextButton")
jumpButton.Size = UDim2.new(0,80,0,80)
jumpButton.Position = UDim2.new(1,-100,1,-180)
jumpButton.Text = "JUMP"
jumpButton.BackgroundColor3 = Color3.fromRGB(70,70,70)
jumpButton.TextColor3 = Color3.fromRGB(255,255,255)
jumpButton.Parent = screenGui

-------------------------
-- Değişkenler
-------------------------
local flying = false
local flySpeed = 16
local moveVector = Vector3.new(0,0,0)
local joystickInput = Vector2.new(0,0)
local draggingMenu = false
local dragInput, mousePos, framePos

-------------------------
-- Menü İşlemleri
-------------------------
menuButton.MouseButton1Click:Connect(function()
	menuFrame.Visible = not menuFrame.Visible
end)

-- Menü butonunu sürükle
menuButton.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		draggingMenu = true
		mousePos = input.Position
		framePos = menuButton.Position
		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				draggingMenu = false
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
	if input == dragInput and draggingMenu then
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
	end
end)

-------------------------
-- Joystick işlemleri
-------------------------
local draggingJoystick = false

joystick.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
		draggingJoystick = true
	end
end)

joystick.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
		draggingJoystick = false
		joystick.Position = UDim2.new(0.5,-30,0.5,-30)
		joystickInput = Vector2.new(0,0)
	end
end)

uis.InputChanged:Connect(function(input)
	if draggingJoystick and (input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseMovement) then
		local delta = input.Position - joystickFrame.AbsolutePosition - Vector2.new(75,75)
		local clamped = Vector2.new(math.clamp(delta.X,-60,60), math.clamp(delta.Y,-60,60))
		joystick.Position = UDim2.new(0,75 + clamped.X - 30,0,75 + clamped.Y - 30)
		joystickInput = Vector2.new(clamped.X/60, -clamped.Y/60)
	end
end)

-------------------------
-- Jump Button
-------------------------
jumpButton.MouseButton1Click:Connect(function()
	hum.Jump = true
end)

-------------------------
-- Fly & Hareket
-------------------------
runService.RenderStepped:Connect(function()
	-- PC hareketi W/A/S/D
	moveVector = Vector3.new(0,0,0)
	if uis:IsKeyDown(Enum.KeyCode.W) then moveVector = moveVector + workspace.CurrentCamera.CFrame.LookVector end
	if uis:IsKeyDown(Enum.KeyCode.S) then moveVector = moveVector - workspace.CurrentCamera.CFrame.LookVector end
	if uis:IsKeyDown(Enum.KeyCode.A) then moveVector = moveVector - workspace.CurrentCamera.CFrame.RightVector end
	if uis:IsKeyDown(Enum.KeyCode.D) then moveVector = moveVector + workspace.CurrentCamera.CFrame.RightVector end

	-- Mobil joystick
	moveVector = moveVector + Vector3.new(joystickInput.X,0,joystickInput.Y)

	-- Fly hareketi
	if flying then
		if moveVector.Magnitude > 0 then
			moveVector = moveVector.Unit * flySpeed
		end
		root.Velocity = Vector3.new(moveVector.X, hum.JumpHeight, moveVector.Z)
		hum.WalkSpeed = flySpeed
	else
		hum.WalkSpeed = 16
	end
end)
