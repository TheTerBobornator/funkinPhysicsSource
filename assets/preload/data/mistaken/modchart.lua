local normal = false

local weee = false

local bopping = false
local bopping2 = false

local x4,x5,x6,x7,y4,y5,y6,y7

function update (elapsed)
local currentBeat = (songPos / 1000)*(bpm/60)
    if weee then
        for i=0,7 do
            setActorX(_G['defaultStrum'..i..'X'] + 32 * math.sin((currentBeat + i*7)), i)
            setActorY(_G['defaultStrum'..i..'Y'],i)
        end
        camHudAngle = 10 * math.sin(currentBeat * 0.5)
        cameraAngle = 10 * math.sin(currentBeat * 0.5)
    end
end



function beatHit (beat)
	if bopping then
		setCamZoom(1)
	end
    if bopping2 then
		setHudZoom(1.25)
	end
end




function stepHit (step)
    if step == 1 then
        changeDadCharacter("trolling2e")
        changeDadCharacter("trolling2")
    end
	if step == 512 then
		weee = true
        bopping = true
    end
    if step == 1152 then
        bopping2 = true
        bopping = false
        changeDadCharacter("trolling2e")
    end
    if step == 1472 then
        bopping2 = false
        tweenFadeOut('camHUD',0,2)
        tweenFadeOut('camNotes',0,2)
        tweenFadeOut('camSustains',0,2)
    end
end



function playerTwoTurn()
    tweenZoom(camGame,1.3,0.1)
end

function playerOneTurn()
    tweenZoom(camGame,0.90,0.1)
end
