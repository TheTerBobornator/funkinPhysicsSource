function onBeatHit()
	if (curBeat >= 49 and curBeat < 64) or (curBeat >= 65 and curBeat < 80) or (curBeat >= 82 and curBeat < 88) or (curBeat >= 90 and curBeat < 96) or (curBeat >= 132 and curBeat < 196) then
		triggerEvent("Add Camera Zoom")
	end
    if curBeat == 99 then
	    for i=0,3 do
	    	setPropertyFromGroup('opponentStrums', i, 'angularVelocity', 2400)
	    	setPropertyFromGroup('playerStrums', i, 'angularVelocity', -2400)
	    end
    end
    if curBeat == 100 then
        for i=0,3 do
	    	setPropertyFromGroup('opponentStrums', i, 'angularVelocity', 0)
	    	setPropertyFromGroup('playerStrums', i, 'angularVelocity', 0)
			setPropertyFromGroup('opponentStrums', i, 'angle', 0)
	    	setPropertyFromGroup('playerStrums', i, 'angle', 0)
	    end
    end
	if curBeat == 358 then -- (in ganon cdi voice) die
		setProperty('camZooming', false)
		setProperty('dad.alpha', 0)
		setProperty('gf.alpha', 0)
		makeLuaSprite("funnyBlack", "", -800, -400)
		makeGraphic("funnyBlack", 3000, 2000, "0xFF000000")
		addLuaSprite("funnyBlack", false)
	end
end
function onStepHit()
	if curStep == 1482 then
		setProperty('camGame.zoom', 1)
	end
	if curStep == 1484 or curStep == 1485 or curStep == 1486 or curStep == 1487 then
		setProperty('camGame.zoom', getProperty('camGame.zoom') + 0.1)
	end
end