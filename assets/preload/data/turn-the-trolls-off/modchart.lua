function onBeatHit()
    if curBeat == 76 or curBeat == 204 or curBeat == 428 then
        transition(true)
    end
    if curBeat == 140 then
        for i=0,3 do
            noteTweenX('returnX'..i, i, _G['defaultOpponentStrumX'..i], 0.5, 'sineInOut')
            noteTweenX('returnX'..i + 4, i + 4, _G['defaultPlayerStrumX'..i], 0.5, 'sineInOut')
        end
        transition(false)
    end
    if curBeat == 268 then
        for i=0,3 do
            noteTweenX('returnX'..i, i, _G['defaultOpponentStrumX'..i], 0.5, 'sineInOut')
            noteTweenX('returnX'..i + 4, i + 4, _G['defaultPlayerStrumX'..i], 0.5, 'sineInOut')
        end
        doTweenAngle('hudReturn', 'camHUD', 0, 1)
        doTweenAngle('gameReturn', 'camGame', 0, 1)
        transition(false)
    end
    if curBeat == 516 then
        for i=0,3 do
            noteTweenX('returnX'..i, i, _G['defaultOpponentStrumX'..i], 0.5, 'sineInOut')
            noteTweenX('returnX'..i + 4, i + 4, _G['defaultPlayerStrumX'..i], 0.5, 'sineInOut')
            noteTweenY('returnY'..i, i, _G['defaultOpponentStrumY'..i], 0.5, 'sineInOut')
            noteTweenY('returnY'..i + 4, i + 4, _G['defaultPlayerStrumY'..i], 0.5, 'sineInOut')
        end
        transition(false)
    end
end

function onUpdate(elapsed)
    local currentBeat = (getSongPosition()/1000)*(curBpm/60)
    if curBeat >= 76 and curBeat < 140 then
        for i=0,3 do
            setPropertyFromGroup('strumLineNotes', i, 'x', _G['defaultOpponentStrumX'..i] + 32 * math.sin(currentBeat))
            setPropertyFromGroup('strumLineNotes', i + 4, 'x', _G['defaultPlayerStrumX'..i] + 32 * math.sin(currentBeat))
        end
    end
    if curBeat >= 204 and curBeat < 268 then
        for i=0,3 do
            setPropertyFromGroup('strumLineNotes', i, 'x', _G['defaultOpponentStrumX'..i] + 32 * math.sin(currentBeat + i*7))
            setPropertyFromGroup('strumLineNotes', i + 4, 'x', _G['defaultPlayerStrumX'..i] + 32 * math.sin(currentBeat+ i*7))
        end
        doTweenAngle('hudwweeeeww', 'camHUD', 10 * math.sin(currentBeat * 0.5), 0.1)
        doTweenAngle('gamewweeeeww', 'camGame', 10 * math.sin(currentBeat * 0.5), 0.1)
    end
    if curBeat >= 428 and curBeat < 516 then
        for i=0,3 do
            setPropertyFromGroup('strumLineNotes', i, 'x', _G['defaultOpponentStrumX'..i] + 50 * math.sin(currentBeat + i*37))
            setPropertyFromGroup('strumLineNotes', i + 4, 'x', _G['defaultPlayerStrumX'..i] + 50 * math.sin(currentBeat+ i*37))
            setPropertyFromGroup('strumLineNotes', i, 'y', _G['defaultOpponentStrumY'..i] + 32 * math.sin(currentBeat + i*4))
            setPropertyFromGroup('strumLineNotes', i + 4, 'y', _G['defaultPlayerStrumY'..i] + 32 * math.sin(currentBeat+ i*4))
        end
    end
end

function transition(bg2In)
    if bg2In then
        setProperty('bg2.alpha', 1)
    else
        setProperty('bg2.alpha', 0.00001)
    end
    cameraFlash('game', '0xFFFFFFFF', 5, true)
    --triggerEvent('Change Character', 'dad', targetCharacter) lagspikes :(
end