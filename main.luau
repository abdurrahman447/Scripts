-- Roblox'da yerel bir betik (LocalScript)
local Player = game.Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")

-- Buton ve menü GUI'lerini tanımla
local button = script.Parent.Parent:WaitForChild("Button")
local menu = script.Parent.Parent:WaitForChild("Menu")

local flyButton = menu:WaitForChild("FlyButton")
local speedInput = menu:WaitForChild("SpeedInput")

-- Menüyü başlangıçta gizle
menu.Visible = false

-- Buton hareketini kontrol et
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
        local mouse = Player:GetMouse()
        button.Position = UDim2.new(0, mouse.X - button.AbsoluteSize.X / 2, 0, mouse.Y - button.AbsoluteSize.Y / 2)
    end
end)

-- Menüyü açma/kapama
button.MouseButton1Click:Connect(function()
    menu.Visible = not menu.Visible
end)

-- Uçma işlevi
local isFlying = false
local defaultWalkSpeed = Humanoid.WalkSpeed

flyButton.MouseButton1Click:Connect(function()
    isFlying = not isFlying
    if isFlying then
        Humanoid.Sit = true -- Karakteri oturtarak yerçekimini devre dışı bırak
        Humanoid.PlatformStand = true
        Humanoid.WalkSpeed = 0 -- Yürüme hızını sıfırla
        flyButton.Text = "İniş"
    else
        Humanoid.Sit = false
        Humanoid.PlatformStand = false
        Humanoid.WalkSpeed = defaultWalkSpeed -- Varsayılan hıza dön
        flyButton.Text = "Uçma"
    end
end)

-- Hız ayarı
speedInput.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        local newSpeed = tonumber(speedInput.Text)
        if newSpeed and newSpeed >= 0 and newSpeed <= 500 and isFlying then
            Humanoid.WalkSpeed = newSpeed
        end
    end
end)
