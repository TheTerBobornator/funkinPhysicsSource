local bfOriginX = 0
local bfOriginY = 0
local bfOriginWidth = 0
function onCreate()
    setProperty('skipCredit', true)
    setProperty('camZooming', true)
    setProperty('camZoomingMult', 0)
    setProperty('camZoomingDecay', 0.25)
    setProperty('gfSpeed', 2)
    setProperty('cameraSpeed', 100)

    makeLuaSprite("opening1", "", 0, 0)
    makeGraphic("opening1", screenWidth, screenHeight / 2, "0xFF000000")
    addLuaSprite("opening1", false)
    setProperty("opening1.alpha", 0.9999)
    setObjectCamera('opening1', 'HUD')
    makeLuaSprite("opening2", "", 0, screenHeight / 2)
    makeGraphic("opening2", screenWidth, screenHeight / 2, "0xFF000000")
    addLuaSprite("opening2", false)
    setProperty("opening2.alpha", 0.9999)
    setObjectCamera('opening2', 'HUD')

    makeLuaSprite("cover", "", 0, 0)
    makeGraphic("cover", screenWidth, screenHeight, "0xFF000000")
    addLuaSprite("cover", false)
    setProperty("cover.alpha", 0)
    setObjectCamera('cover', 'HUD')
end

function onCreatePost()    
    bfOriginX = getCharacterX('boyfriend')
    bfOriginY = getCharacterY('boyfriend')
    bfOriginWidth = getProperty('boyfriend.width')
end

local angleshit = 1;
local anglevar = 1;

function onBeatHit()
    if (curBeat >= 100 and curBeat < 128) or (curBeat >= 132 and curBeat < 164) or (curBeat >= 264 and curBeat < 330) or (curBeat >= 392 and curBeat < 420) or (curBeat >= 648 and curBeat < 712) then
        triggerEvent('Add Camera Zoom') 
    end
    if (curBeat >= 164 and curBeat < 196) or (curBeat >= 424 and curBeat < 440) or (curBeat >= 445 and curBeat < 454) or (curBeat >= 456 and curBeat < 472) or (curBeat >= 477 and curBeat < 484) then
        triggerEvent('Add Camera Zoom', '0.03', '0.06') 
    end
    if (curBeat >= 228 and curBeat < 260) and curBeat % 2 == 0 then
        ytpBFHell()
    end
    if curBeat >= 520 and curBeat < 648 then   
		if curBeat % 2 == 0 then
			angleshit = anglevar;
		else
			angleshit = -anglevar;
		end
		setProperty('camHUD.angle',angleshit*3)
		doTweenAngle('turn', 'camHUD', angleshit, stepCrochet*0.002, 'circOut')
		--doTweenX('tuin', 'camHUD', -angleshit*8, crochet*0.001, 'linear')
	end
    
    if curBeat == 1 then
        doTweenY('opening1Out', 'opening1', -screenHeight / 2, 0.5, 'quadOut')
        doTweenY('opening2Out', 'opening2', screenHeight, 0.5, 'quadOut')
        setProperty('cameraSpeed', 1) --lel
    end
    if curBeat == 68 then
        setProperty('camZoomingMult', 1)
        setProperty('camZoomingDecay', 1)
        setProperty('gfSpeed', 1)
    end
    if curBeat == 196 or curBeat == 648 then
        cameraFlash('game', '0xFF000000', 1)
    end
    if curBeat == 224 then
        for i=0,3 do
			noteTweenAlpha('noteFade'..i, i, 0, 0.7, 'linear')
            noteTweenX('centerSlide'..i, i + 4, (-228 + (160 * getPropertyFromClass('Note', 'swagWidth') * i) + (screenWidth / 2)), 1.4, 'linear')
		end
    end
    if curBeat == 228 then
        setProperty('camZoomingMult', 0)
        setProperty('camZoomingDecay', 0.75)
        setProperty('cameraSpeed', 100)
        setProperty('camGame.zoom', 0.35)
        setObjectCamera('boyfriend', 'other')
        setObjectCamera('bfGhost', 'other')
    end
    if curBeat == 260 then
        setProperty('camZoomingMult', 1)
        setProperty('camZoomingDecay', 1)
    end
    if curBeat == 262 then
        setProperty('boyfriend.flipX', false)
        setProperty('boyfriend.flipY', false)
        screenCenter('boyfriend', 'x')
        setCharacterY('boyfriend', screenHeight)
        doTweenY('bfBounceMiddle', 'boyfriend', (screenHeight / 2) - (getProperty('boyfriend.height') / 2), 0.5, 'elasticOut')
    end
    if curBeat == 263 then
        setGraphicSize('boyfriend', getProperty('boyfriend.width') * 2)
    end
    if curBeat == 264 then
        setProperty('cameraSpeed', 1)
        setObjectCamera('boyfriend', 'game')
        setObjectCamera('bfGhost', 'game')
        setCharacterX('boyfriend', bfOriginX)
        setCharacterY('boyfriend', bfOriginY)
        setGraphicSize('boyfriend', bfOriginWidth)
        setProperty('malleo.alpha', 1)
        for i=0,3 do
            setPropertyFromGroup('opponentStrums', i, 'alpha', 1)
            setPropertyFromGroup('playerStrums', i, 'x', _G['defaultPlayerStrumX'..i])
            setPropertyFromGroup('weegeeGroup', i, 'alpha', 1)
            setPropertyFromGroup('weegeeGroup', i + 3, 'alpha', 1)
        end
    end
    if curBeat == 344 then
        setProperty('camZoomingMult', 0)
        doTweenZoom('zoomIn', 'camGame', 1.2, 5.75, '')
    end
    if curBeat == 356 then
        for i=0,3 do
			setPropertyFromGroup('opponentStrums', i, 'alpha', 0)
            setPropertyFromGroup('playerStrums', i, 'x', (-228 + (160 * getPropertyFromClass('Note', 'swagWidth') * i) + (screenWidth / 2)))
		end
        setProperty('bubbles.alpha', 1)
        playAnim('bubbles', 'bubbles')
        
        setProperty('opening1.y', 0)
        setProperty('opening2.y', screenHeight / 2)
        doTweenAlpha('opening1ReuseOn', 'opening1', 1, 2.44, 'linear')
        doTweenAlpha('opening2ReuseOn', 'opening2', 1, 2.44, 'linear')
    end
    if curBeat == 360 then 
        setProperty('camZoomingDecay', 0.075)
        setProperty('cameraSpeed', 100)

        setProperty('shipParticles.emitting', true)
        setProperty('gf.visible', false)
        setScrollFactor('dad', 0.8, 0.8)
        setScrollFactor('dadGhost', 0.8, 0.8)
        setProperty('bgShip.alpha', 1)
        setProperty('bgShipGreen.alpha', 1)
        setProperty('ship.alpha', 1)
        setProperty('barrels.alpha', 1)
        setProperty('rope.alpha', 1)
        doTweenAlpha('opening1ReuseOff', 'opening1', 0, 10, 'linear')
        doTweenAlpha('opening2ReuseOff', 'opening2', 0, 10, 'linear')
        
		setProperty('omegaWeegeeLightBig.x', getProperty('dad.x') -62)
		setProperty('omegaWeegeeLightBig.y', getProperty('dad.y') -84)
		setProperty('omegaWeegeeLightSmall.x', getProperty('dad.x') -14)
		setProperty('omegaWeegeeLightSmall.y', getProperty('dad.y') -68)
		setProperty('omegaWeegeeFaces.x', getProperty('dad.x') + 508)
		setProperty('omegaWeegeeFaces.y', getProperty('dad.y') + 50)
        setProperty('omegaWeegeeFaces.alpha', 1)
        setProperty('bubbles.alpha', 0.00001)
    end
    if curBeat == 364 then
        setProperty('cameraSpeed', 1)
    end
    if curBeat == 392 then
        setProperty('camZoomingMult', 1)
        setProperty('camZoomingDecay', 1)
    end
    if curBeat == 488 then
        setProperty('camZoomingMult', 0)
    end
    if curBeat == 505 then
        for i=0,3 do
            setPropertyFromGroup('opponentStrums', i, 'alpha', 1)
            setPropertyFromGroup('playerStrums', i, 'x', _G['defaultPlayerStrumX'..i])
        end
    end
    if curBeat == 520 then
        setCharacterX('boyfriend', getProperty('boyfriend.x') + 250)
        setCharacterY('boyfriend', getProperty('boyfriend.y') - 380)
        setProperty('camZoomingMult', 1)
    end
    if curBeat == 648 then
		setProperty('camHUD.angle', 0)
	end
end

function onStepHit()
    if curStep == 2038 then
        doTweenZoom('guiyiiLaugh', 'camGame', 1, 3.75, 'linear')
    end
end

function onUpdate(elapsed)
    local currentBeat = (getSongPosition()/5000)*(curBpm/60)
    if curBeat >= 360 then
        setProperty('bgShipGreen.alpha', math.sin((currentBeat+12)*math.pi))
        setProperty('omegaWeegeeLightBig.alpha', (math.sin((currentBeat+20)*math.pi) + 2.5) / 3)
        setProperty('omegaWeegeeLightSmall.alpha', (math.sin((currentBeat-20)*math.pi) + 2.5) / 3)
    end
    if curBeat >= 392 and curBeat < 488 then
        if mustHitSection then
            setProperty('defaultCamZoom', 0.6)
        else
            setProperty('defaultCamZoom', 0.4)
        end
    end
    runHaxeCode([[
        for (i in 0...6)
		{
            if (game.weegeeGroup.members[i].animation.curAnim.name != game.dad.animation.curAnim.name)
            {
                game.weegeeGroup.members[i].playAnim(game.dad.animation.curAnim.name, true);
            }
            //game.weegeeGroup.members[i].animation.curAnim.curFrame = game.dad.animation.curAnim.curFrame;

        }
    ]])
    if curBeat > 520 then
        if mustHitSection then
            setProperty('defaultCamZoom', 0.5)
        elseif gfSection then
            setProperty('defaultCamZoom', 0.5)
        else
            setProperty('defaultCamZoom', 0.4)
        end
    end
end

local curBFCornerPeek = 0
function ytpBFHell()
    --setCharacterX('boyfriend', getRandomInt(700, 2860 - getProperty('boyfriend.width')))
    --setCharacterY('boyfriend', getRandomInt(1100, 2140 - getProperty('boyfriend.height')))
    --setProperty('boyfriend.angle', getRandomInt(0, 360))
    if curBFCornerPeek == 0 then --bottom left
        setProperty('boyfriend.flipY', false)
        setProperty('boyfriend.flipX', true)
        setCharacterX('boyfriend', 0)
        setCharacterY('boyfriend', screenHeight)
        doTweenY('bfPeek0', 'boyfriend', screenHeight - getProperty('boyfriend.height'), 0.22, 'sineInOut')
    elseif curBFCornerPeek == 1 then --bottom right
        setProperty('boyfriend.flipY', false)
        setProperty('boyfriend.flipX', false)
        setCharacterX('boyfriend', screenWidth - getProperty('boyfriend.width'))
        setCharacterY('boyfriend', screenHeight)
        doTweenY('bfPeek1', 'boyfriend', screenHeight - getProperty('boyfriend.height'), 0.22, 'sineInOut')
    elseif curBFCornerPeek == 2 then --top right
        setProperty('boyfriend.flipY', true)
        setProperty('boyfriend.flipX', false)
        setCharacterX('boyfriend', screenWidth - getProperty('boyfriend.width'))
        setCharacterY('boyfriend', -getProperty('boyfriend.height'))
        doTweenY('bfPeek2', 'boyfriend', 0, 0.22, 'sineInOut')
    elseif curBFCornerPeek == 3 then --top left
        setProperty('boyfriend.flipY', true)
        setProperty('boyfriend.flipX', true)
        setCharacterX('boyfriend', 0)
        setCharacterY('boyfriend', -getProperty('boyfriend.height'))
        doTweenY('bfPeek3', 'boyfriend', 0, 0.22, 'sineInOut')
    end

    if curBFCornerPeek == 3 then
        curBFCornerPeek = 0
    else
        curBFCornerPeek = curBFCornerPeek + 1
    end
end

function onTweenCompleted(tag)
    if tag == 'bfPeek0' then
        doTweenY('bfPeekEnd', 'boyfriend', screenHeight, 0.46, 'sineInOut')
    end
    if tag == 'bfPeek1' then
        doTweenY('bfPeekEnd', 'boyfriend', screenHeight, 0.46, 'sineInOut')
    end
    if tag == 'bfPeek2' then
        doTweenY('bfPeekEnd', 'boyfriend', -getProperty('boyfriend.height'), 0.46, 'sineInOut')
    end
    if tag == 'bfPeek3' then
        doTweenY('bfPeekEnd', 'boyfriend', -getProperty('boyfriend.height'), 0.46, 'sineInOut')
    end
end