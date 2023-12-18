local epicCoolCameraShit = true;

function onCreate()
    setProperty('defaultCamZoom', 1.2)
    setProperty("camGame.zoom", 1.2)
    setProperty('boyfriendCameraOffset[0]', getProperty('boyfriendCameraOffset[0]') + 120)
    setProperty('boyfriendCameraOffset[1]', getProperty('boyfriendCameraOffset[1]') + 100)
    setProperty('opponentCameraOffset[0]', getProperty('opponentCameraOffset[0]') - 300)
    setProperty('opponentCameraOffset[1]', getProperty('opponentCameraOffset[1]') - 0)
    cameraSetTarget('dad')

    makeLuaSprite("funnyBlack", "", 0, 0)
    makeGraphic("funnyBlack", 1280, 720, "0xFF000000")
    setObjectCamera("funnyBlack", 'hud')
    addLuaSprite("funnyBlack", true)
    doTweenAlpha("shiiii", "funnyBlack", 0, 5, "quartIn")

    makeLuaSprite("funnyWhite", "", -800, -400)
    makeGraphic("funnyWhite", 3000, 2000, "0xFFFFFFFF")
    addLuaSprite("funnyWhite", false)

    makeLuaSprite("funniestWhite", "", 0, 0) -- i really wish color tweening made sense
    makeGraphic("funniestWhite", 1280, 720, "0xFFFFFFFF")
    setObjectCamera("funniestWhite", 'hud')
    setProperty("funniestWhite.alpha", 0)
    addLuaSprite("funniestWhite", true)
end

function onBeatHit()
    if curBeat == 128 then
    cameraFlash('game', '0xFF000000', 5, true)
    end
    if curBeat == 160 then
        setProperty('cameraSpeed', '100')
        triggerEvent('Camera Follow Pos', (getMidpointX('dad') + 150) + (getProperty('dad.cameraPosition[0]') + getProperty('opponentCameraOffset[0]')), (getMidpointY('dad') - 100) + (getProperty('dad.cameraPosition[1]') + getProperty('opponentCameraOffset[1]')))
    end
    if curBeat == 161 then
        triggerEvent('Camera Follow Pos', (getMidpointX('gf')) + (getProperty('gf.cameraPosition[0]') + getProperty('girlfriendCameraOffset[0]')), (getMidpointY('gf') - 200) + (getProperty('gf.cameraPosition[1]') + getProperty('girlfriendCameraOffset[1]')))
    end
    if curBeat == 162 then
        triggerEvent('Camera Follow Pos', (getMidpointX('boyfriend') - 100) - (getProperty('boyfriend.cameraPosition[0]') - getProperty('boyfriendCameraOffset[0]')), (getMidpointY('boyfriend') - 100) + (getProperty('boyfriend.cameraPosition[1]') + getProperty('boyfriendCameraOffset[1]')))
    end
    if curBeat == 163 then
        triggerEvent('Camera Follow Pos', '550', '400')
        setProperty("camGame.zoom", 0.6)
    end
    if curBeat == 164 then
        setProperty('cameraSpeed', '1')
        setProperty('funnyWhite.alpha', 0)
    end
    if curBeat == 196 then
        doTweenAlpha("whiteFade", "funniestWhite", 1, 2.4, 'quartOut')
        doTweenY("byebye", 'camFollow', getProperty('camFollow.y') - 300, 2.6, 'quartOut')
    end
end