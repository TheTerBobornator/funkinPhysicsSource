function onStepHit()
	if curStep == 384 then
		tween1()
	end

	if curStep == 640 then
		tween2()
	end

	if curStep == 768 then
		tween3()
	end

	if curStep == 896 then
		tween4()
	end

end

function tween1()
	noteTweenY('note0y', 0, 180, 2, 'bounceOut')
	noteTweenAngle('note0a', 0, -45, 2, 'bounceOut')

	noteTweenY('note3y', 3, 180, 2, 'bounceOut')
	noteTweenAngle('note3a', 3, 45, 2, 'bounceOut')

	noteTweenY('note4y', 4, 180, 2, 'bounceOut')
	noteTweenAngle('note4a', 4, -45, 2, 'bounceOut')

	noteTweenY('note7y', 7, 180, 2, 'bounceOut')
	noteTweenAngle('note7a', 7, 45, 2, 'bounceOut')
end

function tween2()
	noteTweenAngle('note0a', 0, 0, 2, 'bounceOut')
	noteTweenX('note0x', 0, defaultOpponentStrumX2, 2, 'bounceOut')
	noteTweenY('note0y', 0, defaultOpponentStrumY2, 2, 'bounceOut')

	noteTweenX('note1x', 1, defaultOpponentStrumX3, 2, 'bounceOut')

	noteTweenX('note2x', 2, defaultPlayerStrumX0, 2, 'bounceOut')

	noteTweenAngle('note3a', 3, 0, 2, 'bounceOut')
	noteTweenX('note3x', 3, defaultPlayerStrumX1, 2, 'bounceOut')
	noteTweenY('note3y', 3, defaultPlayerStrumY1, 2, 'bounceOut')

	noteTweenAngle('note4a', 4, 0, 2, 'bounceOut')
	noteTweenX('note4x', 4, defaultOpponentStrumX0, 2, 'bounceOut')
	noteTweenY('note4y', 4, defaultOpponentStrumY0, 2, 'bounceOut')

	noteTweenX('note5x', 5, defaultOpponentStrumX1, 2, 'bounceOut')

	noteTweenX('note6x', 6, defaultPlayerStrumX2, 2, 'bounceOut')

	noteTweenAngle('note7a', 7, 0, 2, 'bounceOut')
	noteTweenX('note7x', 7, defaultPlayerStrumX3, 2, 'bounceOut')
	noteTweenY('note7y', 7, defaultPlayerStrumY3, 2, 'bounceOut')
end

function tween3()
	noteTweenX('note0x', 0, defaultOpponentStrumX0, 2, 'bounceOut')

	noteTweenX('note1x', 1, defaultOpponentStrumX1, 2, 'bounceOut')

	noteTweenX('note2x', 2, defaultPlayerStrumX2, 2, 'bounceOut')

	noteTweenX('note3x', 3, defaultPlayerStrumX3, 2, 'bounceOut')

	noteTweenX('note4x', 4, defaultOpponentStrumX2, 2, 'bounceOut')

	noteTweenX('note5x', 5, defaultOpponentStrumX3, 2, 'bounceOut')

	noteTweenX('note6x', 6, defaultPlayerStrumX0, 2, 'bounceOut')

	noteTweenX('note7x', 7, defaultPlayerStrumX1, 2, 'bounceOut')
end

function tween4()
	noteTweenX('note0x', 0, defaultOpponentStrumX2, 2, 'bounceOut')
	noteTweenY('note0y', 0, 1000, 2, 'bounceOut')

	noteTweenX('note1x', 1, defaultOpponentStrumX3, 2, 'bounceOut')
	noteTweenY('note1y', 1, 1000, 2, 'bounceOut')

	noteTweenX('note2x', 2, defaultPlayerStrumX0, 2, 'bounceOut')
	noteTweenY('note2y', 2, 1000, 2, 'bounceOut')

	noteTweenX('note3x', 3, defaultPlayerStrumX1, 2, 'bounceOut')
	noteTweenY('note3y', 3, 1000, 2, 'bounceOut')

	noteTweenX('note4x', 4, defaultOpponentStrumX0, 2, 'bounceOut')

	noteTweenX('note7x', 7, defaultPlayerStrumX3, 2, 'bounceOut')
end