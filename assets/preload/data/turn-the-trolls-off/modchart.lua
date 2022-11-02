local normal = false

local weee = false
local funi = false
local cummywummy = false
local normal1 = false







function update (elapsed)
local currentBeat = (songPos / 1000)*(bpm/60)
    if funi then
        for i=0,13 do
            setActorX(_G['defaultStrum'..i..'X'] + 32 * math.sin((currentBeat)), i)
            setActorY(_G['defaultStrum'..i..'Y'],i)
        end
    end
    if cummywummy then
        for i=0,13 do
            setActorX(_G['defaultStrum'..i..'X'] + 50 * math.sin((currentBeat + i*37)), i)
            setActorY(_G['defaultStrum'..i..'Y'] + 32 * math.sin((currentBeat + i*4)), i)
        end
    end
    if weee then
        for i=0,13 do
            setActorX(_G['defaultStrum'..i..'X'] + 32 * math.sin((currentBeat + i*7)), i)
            setActorY(_G['defaultStrum'..i..'Y'],i)
        end
        camHudAngle = 10 * math.sin(currentBeat * 0.5)
        cameraAngle = 10 * math.sin(currentBeat * 0.5)
    end
    if normal1 then
        for i=0,13 do
            setActorX(_G['defaultStrum'..i..'X'], i)
            setActorY(_G['defaultStrum'..i..'Y'],i)
        end
    end
end

function stepHit (step)
    if step == 1 then
        changeDadCharacter("trolling2")
        changeDadCharacter("trolling2e")
        changeDadCharacter("trolling3")
        changeDadCharacter("phase8")
        changeDadCharacter("trolling")
    end
	if step == 304 then
        funi = true
    end
    if step == 560 then
        funi = false
        changeDadCharacter("trolling2")
    end
    if step == 816 then
        weee = true
        changeDadCharacter("trolling2e")
    end
    if step == 1072 then
        changeDadCharacter("trolling3")
        weee = false
        normal1 = true
        camHudAngle = 0
        cameraAngle = 0
    end
    if step == 1712 then
        cummywummy = true
        changeDadCharacter("phase8")
        normal1 = false
    end
    if step == 2064 then
        cummywummy = false
        normal1 = true
    end
end

