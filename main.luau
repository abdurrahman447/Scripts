-- Ekran üzerindeki GUI elemanları için bir ScreenGui oluştur
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "CalistiScreenGui" -- GUI'ye bir isim verelim ki kolayca bulabilelim
screenGui.Parent = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui") -- LocalPlayer'ın PlayerGui'sine bağla

-- ScreenGui içine bir Frame (kutu) oluştur
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 200, 0, 100) -- Boyutunu ayarla (genişlik 200 piksel, yükseklik 100 piksel)
mainFrame.Position = UDim2.new(0.5, -100, 0.5, -50) -- Ekranın ortasına yerleştir (merkezden sola 100, yukarı 50 kaydır)
mainFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50) -- Koyu gri bir arka plan rengi ver
mainFrame.BackgroundTransparency = 0.2 -- Hafif şeffaf yap
mainFrame.BorderColor3 = Color3.fromRGB(255, 255, 255) -- Beyaz kenarlık
mainFrame.BorderSizePixel = 2 -- 2 piksel kalınlığında kenarlık
mainFrame.Active = true -- Sürükleme için aktif hale getir
mainFrame.Draggable = false -- Manuel olarak sürükleyeceğiz, otomatik sürükleme özelliğini kapat
mainFrame.Parent = screenGui

-- Frame içine bir TextLabel (yazı) oluştur
local textLabel = Instance.new("TextLabel")
textLabel.Size = UDim2.new(1, 0, 1, 0) -- Frame'in tamamını kaplasın
textLabel.Text = "calisti" -- Görüntülenecek metin
textLabel.Font = Enum.Font.SourceSansBold -- Kalın bir yazı tipi kullan
textLabel.TextColor3 = Color3.fromRGB(255, 255, 255) -- Beyaz yazı rengi
textLabel.TextScaled = true -- Metni kutuya sığacak şekilde otomatik ölçekle
textLabel.TextWrapped = true -- Uzun metinleri otomatik satır atla
textLabel.BackgroundTransparency = 1 -- Arka planı tamamen şeffaf yap
textLabel.Parent = mainFrame

-- Çarpı işareti için bir TextButton oluştur
local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.new(0, 30, 0, 30) -- Küçük bir kare düğme
closeButton.Position = UDim2.new(1, -30, 0, 0) -- Sağ üste yerleştir (Frame'in sağından 30 piksel sola, üstünden 0 piksel aşağı)
closeButton.Text = "X" -- Çarpı işareti metni
closeButton.Font = Enum.Font.SourceSansBold -- Kalın bir yazı tipi
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255) -- Beyaz yazı
closeButton.BackgroundColor3 = Color3.fromRGB(200, 0, 0) -- Kırmızı arka plan
closeButton.BackgroundTransparency = 0 -- Tamamen opak
closeButton.BorderSizePixel = 0 -- Kenarlık olmasın
closeButton.Parent = mainFrame

-- Kapatma düğmesine tıklandığında Frame'i gizle
closeButton.MouseButton1Click:Connect(function()
    mainFrame.Visible = false -- Frame'i görünmez yapar
    -- İsterseniz frame:Destroy() kullanarak tamamen silebilirsiniz.
    -- Bu durumda, aynı kodu tekrar çalıştırana kadar geri gelmez.
end)

-- Sürükleme özelliği için değişkenler
local isDragging = false
local dragStartPos = Vector2.new(0, 0)
local initialFramePos = UDim2.new(0, 0, 0, 0)

-- Frame'e fare basıldığında sürüklemeyi başlat
mainFrame.InputBegan:Connect(function(input, gameProcessedEvent)
    if input.UserInputType == Enum.UserInputType.MouseButton1 and not gameProcessedEvent then
        isDragging = true
        dragStartPos = input.Position
        initialFramePos = mainFrame.Position
    end
end)

-- Fare hareket ettiğinde Frame'i hareket ettir
game:GetService("UserInputService").InputChanged:Connect(function(input, gameProcessedEvent)
    if input.UserInputType == Enum.UserInputType.MouseMovement and isDragging and not gameProcessedEvent then
        local delta = input.Position - dragStartPos
        local newX = initialFramePos.X.Offset + delta.X
        local newY = initialFramePos.Y.Offset + delta.Y
        mainFrame.Position = UDim2.new(0, newX, 0, newY)
    end
end)

-- Fare bırakıldığında sürüklemeyi durdur
game:GetService("UserInputService").InputEnded:Connect(function(input, gameProcessedEvent)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        isDragging = false
    end
end)

-- Çıktı konsoluna başarılı mesajı yaz
print("2D 'calisti' kutusu ekranda oluşturuldu ve sürüklenebilir hale getirildi, ayrıca bir kapatma düğmesi eklendi!")
