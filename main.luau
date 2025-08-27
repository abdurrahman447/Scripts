-- LocalScript (ScreenGui içinde)

local screenGui = script.Parent
local button = screenGui:WaitForChild("MainButton") -- sürüklenen buton

local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

-- Başlangıç ayarları
local flying = false
local bodyVel
local speed = 50 -- hız buradan ayarlanabilir (0–500)

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
	if input.UserInputType == Enum.UserInputType.MouseButton1 
	or input.UserInputType == Enum.UserInputType.Touch then
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
	if input.UserInputType == Enum.UserInputType.MouseMovement 
	or input.UserInputType == Enum.UserInputType.Touch then
		dragInput = input
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if input == dragInput and dragging then
		update(input)
	end
end)

-- Butona tıklayınca Fly aç/kapa
button.MouseButton1Click:Connect(function()
	flying = not flying
	if flying then
		button.Text = "Fly: ON"
		bodyVel = Instance.new("BodyVelocity")
		bodyVel.MaxForce = Vector3.new(1e5, 1e5, 1e5)
		bodyVel.Velocity = Vector3.zero
		bodyVel.Parent = character:WaitForChild("HumanoidRootPart")
	else
		button.Text = "Fly: OFF"
		if bodyVel then
			bodyVel:Destroy()
			bodyVel = nil
		end
	end
end)

-- Uçarken yön kontrolü
game:GetService("RunService").Heartbeat:Connect(function()
	if flying and bodyVel then
		local moveDir = humanoid.MoveDirection
		bodyVel.Velocity = moveDir * (speed + humanoid.WalkSpeed)
	end
end)
