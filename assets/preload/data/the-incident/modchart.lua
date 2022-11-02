local normal = false

local shet = false
local OHFUCK = false
local normal1 = false
local cok = false

local bopping = false
local bopping2 = false


function update (elapsed)
local currentBeat = (songPos / 1000)*(bpm/60)
    for i=0,7 do
        setActorAngle(getActorAngle(i) + 1, i)
    end

    if shet then
        for i=0,7 do
        setActorX(_G['defaultStrum'..i..'X'] + 32 * math.sin((currentBeat + i*7)), i)
        setActorY(_G['defaultStrum'..i..'Y'] + 32 * math.cos((currentBeat + i*0.25) * math.pi), i)
        end
    end
    if normal1 then
		for i=0,7 do
			setActorX(_G['defaultStrum'..i..'X'], i)
			setActorY(_G['defaultStrum'..i..'Y'], i)
		end
	end
    if OHFUCK then
        for i=0,7 do
        setActorX(_G['defaultStrum'..i..'X'] + 32 * math.sin((currentBeat + i*7)), i)
        setActorY(_G['defaultStrum'..i..'Y'] + 32 * math.cos((currentBeat + i*0.25) * math.pi), i)
        end
        camHudAngle = 20 * math.sin(currentBeat * 0.5)
        cameraAngle = -20 * math.sin(currentBeat * 0.5)
    end
end

function beatHit (beat)
	if bopping then
		setCamZoom(1)
	end
    if bopping2 then
        setCamZoom(1)
	end
end

function stepHit (step)
	if step == 416 then
		bopping = true
        shet = true
    end
    if step == 672 then
        OHFUCK = true
        shet = false
    end
    if step == 800 then
        OHFUCK = false
        normal1 = true
    end
    if step == 832 then
        OHFUCK = true
        normal1 = false
    end
    if step == 864 then
        OHFUCK = false
        normal1 = true
    end
    if step == 896 then
        OHFUCK = true
        normal1 = false
    end
    if step == 1056 then
        bopping2 = true
        bopping = false
        for i=0,7 do
			tweenFadeOut(i,0,0.6)
		end
    end
    if step == 1106 then
        for i=4,7 do
			tweenFadeIn(i,1,0.6)
		end
    end
    if step == 1376 then
        for i=0,3 do
			tweenFadeIn(i,1,0.6)
		end
        cockusballus = false
        OHFUCK = true 
    end
    if step == 1696 then
        OHFUCK = false
        bopping2 = false
        normal1 = true
    end
end


function playerTwoTurn()
    tweenZoom(camGame,1.3,0.1)
end

function playerOneTurn()
    tweenZoom(camGame,0.85,0.1)
end
