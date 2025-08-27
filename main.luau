-- Gui Referansları
local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hum = char:WaitForChild("Humanoid")
local hrp = char:WaitForChild("HumanoidRootPart")

local screenGui = script.Parent

-- Menü Açma Butonu
local mainButton = Instance.new("TextButton")
mainButton.Size = UDim2.new(0,100,0,50)
mainButton.Position = UDim2.new(0,20,0,200)
mainButton.Text = "MENU"
mainButton.Parent = screenGui
mainButton.BackgroundColor3 = Color3.fromRGB(0,170,255)

-- Menü Frame
local menuFrame = Instance.new("Frame")
menuFrame.Size = UDim2.new(0,200,0,200)
menuFrame.Position = UDim2.new(0,20,0,260)
menuFrame.BackgroundColor3 = Color3.fromRGB(40,40,40)
menuFrame.Visible = false
menuFrame.Parent = screenGui

-- Speed Label + Box
local speedLabel = Instance.new("TextLabel")
speedLabel.Size = UDim2.new(0,80,0,30)
speedLabel.Position = UDim2.new(0,10,0,10)
speedLabel.Text = "Speed:"
speedLabel.TextColor3 = Color3.new(1,1,1)
speedLabel.BackgroundTransparency = 1
speedLabel.Parent = menuFrame

local speedBox = Instance.new("TextBox")
speedBox.Size = UDim2.new(0,80,0,30)
speedBox.Position = UDim2.new(0,100,0,10)
speedBox.Text = tostring(hum.WalkSpeed)
speedBox.Parent = menuFrame

-- Fly Toggle
local flyButton = Instance.new("TextButton")
flyButton.Size = UDim2.new(0,180,0,40)
flyButton.Position = UDim2.new(0,10,0,50)
flyButton.Text = "Fly: OFF"
flyButton.Parent = menuFrame
flyButton.BackgroundColor3 = Color3.fromRGB(100,100,255)

-- Mobil Jump Butonu
local jumpButton = Instance.new("TextButton")
jumpButton.Size = UDim2.new(0,100,0,100)
jumpButton.Position = UDim2.new(1,-120,1,-120)
jumpButton.AnchorPoint = Vector2.new(0,0)
jumpButton.Text = "↑"
jumpButton.TextScaled = true
jumpButton.BackgroundColor3 = Color3.fromRGB(255,100,100)
jumpButton.Parent = screenGui

-- Menü Aç/Kapa
mainButton.MouseButton1Click:Connect(function()
	menuFrame.Visible = not menuFrame.Visible
end)

-- Speed Ayarı
speedBox.FocusLost:Connect(function()
	local val = tonumber(speedBox.Text)
	if val and val >= 0 and val <= 500 then
		hum.WalkSpeed = val
	end
end)

-- Fly Sistemi
local flying = false
flyButton.MouseButton1Click:Connect(function()
	flying = not flying
	if flying then
		flyButton.Text = "Fly: ON"
	else
		flyButton.Text = "Fly: OFF"
	end
end)

-- Jump Sistemi (Telefon İçin)
local jumping = false

local function jumpStep()
	if jumping then
		hrp.CFrame = hrp.CFrame + Vector3.new(0,1,0) -- 1 metre yukarı
	end
end

jumpButton.MouseButton1Down:Connect(function()
	jumping = true
	while jumping do
		jumpStep()
		task.wait(0.2) -- hız ayarı (0.2sn'de 1 metre)
	end
end)

jumpButton.MouseButton1Up:Connect(function()
	jumping = false
end)

-- Uçma Kontrolü
game:GetService("RunService").RenderStepped:Connect(function()
	if flying then
		local moveDir = hum.MoveDirection
		hrp.Velocity = moveDir * hum.WalkSpeed + Vector3.new(0,0,0)
	end
end)
