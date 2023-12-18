local randomTimeLength = 0
local shakeNotes = true
local otherStrumY = 570
local wasMidscrollOn = false
function onCreate()
    setProperty('skipCredit', true)
    setProperty('skipCountdown', true)
    makeLuaSprite("funnyBlack", "", -800, -400)
    makeGraphic("funnyBlack", 3000, 2000, "0xFF000000")
    addLuaSprite("funnyBlack", true)
    if middlescroll == true then
        setPropertyFromClass('ClientPrefs', 'middleScroll', false)
        wasMidscrollOn = true
    end
    if downscroll == true then
        otherStrumY = 50
    end
end

function onCreatePost()
    setProperty('camHUD.alpha', 0)
    setTimeBarColors('0xFFFF0000', '0xFF000000')
end

function onSongStart()
    setProperty('cameraSpeed', '100')
    setProperty('camGame.zoom', 2)
end

function onStepHit()
    if curStep == 1 or curStep == 8 or curStep == 16 then -- woulda done in beatHit also but curBeat cant be < 1
        setProperty('funnyBlack.alpha', 0)
        doTweenAlpha("womp", "funnyBlack", 1, 0.5, "quartIn")
    end
end

function onBeatHit()
    randomTimeLength = getRandomFloat(0, 1)
    if (curBeat >= 8 and curBeat < 40) 
    or (curBeat >= 41 and curBeat < 70) 
    or (curBeat >= 72 and curBeat < 102) 
    or (curBeat >= 104 and curBeat < 136) 
    or (curBeat >= 360 and curBeat < 422) 
    or (curBeat >= 424 and curBeat < 454) 
    or (curBeat >= 456 and curBeat < 486) then
        triggerEvent('Add Camera Zoom', '0.08', '0.05')
    end
    if curBeat >= 152 and curBeat < 212 then
        if curBeat % 4 == 2 then
            for i=3,7 do
                noteSquish(i, 'x', 1)
            end
        end
        if curBeat % 8 == 0 then
            for i=3,7 do
                noteSquish(i, 'y', 1)
            end
        end
    end
    if (curBeat >= 216 and curBeat < 344) and curBeat % 4 == 2 then
        triggerEvent('Add Camera Zoom', '0.06', '0.06')
    end
    
    if curBeat == 6 then
        doTweenAlpha("funnyBlackLeave", "funnyBlack", 0, 0.25, "quartIn")
        setProperty('cameraSpeed', '1')
        for i=0,3 do
            setPropertyFromGroup('opponentStrums', i, 'alpha', 0)
        end
    end
    if curBeat == 8 then
        setProperty('funnyBlack.alpha', 0)
        setProperty('camHUD.alpha', 1)
    end
    if curBeat == 72 then
        doTweenAlpha("vignetteGone", "vignette", 0, 0.8, "quartOut")
        shakeNotes = false
    end
    if curBeat == 104 then 
        for i=3,7 do
            noteTweenY('noteReturn'..i, i, _G['defaultPlayerStrumY'..i - 3], 0.5)
        end
        backAndForth(1)
    end
    if curBeat == 136 then
        cancelTimer('backAndForth1')
        cancelTimer('backAndForth2')
        for i=0,3 do
            if downscroll == false then
                setPropertyFromGroup('playerStrums', i, 'downScroll', true)
            else
                setPropertyFromGroup('playerStrums', i, 'downScroll', false)
            end
            setPropertyFromGroup('playerStrums', i, 'y', otherStrumY)
        end
    end
    if curBeat == 137 or curBeat == 140 or curBeat == 142 or curBeat == 145 or curBeat == 148 or curBeat == 150 then 
        for i=0,3 do
            if downscroll == false then
                setPropertyFromGroup('playerStrums', i, 'downScroll', false)
            else
                setPropertyFromGroup('playerStrums', i, 'downScroll', true)
            end
            setPropertyFromGroup('playerStrums', i, 'y', _G['defaultPlayerStrumY'..i])
        end
    end
    if curBeat == 138 or curBeat == 141 or curBeat == 144 or curBeat == 146 or curBeat == 149 then 
        for i=0,3 do
            if downscroll == false then
                setPropertyFromGroup('playerStrums', i, 'downScroll', true)
            else
                setPropertyFromGroup('playerStrums', i, 'downScroll', false)
            end
            setPropertyFromGroup('playerStrums', i, 'y', otherStrumY)
        end
    end
    if curBeat == 139 then
        for i=3,7 do
            noteTweenAngle('angle'..i, i, 720, 0.5)
        end
    end
    if curBeat == 147 then
        for i=3,7 do
            noteTweenAngle('angle'..i, i, 0, 0.5)
        end
    end
    if curBeat == 152 then
        setPropertyFromGroup('playerStrums', 0, 'x', defaultOpponentStrumX1)
        setPropertyFromGroup('playerStrums', 1, 'x', defaultOpponentStrumX3)
        setPropertyFromGroup('playerStrums', 2, 'x', defaultPlayerStrumX0)
        setPropertyFromGroup('playerStrums', 3, 'x', defaultPlayerStrumX2)
    end
    if curBeat == 188 then
        for i=1,2 do
            if downscroll == false then
                setPropertyFromGroup('playerStrums', i, 'downScroll', true)
            else
                setPropertyFromGroup('playerStrums', i, 'downScroll', false)
            end
            noteTweenY('dropDown1'..i, i + 4, otherStrumY, 0.8, "quartOut")
        end
    end
    if curBeat == 190 then
        for i=0,3 do
            if downscroll == false then
                setPropertyFromGroup('playerStrums', i, 'downScroll', true)
            else
                setPropertyFromGroup('playerStrums', i, 'downScroll', false)
            end
            noteTweenY('dropDown2'..i , i + 4, otherStrumY, 0.8, "quartOut")
        end
    end
    if curBeat == 214 then
        doTweenAlpha("vignetteReturn", "vignette", 1, 0.8, "quartIn")
    end
    if curBeat == 216 then
        cameraFlash('game', '0xFF000000', 1, true)
        for i=0,3 do
            if downscroll == false then
                setPropertyFromGroup('playerStrums', i, 'downScroll', false)
            else
                setPropertyFromGroup('playerStrums', i, 'downScroll', true)
            end
            setPropertyFromGroup('playerStrums', i, 'y', _G['defaultPlayerStrumY'..i])
            setPropertyFromGroup('playerStrums', i, 'x', _G['defaultPlayerStrumX'..i])
        end
        setProperty('boyfriendCameraOffset[0]', getProperty('boyfriendCameraOffset[0]') + 100)
        setProperty('boyfriendCameraOffset[1]', getProperty('boyfriendCameraOffset[1]') + 100)
        setProperty('opponentCameraOffset[0]', getProperty('opponentCameraOffset[0]') - 150)
        shakeNotes = true
    end
    if curBeat == 280 then
        shakeNotes = false
        doTweenAlpha("vignetteKindaGone", "vignette", 0.5, 0.8, "quartOut")
    end
    if curBeat == 344 then
        setProperty('defaultCamZoom', 1.2)
        setProperty('camGame.zoom', 1.2)
        doTweenZoom('cameraZoomOut', 'camGame', 0.7, 5.5, "linear")
        cameraFlash('hud', '0xFF000000', 5.5, true)
        cameraFlash('game', '0xFF000000', 5.5, true)
        setProperty('vignette.alpha', 1)
        shakeNotes = true
        setProperty('boyfriendCameraOffset[1]', getProperty('boyfriendCameraOffset[1]') - 100)
    end
    if curBeat == 360 then
        setProperty('boyfriendCameraOffset[0]', getProperty('boyfriendCameraOffset[0]') - 100)
        setProperty('opponentCameraOffset[0]', getProperty('opponentCameraOffset[0]') + 150)
    end
    if curBeat == 424 then
        doTweenAlpha("vignetteGone", "vignette", 0, 0.8, "quartOut")
        backAndForth(1)
        shakeNotes = false
        for i=0,1 do
            setPropertyFromGroup('playerStrums', i, 'angularVelocity', 3600)
        end
        for i=2,3 do
            setPropertyFromGroup('playerStrums', i, 'angularVelocity', -3600)
        end
    end
    if curBeat == 488 then
        cancelTimer('backAndForth1')
        cancelTimer('backAndForth2')
        for i=0,3 do
            setPropertyFromGroup('playerStrums', i, 'y', _G['defaultPlayerStrumY'..i])
        end
    end
    if curBeat == 508 then
        setPropertyFromClass('FlxG.camera', 'bgColor', 0xFF000000)
    end
end

function onUpdate(elapsed)
    local currentBeat = (getSongPosition()/5000)*(curBpm/60)
    if shakeNotes and shaking then
        for i=0,3 do
            setPropertyFromGroup('playerStrums', i, 'x', _G['defaultPlayerStrumX'..i] + getRandomInt(-2, 2) + math.sin((currentBeat + i*0.25) * math.pi))
            setPropertyFromGroup('playerStrums', i, 'y', _G['defaultPlayerStrumY'..i] + getRandomInt(-2, 2) + math.sin((currentBeat + i*0.25) * math.pi))
        end
    end
    if (curBeat >= 72 and curBeat < 104) or (curBeat >= 143 and curBeat < 144) then
        for i=0,3 do 
            setPropertyFromGroup('playerStrums', i, 'y', _G['defaultPlayerStrumY'..i] - 50 * math.sin((currentBeat + i*0.25) * math.pi * 2))
        end
    end
    if (curBeat >= 104 and curBeat < 136) or (curBeat >= 424 and curBeat < 456) then
        for i=0,3 do 
            setPropertyFromGroup('playerStrums', i, 'y', _G['defaultPlayerStrumY'..i] + 50 * math.cos((currentBeat*0.5) * math.pi * 10))   
        end
    end
    if curBeat >= 280 and curBeat < 344 then
        for i=0,3 do 
            setPropertyFromGroup('playerStrums', i, 'x', _G['defaultPlayerStrumX'..i] - 40 * math.sin((currentBeat + i*0.25) * math.pi * 2))
        end
    end
    if curBeat >= 456 and curBeat < 488 then
        for i=0,3 do 
            setPropertyFromGroup('playerStrums', i, 'y', _G['defaultPlayerStrumY'..i] + 40 * math.sin((currentBeat + i*0.25) * math.pi * 2))
        end
    end
end

function onUpdatePost(elapsed)
    local currentBeat = (getSongPosition()/5000)*(curBpm/60)
    setProperty('timeTxt.text', 'TIME IS MEANINGLESS')
    setProperty('songPercent', randomTimeLength)
    --setProperty('camFollow.x', getProperty('camFollow.x') - getRandomFloat(0.5, 0.8)*math.sin((currentBeat+12)*math.pi)) nvm looks dumb with each sec
    --setProperty('camFollow.y', getProperty('camFollow.y') - getRandomFloat(0.5, 0.8)*math.cos((currentBeat+12)*math.pi))
end

function noteSquish(note, axis, mult)
    if axis == 'x' then
        setPropertyFromGroup('strumLineNotes', note, 'scale.x', mult)
        doTweenX('noteSquish'..axis..note, 'strumLineNotes.members['..note..'].scale', 0.7, 1, 'quadOut')
    else
        setPropertyFromGroup('strumLineNotes', note, 'scale.y', mult)
        doTweenY('noteSquish'..axis..note, 'strumLineNotes.members['..note..'].scale', 0.7, 1, 'quadOut')
    end
end

function backAndForth(num)
    if num == 1 then
        for i=0,3 do
            noteTweenX('xBackAndForth1'..i, i + 4, _G['defaultOpponentStrumX'..i], 1.9, 'sineInOut')
        end
        runTimer('backAndForth1', 1.9, 1)
    else
        for i=0,3 do
            noteTweenX('xBackAndForth2'..i, i + 4, _G['defaultPlayerStrumX'..i], 1.9, 'sineInOut')
        end
        runTimer('backAndForth2', 1.9, 1)
    end
end

function onTimerCompleted(whatTimer)
    if whatTimer == 'backAndForth1' then
        backAndForth(2)
    end
    if whatTimer == 'backAndForth2' then
        backAndForth(1)
    end
end

function onEndSong()
    if wasMidscrollOn == true then
        setPropertyFromClass('ClientPrefs', 'middleScroll', true)
    end
end