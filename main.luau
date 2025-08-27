-- Kodu Button objesinin icine koyun
local Player = game.Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local mouse = Player:GetMouse()

-- GUI objelerine erisim.
-- Artık button.Parent'i doğru şekilde bulacak ve oradan diger objelere erisecek.
local screenGui = script.Parent.Parent
local button = script.Parent
local menu = screenGui:WaitForChild("Menu")
local flyButton = menu:WaitForChild("FlyButton")
local speedInput = menu:WaitForChild("SpeedInput")

-- Butonun gorsel ozellikleri
button.Text = "Menu"
button.Size = UDim2.new(0, 100, 0, 100)
button.Position = UDim2.new(0.5, -50, 0.5, -50)
button.BackgroundColor3 = Color3.new(0, 0.5, 1)

-- Menu gorsel ozellikleri
menu.Size = UDim2.new(0, 250, 0, 200)
menu.Position = UDim2.new(0.5, -125, 0.5, -100)
menu.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
menu.Visible = false

-- FlyButton gorsel ozellikleri
flyButton.Text = "Uçma"
flyButton.Size = UDim2.new(0, 150, 0, 50)
flyButton.Position = UDim2.new(0.5, -75, 0.2, 0)
flyButton.BackgroundColor3 = Color3.new(0, 0.8, 0.2)

-- SpeedInput gorsel ozellikleri
speedInput.PlaceholderText = "0-500"
speedInput.Size = UDim2.new(0, 100, 0, 40)
speedInput.Position = UDim2.new(0.5, -50, 0.7, 0)

---

-- Buton hareketini kontrol etme
local dragging = false
button.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
    end
end)

button.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

game:GetService("RunService").RenderStepped:Connect(function()
    if dragging then
        button.Position = UDim2.new(0, mouse.X - button.AbsoluteSize.X / 2, 0, mouse.Y - button.AbsoluteSize.Y / 2)
    end
end)

-- Menuyu acma/kapama
local isMenuVisible = false
button.MouseButton1Click:Connect(function()
    isMenuVisible = not isMenuVisible
    menu.Visible = isMenuVisible
end)

---

-- Ucus ve hiz ayarlari
local isFlying = false
local defaultWalkSpeed = Humanoid.WalkSpeed

flyButton.MouseButton1Click:Connect(function()
    isFlying = not isFlying
    if isFlying then
        Humanoid.Sit = true
        Humanoid.PlatformStand = true
        Humanoid.WalkSpeed = 0
        flyButton.Text = "İniş"
    else
        Humanoid.Sit = false
        Humanoid.PlatformStand = false
        Humanoid.WalkSpeed = defaultWalkSpeed
        flyButton.Text = "Uçma"
    end
end)

-- Hiz ayari
speedInput.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        local newSpeed = tonumber(speedInput.Text)
        if newSpeed and newSpeed >= 0 and newSpeed <= 500 then
            Humanoid.WalkSpeed = newSpeed
        else
            print("Gecersiz hiz degeri. Lutfen 0 ile 500 arasinda bir sayi girin.")
        end
    end
end)
