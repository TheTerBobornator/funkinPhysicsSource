function onEvent(name, value1, value2)
	if name == "Note Bump" then
		direction = value1
		strums = tonumber(value2)

		if direction == 'left' then
			if strums == 0 then
				for i=0,3 do
					setPropertyFromGroup('opponentStrums', i, 'x', _G['defaultOpponentStrumX'..i] - 40)
					setPropertyFromGroup('playerStrums', i, 'x', _G['defaultPlayerStrumX'..i] - 40)
				end
			elseif strums == 1 then
				for i=0,3 do
					setPropertyFromGroup('opponentStrums', i, 'x', _G['defaultOpponentStrumX'..i] - 40)
				end
			elseif strums == 2 then
				for i=0,3 do
					setPropertyFromGroup('playerStrums', i, 'x', _G['defaultPlayerStrumX'..i] - 40)
				end
			end
		elseif direction == 'down' then
			if strums == 0 then
				for i=0,3 do
					setPropertyFromGroup('opponentStrums', i, 'y', _G['defaultOpponentStrumY'..i] + 40)
					setPropertyFromGroup('playerStrums', i, 'y', _G['defaultPlayerStrumY'..i] + 40)
				end
			elseif strums == 1 then
				for i=0,3 do
					setPropertyFromGroup('opponentStrums', i, 'y', _G['defaultOpponentStrumY'..i] + 40)
				end
			elseif strums == 2 then
				for i=0,3 do
					setPropertyFromGroup('playerStrums', i, 'y', _G['defaultPlayerStrumY'..i] + 40)
				end
			end
		elseif direction == 'up' then
			if strums == 0 then
				for i=0,3 do
					setPropertyFromGroup('opponentStrums', i, 'y', _G['defaultOpponentStrumY'..i] - 40)
					setPropertyFromGroup('playerStrums', i, 'y', _G['defaultPlayerStrumY'..i] - 40)
				end
			elseif strums == 1 then
				for i=0,3 do
					setPropertyFromGroup('opponentStrums', i, 'y', _G['defaultOpponentStrumY'..i] - 40)
				end
			elseif strums == 2 then
				for i=0,3 do
					setPropertyFromGroup('playerStrums', i, 'y', _G['defaultPlayerStrumY'..i] - 40)
				end
			end
		elseif direction == 'right' then
			if strums == 0 then
				for i=0,3 do
					setPropertyFromGroup('opponentStrums', i, 'x', _G['defaultOpponentStrumX'..i] + 40)
					setPropertyFromGroup('playerStrums', i, 'x', _G['defaultPlayerStrumX'..i] + 40)
				end
			elseif strums == 1 then
				for i=0,3 do
					setPropertyFromGroup('opponentStrums', i, 'x', _G['defaultOpponentStrumX'..i] + 40)
				end
			elseif strums == 2 then
				for i=0,3 do
					setPropertyFromGroup('playerStrums', i, 'x', _G['defaultPlayerStrumX'..i] + 40)
				end
			end
		end

		returnNote()
	end
end

function returnNote()
	noteTweenY('note0y', 0, defaultOpponentStrumY0, 0.5, 'bounceOut')
	noteTweenY('note1y', 1, defaultOpponentStrumY1, 0.5, 'bounceOut')
	noteTweenY('note2y', 2, defaultOpponentStrumY2, 0.5, 'bounceOut')
	noteTweenY('note3y', 3, defaultOpponentStrumY3, 0.5, 'bounceOut')
	noteTweenY('note4y', 4, defaultPlayerStrumY0, 0.5, 'bounceOut')
	noteTweenY('note5y', 5, defaultPlayerStrumY1, 0.5, 'bounceOut')
	noteTweenY('note6y', 6, defaultPlayerStrumY2, 0.5, 'bounceOut')
	noteTweenY('note7y', 7, defaultPlayerStrumY3, 0.5, 'bounceOut')

	noteTweenX('note0x', 0, defaultOpponentStrumX0, 0.5, 'bounceOut')
	noteTweenX('note1x', 1, defaultOpponentStrumX1, 0.5, 'bounceOut')
	noteTweenX('note2x', 2, defaultOpponentStrumX2, 0.5, 'bounceOut')
	noteTweenX('note3x', 3, defaultOpponentStrumX3, 0.5, 'bounceOut')
	noteTweenX('note4x', 4, defaultPlayerStrumX0, 0.5, 'bounceOut')
	noteTweenX('note5x', 5, defaultPlayerStrumX1, 0.5, 'bounceOut')
	noteTweenX('note6x', 6, defaultPlayerStrumX2, 0.5, 'bounceOut')
	noteTweenX('note7x', 7, defaultPlayerStrumX3, 0.5, 'bounceOut')
end