local randomTimerInt = 0.5

function onCreate()
    wackyTweens()
    runTimer('wacky', randomTimerInt, 1)
end

function onUpdatePost()
    setProperty('gf.angle', getProperty('gf.angle') + getRandomInt(0, 10))
    setProperty('amazed.angle', getProperty('amazed.angle') + getRandomInt(0, 10))
end

function onTimerCompleted()
    randomTimerInt = getRandomFloat(0.1, 1)
    wackyTweens()
    runTimer('wacky', randomTimerInt, 1)
end

function wackyTweens()
    doTweenX('gfPositionXLol', 'gf', getRandomInt(-690, 2060), randomTimerInt, 'bounceOut')
    doTweenY('gfPositionYLol', 'gf', getRandomInt(-390, 1110), randomTimerInt, 'bounceOut')
    doTweenX('amazedPositionXLol', 'amazed', getRandomInt(-690, 2060), randomTimerInt, 'bounceOut')
    doTweenY('amazedPositionYLol', 'amazed', getRandomInt(-390, 1110), randomTimerInt, 'bounceOut')
end

function noteMiss()
    runHaxeCode('game.createStupid();')
end