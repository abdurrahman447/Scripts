-- Ekran boyutlarını al
local screenWidth = display.contentWidth
local screenHeight = display.contentHeight

-- Buton oluştur
local button = display.newCircle( screenWidth * 0.5, screenHeight * 0.5, 50 )
button:setFillColor( 0, 0.5, 1 ) -- Mavi renk
local buttonText = display.newText( "Menü", button.x, button.y, native.systemFontBold, 20 )
buttonText:setFillColor( 1, 1, 1 )

-- Butonu bir grup içinde topla
local buttonGroup = display.newGroup()
buttonGroup:insert( button )
buttonGroup:insert( buttonText )

-- Butonu hareket ettirme fonksiyonu
local function onButtonTouch( event )
    local t = event.target
    local phase = event.phase

    if "began" == phase then
        display.getCurrentStage():setFocus( t )
        t.isFocus = true
        t.x0 = event.x - t.x
        t.y0 = event.y - t.y
    elseif "moved" == phase and t.isFocus then
        t.x = event.x - t.x0
        t.y = event.y - t.y0
        buttonText.x = t.x
        buttonText.y = t.y
    elseif "ended" == phase or "cancelled" == phase then
        display.getCurrentStage():setFocus( nil )
        t.isFocus = false
    end
    return true
end

-- Butona dokunma olayı ekle
button:addEventListener( "touch", onButtonTouch )

---

-- Menü oluşturma
local menuGroup = display.newGroup()
menuGroup.alpha = 0 -- Menüyü başlangıçta gizle

-- Menü arkaplanı
local menuBg = display.newRoundedRect( menuGroup, 0, 0, 250, 200, 20 )
menuBg:setFillColor( 0.1, 0.1, 0.1, 0.9 ) -- Yarı şeffaf siyah
menuBg.x = screenWidth * 0.5
menuBg.y = screenHeight * 0.5

-- "Uçma" butonu
local flyButton = display.newRoundedRect( menuGroup, 0, -50, 150, 50, 10 )
flyButton.x = menuBg.x
flyButton.y = menuBg.y - 50
flyButton:setFillColor( 0, 0.8, 0.2 ) -- Yeşil
local flyText = display.newText( menuGroup, "Uçma", flyButton.x, flyButton.y, native.systemFontBold, 24 )
flyText:setFillColor( 1, 1, 1 )

-- "Hız" metni ve giriş alanı
local speedLabel = display.newText( menuGroup, "Hız:", menuBg.x - 70, menuBg.y + 40, native.systemFont, 20 )
speedLabel:setFillColor( 1, 1, 1 )
local speedInput = native.newTextField( menuBg.x + 40, menuBg.y + 40, 100, 40 )
speedInput.placeholder = "0-500"
speedInput.isFontSizeScaled = false

-- Menüyü açma/kapama fonksiyonu
local menuVisible = false
local function toggleMenu()
    if not menuVisible then
        transition.to( menuGroup, { alpha = 1, time = 300 } )
    else
        transition.to( menuGroup, { alpha = 0, time = 300 } )
    end
    menuVisible = not menuVisible
end

-- Butona tıklanınca menüyü aç/kapa
local function onButtonTap( event )
    if event.phase == "ended" then
        toggleMenu()
    end
    return true
end
buttonGroup:addEventListener( "tap", onButtonTap )

---

-- Menü içi fonksiyonlar
local isFlying = false
local function onFlyButtonTap( event )
    if event.phase == "ended" then
        isFlying = not isFlying
        
        if isFlying then
            print( "Uçuş aktif!" )
            flyButton:setFillColor( 0.8, 0, 0 ) -- Kırmızı
            flyText.text = "İniş"
        else
            print( "Uçuş durduruldu." )
            flyButton:setFillColor( 0, 0.8, 0.2 ) -- Yeşil
            flyText.text = "Uçma"
        end
    end
    return true
end

flyButton:addEventListener( "touch", onFlyButtonTap )

local currentSpeed = 0
local function onSpeedInputChange( event )
    if event.phase == "submitted" then
        local speedValue = tonumber( event.target.text )
        
        if speedValue and speedValue >= 0 and speedValue <= 500 then
            currentSpeed = speedValue
            print( "Hız ayarlandı: " .. currentSpeed )
        else
            print( "Geçersiz hız değeri. Lütfen 0 ile 500 arasında bir sayı girin." )
        end
        event.target.text = "" -- Kutuyu temizle
    end
end

speedInput:addEventListener( "userInput", onSpeedInputChange )
