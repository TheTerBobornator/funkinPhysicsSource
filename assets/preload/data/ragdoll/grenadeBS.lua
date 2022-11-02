--DROP THIS IN THE SCRIPTS FOLDER IF YOU WANT TO USE THE GRENADES ELSEWHERE
function noteMiss(id, direction, noteType, isSustainNote)
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

function onTimerCompleted(noteReset)
	for i=0,3 do
		noteTweenX('defaultNotetweenX'..i, i, _G['defaultOpponentStrumX'..i], 0.8, 'bounceOut')
		noteTweenY('defaultNotetweenY'..i, i, _G['defaultOpponentStrumY'..i], 0.8, 'bounceOut')
	end

	-- probably a better way to do this with loops but idrc

	noteTweenX('defaultNotetweenX4', 4, defaultPlayerStrumX0, 0.8, 'bounceOut')
	noteTweenY('defaultNotetweenY4', 4, defaultPlayerStrumY0, 0.8, 'bounceOut')

	noteTweenX('defaultNotetweenX5', 5, defaultPlayerStrumX1, 0.8, 'bounceOut')
	noteTweenY('defaultNotetweenY5', 5, defaultPlayerStrumY1, 0.8, 'bounceOut')

	noteTweenX('defaultNotetweenX6', 6, defaultPlayerStrumX2, 0.8, 'bounceOut')
	noteTweenY('defaultNotetweenY6', 6, defaultPlayerStrumY2, 0.8, 'bounceOut')

	noteTweenX('defaultNotetweenX7', 7, defaultPlayerStrumX3, 0.8, 'bounceOut')
	noteTweenY('defaultNotetweenY7', 7, defaultPlayerStrumY3, 0.8, 'bounceOut')
	
end