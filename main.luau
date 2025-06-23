-- Deneme Amaçlı Uçuş Kontrol Sistemi
local player = game:GetService("Players").LocalPlayer
local userInputService = game:GetService("UserInputService")
local runService = game:GetService("RunService")
local ContextActionService = game:GetService("ContextActionService") -- Mobil zıplama butonu için

-- GUI oluşturma
local flightGui = Instance.new("ScreenGui")
flightGui.Name = "FlightControlGui"
flightGui.Parent = player:WaitForChild("PlayerGui")

local flightButton = Instance.new("TextButton")
flightButton.Size = UDim2.new(0, 150, 0, 50)
flightButton.Position = UDim2.new(0.5, -75, 0.8, 0) -- Ekranın alt ortası
flightButton.BackgroundColor3 = Color3.fromRGB(0, 100, 0) -- Koyu yeşil
flightButton.TextColor3 = Color3.fromRGB(255, 255, 255)
flightButton.Text = "Uçuş Modunu Aç" -- Başlangıç metni
flightButton.Font = Enum.Font.SourceSansBold
flightButton.TextScaled = true
flightButton.BorderSizePixel = 0
flightButton.Parent = flightGui

-- Durum değişkenleri
local isFlightModeEnabled = false -- Uçuş modu aktif mi?
local isFlying = false -- Karakter şu an uçuyor mu?

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
        originalGravity = humanoid.Gravity
    else
        character = player.CharacterAdded:Wait()
        humanoid = character:WaitForChild("Humanoid")
        humanoidRootPart = character:WaitForChild("HumanoidRootPart")
        originalGravity = humanoid.Gravity
    end
end

-- Uçuşu Başlatma Fonksiyonu
local function enableFlight()
    if not character or not humanoid or not humanoidRootPart then return end
    if isFlying then return end -- Zaten uçuyorsa tekrar başlatma

    isFlying = true
    humanoid.Gravity = 0
    humanoid.PlatformStand = true

    -- Varsayılan kontrolleri kapat
    humanoid.AutoRotate = false
    humanoid.WalkSpeed = 0
    humanoid.JumpPower = 0
    character.HumanoidRootPart.CanCollide = false

    -- Hareket dinleyicilerini bağla (sadece uçuş aktifken hareket etsin)
    connections.InputBegan_Move = userInputService.InputBegan:Connect(function(input, gameProcessedEvent)
        if gameProcessedEvent then return end
        if isFlying and input.UserInputType == Enum.UserInputType.Keyboard then
            local key = input.KeyCode
            if key == Enum.KeyCode.W then
                currentMoveVector = currentMoveVector + Vector3.new(0, 0, -1)
            elseif key == Enum.KeyCode.S then
                currentMoveVector = currentMoveVector + Vector3.new(0, 0, 1)
            elseif key == Enum.KeyCode.A then
                currentMoveVector = currentMoveVector + Vector3.new(-1, 0, 0)
            elseif key == Enum.KeyCode.D then
                currentMoveVector = currentMoveVector + Vector3.new(1, 0, 0)
            -- Space tuşu artık sadece uçuşu başlatıp durdurur, yukarı gitmez.
            -- Yukarı gitme için ayrı bir tuş düşünülmeli veya mevcut mantık değiştirilmeli.
            elseif key == Enum.KeyCode.E then -- E tuşu ile yukarı
                currentMoveVector = currentMoveVector + Vector3.new(0, 1, 0)
            elseif key == Enum.KeyCode.LeftShift or key == Enum.KeyCode.RightShift then
                currentMoveVector = currentMoveVector + Vector3.new(0, -1, 0) -- Shift ile aşağı
            end
        end
    end)

    connections.InputEnded_Move = userInputService.InputEnded:Connect(function(input, gameProcessedEvent)
        if gameProcessedEvent then return end
        if isFlying and input.UserInputType == Enum.UserInputType.Keyboard then
            local key = input.KeyCode
            if key == Enum.KeyCode.W then
                currentMoveVector = currentMoveVector - Vector3.new(0, 0, -1)
            elseif key == Enum.KeyCode.S then
                currentMoveVector = currentMoveVector - Vector3.new(0, 0, 1)
            elseif key == Enum.KeyCode.A then
                currentMoveVector = currentMoveVector - Vector3.new(-1, 0, 0)
            elseif key == Enum.KeyCode.D then
                currentMoveVector = currentMoveVector - Vector3.new(1, 0, 0)
            elseif key == Enum.KeyCode.E then -- E tuşu bırakıldığında
                currentMoveVector = currentMoveVector - Vector3.new(0, 1, 0)
            elseif key == Enum.KeyCode.LeftShift or key == Enum.KeyCode.RightShift then
                currentMoveVector = currentMoveVector - Vector3.new(0, -1, 0)
            end
        end
    end)

    connections.RenderStepped = runService.RenderStepped:Connect(function(deltaTime)
        if isFlying and humanoidRootPart and humanoid then
            local currentSpeed = moveSpeed
            if userInputService:IsKeyDown(Enum.KeyCode.LeftShift) or userInputService:IsKeyDown(Enum.KeyCode.RightShift) then
                currentSpeed = moveSpeed * flySpeedMultiplier
            end

            local desiredVelocity = currentMoveVector.Unit * currentSpeed
            if currentMoveVector.Magnitude > 0 then
                -- Karakterin baktığı yöne göre hareket etsin
                humanoidRootPart.CFrame = humanoidRootPart.CFrame + (humanoidRootPart.CFrame.LookVector * desiredVelocity.Z * deltaTime)
                humanoidRootPart.CFrame = humanoidRootPart.CFrame + (humanoidRootPart.CFrame.RightVector * desiredVelocity.X * deltaTime)
                humanoidRootPart.CFrame = humanoidRootPart.CFrame + (Vector3.new(0,1,0) * desiredVelocity.Y * deltaTime) -- Y ekseni (yukarı/aşağı) her zaman dünya yukarıdır.
            else
                humanoidRootPart.Velocity = Vector3.new(0,0,0)
                humanoidRootPart.RotVelocity = Vector3.new(0,0,0)
            end
        end
    end)
    print("Uçuş başlatıldı!")
end

-- Uçuşu Durdurma Fonksiyonu
local function disableFlight()
    if not character or not humanoid or not humanoidRootPart then return end
    if not isFlying then return end -- Zaten uçmuyorlarsa tekrar durdurma

    isFlying = false
    humanoid.Gravity = originalGravity
    humanoid.PlatformStand = false
    humanoid.AutoRotate = true
    humanoid.WalkSpeed = 16 -- Varsayılan yürüme hızı
    humanoid.JumpPower = 50 -- Varsayılan zıplama gücü
    character.HumanoidRootPart.CanCollide = true

    -- Hareket dinleyici bağlantılarını kes
    if connections.InputBegan_Move then connections.InputBegan_Move:Disconnect() end
    if connections.InputEnded_Move then connections.InputEnded_Move:Disconnect() end
    if connections.RenderStepped then connections.RenderStepped:Disconnect() end
    connections = {} -- Tabloyu temizle

    currentMoveVector = Vector3.new(0,0,0)
    humanoidRootPart.Velocity = Vector3.new(0,0,0)
    humanoidRootPart.RotVelocity = Vector3.new(0,0,0)
    print("Uçuş durduruldu.")
end

-- Jump (Zıplama) Tuşu Basıldığında/Bırakıldığında Uçuşu Yönet
local function handleJumpAction(actionName, inputState, inputObject)
    -- Uçuş modu kapalıysa veya oyun zaten bir girdiyi işliyorsa varsayılan zıplamaya izin ver
    if not isFlightModeEnabled or inputObject.UserInputType == Enum.UserInputType.Touch and inputObject.Position.Y == 0 then
        -- Mobil zıplama butonu için bazen y=0 gelir, bu durumda default aksiyon geçsin.
        return Enum.ContextActionResult.Pass
    end

    if inputState == Enum.UserInputState.Begin then
        if isFlying then
            disableFlight()
        else
            enableFlight()
        end
    end
    return Enum.ContextActionResult.Sink -- Zıplama eylemini tüket, varsayılan zıplamayı engelle
end

-- Butona tıklama olayı (Uçuş Modunu Açar/Kapatır)
flightButton.MouseButton1Click:Connect(function()
    print("Uçuş Modu butonu tıklandı!")

    if not character or not humanoid or not humanoidRootPart then
        setupCharacter()
        if not character or not humanoid or not humanoidRootPart then
            warn("Karakter referansları hala alınamıyor. Buton tıklama başarısız.")
            return
        end
    end

    if isFlightModeEnabled then
        -- Uçuş modu zaten açıksa, kapat
        disableFlight() -- Önce varsa aktif uçuşu durdur
        isFlightModeEnabled = false
        flightButton.Text = "Uçuş Modunu Aç"
        ContextActionService:UnbindAction("JumpAction_Flight") -- Zıplama bağlamını kaldır
        print("Uçuş Modu kapatıldı.")
    else
        -- Uçuş modu kapalıysa, aç
        isFlightModeEnabled = true
        flightButton.Text = "Uçuş Modunu Kapat"
        -- Zıplama tuşunu uçuş için bağla
        ContextActionService:BindAction(
            "JumpAction_Flight",          -- Eylem adı
            handleJumpAction,             -- Eylemi yönetecek fonksiyon
            true,                         -- Kullanıcı girdisi işlem gördüğünde kapat
            Enum.KeyCode.Space            -- PC için Spacebar
        )
        -- ContextActionService, mobil zıplama butonunu otomatik olarak tanır ve bu eyleme bağlar.
        print("Uçuş Modu açıldı. Şimdi Zıplama tuşuna basarak uçabilirsiniz!")
    end
end)

-- Karakter yeniden yüklendiğinde (ölünce vb.) uçuş durumunu sıfırla
player.CharacterAdded:Connect(function(newChar)
    print("Karakter yeniden eklendi. Uçuş durumu sıfırlanıyor.")
    if isFlightModeEnabled then -- Eğer uçuş modu aktifken karakter öldüyse, modu kapat
        disableFlight()
        isFlightModeEnabled = false
        flightButton.Text = "Uçuş Modunu Aç"
        ContextActionService:UnbindAction("JumpAction_Flight") -- Zıplama bağlamını kaldır
    end
    -- Yeni karakteri ayarla ve Humanoid'i tekrar bağla
    character = newChar
    humanoid = newChar:WaitForChild("Humanoid")
    humanoidRootPart = newChar:WaitForChild("HumanoidRootPart")
    originalGravity = humanoid.Gravity

    isFlying = false -- Uçuş durumu sıfırla
    currentMoveVector = Vector3.new(0,0,0) -- Hareket vektörünü sıfırla
end)

-- İlk karakter kurulumunu yap
setupCharacter()

print("Yeni uçuş kontrol sistemi yüklendi. 'Uçuş Modunu Aç' butonuna tıklayarak başlayın, sonra zıplama tuşuna basın.")
