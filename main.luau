-- Deneme Amaçlı Uçuş Kontrol Sistemi
local player = game:GetService("Players").LocalPlayer
local userInputService = game:GetService("UserInputService")
local runService = game:GetService("RunService")

local flightGui = Instance.new("ScreenGui")
flightGui.Name = "FlightControlGui"
flightGui.Parent = player:WaitForChild("PlayerGui")

local flightButton = Instance.new("TextButton")
flightButton.Size = UDim2.new(0, 150, 0, 50)
flightButton.Position = UDim2.new(0.5, -75, 0.8, 0) -- Ekranın alt ortası
flightButton.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
flightButton.TextColor3 = Color3.fromRGB(255, 255, 255)
flightButton.Text = "Uçuşu Başlat"
flightButton.Font = Enum.Font.SourceSansBold
flightButton.TextScaled = true
flightButton.BorderSizePixel = 0
flightButton.Parent = flightGui

local isFlying = false
local character = nil
local humanoid = nil
local humanoidRootPart = nil
local originalGravity = 0 -- Varsayılan 0, çünkü Humanoid yüklendiğinde güncelleyeceğiz
local moveSpeed = 30 -- Uçuş hızı (istediğiniz gibi değiştirebilirsiniz)
local flySpeedMultiplier = 2 -- Shift basılıyken uçuş hız çarpanı

local currentMoveVector = Vector3.new(0, 0, 0) -- Hareket yönü
local connections = {} -- Bağlantıları saklamak için tablo

-- Karakter ve Humanoid referanslarını güvenli bir şekilde al
local function setupCharacter()
    if player.Character then
        character = player.Character
        humanoid = character:WaitForChild("Humanoid")
        humanoidRootPart = character:WaitForChild("HumanoidRootPart")
        originalGravity = humanoid.Gravity -- Orijinal yerçekimini al
    else
        player.CharacterAdded:Wait() -- Karakter henüz yoksa bekle
        character = player.Character
        humanoid = character:WaitForChild("Humanoid")
        humanoidRootPart = character:WaitForChild("HumanoidRootPart")
        originalGravity = humanoid.Gravity
    end
end

-- Tuş girdilerini dinle
local function onInputBegan(input, gameProcessedEvent)
    if gameProcessedEvent then return end -- Oyun zaten işlediyse dur

    if isFlying then
        if input.UserInputType == Enum.UserInputType.Keyboard then
            local key = input.KeyCode
            if key == Enum.KeyCode.W then
                currentMoveVector = currentMoveVector + Vector3.new(0, 0, -1)
            elseif key == Enum.KeyCode.S then
                currentMoveVector = currentMoveVector + Vector3.new(0, 0, 1)
            elseif key == Enum.KeyCode.A then
                currentMoveVector = currentMoveVector + Vector3.new(-1, 0, 0)
            elseif key == Enum.KeyCode.D then
                currentMoveVector = currentMoveVector + Vector3.new(1, 0, 0)
            elseif key == Enum.KeyCode.Space then
                currentMoveVector = currentMoveVector + Vector3.new(0, 1, 0)
            elseif key == Enum.KeyCode.LeftShift or key == Enum.KeyCode.RightShift then
                currentMoveVector = currentMoveVector + Vector3.new(0, -1, 0)
            end
        end
        -- Mobil dokunmatik hareket de eklenebilir, ancak varsayılan Roblox joystiği bunu halleder.
        -- Buraya custom mobil UI hareket kontrolü eklemek daha karmaşık olur.
    end
end

local function onInputEnded(input, gameProcessedEvent)
    if gameProcessedEvent then return end

    if isFlying then
        if input.UserInputType == Enum.UserInputType.Keyboard then
            local key = input.KeyCode
            if key == Enum.KeyCode.W then
                currentMoveVector = currentMoveVector - Vector3.new(0, 0, -1)
            elseif key == Enum.KeyCode.S then
                currentMoveVector = currentMoveVector - Vector3.new(0, 0, 1)
            elseif key == Enum.KeyCode.A then
                currentMoveVector = currentMoveVector - Vector3.new(-1, 0, 0)
            elseif key == Enum.KeyCode.D then
                currentMoveVector = currentMoveVector - Vector3.new(1, 0, 0)
            elseif key == Enum.KeyCode.Space then
                currentMoveVector = currentMoveVector - Vector3.new(0, 1, 0)
            elseif key == Enum.KeyCode.LeftShift or key == Enum.KeyCode.RightShift then
                currentMoveVector = currentMoveVector - Vector3.new(0, -1, 0)
            end
        end
    end
end

-- Karakteri hareket ettiren fonksiyon (her karede çalışır)
local function onRenderStepped(deltaTime)
    if isFlying and humanoidRootPart and humanoid then
        local currentSpeed = moveSpeed
        if userInputService:IsKeyDown(Enum.KeyCode.LeftShift) or userInputService:IsKeyDown(Enum.KeyCode.RightShift) then
            currentSpeed = moveSpeed * flySpeedMultiplier
        end

        local desiredVelocity = currentMoveVector.Unit * currentSpeed
        if currentMoveVector.Magnitude > 0 then
            -- Karakterin bakış yönüne göre hareket ettir
            humanoidRootPart.CFrame = humanoidRootPart.CFrame + (humanoidRootPart.CFrame.LookVector * desiredVelocity.Z * deltaTime)
            humanoidRootPart.CFrame = humanoidRootPart.CFrame + (humanoidRootPart.CFrame.RightVector * desiredVelocity.X * deltaTime)
            humanoidRootPart.CFrame = humanoidRootPart.CFrame + (Vector3.new(0,1,0) * desiredVelocity.Y * deltaTime) -- Y ekseni (yukarı/aşağı) her zaman dünya yukarıdır.

            humanoid.WalkSpeed = 0 -- Yürüme hızını sıfırla ki default kontroller karışmasın
            humanoid.JumpPower = 0 -- Zıplamayı kapat
        else
            -- Hareket yoksa karakteri olduğu yerde tut
            humanoid.WalkSpeed = 0
            humanoid.JumpPower = 0
            humanoidRootPart.Velocity = Vector3.new(0,0,0) -- Dururken titreşimi engelle
            humanoidRootPart.RotVelocity = Vector3.new(0,0,0)
        end
    end
end

local function enableFlight()
    if not character or not humanoid or not humanoidRootPart then return end

    isFlying = true
    humanoid.Gravity = 0 -- Yerçekimini sıfırla
    humanoid.PlatformStand = true -- Karakteri havada sabit tut

    -- Varsayılan kontrolleri kapat
    humanoid.AutoRotate = false -- Otomatik dönüşü kapat
    humanoid.WalkSpeed = 0
    humanoid.JumpPower = 0
    character.HumanoidRootPart.CanCollide = false -- Başka parçalarla çarpışmayı kapat
    -- Opsiyonel: Kamerayı serbest moda geçirebilirsiniz
    -- game:GetService("StarterGui"):SetCoreGuiEnabled(Enum.CoreGuiType.All, false) -- Tüm varsayılan GUI'leri kapat

    flightButton.Text = "Uçuşu Durdur"

    -- Uçuş hareket dinleyicilerini bağla
    connections.InputBegan = userInputService.InputBegan:Connect(onInputBegan)
    connections.InputEnded = userInputService.InputEnded:Connect(onInputEnded)
    connections.RenderStepped = runService.RenderStepped:Connect(onRenderStepped)
    print("Uçuş başlatıldı!")
end

local function disableFlight()
    if not character or not humanoid or not humanoidRootPart then return end

    isFlying = false
    humanoid.Gravity = originalGravity -- Orijinal yerçekimini geri yükle
    humanoid.PlatformStand = false -- Platform standı kapat
    humanoid.AutoRotate = true -- Otomatik dönüşü aç
    humanoid.WalkSpeed = 16 -- Varsayılan yürüme hızı (oyununuza göre değişebilir)
    humanoid.JumpPower = 50 -- Varsayılan zıplama gücü (oyununuza göre değişebilir)
    character.HumanoidRootPart.CanCollide = true -- Çarpışmayı tekrar aç
    -- Opsiyonel: Kamerayı eski haline getir
    -- game:GetService("StarterGui"):SetCoreGuiEnabled(Enum.CoreGuiType.All, true)

    -- Bağlantıları kes
    for _, connection in pairs(connections) do
        connection:Disconnect()
    end
    connections = {} -- Tabloyu temizle

    currentMoveVector = Vector3.new(0,0,0) -- Hareket vektörünü sıfırla
    humanoidRootPart.Velocity = Vector3.new(0,0,0) -- Hızı sıfırla
    humanoidRootPart.RotVelocity = Vector3.new(0,0,0) -- Dönme hızını sıfırla

    flightButton.Text = "Uçuşu Başlat"
    print("Uçuş durduruldu.")
end

-- Butona tıklama olayı
flightButton.MouseButton1Click:Connect(function()
    if not character or not humanoid or not humanoidRootPart then
        setupCharacter() -- Karakter referansları yoksa tekrar kur
        if not character or not humanoid or not humanoidRootPart then
            warn("Karakter referansları hala alınamıyor.")
            return
        end
    end

    if isFlying then
        disableFlight()
    else
        enableFlight()
    end
end)

-- Karakter yeniden yüklendiğinde (ölünce vb.) uçuş durumunu sıfırla
player.CharacterAdded:Connect(function(newChar)
    if isFlying then -- Eğer uçuş modundayken öldüyse, uçuşu durdur
        disableFlight()
    end
    -- Yeni karakteri ayarla ve Humanoid'i tekrar bağla
    character = newChar
    humanoid = newChar:WaitForChild("Humanoid")
    humanoidRootPart = newChar:WaitForChild("HumanoidRootPart")
    originalGravity = humanoid.Gravity -- Yeni karakter için orijinal yerçekimini güncelle

    -- Humanoid referansları güncellendiğinde, tekrar uçuşa geçebilmek için butonu hazırla
    flightButton.Text = "Uçuşu Başlat"
    isFlying = false
end)

-- İlk karakter kurulumunu yap
setupCharacter()

print("Uçuş kontrol sistemi yüklendi.")
