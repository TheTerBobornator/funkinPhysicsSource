-- less rebuilt from the ground up
-- pretty much just copy pasted everything from 1.5 and tweaked it to work on psych, hence the stupid naming of variables (not that i dont do that myself with some things)
-- anyway i hate this modchart but idc because this is an old song and again, fo da fans

local noteSpin = 0;

local normal = false
local shet = false
local OHFUCK = false
local normal1 = false

function onUpdatePost(elapsed)
    -- probably one of the stupidest things ive done but it works,
    -- literally just increase the value as time passes and set the angle of the first 200 notes in the notes group
    -- setting angle/angularVelocity is a pain without setting the strum's angle also but i think this works, no more than 200 notes are onscreen at once ithink
    -- too lazy to bother finding a better way lole
    noteSpin = noteSpin + 1
    for i=0,200 do
        setPropertyFromGroup('notes', i, 'angle', noteSpin)
    end
end
function onUpdate(elapsed)
    local currentBeat = (getSongPosition()/1000)*(curBpm/60)
    if shet or OHFUCK then
        for i=0,3 do
            setPropertyFromGroup('opponentStrums', i, 'x', _G['defaultOpponentStrumX'..i] + 32 * math.sin(currentBeat + i*7))
            setPropertyFromGroup('playerStrums', i, 'x', _G['defaultPlayerStrumX'..i] + 32 * math.sin(currentBeat + (i+4)*7))
            setPropertyFromGroup('opponentStrums', i, 'y', _G['defaultOpponentStrumY'..i] + 32 * math.sin((currentBeat + i*0.25) * math.pi))
            setPropertyFromGroup('playerStrums', i, 'y', _G['defaultPlayerStrumY'..i] + 32 * math.sin((currentBeat + (i+4)*0.25) * math.pi))
        end
    end
    if normal1 then
		for i=0,7 do
            setPropertyFromGroup('opponentStrums', i, 'x', _G['defaultOpponentStrumX'..i])
            setPropertyFromGroup('playerStrums', i, 'x', _G['defaultPlayerStrumX'..i])
            setPropertyFromGroup('opponentStrums', i, 'y', _G['defaultOpponentStrumY'..i])
            setPropertyFromGroup('playerStrums', i, 'y', _G['defaultPlayerStrumY'..i])
		end
	end
    if OHFUCK then
        doTweenAngle('hudwweeeeww', 'camHUD', 20 * math.sin(currentBeat * 0.5), 0.1)
        doTweenAngle('gamewweeeeww', 'camGame', -20 * math.sin(currentBeat * 0.5), 0.1)
    end
end

function onBeatHit()
    if curBeat >= 104 and curBeat < 264 then
        setProperty('camGame.zoom', 1)
    end
    if curBeat >= 264 and curBeat < 392 then
        setProperty('camGame.zoom', 1.5)
        setProperty('camHUD.zoom', 1.25)
    end
    -- ew
    if curBeat == 104 then
        shet = true
    end
    if curBeat == 168 then
        OHFUCK = true
        shet = false
    end
    if curBeat == 200 then
        OHFUCK = false
        normal1 = true
    end
    if curBeat == 208 then
        OHFUCK = true
        normal1 = false
    end
    if curBeat == 216 then
        OHFUCK = false
        normal1 = true
    end
    if curBeat == 224 then
        OHFUCK = true
        normal1 = false
    end
    if curBeat == 264 then
        for i=0,7 do
            noteTweenAlpha('bye'..i, i, 0, 0.6)
		end
    end
    if curBeat == 276 then
        for i=4,7 do
            noteTweenAlpha('hello'..i, i, 1, 0.6)
		end
    end
    if curBeat == 344 then
        for i=0,3 do
			noteTweenAlpha('hello'..i, i, 1, 0.6)
		end
        OHFUCK = true 
    end
    if curBeat == 392 then
        OHFUCK = false
        normal1 = true
        doTweenAngle('hudReturn', 'camHUD', 0, 1)
        doTweenAngle('gameReturn', 'camGame', 0, 1)
        doTweenAlpha('bfLeave', 'boyfriend', 0, 1)
        doTweenAlpha('gfLeave', 'gf', 0, 1)

        makeLuaSprite("funnyWhite", "", -600, -220)
        makeGraphic("funnyWhite", 3000, 2000, "0xFFFFFFFF")
        setProperty("funnyWhite.alpha", 0)
        addLuaSprite("funnyWhite", false)
        doTweenAlpha("fadeIn", "funnyWhite", 1, 1)
    end
end