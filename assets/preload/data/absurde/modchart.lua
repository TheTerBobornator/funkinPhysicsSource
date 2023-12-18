-- this song has some hardcoded aspects that work in tandem with this modchart.lua!
-- if you'd like to better understand the inner workings consider getting the source code and messing around with that instead!

local defaultPlayerStrumX4K = {0, 0, 0, 0}
local defaultOpponentStrumX4K = {0, 0, 0, 0}
local defaultPlayerStrumX8K = {0, 0, 0, 0, 0, 0, 0, 0, 0} --bear with me on this
local defaultOpponentStrumX8K = {0, 0, 0, 0, 0, 0, 0, 0, 0}
local curSwitch = 0

function onCreate()
    setProperty('skipCredit', true)
    setProperty('skipArrowStartTween', true)
    setProperty('skipCountdown', true)
end
function onCreatePost()
    -- DA SETUPPP
    for i=4,8 do
        setPropertyFromGroup('strumLineNotes', i, 'alpha', 0)
        setPropertyFromGroup('strumLineNotes', i + 9, 'alpha', 0)
    end
    for i=0,3 do
        setPropertyFromGroup('strumLineNotes', i, 'scale.x', 0.7)
        setPropertyFromGroup('strumLineNotes', i, 'scale.y', 0.7)
        setPropertyFromGroup('strumLineNotes', i + 9, 'scale.x', 0.7)
        setPropertyFromGroup('strumLineNotes', i + 9, 'scale.y', 0.7)

        defaultPlayerStrumX8K[i] = getPropertyFromGroup('playerStrums', i, 'x') + 50
        defaultPlayerStrumX8K[i + 5] = getPropertyFromGroup('playerStrums', i + 4, 'x') + 50
        defaultOpponentStrumX8K[i] = getPropertyFromGroup('opponentStrums', i + 1, 'x') - 50
        defaultOpponentStrumX8K[i + 5] = getPropertyFromGroup('opponentStrums', i + 5, 'x') - 50

        defaultPlayerStrumX4K[i] = 92 + (160 * getPropertyFromClass('Note', 'swagWidth') * i) + (screenWidth / 2)
        defaultOpponentStrumX4K[i] = 92 + (160 * getPropertyFromClass('Note', 'swagWidth') * i)

        setPropertyFromGroup('strumLineNotes', i, 'x', defaultOpponentStrumX4K[i])
        setPropertyFromGroup('strumLineNotes', i + 9, 'x', defaultPlayerStrumX4K[i])
        updateHitboxFromGroup('strumLineNotes', i)
        updateHitboxFromGroup('strumLineNotes', i + 9)
    end
    setPropertyFromGroup('opponentStrums', 4, 'visible', false)
    setPropertyFromGroup('playerStrums', 4, 'visible', false)

 --   for i=0,getProperty('unspawnNotes.length') do
 --       setProperty('unspawnNotes['..i..']', 'scale.x', 0.7)
 --       setProperty('unspawnNotes['..i..']', 'scale.y', 0.7)
 --   end

    setProperty('camHUD.alpha', 0)
    setProperty('camGame.alpha', 0)
    setProperty('camZoomingMult', 0)
end
function onSongStart()
	runHaxeCode("FlxTween.tween(FlxG.camera, {zoom: 0.9}, 3.2, {ease: FlxEase.quartIn, onComplete: defaultCamZoom = 0.9});")
end

function onBeatHit()
    if curBeat >= 16 and curBeat < 208 then
        if curBeat % 4 == 0 then
            if curBeat < 144 then
                for i=0,8 do
                    noteTweenAngle('a'..i, i, -30, 0.5, 'elasticOut')
                end
                for i=9,17 do
                    noteTweenAngle('a'..i, i, 30, 0.5, 'elasticOut')
                end
            else
                for i=0,3 do
                    noteSquish(i, 'x', 1, 0.4)
                    noteSquish(i, 'y', 0.4, 0.4)
                    noteSquish(i + 9, 'x', 1, 0.4)
                    noteSquish(i + 9, 'y', 0.4, 0.4)
                    if i % 2 == 0 then
                        noteTweenY('y'..i, i, _G['defaultOpponentStrumY'..i] - 30, 0.5, 'elasticOut')
                        noteTweenY('y'..i + 9, i + 9, _G['defaultPlayerStrumY'..i] + 30, 0.5, 'elasticOut')
                    else
                        noteTweenY('y'..i, i, _G['defaultOpponentStrumY'..i] + 30, 0.5, 'elasticOut')
                        noteTweenY('y'..i + 9, i + 9, _G['defaultPlayerStrumY'..i] - 30, 0.5, 'elasticOut')
                    end
                end
            end
        end
        if curBeat % 4 == 2 then
            if curBeat < 144 then
                for i=0,8 do
                    noteTweenAngle('a2'..i, i, 30, 0.5, 'elasticOut')
                end
                for i=9,17 do
                    noteTweenAngle('a2'..i, i, -30, 0.5, 'elasticOut')
                end
            else
                for i=0,3 do
                    noteSquish(i, 'x', 1, 0.4)
                    noteSquish(i, 'y', 0.4, 0.4)
                    noteSquish(i + 9, 'x', 1, 0.4)
                    noteSquish(i + 9, 'y', 0.4, 0.4)
                    if i % 2 == 0 then
                        noteTweenY('y'..i, i, _G['defaultOpponentStrumY'..i] + 30, 0.5, 'elasticOut')
                        noteTweenY('y'..i + 9, i + 9, _G['defaultPlayerStrumY'..i] - 30, 0.5, 'elasticOut')
                    else
                        noteTweenY('y'..i, i, _G['defaultOpponentStrumY'..i] - 30, 0.5, 'elasticOut')
                        noteTweenY('y'..i + 9, i + 9, _G['defaultPlayerStrumY'..i] + 30, 0.5, 'elasticOut')
                    end
                end
            end
        end
    end
    if curBeat >= 564 and curBeat < 692 then
        if curBeat % 2 == 0 then
            noteSwitch(curSwitch)
        end
    end
    if curBeat < 492 then
        for i=0,20 do
            setPropertyFromGroup('notes', i, 'scale.x', 0.7)
            if not getPropertyFromGroup('notes', i, 'isSustainNote') then
                setPropertyFromGroup('notes', i, 'scale.y', 0.7)
            end
            updateHitboxFromGroup('notes', i)
        end
    end
    if curBeat == 16 then
        doTweenY('timebarLeave', 'timeBar', 1500, 4, 'quadOut')
        doTweenAngle('timebarAngleFling', 'timeBar', 1500, 5, 'linear')
    end
    if curBeat == 20 then
        doTweenAlpha('timeTxtFade', 'timeTxt', 0, 1, 'quadOut')
    end
    if curBeat == 144 then
        for i=0,17 do
            noteTweenAngle('resetA'..i, i, 0, 0.5, 'quadOut')
            if i < 9 then
                noteTweenX('resetX'..i, i, defaultOpponentStrumX4K[i], 0.5, 'quadOut')
            else
                noteTweenX('resetX'..i, i, defaultPlayerStrumX4K[i - 9], 0.5, 'quadOut')
            end
        end 
    end
    if curBeat == 208 or curBeat == 692 then
        for i=0,8 do
            noteTweenY('resetYOppo'..i, i, _G['defaultOpponentStrumY'..i], 0.5, 'quadOut')
            noteTweenY('resetYPlayer'..i, i + 9, _G['defaultPlayerStrumY'..i], 0.5, 'quadOut')
        end
    end
    if curBeat == 272 then
        setProperty('cameraSpeed', 100)
        setProperty('boyfriend.cameraPosition[0]', getProperty('boyfriend.cameraPosition[0]') - 100)
        setProperty('dad.cameraPosition[0]', getProperty('dad.cameraPosition[0]') - 350)
        setProperty('dad.cameraPosition[1]', getProperty('dad.cameraPosition[1]') - 80)

        for i=0,3 do
            setPropertyFromGroup('opponentStrums', i, 'x', defaultOpponentStrumX4K[i])
            noteTweenY('y'..i, i, _G['defaultOpponentStrumY'..i], 0.5, 'quadOut')
            setPropertyFromGroup('playerStrums', i, 'x', defaultPlayerStrumX4K[i])
            noteTweenY('y'..i + 9, i + 9, 800, 0.5, 'quadOut')
        end
    end
    if curBeat == 278 or curBeat == 294 or curBeat == 318 then
        for i=0,3 do
            noteTweenY('y'..i, i, 800, 0.5, 'quadOut')
            noteTweenY('y'..i + 9, i + 9, _G['defaultPlayerStrumY'..i], 0.5, 'quadOut')
        end
    end
    if curBeat == 286 or curBeat == 304 then
        for i=0,3 do
            noteTweenY('y'..i, i, _G['defaultOpponentStrumY'..i], 0.5, 'quadOut')
            noteTweenY('y'..i + 9, i + 9, 800, 0.5, 'quadOut')
        end
    end
    if curBeat == 340 then
        for i=0,3 do
            noteTweenY('y'..i + 9, i + 9, 800, 1.5, 'quadOut')
        end
    end
    if curBeat == 347 then
        for i=0,3 do
            noteTweenY('y'..i, i, _G['defaultOpponentStrumY'..i], 0.25, 'quadOut')
            noteTweenAlpha('a'..i, i, 0.25, 0.25, 'quadOut')
            noteTweenY('y'..i + 9, i + 9, _G['defaultPlayerStrumY'..i], 0.25, 'quadOut')
        end
        noteTweenX('x0', 0, defaultOpponentStrumX4K[1], 0.25, 'quadOut')
        noteTweenX('x9', 9, defaultOpponentStrumX4K[1], 0.25, 'quadOut')
        noteTweenX('x1', 1, defaultOpponentStrumX4K[3], 0.25, 'quadOut')
        noteTweenX('x10', 10, defaultOpponentStrumX4K[3], 0.25, 'quadOut')
        noteTweenX('x2', 2, defaultPlayerStrumX4K[0], 0.25, 'quadOut')
        noteTweenX('x11', 11, defaultPlayerStrumX4K[0], 0.25, 'quadOut')
        noteTweenX('x3', 3, defaultPlayerStrumX4K[2], 0.25, 'quadOut')
        noteTweenX('x12', 12, defaultPlayerStrumX4K[2], 0.25, 'quadOut')
    end
    if curBeat == 494 then
        setProperty('camHUD.angle', 0)
        for i=0,17 do
            noteTweenAngle('resetA'..i, i, 0, 0.25)
        end
    end
    if curBeat == 498 then
        for i=0,3 do
            setPropertyFromGroup('opponentStrums', i, 'scale.x', 0.46)
            setPropertyFromGroup('opponentStrums', i, 'scale.y', 0.46)
            updateHitboxFromGroup('opponentStrums', i)
            setPropertyFromGroup('playerStrums', i, 'scale.x', 0.46)
            setPropertyFromGroup('playerStrums', i, 'scale.y', 0.46)
            updateHitboxFromGroup('playerStrums', i)
        end    
        for i=4,8 do
            setPropertyFromGroup('playerStrums', i, 'alpha', 1)
        end
        for i=0,8 do
            setPropertyFromGroup('opponentStrums', i, 'x', defaultOpponentStrumX8K[i])
            setPropertyFromGroup('opponentStrums', i, 'y', _G['defaultOpponentStrumY'..i])
            setPropertyFromGroup('opponentStrums', i, 'alpha', 1)
            setPropertyFromGroup('playerStrums', i, 'x', defaultPlayerStrumX8K[i])
            setPropertyFromGroup('playerStrums', i, 'y', _G['defaultPlayerStrumY'..i])
        end
        setPropertyFromGroup('playerStrums', 4, 'x', -200) -- fuckoutta here
    end
    if curBeat == 500 then
        setProperty('camHUD.alpha', 1)
        setProperty('cameraSpeed', 1)
        setProperty('boyfriend.cameraPosition[0]', getProperty('boyfriend.cameraPosition[0]') + 100)
        setProperty('dad.cameraPosition[0]', getProperty('dad.cameraPosition[0]') + 350)
        setProperty('dad.cameraPosition[1]', getProperty('dad.cameraPosition[1]') + 80)
    end

    if curBeat == 820 then
        for i=0,8 do
            noteTweenAlpha('a'..i, i, 0.25, 0.25, 'quadOut')
        end

        midX = 640 - (getPropertyFromGroup('strumLineNotes', 0, 'width') / 2)
        midY = 360 - (getPropertyFromGroup('strumLineNotes', 0, 'height') / 2)

        setPropertyFromGroup('strumLineNotes', 0, 'x', midX - 100)
        setPropertyFromGroup('strumLineNotes', 1, 'x', midX)
        setPropertyFromGroup('strumLineNotes', 2, 'x', midX)
        setPropertyFromGroup('strumLineNotes', 3, 'x', midX + 100)
        setPropertyFromGroup('strumLineNotes', 5, 'x', midX - 50)
        setPropertyFromGroup('strumLineNotes', 6, 'x', midX - 50)
        setPropertyFromGroup('strumLineNotes', 7, 'x', midX + 50)
        setPropertyFromGroup('strumLineNotes', 8, 'x', midX + 50)
        setPropertyFromGroup('strumLineNotes', 9, 'x', midX - 100)
        setPropertyFromGroup('strumLineNotes', 10, 'x', midX)
        setPropertyFromGroup('strumLineNotes', 11, 'x', midX)
        setPropertyFromGroup('strumLineNotes', 12, 'x', midX + 100)
        setPropertyFromGroup('strumLineNotes', 14, 'x', midX - 50)
        setPropertyFromGroup('strumLineNotes', 15, 'x', midX - 50)
        setPropertyFromGroup('strumLineNotes', 16, 'x', midX + 50)
        setPropertyFromGroup('strumLineNotes', 17, 'x', midX + 50)
        
        setPropertyFromGroup('strumLineNotes', 0, 'y', midY)
        setPropertyFromGroup('strumLineNotes', 1, 'y', midY + 100)
        setPropertyFromGroup('strumLineNotes', 2, 'y', midY - 100)
        setPropertyFromGroup('strumLineNotes', 3, 'y', midY)
        setPropertyFromGroup('strumLineNotes', 5, 'y', midY - 50)
        setPropertyFromGroup('strumLineNotes', 6, 'y', midY + 50)
        setPropertyFromGroup('strumLineNotes', 7, 'y', midY - 50)
        setPropertyFromGroup('strumLineNotes', 8, 'y', midY + 50)
        setPropertyFromGroup('strumLineNotes', 9, 'y', midY)
        setPropertyFromGroup('strumLineNotes', 10, 'y', midY + 100)
        setPropertyFromGroup('strumLineNotes', 11, 'y', midY - 100)
        setPropertyFromGroup('strumLineNotes', 12, 'y', midY)
        setPropertyFromGroup('strumLineNotes', 14, 'y', midY - 50)
        setPropertyFromGroup('strumLineNotes', 15, 'y', midY + 50)
        setPropertyFromGroup('strumLineNotes', 16, 'y', midY - 50)
        setPropertyFromGroup('strumLineNotes', 17, 'y', midY + 50)

        setPropertyFromGroup('strumLineNotes', 5, 'angle', 45)
        setPropertyFromGroup('strumLineNotes', 6, 'angle', 45)
        setPropertyFromGroup('strumLineNotes', 7, 'angle', 45)
        setPropertyFromGroup('strumLineNotes', 8, 'angle', 45)
        setPropertyFromGroup('strumLineNotes', 14, 'angle', 45)
        setPropertyFromGroup('strumLineNotes', 15, 'angle', 45)
        setPropertyFromGroup('strumLineNotes', 16, 'angle', 45)
        setPropertyFromGroup('strumLineNotes', 17, 'angle', 45)

        setPropertyFromGroup('strumLineNotes', 0, 'direction', 180)
        setPropertyFromGroup('strumLineNotes', 1, 'direction', 90)
        setPropertyFromGroup('strumLineNotes', 2, 'direction', 270)
        setPropertyFromGroup('strumLineNotes', 3, 'direction', 0)
        setPropertyFromGroup('strumLineNotes', 5, 'direction', -135)
        setPropertyFromGroup('strumLineNotes', 6, 'direction', 135)
        setPropertyFromGroup('strumLineNotes', 7, 'direction', -45)
        setPropertyFromGroup('strumLineNotes', 8, 'direction', 45)
        setPropertyFromGroup('strumLineNotes', 9, 'direction', 180)
        setPropertyFromGroup('strumLineNotes', 10, 'direction', 90)
        setPropertyFromGroup('strumLineNotes', 11, 'direction', 270)
        setPropertyFromGroup('strumLineNotes', 12, 'direction', 0)
        setPropertyFromGroup('strumLineNotes', 14, 'direction', -135)
        setPropertyFromGroup('strumLineNotes', 15, 'direction', 135)
        setPropertyFromGroup('strumLineNotes', 16, 'direction', -45)
        setPropertyFromGroup('strumLineNotes', 17, 'direction', 45)
    end
end

function onUpdate(elapsed)
    local currentBeat = (getSongPosition()/5000)*(curBpm/60)

    if curBeat >= 80 and curBeat < 144 then
        for i=0,8 do
            noteTweenX('noteWobblin'..i, i, getPropertyFromGroup('strumLineNotes', i, 'x') - 10*math.sin((currentBeat+12)*math.pi), 0.1)
        end
        for i=9,17 do
            noteTweenX('noteWobblin'..i, i, getPropertyFromGroup('strumLineNotes', i, 'x') + 10*math.sin((currentBeat+12)*math.pi), 0.1)
        end
    end
    if curBeat >= 208 and curBeat < 272 then
        for i=0,3 do
            setPropertyFromGroup('opponentStrums', i, 'y', _G['defaultOpponentStrumY'..i] + 50*math.sin((currentBeat+12)*math.pi + i))
            setPropertyFromGroup('opponentStrums', i, 'x', getPropertyFromGroup('opponentStrums', i, 'x') + 12)
            if getPropertyFromGroup('opponentStrums', i, 'x') > screenWidth then
                setPropertyFromGroup('opponentStrums', i, 'x', 0 - getPropertyFromGroup('opponentStrums', i, 'width'))
            end
            setPropertyFromGroup('playerStrums', i, 'y', _G['defaultPlayerStrumY'..i] + 50*math.sin((currentBeat+12)*math.pi + (i + 3)))
            setPropertyFromGroup('playerStrums', i, 'x', getPropertyFromGroup('playerStrums', i, 'x') + 12)
            if getPropertyFromGroup('playerStrums', i, 'x') > screenWidth then 
                setPropertyFromGroup('playerStrums', i, 'x', 0 - getPropertyFromGroup('playerStrums', i, 'width'))
            end
        end
    end
    if curBeat >= 348 and curBeat < 492 then
        setProperty('songSpeed', getProperty('songSpeed') - (math.sin(currentBeat + 1.2) * 0.02))
        for i=0,3 do
            setPropertyFromGroup('opponentStrums', i, 'x', getPropertyFromGroup('opponentStrums', i, 'x') + math.sin((currentBeat+12)*math.pi + i))
            setPropertyFromGroup('opponentStrums', i, 'y', _G['defaultOpponentStrumY'..i] + 50*math.sin((currentBeat+12)*math.pi + i))
            setPropertyFromGroup('playerStrums', i, 'x', getPropertyFromGroup('playerStrums', i, 'x') + math.sin((currentBeat+12)*math.pi + i))
            setPropertyFromGroup('playerStrums', i, 'y', _G['defaultPlayerStrumY'..i] + 50*math.sin((currentBeat+12)*math.pi + i))
        end
        triggerEvent('Camera Follow Pos', cameraX + 2.5*math.cos((currentBeat+12)*math.pi), cameraY + 2*math.sin((currentBeat+12)*math.pi))
        doTweenAngle('hudwweeeeww', 'camHUD', 5*math.sin((currentBeat+12)*math.pi), 0.1)
        --doTweenAngle('gamewweeeeww', 'camGame', -5*math.sin((currentBeat+12)*math.pi), 0.1)
        for i=0,17 do
            noteTweenAngle('a'..i, i, -5*math.sin((currentBeat+12)*math.pi), 0.1)
        end
    end
    if curBeat >= 628 and curBeat < 692 then
        for i=0,8 do 
            if i < 4 then
                setPropertyFromGroup('opponentStrums', i, 'y', _G['defaultOpponentStrumY'..i] - 50*math.sin((currentBeat+12)*math.pi + i))
                setPropertyFromGroup('playerStrums', i, 'y', _G['defaultPlayerStrumY'..i] + 50*math.sin((currentBeat+12)*math.pi + i))
            else
                setPropertyFromGroup('opponentStrums', i, 'y', _G['defaultOpponentStrumY'..i] - 50*math.sin((currentBeat+12)*math.pi + (i - 1)))
                setPropertyFromGroup('playerStrums', i, 'y', _G['defaultPlayerStrumY'..i] + 50*math.sin((currentBeat+12)*math.pi + (i - 1)))
            end
        end
    end
    if curBeat >= 692 and curBeat < 756 then
        for i=0,8 do
            if i < 4 then
                setPropertyFromGroup('opponentStrums', i, 'x', getPropertyFromGroup('opponentStrums', i, 'x') + 13*math.cos((currentBeat+12)*math.pi))
                setPropertyFromGroup('opponentStrums', i, 'y', _G['defaultOpponentStrumY'..i] + (40 + i)*math.cos((currentBeat+12)*math.pi + i))
                setPropertyFromGroup('playerStrums', i, 'x', getPropertyFromGroup('playerStrums', i, 'x') - 13*math.cos((currentBeat+12)*math.pi))
                setPropertyFromGroup('playerStrums', i, 'y', _G['defaultPlayerStrumY'..i] + (40 + i)*math.cos((currentBeat+12)*math.pi + i))
            else
                setPropertyFromGroup('opponentStrums', i, 'x', getPropertyFromGroup('opponentStrums', i, 'x') + 13*math.cos((currentBeat+12)*math.pi))
                setPropertyFromGroup('opponentStrums', i, 'y', _G['defaultOpponentStrumY'..i] + (40 + (i - 1))*math.cos((currentBeat+12)*math.pi + (i - 1)))
                setPropertyFromGroup('playerStrums', i, 'x', getPropertyFromGroup('playerStrums', i, 'x') - 13*math.cos((currentBeat+12)*math.pi))
                setPropertyFromGroup('playerStrums', i, 'y', _G['defaultPlayerStrumY'..i] + (40 + (i - 1))*math.cos((currentBeat+12)*math.pi + (i - 1)))
            end
        end
    end
    if curBeat >= 756 and curBeat < 820 then
        for i=0,8 do
            if i < 4 then
                setPropertyFromGroup('opponentStrums', i, 'x', 600 + 200*math.cos((currentBeat)*math.pi + (i + 9)))
                setPropertyFromGroup('opponentStrums', i, 'y', 200 + 150*math.sin((currentBeat)*math.pi + (i + 9)))
                setPropertyFromGroup('playerStrums', i, 'x', 600 + 200*math.cos((currentBeat)*math.pi + i))
                setPropertyFromGroup('playerStrums', i, 'y', 200 + 150*math.sin((currentBeat)*math.pi + i))
            else
                setPropertyFromGroup('opponentStrums', i, 'x', 600 + 200*math.cos((currentBeat)*math.pi + (i + 8)))
                setPropertyFromGroup('opponentStrums', i, 'y', 200 + 150*math.sin((currentBeat)*math.pi + (i + 8)))
                setPropertyFromGroup('playerStrums', i, 'x', 600 + 200*math.cos((currentBeat)*math.pi + (i - 1)))
                setPropertyFromGroup('playerStrums', i, 'y', 200 + 150*math.sin((currentBeat)*math.pi + (i - 1)))
            end
        end
    end
end

function onUpdatePost(elapsed)
    setProperty('timeTxt.text', 'NOPE')
end

function noteSquish(note, axis, mult, time)
    if curBeat >= 500 then
        noteScale = 0.46
    else
        noteScale = 0.7
    end
    if axis == 'x' then
        setPropertyFromGroup('strumLineNotes', note, 'scale.x', mult)
        doTweenX('noteSquish'..axis..note, 'strumLineNotes.members['..note..'].scale', noteScale, time, 'quadOut')
    else
        setPropertyFromGroup('strumLineNotes', note, 'scale.y', mult)
        doTweenY('noteSquish'..axis..note, 'strumLineNotes.members['..note..'].scale', noteScale, time, 'quadOut')
    end
end

local noteSwitchNewXOpponent = {}
local noteSwitchNewXPlayer = {}
local noteSwitchNewX = {}
--literally killing myself 
--I FUCKING HATE THIS I FUCKING HATE THIS I FUCKING HATE THIS I FUCKING HATE THIS I FUCKING HATE THIS I FUCKING HATE THIS I FUCKING HATE THIS 
function noteSwitch(switchNum)
    if switchNum == 0 then
        noteTweenX('0x', 0, defaultOpponentStrumX8K[1], 0.5, 'elasticOut')
        noteTweenX('1x', 1, defaultOpponentStrumX8K[2], 0.5, 'elasticOut')
        noteTweenX('2x', 2, defaultOpponentStrumX8K[3], 0.5, 'elasticOut')
        noteTweenX('3x', 3, defaultOpponentStrumX8K[5], 0.5, 'elasticOut')

        noteTweenX('5x', 5, defaultOpponentStrumX8K[6], 0.5, 'elasticOut')
        noteTweenX('6x', 6, defaultOpponentStrumX8K[7], 0.5, 'elasticOut')
        noteTweenX('7x', 7, defaultOpponentStrumX8K[8], 0.5, 'elasticOut')
        noteTweenX('8x', 8, defaultOpponentStrumX8K[0], 0.5, 'elasticOut')

        
        noteTweenX('9x', 9, defaultPlayerStrumX8K[8], 0.5, 'elasticOut')
        noteTweenX('10x', 10, defaultPlayerStrumX8K[0], 0.5, 'elasticOut')
        noteTweenX('11x', 11, defaultPlayerStrumX8K[1], 0.5, 'elasticOut')
        noteTweenX('12x', 12, defaultPlayerStrumX8K[2], 0.5, 'elasticOut')

        noteTweenX('14x', 14, defaultPlayerStrumX8K[3], 0.5, 'elasticOut')
        noteTweenX('15x', 15, defaultPlayerStrumX8K[5], 0.5, 'elasticOut')
        noteTweenX('16x', 16, defaultPlayerStrumX8K[6], 0.5, 'elasticOut')
        noteTweenX('17x', 17, defaultPlayerStrumX8K[7], 0.5, 'elasticOut')
    elseif switchNum == 1 then
        noteTweenX('0x', 0, defaultOpponentStrumX8K[2], 0.5, 'elasticOut')
        noteTweenX('1x', 1, defaultOpponentStrumX8K[3], 0.5, 'elasticOut')
        noteTweenX('2x', 2, defaultOpponentStrumX8K[5], 0.5, 'elasticOut')
        noteTweenX('3x', 3, defaultOpponentStrumX8K[6], 0.5, 'elasticOut')

        noteTweenX('5x', 5, defaultOpponentStrumX8K[7], 0.5, 'elasticOut')
        noteTweenX('6x', 6, defaultOpponentStrumX8K[8], 0.5, 'elasticOut')
        noteTweenX('7x', 7, defaultOpponentStrumX8K[0], 0.5, 'elasticOut')
        noteTweenX('8x', 8, defaultOpponentStrumX8K[1], 0.5, 'elasticOut')

        
        noteTweenX('9x', 9, defaultPlayerStrumX8K[7], 0.5, 'elasticOut')
        noteTweenX('10x', 10, defaultPlayerStrumX8K[8], 0.5, 'elasticOut')
        noteTweenX('11x', 11, defaultPlayerStrumX8K[0], 0.5, 'elasticOut')
        noteTweenX('12x', 12, defaultPlayerStrumX8K[1], 0.5, 'elasticOut')

        noteTweenX('14x', 14, defaultPlayerStrumX8K[2], 0.5, 'elasticOut')
        noteTweenX('15x', 15, defaultPlayerStrumX8K[3], 0.5, 'elasticOut')
        noteTweenX('16x', 16, defaultPlayerStrumX8K[5], 0.5, 'elasticOut')
        noteTweenX('17x', 17, defaultPlayerStrumX8K[6], 0.5, 'elasticOut')
    elseif switchNum == 2 then
        noteTweenX('0x', 0, defaultOpponentStrumX8K[3], 0.5, 'elasticOut')
        noteTweenX('1x', 1, defaultOpponentStrumX8K[5], 0.5, 'elasticOut')
        noteTweenX('2x', 2, defaultOpponentStrumX8K[6], 0.5, 'elasticOut')
        noteTweenX('3x', 3, defaultOpponentStrumX8K[7], 0.5, 'elasticOut')

        noteTweenX('5x', 5, defaultOpponentStrumX8K[8], 0.5, 'elasticOut')
        noteTweenX('6x', 6, defaultOpponentStrumX8K[0], 0.5, 'elasticOut')
        noteTweenX('7x', 7, defaultOpponentStrumX8K[1], 0.5, 'elasticOut')
        noteTweenX('8x', 8, defaultOpponentStrumX8K[2], 0.5, 'elasticOut')

        
        noteTweenX('9x', 9, defaultPlayerStrumX8K[6], 0.5, 'elasticOut')
        noteTweenX('10x', 10, defaultPlayerStrumX8K[7], 0.5, 'elasticOut')
        noteTweenX('11x', 11, defaultPlayerStrumX8K[8], 0.5, 'elasticOut')
        noteTweenX('12x', 12, defaultPlayerStrumX8K[0], 0.5, 'elasticOut')

        noteTweenX('14x', 14, defaultPlayerStrumX8K[1], 0.5, 'elasticOut')
        noteTweenX('15x', 15, defaultPlayerStrumX8K[2], 0.5, 'elasticOut')
        noteTweenX('16x', 16, defaultPlayerStrumX8K[3], 0.5, 'elasticOut')
        noteTweenX('17x', 17, defaultPlayerStrumX8K[5], 0.5, 'elasticOut')
    elseif switchNum == 3 then
        noteTweenX('0x', 0, defaultOpponentStrumX8K[5], 0.5, 'elasticOut')
        noteTweenX('1x', 1, defaultOpponentStrumX8K[6], 0.5, 'elasticOut')
        noteTweenX('2x', 2, defaultOpponentStrumX8K[7], 0.5, 'elasticOut')
        noteTweenX('3x', 3, defaultOpponentStrumX8K[8], 0.5, 'elasticOut')

        noteTweenX('5x', 5, defaultOpponentStrumX8K[0], 0.5, 'elasticOut')
        noteTweenX('6x', 6, defaultOpponentStrumX8K[1], 0.5, 'elasticOut')
        noteTweenX('7x', 7, defaultOpponentStrumX8K[2], 0.5, 'elasticOut')
        noteTweenX('8x', 8, defaultOpponentStrumX8K[3], 0.5, 'elasticOut')

        
        noteTweenX('9x', 9, defaultPlayerStrumX8K[5], 0.5, 'elasticOut')
        noteTweenX('10x', 10, defaultPlayerStrumX8K[6], 0.5, 'elasticOut')
        noteTweenX('11x', 11, defaultPlayerStrumX8K[7], 0.5, 'elasticOut')
        noteTweenX('12x', 12, defaultPlayerStrumX8K[8], 0.5, 'elasticOut')

        noteTweenX('14x', 14, defaultPlayerStrumX8K[0], 0.5, 'elasticOut')
        noteTweenX('15x', 15, defaultPlayerStrumX8K[1], 0.5, 'elasticOut')
        noteTweenX('16x', 16, defaultPlayerStrumX8K[2], 0.5, 'elasticOut')
        noteTweenX('17x', 17, defaultPlayerStrumX8K[3], 0.5, 'elasticOut')
    elseif switchNum == 4 then
        noteTweenX('0x', 0, defaultOpponentStrumX8K[6], 0.5, 'elasticOut')
        noteTweenX('1x', 1, defaultOpponentStrumX8K[7], 0.5, 'elasticOut')
        noteTweenX('2x', 2, defaultOpponentStrumX8K[8], 0.5, 'elasticOut')
        noteTweenX('3x', 3, defaultOpponentStrumX8K[0], 0.5, 'elasticOut')

        noteTweenX('5x', 5, defaultOpponentStrumX8K[1], 0.5, 'elasticOut')
        noteTweenX('6x', 6, defaultOpponentStrumX8K[2], 0.5, 'elasticOut')
        noteTweenX('7x', 7, defaultOpponentStrumX8K[3], 0.5, 'elasticOut')
        noteTweenX('8x', 8, defaultOpponentStrumX8K[5], 0.5, 'elasticOut')

        
        noteTweenX('9x', 9, defaultPlayerStrumX8K[3], 0.5, 'elasticOut')
        noteTweenX('10x', 10, defaultPlayerStrumX8K[5], 0.5, 'elasticOut')
        noteTweenX('11x', 11, defaultPlayerStrumX8K[6], 0.5, 'elasticOut')
        noteTweenX('12x', 12, defaultPlayerStrumX8K[7], 0.5, 'elasticOut')

        noteTweenX('14x', 14, defaultPlayerStrumX8K[8], 0.5, 'elasticOut')
        noteTweenX('15x', 15, defaultPlayerStrumX8K[0], 0.5, 'elasticOut')
        noteTweenX('16x', 16, defaultPlayerStrumX8K[1], 0.5, 'elasticOut')
        noteTweenX('17x', 17, defaultPlayerStrumX8K[2], 0.5, 'elasticOut')
    elseif switchNum == 5 then
        noteTweenX('0x', 0, defaultOpponentStrumX8K[7], 0.5, 'elasticOut')
        noteTweenX('1x', 1, defaultOpponentStrumX8K[8], 0.5, 'elasticOut')
        noteTweenX('2x', 2, defaultOpponentStrumX8K[0], 0.5, 'elasticOut')
        noteTweenX('3x', 3, defaultOpponentStrumX8K[1], 0.5, 'elasticOut')

        noteTweenX('5x', 5, defaultOpponentStrumX8K[2], 0.5, 'elasticOut')
        noteTweenX('6x', 6, defaultOpponentStrumX8K[3], 0.5, 'elasticOut')
        noteTweenX('7x', 7, defaultOpponentStrumX8K[5], 0.5, 'elasticOut')
        noteTweenX('8x', 8, defaultOpponentStrumX8K[6], 0.5, 'elasticOut')

        
        noteTweenX('9x', 9, defaultPlayerStrumX8K[2], 0.5, 'elasticOut')
        noteTweenX('10x', 10, defaultPlayerStrumX8K[3], 0.5, 'elasticOut')
        noteTweenX('11x', 11, defaultPlayerStrumX8K[5], 0.5, 'elasticOut')
        noteTweenX('12x', 12, defaultPlayerStrumX8K[6], 0.5, 'elasticOut')

        noteTweenX('14x', 14, defaultPlayerStrumX8K[7], 0.5, 'elasticOut')
        noteTweenX('15x', 15, defaultPlayerStrumX8K[8], 0.5, 'elasticOut')
        noteTweenX('16x', 16, defaultPlayerStrumX8K[0], 0.5, 'elasticOut')
        noteTweenX('17x', 17, defaultPlayerStrumX8K[1], 0.5, 'elasticOut')
    elseif switchNum == 6 then
        noteTweenX('0x', 0, defaultOpponentStrumX8K[8], 0.5, 'elasticOut')
        noteTweenX('1x', 1, defaultOpponentStrumX8K[0], 0.5, 'elasticOut')
        noteTweenX('2x', 2, defaultOpponentStrumX8K[1], 0.5, 'elasticOut')
        noteTweenX('3x', 3, defaultOpponentStrumX8K[2], 0.5, 'elasticOut')

        noteTweenX('5x', 5, defaultOpponentStrumX8K[3], 0.5, 'elasticOut')
        noteTweenX('6x', 6, defaultOpponentStrumX8K[5], 0.5, 'elasticOut')
        noteTweenX('7x', 7, defaultOpponentStrumX8K[6], 0.5, 'elasticOut')
        noteTweenX('8x', 8, defaultOpponentStrumX8K[7], 0.5, 'elasticOut')

        noteTweenX('9x', 9, defaultPlayerStrumX8K[1], 0.5, 'elasticOut')
        noteTweenX('10x', 10, defaultPlayerStrumX8K[2], 0.5, 'elasticOut')
        noteTweenX('11x', 11, defaultPlayerStrumX8K[3], 0.5, 'elasticOut')
        noteTweenX('12x', 12, defaultPlayerStrumX8K[5], 0.5, 'elasticOut')

        noteTweenX('14x', 14, defaultPlayerStrumX8K[6], 0.5, 'elasticOut')
        noteTweenX('15x', 15, defaultPlayerStrumX8K[7], 0.5, 'elasticOut')
        noteTweenX('16x', 16, defaultPlayerStrumX8K[8], 0.5, 'elasticOut')
        noteTweenX('17x', 17, defaultPlayerStrumX8K[0], 0.5, 'elasticOut')
    elseif switchNum == 7 then
        noteTweenX('0x', 0, defaultOpponentStrumX8K[0], 0.5, 'elasticOut')
        noteTweenX('1x', 1, defaultOpponentStrumX8K[1], 0.5, 'elasticOut')
        noteTweenX('2x', 2, defaultOpponentStrumX8K[2], 0.5, 'elasticOut')
        noteTweenX('3x', 3, defaultOpponentStrumX8K[3], 0.5, 'elasticOut')

        noteTweenX('5x', 5, defaultOpponentStrumX8K[5], 0.5, 'elasticOut')
        noteTweenX('6x', 6, defaultOpponentStrumX8K[6], 0.5, 'elasticOut')
        noteTweenX('7x', 7, defaultOpponentStrumX8K[7], 0.5, 'elasticOut')
        noteTweenX('8x', 8, defaultOpponentStrumX8K[8], 0.5, 'elasticOut')

        
        noteTweenX('9x', 9, defaultPlayerStrumX8K[0], 0.5, 'elasticOut')
        noteTweenX('10x', 10, defaultPlayerStrumX8K[1], 0.5, 'elasticOut')
        noteTweenX('11x', 11, defaultPlayerStrumX8K[2], 0.5, 'elasticOut')
        noteTweenX('12x', 12, defaultPlayerStrumX8K[3], 0.5, 'elasticOut')

        noteTweenX('14x', 14, defaultPlayerStrumX8K[5], 0.5, 'elasticOut')
        noteTweenX('15x', 15, defaultPlayerStrumX8K[6], 0.5, 'elasticOut')
        noteTweenX('16x', 16, defaultPlayerStrumX8K[7], 0.5, 'elasticOut')
        noteTweenX('17x', 17, defaultPlayerStrumX8K[8], 0.5, 'elasticOut')

        curSwitch = 0
    end
    for i=0,8 do
        noteSquish(i, 'x', 0.3, 0.4)
        noteSquish(i, 'y', 0.6, 0.4)
        noteSquish(i + 9, 'x', 0.3, 0.4)
        noteSquish(i + 9, 'y', 0.6, 0.4)
    end
    curSwitch = curSwitch + 1
end

function backAndForth(num)
    if num == 1 then
        noteTweenX('x0', 0, defaultOpponentStrumX8K[0], 2, 'sineInOut')
        noteTweenX('x1', 1, defaultOpponentStrumX8K[1], 2, 'sineInOut')
        noteTweenX('x2', 2, defaultOpponentStrumX8K[2], 2, 'sineInOut')
        noteTweenX('x3', 3, defaultOpponentStrumX8K[3], 2, 'sineInOut')
        noteTweenX('x5', 5, defaultOpponentStrumX8K[4], 2, 'sineInOut')
        noteTweenX('x6', 6, defaultOpponentStrumX8K[5], 2, 'sineInOut')
        noteTweenX('x7', 7, defaultOpponentStrumX8K[6], 2, 'sineInOut')
        noteTweenX('x8', 8, defaultOpponentStrumX8K[7], 2, 'sineInOut')
        noteTweenX('x9', 9, defaultOpponentStrumX8K[0], 2, 'sineInOut')
        noteTweenX('x10', 10, defaultOpponentStrumX8K[1], 2, 'sineInOut')
        noteTweenX('x11', 11, defaultOpponentStrumX8K[2], 2, 'sineInOut')
        noteTweenX('x12', 12, defaultOpponentStrumX8K[3], 2, 'sineInOut')
        noteTweenX('x14', 14, defaultOpponentStrumX8K[4], 2, 'sineInOut')
        noteTweenX('x15', 15, defaultOpponentStrumX8K[5], 2, 'sineInOut')
        noteTweenX('x16', 16, defaultOpponentStrumX8K[6], 2, 'sineInOut')
        noteTweenX('x17', 17, defaultOpponentStrumX8K[7], 2, 'sineInOut')
        runTimer('backAndForth1', 2, 1)
    else
        noteTweenX('x0', 0, defaultPlayerStrumX8K[0], 2, 'sineInOut')
        noteTweenX('x1', 1, defaultPlayerStrumX8K[1], 2, 'sineInOut')
        noteTweenX('x2', 2, defaultPlayerStrumX8K[2], 2, 'sineInOut')
        noteTweenX('x3', 3, defaultPlayerStrumX8K[3], 2, 'sineInOut')
        noteTweenX('x5', 5, defaultPlayerStrumX8K[4], 2, 'sineInOut')
        noteTweenX('x6', 6, defaultPlayerStrumX8K[5], 2, 'sineInOut')
        noteTweenX('x7', 7, defaultPlayerStrumX8K[6], 2, 'sineInOut')
        noteTweenX('x8', 8, defaultPlayerStrumX8K[7], 2, 'sineInOut')
        noteTweenX('x9', 9, defaultPlayerStrumX8K[0], 2, 'sineInOut')
        noteTweenX('x10', 10, defaultPlayerStrumX8K[1], 2, 'sineInOut')
        noteTweenX('x11', 11, defaultPlayerStrumX8K[2], 2, 'sineInOut')
        noteTweenX('x12', 12, defaultPlayerStrumX8K[3], 2, 'sineInOut')
        noteTweenX('x14', 14, defaultPlayerStrumX8K[4], 2, 'sineInOut')
        noteTweenX('x15', 15, defaultPlayerStrumX8K[5], 2, 'sineInOut')
        noteTweenX('x16', 16, defaultPlayerStrumX8K[6], 2, 'sineInOut')
        noteTweenX('x17', 17, defaultPlayerStrumX8K[7], 2, 'sineInOut')
        runTimer('backAndForth2', 2, 1)
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

function noteMiss(membersIndex, noteData, noteType, isSustainNote)
end