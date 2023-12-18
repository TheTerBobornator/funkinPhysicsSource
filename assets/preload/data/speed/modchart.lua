function onCreatePost()
    triggerEvent('Camera Follow Pos', 1140, 1000)
    setProperty('cameraSpeed', '100')
    setProperty('camHUD.alpha', 0)

   makeLuaSprite("funnyBlack", "", -800, -400)
   makeGraphic("funnyBlack", 3000, 2000, "0xFF000000")
   addLuaSprite("funnyBlack", true)
end

function onSongStart()
   doTweenAlpha("shiiii", "funnyBlack", '0', '6', "linear")
end

function onBeatHit()
    if curBeat == 2 then
        setProperty('cameraSpeed', '1')
    end
    if curBeat == 166 then
        doTweenAlpha("computerOut", "computer", '0.00001', '0.25', "linear")
        doTweenAlpha("miniBFOut", "miniBF", '0.00001', '0.25', "linear")
        doTweenAlpha("miniSanicOut", "miniSanic", '0.00001', '0.25', "linear")
        setProperty('cameraSpeed', '100')
    end
    if curBeat == 169 then --fucking stupid ass shit fuck balls pussy cock dick
        setProperty('cameraSpeed', '1')
    end
    if curBeat == 171 then
        setProperty('cameraSpeed', '100')
        setProperty('bg2.alpha', 1)
        setProperty('danceFrog.alpha', 1)
        setProperty('datBoi.alpha', 1)
        setProperty('grooby.alpha', 1)
        setProperty('bfWatching.alpha', 1)

        setProperty('bg.alpha', 0.00001)
        setProperty('lights.alpha', 0.00001)
        --doTweenZoom('slowInDolan', 'game', "1.2", 1.6, 'linear') why doesnt this function fucking work? we may never know
        setProperty('camZooming', 'false')
        runHaxeCode("FlxTween.tween(FlxG.camera, {zoom: 1}, 3, {ease: FlxEase.linear, onComplete: defaultCamZoom = 1});")
    end 
    if curBeat == 296 then
        doTweenY('bfDropOut', 'bfWatching', 1600, 1.2, 'elasticOut')
    end
    if curBeat == 308 then
        setProperty('bg2.alpha', 0.00001)
        setProperty('danceFrog.alpha', 0.00001)
        setProperty('datBoi.alpha', 0.00001)
        setProperty('grooby.alpha', 0.00001)
        setProperty('bfWatching.alpha', 0.00001)

        setProperty('bg.alpha', 1)
        setProperty('lights.alpha', 1)
        setProperty('computer.alpha', 1)
        setProperty('miniBF.alpha', 1)
        setProperty('miniSanic.alpha', 1)
        setProperty('gunshots.alpha', 0.00001)
    end 
end

function onStepHit()
    if curStep == 669 then
        setProperty('scream.alpha', '1')
        playAnim('scream', 'idle', true)
    end
    if curStep == 678 then
        setProperty('scream.alpha', '0.00001')
    end
    if curStep == 685 then
        setProperty('cameraSpeed', '1')
    end
    if curStep == 1197 then
        setProperty('gunshots.alpha', '1')
        playAnim('gunshots', 'idle', true)
    end
    if curStep == 1203 then
        doTweenX('spooderFlyX', 'boyfriend', 2000, 0.6, 'linear')
        doTweenY('spooderFlyY', 'boyfriend', -500, 0.6, 'linear')
        doTweenAngle('spooderFlyA', 'boyfriend', 6000, 0.6, 'linear')
    end
end