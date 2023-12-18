local trollfaceSinging = false;

function onCreatePost()
	for i=0,3 do
		setPropertyFromGroup('opponentStrums', i, 'x', _G['defaultPlayerStrumX'..i])
		setPropertyFromGroup('playerStrums', i, 'x', _G['defaultOpponentStrumX'..i])
	end

    setProperty('gf.alpha', 0.00001)
end
function onUpdatePost()

	--big thanks to user Unholywanderer04 on gamebanana for the flip healthbar script!
	
    if trollfaceSinging == false then
        setProperty('iconP1.flipX',true)
        setProperty('iconP2.flipX',true)
        setProperty('healthBar.flipX',true)

        P1Mult = getProperty('healthBar.x') + ((getProperty('healthBar.width') * getProperty('healthBar.percent') * 0.01) + (150 * getProperty('iconP1.scale.x') - 150) / 2 - 26)

        P2Mult = getProperty('healthBar.x') + ((getProperty('healthBar.width') * getProperty('healthBar.percent') * 0.01) - (150 * getProperty('iconP2.scale.x')) / 2 - 26 * 2)

        setProperty('iconP1.x',P1Mult - 110)

        setProperty('iconP1.origin.x',240)

        setProperty('iconP2.x',P2Mult + 110)

        setProperty('iconP2.origin.x',-100)
    else
        setProperty('iconP1.flipX',false)
        setProperty('iconP2.flipX',false)
        setProperty('healthBar.flipX',false)
    end

end
function onBeatHit()
    if (curBeat >= 64 and curBeat < 128) or (curBeat >= 228 and curBeat < 260) or (curBeat >= 324 and curBeat < 392) or (curBeat >= 460 and curBeat < 556) then
        triggerEvent('Add Camera Zoom')
    end
    if curBeat >= 396 and curBeat <= 424 and curBeat % 4 == 0 then
        setProperty('defaultCamZoom', getProperty('defaultCamZoom') + 0.05)
        doTweenAlpha('trollfaceAppear', 'gf', getProperty('gf.alpha') + 1 / 8, 0.8)
    end

    if curBeat == 456 then
        for i=0,3 do
            noteTweenAlpha('noteTweenAlpha'..i, i, 0, 1, 'quadInOut')
        end
    end

    if curBeat == 396 or curBeat == 460 or curBeat == 524 or curBeat == 604 or curBeat == 628 then
        triggerEvent('Change Character', 'Dad', 'lore-limc-right')
        if curBeat == 460 or curBeat == 524 or curBeat == 604 then
            trollfaceSinging = true
            triggerEvent('Change Icon', 'player', 'lore-trollface')
            for i=0,3 do
                noteTweenX('noteTweenTrollface'..i, i + 4, _G['defaultPlayerStrumX'..i], 1, 'bounceOut')
            end
        end
    end
    if curBeat == 444 or curBeat == 508 or curBeat == 588 or curBeat == 620 then
        triggerEvent('Change Character', 'Dad', 'lore-limc-left')
        if curBeat == 508 or curBeat == 588 then
            trollfaceSinging = false
            triggerEvent('Change Icon', 'player', 'lore-trollge')
            for i=0,3 do
                noteTweenX('noteTweenTrollge'..i, i + 4, _G['defaultOpponentStrumX'..i], 1, 'bounceOut')
            end
        end
    end
end

function onUpdate()
    if epicCoolCameraShit == false then
        if mustHitSection then
            setProperty('defaultCamZoom', 0.9)
        else
            setProperty('defaultCamZoom', 0.7)
        end
    end
end