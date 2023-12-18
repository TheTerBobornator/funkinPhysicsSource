--DROP THIS IN THE SCRIPTS FOLDER IF YOU WANT TO USE THE GRENADES ELSEWHERE
function noteMiss(id, direction, noteType, isSustainNote)
	triggerEvent('Play Animation', 'Tbag', 'dad')
	if noteType == 'Grenade' then
		for i=0,7 do
			noteTweenX('notetweenX'..i, i, getRandomInt(100, 1100), 0.5, 'bounceOut')
			noteTweenY('notetweenY'..i, i, getRandomInt(0, 300), 0.5, 'bounceOut')
		end
		triggerEvent('Play Animation', 'hurt', 'boyfriend')
		triggerEvent('Screen Flash', '0.5', '0.5')
		runTimer('noteReset', 5, 1)
	end
end

function onTimerCompleted(timer)
	if timer == 'noteReset' then
		for i=0,3 do
			noteTweenX('defaultNotetweenX'..i, i, _G['defaultOpponentStrumX'..i], 0.8, 'bounceOut')
			noteTweenY('defaultNotetweenY'..i, i, _G['defaultOpponentStrumY'..i], 0.8, 'bounceOut')
			noteTweenX('defaultNotetweenX'..i + 4, i + 4, _G['defaultPlayerStrumX0'..i], 0.8, 'bounceOut')
			noteTweenY('defaultNotetweenY'..i + 4, i + 4, _G['defaultPlayerStrumY0'..i], 0.8, 'bounceOut')
		end
	end
end