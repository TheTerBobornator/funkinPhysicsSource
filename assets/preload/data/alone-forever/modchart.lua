function onCreate()
	setProperty('skipCountdown', true)
	triggerEvent("Camera Follow Pos", 1365, 300)
    makeLuaSprite("funnyBlack", "", -800, -400)
    makeGraphic("funnyBlack", 3000, 2000, "0xFF000000")
    addLuaSprite("funnyBlack", true)
end

function onSongStart()
	runHaxeCode("FlxTween.tween(FlxG.camera, {zoom: 1.1}, 14, {ease: FlxEase.quadInOut, onComplete: defaultCamZoom = 1.1});")
end

function onStepHit()
	if curStep == 8 then
		doTweenAlpha("shiiii", "funnyBlack", 0, 5.5, "quartIn")
	end

	if curStep == 384 then
		tween1()
	end

	if curStep == 640 then
		tween2()
	end

	if curStep == 768 then
		tween3()
	end

	if curStep == 896 then
		tween4()
	end

	if curStep == 1024 then
		tween5()
	end

end

function onBeatHit()
	if (curBeat >= 192 and curBeat < 224)then
		triggerEvent('Add Camera Zoom')
	 end
end

function tween1()
	yValue = 180
	if downscroll then
		yValue = 440
		noteTweenAngle('note0a', 0, 45, 2, 'bounceOut')
		noteTweenAngle('note3a', 3, -45, 2, 'bounceOut')
		noteTweenAngle('note4a', 4, 45, 2, 'bounceOut')
		noteTweenAngle('note7a', 7, -45, 2, 'bounceOut')
	else
		noteTweenAngle('note0a', 0, -45, 2, 'bounceOut')
		noteTweenAngle('note3a', 3, 45, 2, 'bounceOut')
		noteTweenAngle('note4a', 4, -45, 2, 'bounceOut')
		noteTweenAngle('note7a', 7, 45, 2, 'bounceOut')
	end
	noteTweenY('note0y', 0, yValue, 2, 'bounceOut')
	noteTweenY('note3y', 3, yValue, 2, 'bounceOut')
	noteTweenY('note4y', 4, yValue, 2, 'bounceOut')
	noteTweenY('note7y', 7, yValue, 2, 'bounceOut')
end

function tween2()
	noteTweenAngle('note0a', 0, 0, 2, 'bounceOut')
	noteTweenX('note0x', 0, defaultOpponentStrumX2, 2, 'bounceOut')
	noteTweenY('note0y', 0, defaultOpponentStrumY2, 2, 'bounceOut')

	noteTweenX('note1x', 1, defaultOpponentStrumX3, 2, 'bounceOut')

	noteTweenX('note2x', 2, defaultPlayerStrumX0, 2, 'bounceOut')

	noteTweenAngle('note3a', 3, 0, 2, 'bounceOut')
	noteTweenX('note3x', 3, defaultPlayerStrumX1, 2, 'bounceOut')
	noteTweenY('note3y', 3, defaultPlayerStrumY1, 2, 'bounceOut')

	noteTweenAngle('note4a', 4, 0, 2, 'bounceOut')
	noteTweenX('note4x', 4, defaultOpponentStrumX0, 2, 'bounceOut')
	noteTweenY('note4y', 4, defaultOpponentStrumY0, 2, 'bounceOut')

	noteTweenX('note5x', 5, defaultOpponentStrumX1, 2, 'bounceOut')

	noteTweenX('note6x', 6, defaultPlayerStrumX2, 2, 'bounceOut')

	noteTweenAngle('note7a', 7, 0, 2, 'bounceOut')
	noteTweenX('note7x', 7, defaultPlayerStrumX3, 2, 'bounceOut')
	noteTweenY('note7y', 7, defaultPlayerStrumY3, 2, 'bounceOut')
end

function tween3()
	noteTweenX('note0x', 0, defaultOpponentStrumX0, 2, 'bounceOut')

	noteTweenX('note1x', 1, defaultOpponentStrumX1, 2, 'bounceOut')

	noteTweenX('note2x', 2, defaultPlayerStrumX2, 2, 'bounceOut')

	noteTweenX('note3x', 3, defaultPlayerStrumX3, 2, 'bounceOut')

	noteTweenX('note4x', 4, defaultOpponentStrumX2, 2, 'bounceOut')

	noteTweenX('note5x', 5, defaultOpponentStrumX3, 2, 'bounceOut')

	noteTweenX('note6x', 6, defaultPlayerStrumX0, 2, 'bounceOut')

	noteTweenX('note7x', 7, defaultPlayerStrumX1, 2, 'bounceOut')
end

function tween4()
	yValue = 1000
	if downscroll then
		yValue = -380
	end
	noteTweenX('note0x', 0, defaultOpponentStrumX2, 2, 'bounceOut')
	noteTweenY('note0y', 0, yValue, 2, 'bounceOut')
	noteTweenAngle('note0a', 0, 90, 2, 'bounceOut')

	noteTweenX('note1x', 1, defaultOpponentStrumX3, 2, 'bounceOut')
	noteTweenY('note1y', 1, yValue, 2, 'bounceOut')
	noteTweenAngle('note1a', 0, 90, 2, 'bounceOut')

	noteTweenX('note2x', 2, defaultPlayerStrumX0, 2, 'bounceOut')
	noteTweenY('note2y', 2, yValue, 2, 'bounceOut')
	noteTweenAngle('note2a', 0, -90, 2, 'bounceOut')

	noteTweenX('note3x', 3, defaultPlayerStrumX1, 2, 'bounceOut')
	noteTweenY('note3y', 3, yValue, 2, 'bounceOut')
	noteTweenAngle('note3a', 0, -90, 2, 'bounceOut')

	noteTweenX('note4x', 4, defaultOpponentStrumX0, 2, 'bounceOut')

	noteTweenX('note7x', 7, defaultPlayerStrumX3, 2, 'bounceOut')
end

function tween5()
	noteTweenY('note4y', 4, 310, 2, 'bounceOut')
	noteTweenY('note5y', 5, 310, 2, 'bounceOut')
	noteTweenY('note6y', 6, 310, 2, 'bounceOut')
	noteTweenY('note7y', 7, 310, 2, 'bounceOut')

	noteTweenAngle('note4a', 4, 180, 2, 'bounceOut')
	noteTweenAngle('note5a', 5, 180, 2, 'bounceOut')
	noteTweenAngle('note6a', 6, 180, 2, 'bounceOut')
	noteTweenAngle('note7a', 7, 180, 2, 'bounceOut')
end