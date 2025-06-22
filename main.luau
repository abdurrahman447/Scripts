-- Ekran üzerindeki GUI elemanları için bir ScreenGui oluştur
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "CalistiScreenGui"
screenGui.Parent = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")

-- ScreenGui içine bir Frame (kutu) oluştur
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 200, 0, 100)
mainFrame.Position = UDim2.new(0.5, -100, 0.5, -50)
mainFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
mainFrame.BackgroundTransparency = 0.2
mainFrame.BorderColor3 = Color3.fromRGB(255, 255, 255)
mainFrame.BorderSizePixel = 2
mainFrame.Active = true -- Sürükleme için aktif hale getir (önceki gibi)
mainFrame.Draggable = false -- Manuel olarak sürükleyeceğiz (önceki gibi)
mainFrame.Parent = screenGui

-- Frame içine bir TextLabel (yazı) oluştur
local textLabel = Instance.new("TextLabel")
textLabel.Size = UDim2.new(1, 0, 1, 0)
textLabel.Text = "calisti"
textLabel.Font = Enum.Font.SourceSansBold
textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
textLabel.TextScaled = true
textLabel.TextWrapped = true
textLabel.BackgroundTransparency = 1
textLabel.Parent = mainFrame

-- Çarpı işareti için bir TextButton oluştur
local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.new(0, 30, 0, 30)
closeButton.Position = UDim2.new(1, -30, 0, 0)
closeButton.Text = "X"
closeButton.Font = Enum.Font.SourceSansBold
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
closeButton.BackgroundTransparency = 0
closeButton.BorderSizePixel = 0
closeButton.Parent = mainFrame

-- Kapatma düğmesine tıklandığında Frame'i gizle
closeButton.MouseButton1Click:Connect(function()
    mainFrame.Visible = false
end)

-- Sürükleme özelliği için değişkenler
local isDragging = false
local dragStartPos = Vector2.new(0, 0)
local initialFramePos = UDim2.new(0, 0, 0, 0)
local UserInputService = game:GetService("UserInputService") -- UserInputService'i kısaltma olarak tanımla

-- Frame'e fare veya dokunma basıldığında sürüklemeyi başlat
mainFrame.InputBegan:Connect(function(input, gameProcessedEvent)
    -- Sadece sol fare tuşu veya parmak dokunuşu ise
    if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) and not gameProcessedEvent then
        isDragging = true
        dragStartPos = input.Position -- Fare veya dokunma pozisyonu
        initialFramePos = mainFrame.Position -- Çerçevenin o anki pozisyonu
    end
end)

-- Fare veya parmak hareket ettiğinde Frame'i hareket ettir
UserInputService.InputChanged:Connect(function(input, gameProcessedEvent)
    -- Sadece fare hareketi veya parmak dokunuşu hareketi ve sürükleme aktifse
    if (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) and isDragging and not gameProcessedEvent then
        local delta = input.Position - dragStartPos -- Başlangıçtan ne kadar kaydığını hesapla
        local newX = initialFramePos.X.Offset + delta.X
        local newY = initialFramePos.Y.Offset + delta.Y
        mainFrame.Position = UDim2.new(0, newX, 0, newY)
    end
end)

-- Fare veya parmak bırakıldığında sürüklemeyi durdur
UserInputService.InputEnded:Connect(function(input, gameProcessedEvent)
    -- Sadece sol fare tuşu veya parmak dokunuşu bırakıldıysa
    if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
        isDragging = false
    end
end)

print("2D 'calisti' kutusu ekranda oluşturuldu ve hem fare hem de dokunmatik cihazlar için sürüklenebilir hale getirildi, ayrıca bir kapatma düğmesi eklendi!")

