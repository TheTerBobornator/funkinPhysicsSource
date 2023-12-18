function onCreate()
	for i=1,4 do
		makeLuaSprite('cutscene'..i, 'cutscenes/foretoken/'..i, 0, 0)
		setScrollFactor('cutscene'..i, 1.0, 1.0)
		setObjectCamera('cutscene'..i, 'other')
		setProperty('cutscene'..i..'.alpha', 0.00001)
		setGraphicSize('cutscene'..i, screenWidth, screenHeight)
		addLuaSprite('cutscene'..i, true)
	end

	setProperty('skipCredit', true)
	setProperty('skipCountdown', true)
	setProperty('camHUD.alpha', 0)
    setProperty('gfSpeed', 2)
	setProperty('camZooming', true)
	setProperty('camZoomingMult', 0)

    makeLuaSprite("blackBGOverlay", "", -800, -400)
    makeGraphic("blackBGOverlay", 3000, 2000, "0xFF000000")
	setProperty('blackBGOverlay.alpha', 0.2)
    addLuaSprite("blackBGOverlay", true)
	
    makeLuaSprite("blackBGBack", "", -800, -400)
    makeGraphic("blackBGBack", 3000, 2000, "0xFF000000")
	setProperty('blackBGBack.alpha', 0)
    addLuaSprite("blackBGBack", false)

	makeLuaSprite("funnyBlack", "", -800, -400)
    makeGraphic("funnyBlack", 3000, 2000, "0xFF000000")
    addLuaSprite("funnyBlack", true)
end

function onCreatePost()
	setProperty('defaultCamZoom', 2.0)

	makeLuaSprite('vignette', 'backgrounds/vignette', 0, 0)
    setScrollFactor('vignette', 1.0, 1.0)
    setObjectCamera('vignette', 'camHUD')
    addLuaSprite('vignette', true)
end

function onSongStart()
	setProperty('songLength', 91000)
	doCutsceneAppear(1)
end

function onUpdate(elapsed)
	local currentBeat = (getSongPosition()/1000)*(curBpm/60)
	if curBeat >= 128 and curBeat < 192 then
		for i=0,3 do
			setPropertyFromGroup('opponentStrums', i, 'x', _G['defaultOpponentStrumX'..i] + 32 * math.sin(currentBeat + i*7))
			setPropertyFromGroup('playerStrums', i, 'x', _G['defaultPlayerStrumX'..i] + 32 * math.sin(currentBeat + (i+4)*7))
		end
	end
	if shaking then
		if curBeat >= 196 and curBeat < 316 then
    	    for i=0,3 do
    	        setPropertyFromGroup('opponentStrums', i, 'x', _G['defaultOpponentStrumX'..i] + getRandomInt(-2, 2) + math.sin((currentBeat + i*0.25) * math.pi))
    	        setPropertyFromGroup('opponentStrums', i, 'y', _G['defaultOpponentStrumY'..i] + getRandomInt(-2, 2) + math.sin((currentBeat + i*0.25) * math.pi))
    	    end
    	end
		if curBeat >= 308 then
    	    for i=0,3 do
    	        setPropertyFromGroup('playerStrums', i, 'x', _G['defaultPlayerStrumX'..i] + getRandomInt(-2, 2) + math.sin((currentBeat + i*0.25) * math.pi))
    	        setPropertyFromGroup('playerStrums', i, 'y', _G['defaultPlayerStrumY'..i] + getRandomInt(-2, 2) + math.sin((currentBeat + i*0.25) * math.pi))
    	    end
    	end
	end
end

function onBeatHit()
	if curBeat == 4 then
		doCutsceneDisappear(1)
	end
	if curBeat == 8 then
		doCutsceneAppear(2)
	end
	if curBeat == 10 then
		setProperty('cutscene2.alpha', 0)
		setProperty('cutscene3.alpha', 1)
		cameraShake('other', 0.02, 0.2)
	end
	if curBeat == 12 then
		doCutsceneDisappear(3)
	end
	if curBeat == 16 then
		doCutsceneAppear(4)
	end
	if curBeat == 20 then
		doCutsceneDisappear(4)
	end
	if curBeat == 22 then
		doTweenAlpha('hudIn', 'camHUD', 1, 3, 'linear')
		doTweenAlpha("shiiii", "funnyBlack", 0, 4, "quartIn")
		runHaxeCode("FlxTween.tween(FlxG.camera, {zoom: 1.2}, 4, {ease: FlxEase.quadInOut, onComplete: defaultCamZoom = 1.2});")
		setProperty('defaultCamZoom', 1.2)
	end
	if curBeat == 28 then
		setProperty('camZoomingDecay', 100)
		
		--makeLuaSprite("redBG", "", -800, -400)
		--makeGraphic("redBG", 3000, 2000, "0xFFFF0000")
		--setProperty('redBG.alpha', 0)
		--addLuaSprite("redBG", true)
		--setProperty('redBG.blend', 'ADD')
		----setBlendMode('redBG', 'ADD')
		--doTweenAlpha("w", "redBG", 0.25, 4, "quartIn")
	--	runHaxeCode([[
	--		var erm:ColorSwap = new ColorSwap();
	--		//erm.saturation = 0.8;
	--		erm.brightness = 0.5;
	--		erm.hue = 0.5;
	--		//FlxTween.tween(erm, {saturation: 0, brightness: 0}, 5);
	--		game.camGame.setFilters([new ShaderFilter(erm.shader)]);
	--	]])
		
	end
	if curBeat == 32 then
		cameraFlash('game', "0xFF000000", 1, true)
		setProperty('gfSpeed', 1)
		setProperty('camZoomingMult', 1)
		setProperty('camZoomingDecay', 0.5)
		setProperty('boyfriend.cameraPosition[0]', getProperty('boyfriend.cameraPosition[0]') - 55)
		setProperty('boyfriend.cameraPosition[1]', getProperty('boyfriend.cameraPosition[1]') + 40)
        setProperty('dad.cameraPosition[0]', getProperty('dad.cameraPosition[0]') - 200)
	end
	if curBeat == 64 then
		setProperty('boyfriend.cameraPosition[0]', getProperty('boyfriend.cameraPosition[0]') + 55)
		setProperty('boyfriend.cameraPosition[1]', getProperty('boyfriend.cameraPosition[1]') - 40)
        setProperty('dad.cameraPosition[0]', getProperty('dad.cameraPosition[0]') + 200)
		setProperty('camZoomingDecay', 1)
	end
	if curBeat == 124 then
		cameraFlash('game', "0xFF000000", 1, true)
		doTweenAlpha("scary", "blackBGBack", 1, 1.5, "linear")
		setProperty('boyfriend.cameraPosition[0]', getProperty('boyfriend.cameraPosition[0]') - 110)
		setProperty('boyfriend.cameraPosition[1]', getProperty('boyfriend.cameraPosition[1]') + 80)
        setProperty('dad.cameraPosition[0]', getProperty('dad.cameraPosition[0]') - 300)
	end
	if curBeat == 125 then
		setProperty('camZoomingDecay', 100)
	end
	if curBeat == 128 then
		setProperty('camZoomingDecay', 1)
		setProperty('blackBGBack.alpha', 0)
	end
	if curBeat == 192 then
		for i=0,3 do
			noteTweenX('opponentReturn'..i, i, _G['defaultOpponentStrumX'..i], 1, 'quadOut')
			noteTweenX('playerReturn'..i, i + 4, _G['defaultPlayerStrumX'..i], 1, 'quadOut')
		end
		doTweenZoom('fakeOutZoom', 'camGame', 1.5, 1.5, 'linear')
		doTweenAlpha("fakeOut", "funnyBlack", 1, 1, "linear")
		makeLuaText('threat', "We're not done here yet.", 0, 0, 0)
		setTextAlignment('threat', 'center')
		setTextSize('threat', 64)
		screenCenter('threat', 'xy')
		setProperty('threat.alpha', 0)
		setTextFont('threat', 'impact.otf')
		setObjectCamera('threat', 'hud')
		addLuaText('threat')
	end
	if curBeat == 194 then
		doTweenAlpha('threatTweenIn', 'threat', 1, 0.8, "linear")
	end
	if curBeat == 196 then
		setProperty('cameraSpeed', 100)
		cameraFlash('hud', "0xFFFF0000", 0.5, true)
		setProperty('threat.alpha', 0)
		setProperty('funnyBlack.alpha', 0)
		setProperty('boyfriend.cameraPosition[0]', getProperty('boyfriend.cameraPosition[0]') + 55)
		setProperty('boyfriend.cameraPosition[1]', getProperty('boyfriend.cameraPosition[1]') - 40)
        setProperty('dad.cameraPosition[0]', getProperty('dad.cameraPosition[0]') + 100)
	end
	if curBeat == 197 then
		setProperty('cameraSpeed', 1)
	end
	if curBeat == 228 then
		setProperty('boyfriend.cameraPosition[0]', getProperty('boyfriend.cameraPosition[0]') + 55)
		setProperty('boyfriend.cameraPosition[1]', getProperty('boyfriend.cameraPosition[1]') - 40)
        setProperty('dad.cameraPosition[0]', getProperty('dad.cameraPosition[0]') + 200)
	end
	if curBeat == 292 then
		setProperty('boyfriend.cameraPosition[0]', getProperty('boyfriend.cameraPosition[0]') - 55)
		setProperty('boyfriend.cameraPosition[1]', getProperty('boyfriend.cameraPosition[1]') + 40)
        setProperty('dad.cameraPosition[0]', getProperty('dad.cameraPosition[0]') - 200)
	end
	if curBeat == 308 then
		setProperty('boyfriend.cameraPosition[0]', getProperty('boyfriend.cameraPosition[0]') - 55)
		setProperty('boyfriend.cameraPosition[1]', getProperty('boyfriend.cameraPosition[1]') + 40)
        setProperty('dad.cameraPosition[0]', getProperty('dad.cameraPosition[0]') - 100)
	end
	if curBeat == 316 then
		for i=0,3 do
			noteTweenY('noteDown'..i, i, defaultOpponentStrumY0 + 200, 2.5 + (i * 0.5), 'quadInOut')
			noteTweenAlpha('noteFade'..i, i, 0, 1.5 + (i * 0.5), 'quadInOut')
		end
	end
	if curBeat == 324 then
		setProperty('camGame.alpha', 0)
		setProperty('camHUD.alpha', 0)
	end
end

function onStepHit()
	if 
	(curStep >= 512 and curStep < 528) or 
	(curStep >= 544 and curStep < 560) or 
	(curStep >= 576 and curStep < 592) or 
	(curStep >= 608 and curStep < 624) or 
	(curStep >= 640 and curStep < 656) or 
	(curStep >= 672 and curStep < 688) or
	(curStep >= 704 and curStep < 720) or 
	(curStep >= 736 and curStep < 752) then
		triggerEvent('Add Camera Zoom', '0.01', '0.01')
	end
	if curStep == 1294 then
		cameraFlash('hud', "0xFFFF0000", 1, true)
	end
end

function doCutsceneAppear(num)
	doTweenAlpha('inCutscene'..num, 'cutscene'..num, 1, 0.5, 'sineIn')
end

function doCutsceneDisappear(num)
	doTweenAlpha('outCutscene'..num, 'cutscene'..num, 0, 0.5, 'sineOut')
end