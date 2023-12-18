function onCreate()
    setProperty('gfSpeed', 2)
    makeLuaSprite("funnyBlack", "", -800, -400)
    makeGraphic("funnyBlack", 3000, 2000, "0xFF000000")
    setProperty('funnyBlack.alpha', 0.5)
    addLuaSprite("funnyBlack", false)
end

function onCreatePost()
    setProperty('gf.alpha', 0.5)
end

function onBeatHit()
    if curBeat == 112 then
        setProperty('overlayThingy.alpha', 0)
        setProperty('funnyBlack.alpha', 0)
        setProperty('vignette.alpha', 0)
        setProperty('gf.alpha', 1)
        setProperty('boyfriend.cameraPosition[1]', getProperty('boyfriend.cameraPosition[1]') - 80)
    end
    if curBeat == 208 then
        setProperty('boyfriend.cameraPosition[0]', getProperty('boyfriend.cameraPosition[0]') + 80)
        setProperty('boyfriend.cameraPosition[1]', getProperty('boyfriend.cameraPosition[1]') - 80)
        setProperty('dad.cameraPosition[0]', getProperty('dad.cameraPosition[0]') + 80)
    end
    if curBeat == 240 then
        setProperty('boyfriend.cameraPosition[0]', getProperty('boyfriend.cameraPosition[0]') - 80)
        setProperty('boyfriend.cameraPosition[1]', getProperty('boyfriend.cameraPosition[1]') + 160)
        setProperty('dad.cameraPosition[0]', getProperty('dad.cameraPosition[0]') - 80)
        setProperty('camZoomingMult', 0)
        doTweenAlpha('overlayBack', 'overlayThingy', 1, 1.2, 'quadIn')
        doTweenAlpha('vignetteBack', 'vignette', 1, 1.2, 'quadIn')
    end
    if curBeat == 336 then
        setProperty('camZoomingMult', 1)
        setProperty('overlayThingy.alpha', 0)
        setProperty('vignette.alpha', 0)
    end
    if curBeat == 400 then
        setProperty('boyfriend.cameraPosition[0]', getProperty('boyfriend.cameraPosition[0]') + 80)
        setProperty('boyfriend.cameraPosition[1]', getProperty('boyfriend.cameraPosition[1]') - 160)
        setProperty('dad.cameraPosition[0]', getProperty('dad.cameraPosition[0]') + 80)
    end
    if curBeat == 420 or curBeat == 424 or curBeat == 428 then
        setProperty('boyfriend.cameraPosition[1]', getProperty('boyfriend.cameraPosition[1]') + 50)
    end
end