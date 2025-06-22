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

-- Çıktı konsoluna başarılı mesajı yaz
print("2D 'calisti' kutusu ekranda oluşturuldu!")
