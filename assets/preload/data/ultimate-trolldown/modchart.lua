function onBeatHit()
    if curBeat == 194 then
        fancyNoteTween('dad', 0)
    end
    if curBeat == 196 then
        cameraFlash('game', '0xFF000000', 2, true)
        setProperty('cameraSpeed', '100')
        setProperty('boyfriendCameraOffset[0]', getProperty('boyfriendCameraOffset[0]') + 100)
        setProperty('opponentCameraOffset[0]', getProperty('opponentCameraOffset[0]') - 100)
        setProperty('opponentCameraOffset[1]', getProperty('opponentCameraOffset[1]') - 100)
    end
    if curBeat == 210 or curBeat == 242 or curBeat == 274 then
        fancyNoteTween('player', 0)
        fancyNoteTween('dad', 1)
    end
    if curBeat == 226 or curBeat == 258 or curBeat == 290 then
        fancyNoteTween('player', 1)
        fancyNoteTween('dad', 0)
    end
    if curBeat == 306 then
        fancyNoteTween('dad', 1)
    end
    if curBeat == 336 then
        setProperty('cameraSpeed', '1')
        setProperty('boyfriendCameraOffset[0]', getProperty('boyfriendCameraOffset[0]') - 100)
        setProperty('opponentCameraOffset[0]', getProperty('opponentCameraOffset[0]') + 100)
        setProperty('opponentCameraOffset[1]', getProperty('opponentCameraOffset[1]') + 100)
    end
end

function fancyNoteTween(char, to)
    if char == 'dad' then
        for i=0,3 do
            noteTweenAlpha('a'..i, i, to, 1.5, 'quadIn')
        end
    else
        for i=0,3 do
            noteTweenAlpha('a'..i + 4, i + 4, to, 1.5, 'quadIn')
        end
    end
end