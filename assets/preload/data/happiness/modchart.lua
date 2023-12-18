function onCreate()
    setProperty('camGame.alpha', 0.00001)
    setProperty('camHUD.alpha', 0.00001)
    setProperty('skipCredit', true)
end

function onCreatePost()
	for i=0,3 do
		setPropertyFromGroup('opponentStrums', i, 'x', _G['defaultPlayerStrumX'..i])
		setPropertyFromGroup('playerStrums', i, 'x', _G['defaultOpponentStrumX'..i])
	end
    setProperty('iconP1.flipX',true)
    setProperty('iconP2.flipX',true)
    setProperty('healthBar.flipX',true)
    --650
    --500
    triggerEvent('Set Haxe Shader', 'game', 'ntsc')
end

function onUpdatePost()
	--big thanks to user Unholywanderer04 on gamebanana for the flip healthbar script!
	
    P1Mult = getProperty('healthBar.x') + ((getProperty('healthBar.width') * getProperty('healthBar.percent') * 0.01) + (150 * getProperty('iconP1.scale.x') - 150) / 2 - 26)

    P2Mult = getProperty('healthBar.x') + ((getProperty('healthBar.width') * getProperty('healthBar.percent') * 0.01) - (150 * getProperty('iconP2.scale.x')) / 2 - 26 * 2)

    setProperty('iconP1.x',P1Mult - 110)

    setProperty('iconP1.origin.x',240)

    setProperty('iconP2.x',P2Mult + 110)

    setProperty('iconP2.origin.x',-100)
end

function onBeatHit()
    if curBeat == 96 then
        setProperty('camZooming', true)
    end
    if curBeat == 432 then
        cameraFlash('game', '0xFF000000', 2, true)
        cameraFlash('hud', '0xFF000000', 2, true)
    end
end