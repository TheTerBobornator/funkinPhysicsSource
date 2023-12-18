-- rebuilt from the ground up from whatever the hell version 1.5's was
-- shouldnt have noticable differences but i still hate this modchart, i wanna keep it the same for the fans tho

function onUpdate(elapsed)
    local currentBeat = (getSongPosition()/1000)*(curBpm/60)
    if curBeat >= 128 then
        for i=0,3 do
            setPropertyFromGroup('opponentStrums', i, 'x', _G['defaultOpponentStrumX'..i] + 32 * math.sin(currentBeat + i*7))
            setPropertyFromGroup('playerStrums', i, 'x', _G['defaultPlayerStrumX'..i] + 32 * math.sin(currentBeat + (i+4)*7))
        end
        doTweenAngle('hudwweeeeww', 'camHUD', 10 * math.sin(currentBeat * 0.5), 0.1)
        doTweenAngle('gamewweeeeww', 'camGame', 10 * math.sin(currentBeat * 0.5), 0.1)
    end
end

function onBeatHit()
    if curBeat >= 128 and curBeat < 288 then
        setProperty('camGame.zoom', 1) --boi what the hell boi
    end
    if curBeat >= 288 and curBeat < 368 then
        setProperty('camHUD.zoom', 1.25)
    end
    if curBeat == 368 then
        doTweenAlpha('bye', 'camHUD', 0, 2)
    end
end