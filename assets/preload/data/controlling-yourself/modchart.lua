function onStepHit()
	if ((curStep > 128 and curStep <= 384) or (curStep > 576 and curStep <= 672) or (curStep > 688 and curStep <= 1152)) and curStep % 2 == 0 then
		triggerEvent('Add Camera Zoom')
	end
end

function onBeatHit()
	if curBeat == 28 or curBeat == 222 then
		doTweenAlpha('vignetteIn', 'vignette', 1, 0.5, 'quadInOut')
	end
	if curBeat == 32 or curBeat == 128 or curBeat == 224 then
		setProperty('vignette.alpha', 0.00001)
	end
	if curBeat == 96 then
		doTweenAlpha('vignetteIn', 'vignette', 1, 1, 'quadInOut')
	end
	if curBeat == 222 then
		cameraSetTarget('dad')
	end
	if curBeat == 288 then
		doTweenX('byebye', 'boyfriend', getCharacterX('boyfriend') + 10000, 5)
	end
end

function noteMiss()
	setHealth(getHealth() - 0.01)
end