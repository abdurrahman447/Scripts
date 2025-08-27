-- GUI öğelerini tanımla
local button = script.Parent -- sürüklenen buton
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

-- Menü
local menu = button.Parent:WaitForChild("MenuFrame") 
menu.Visible = false 

-- Fly butonu ve Speed kutusu
local flyButton = menu:WaitForChild("FlyButton")
local speedBox = menu:WaitForChild("SpeedBox")

-- Sürüklenebilirlik
local UserInputService = game:GetService("UserInputService")
local dragging, dragInput, dragStart, startPos

local function update(input)
	local delta = input.Position - dragStart
	button.Position = UDim2.new(
		startPos.X.Scale, startPos.X.Offset + delta.X,
		startPos.Y.Scale, startPos.Y.Offset + delta.Y
	)
end

button.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragging = true
		dragStart = input.Position
		startPos = button.Position

		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
			end
		end)
	end
end)

button.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
		dragInput = input
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if input == dragInput and dragging then
		update(input)
	end
end)

-- Butona basınca menüyü aç/kapat
button.MouseButton1Click:Connect(function()
	menu.Visible = not menu.Visible
end)

-- Fly sistemi
local flying = false
local bodyVel

flyButton.MouseButton1Click:Connect(function()
	flying = not flying
	if flying then
		flyButton.Text = "Fly: ON"
		bodyVel = Instance.new("BodyVelocity")
		bodyVel.MaxForce = Vector3.new(1e5, 1e5, 1e5)
		bodyVel.Velocity = Vector3.zero
		bodyVel.Parent = character:WaitForChild("HumanoidRootPart")
	else
		flyButton.Text = "Fly: OFF"
		if bodyVel then
			bodyVel:Destroy()
			bodyVel = nil
		end
	end
end)

-- Speed ayarı
speedBox.FocusLost:Connect(function(enterPressed)
	local val = tonumber(speedBox.Text)
	if val and val >= 0 and val <= 500 then
		humanoid.WalkSpeed = val
	else
		speedBox.Text = tostring(humanoid.WalkSpeed) -- geçerli hız göster
	end
end)

-- Eğer uçma açıkken hareket tuşlarına basılırsa uçma yönü
game:GetService("RunService").Heartbeat:Connect(function()
	if flying and bodyVel then
		local moveDir = humanoid.MoveDirection
		bodyVel.Velocity = moveDir * (humanoid.WalkSpeed + 20)
	end
end)
