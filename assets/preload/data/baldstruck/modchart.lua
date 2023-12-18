function onCreate()
    -- if i had a nickel for ever makeLuaSprite("funnyBlack") i've used in this mod
    makeLuaSprite("funnyBlack", "", -1000, -800)
    makeGraphic("funnyBlack", 3400, 2000, "0xFF000000")
    addLuaSprite("funnyBlack", true)
    setProperty('camHUD.alpha', 0)
    setProperty('skipCredit', true)
end

function onCreatePost()
    setScrollFactor('gf', 0.6, 0.6)
    setProperty('camZooming', true)
    setProperty('camZoomingMult', 0)
end

function onBeatHit()
    if curBeat >= 0 and curBeat < 30 then
        triggerEvent("Add Camera Zoom", '0.015', '0.015')
        setProperty('funnyBlack.alpha', getProperty('funnyBlack.alpha') - (1/30))
        setProperty('camHUD.alpha', getProperty('camHUD.alpha') + (1/30))
    end

        if curBeat % 2 == 0 then
	    	triggerEvent("Add Camera Zoom", '0.03', '0.03')
	    end
	    if curBeat % 2 == 1 then
	    	triggerEvent("Add Camera Zoom", '0.06', '0.06')
	    end
        
    if curBeat == 28 then
        doTweenAlpha('blackReturn', 'funnyBlack', 1, 1.8, 'quadOut')
        doTweenAlpha('hudFade', 'camHUD', 0, 1.8, 'quadOut')
        for i=0,7 do
            if i < 4 then
                noteTweenX('noteTween'..i, i, (-228 + (160 * getPropertyFromClass('Note', 'swagWidth') * i) + (screenWidth / 2)), 1.8, 'quadOut')
            else
                noteTweenX('noteTween'..i, i, (-228 + (160 * getPropertyFromClass('Note', 'swagWidth') * (i - 4)) + (screenWidth / 2)), 1.8, 'quadOut')
            end
		end
    end
    if curBeat == 32 then
        for i=0,2 do
            setPropertyFromGroup('awesomeBoppers', i, 'alpha', 1)
        end

        setProperty('funnyBlack.alpha', 0)
        setProperty('camHUD.alpha', 1)
        setProperty('boyfriendCameraOffset[0]', getProperty('boyfriendCameraOffset[0]') - 50)
        setProperty('boyfriendCameraOffset[1]', getProperty('boyfriendCameraOffset[1]') - 100)
        setProperty('opponentCameraOffset[0]', getProperty('opponentCameraOffset[0]') + 150)
        setProperty('opponentCameraOffset[1]', getProperty('opponentCameraOffset[1]') - 100)
    end
end

function onStepHit()
	    if curStep % 4 == 0 then
	    	doTweenY('rrr', 'camHUD', -12, stepCrochet*0.002, 'circOut')
	    	doTweenY('rtr', 'camHUD.scroll', 12, stepCrochet*0.002, 'sineIn')
	    end
	    if curStep % 4 == 2 then
	    	doTweenY('rir', 'camHUD', 0, stepCrochet*0.002, 'sineIn')
	    	doTweenY('ryr', 'camHUD.scroll', 0, stepCrochet*0.002, 'sineIn')
	    end
end