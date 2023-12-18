local angleshit = 1;
local anglevar = 1;

function onBeatHit()
	if (curBeat >= 32 and curBeat < 96) or (curBeat >= 224 and curBeat < 256) or (curBeat >= 416 and curBeat < 480) then
		if curBeat % 2 == 0 then
			for i=0,3 do
				--setPropertyFromGroup('opponentStrums', i, 'width', getProperty(_G['opponentStrums'..i], 'width') + 20)
				--setPropertyFromGroup('opponentStrums', i, 'height', getProperty(_G['opponentStrums'..i], 'height') - 20)
				--setPropertyFromGroup('playerStrums', i, 'width', getProperty(_G['playerStrums'..i], 'width') + 20)
				--setPropertyFromGroup('playerStrums', i, 'height', getProperty(_G['playerStrums'..i], 'height') - 20)
				if i % 2 == 0 then
					setPropertyFromGroup('opponentStrums', i, 'y', _G['defaultOpponentStrumY'..i] - 20)
					setPropertyFromGroup('playerStrums', i, 'y', _G['defaultPlayerStrumY'..i] + 20)
				else
					setPropertyFromGroup('opponentStrums', i, 'y', _G['defaultOpponentStrumY'..i] + 20)
					setPropertyFromGroup('playerStrums', i, 'y', _G['defaultPlayerStrumY'..i] - 20)
				end
			end
		else
			for i=0,3 do
				if i % 2 == 0 then
					setPropertyFromGroup('opponentStrums', i, 'y', _G['defaultOpponentStrumY'..i] + 20)
					setPropertyFromGroup('playerStrums', i, 'y', _G['defaultPlayerStrumY'..i] - 20)
				else
					setPropertyFromGroup('opponentStrums', i, 'y', _G['defaultOpponentStrumY'..i] - 20)
					setPropertyFromGroup('playerStrums', i, 'y', _G['defaultPlayerStrumY'..i] + 20)
				end
			end
		end
		returnNoteY()
	end

--	if curBeat < 388 then
--		triggerEvent('Add Camera Zoom', 0.04,0.05)
--
--		if curBeat % 2 == 0 then
--			angleshit = anglevar;
--		else
--			angleshit = -anglevar;
--		end
--		setProperty('camHUD.angle',angleshit*3)
--		setProperty('camGame.angle',angleshit*3)
--		doTweenAngle('turn', 'camHUD', angleshit, stepCrochet*0.002, 'circOut')
--		doTweenX('tuin', 'camHUD', -angleshit*8, crochet*0.001, 'linear')
--		doTweenAngle('tt', 'camGame', angleshit, stepCrochet*0.002, 'circOut')
--		doTweenX('ttrn', 'camGame', -angleshit*8, crochet*0.001, 'linear')
--	else
--		setProperty('camHUD.angle',0)
--		setProperty('camHUD.x',0)
--		setProperty('camHUD.x',0)
--	end

end

function onStepHit()
	if curBeat >= 416 and curBeat < 480 then
		if curStep % 4 == 0 then
			doTweenY('rrr', 'camHUD', -12, stepCrochet*0.002, 'circOut')
			doTweenY('rtr', 'camGame.scroll', 12, stepCrochet*0.002, 'sineIn')
		end
		if curStep % 4 == 2 then
			doTweenY('rir', 'camHUD', 0, stepCrochet*0.002, 'sineIn')
			doTweenY('ryr', 'camGame.scroll', 0, stepCrochet*0.002, 'sineIn')
		end
	end
end

function returnNoteY()
	noteTweenY('note0y', 0, defaultOpponentStrumY0, 0.5, 'bounceOut')
	noteTweenY('note1y', 1, defaultOpponentStrumY0, 0.5, 'bounceOut')
	noteTweenY('note2y', 2, defaultOpponentStrumY0, 0.5, 'bounceOut')
	noteTweenY('note3y', 3, defaultOpponentStrumY0, 0.5, 'bounceOut')
	noteTweenY('note4y', 4, defaultOpponentStrumY0, 0.5, 'bounceOut')
	noteTweenY('note5y', 5, defaultOpponentStrumY0, 0.5, 'bounceOut')
	noteTweenY('note6y', 6, defaultOpponentStrumY0, 0.5, 'bounceOut')
	noteTweenY('note7y', 7, defaultOpponentStrumY0, 0.5, 'bounceOut')
end