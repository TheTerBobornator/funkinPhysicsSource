function onCreate()
    setProperty('camHUD.alpha', 0)
end

function onBeatHit()
    if curBeat == 24 then
        doTweenAlpha('hudAppear', 'camHUD', 1, 2.5)
    end
    if curBeat == 172 then
		setProperty('boyfriendCameraOffset[1]', (getProperty('boyfriendCameraOffset[1]') - 300))
        setProperty('opponentCameraOffset[1]', (getProperty('opponentCameraOffset[1]') - 200))
        doTweenAlpha('bgTween', 'blackCover', 0, 5, 'linear')
    end
    if curBeat == 176 then
        doTweenY('cat1Up', 'idiotCats.members[0]', 720 - getPropertyFromGroup('idiotCats', 0, 'height') + 150, 1, 'elasticOut')
    end
    if curBeat == 178 then
        doTweenY('cat2Up', 'idiotCats.members[1]', 720 - getPropertyFromGroup('idiotCats', 1, 'height'), 1, 'elasticOut')
    end
    if curBeat == 240 then
        doTweenX('cat1GoneLeft', 'idiotCats.members[0]', -getPropertyFromGroup('idiotCats', 0, 'width'), 1, 'quartIn')
        doTweenAngle('cat1GoneAngle', 'idiotCats.members[0]', -90, 1, 'quartIn')
    end
    if curBeat == 242 then    
        doTweenX('cat2GoneLeft', 'idiotCats.members[1]', 1300 + getPropertyFromGroup('idiotCats', 1, 'width'), 1, 'quartIn')
        doTweenAngle('cat2GoneAngle', 'idiotCats.members[1]', 90, 1, 'quartIn')
    end
    if curBeat == 364 then
        for i=0,1 do
            doTweenY('stalkerLeave'..i, 'idiotStalkers.members['..i..']', 720, 2, 'quartIn')
        end
        doTweenAlpha('bgTween', 'blackCover', 1, 4, 'quartOut')
    end
    if curBeat == 400 then
        doTweenAlpha('bgTween', 'blackCover', 0, 4, 'quartIn')
    end
end

function onStepHit()
    if curStep == 1467 then
        doTweenZoom('camIn', 'camGame', 1.2, 2, 'linear')
        setProperty('boyfriendCameraOffset[1]', (getProperty('boyfriendCameraOffset[1]') + 300))
        setProperty('opponentCameraOffset[1]', (getProperty('opponentCameraOffset[1]') + 200))
    end
end

function onUpdatePost(elapsed)
    setProperty('timeTxt.text', 'YOU ARE AN IDIOT!')
end

function noteMiss(id, direction, noteType, isSustainNote)
    debugPrint('you are an idiot!')
    debugPrint('>>'..misses)
end