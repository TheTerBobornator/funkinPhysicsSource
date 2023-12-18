function onCreatePost()
    setProperty('healthBar.flipX', true)
end

function onUpdate()
    if getProperty('health') <= 2.0 and curStep < 1152 then
        setProperty('boyfriend.x', getProperty('BF_X') + (getProperty('health') * 800))
    end

    if curBeat < 231 and curBeat ~= 222 and curBeat ~= 223 then
        if (mustHitSection) then
            cameraSetTarget('boyfriend')
        else
            cameraSetTarget('dad')
        end
    end

    local currentBeat = (getSongPosition()/5000)*(curBpm/60)
    doTweenY('opponentmove', 'dad', 100 + 50*math.sin((currentBeat+12)*math.pi), 0.1)
end

function onUpdatePost()
	--big thanks to user Unholywanderer04 on gamebanana for the flip healthbar script! (a lot of this is tidbits of that)
	
    P1Mult = getProperty('healthBar.x') + ((getProperty('healthBar.width') * getProperty('healthBar.percent') * 0.01) + (150 * getProperty('iconP1.scale.x')) / 2 - 26)

    setProperty('iconP1.x', P1Mult - 110)

    setProperty('iconP2.x', getProperty('healthBar.x') - 75)
end