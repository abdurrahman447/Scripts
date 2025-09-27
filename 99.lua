-- StarterGui içine bir LocalScript olarak koy
local Lighting = game:GetService("Lighting")
local player = game.Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- === Buton oluşturma ===
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "MakeEveningGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

local button = Instance.new("TextButton")
button.Size = UDim2.new(0, 220, 0, 64)
button.Position = UDim2.new(0.5, 0, 1, -90) -- alt orta
button.AnchorPoint = Vector2.new(0.5, 1)
button.Text = "🌙 Akşam Yap"
button.TextScaled = true
button.Font = Enum.Font.GothamBold
button.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
button.TextColor3 = Color3.fromRGB(240, 240, 240)
button.BorderSizePixel = 0
button.Parent = screenGui

-- köşeleri yuvarlat
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 12)
corner.Parent = button

-- === Butona basıldığında ===
button.Activated:Connect(function()
    -- Akşam değerleri
    Lighting.ClockTime = 18
    Lighting.Brightness = 1.5
    Lighting.Ambient = Color3.fromRGB(90, 90, 110)
    Lighting.FogEnd = 1000

    -- geri bildirim
    button.Text = "✅ Akşam Oldu"
    task.delay(2, function()
        if button then
            button.Text = "🌙 Akşam Yap"
        end
    end)
end)
