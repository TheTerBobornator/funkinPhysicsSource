--script by BCTIX
--im still new to lua and was in a rush to make this work so sorry if this upsets anyone!
--ill probably make my own version of this later

-- ez settings lol

local centerMod = 1

 local xOffset = 0
 local yOffset = 80

 local size = 40

 local setColor = 'ffffff'
 local sungColor = 'ff7800'

 local font = 'impact.otf'

 local autoMode = false

 local curLine = 1

 local lyrics = {}

local function formattosongpath(song) -- formats name to song file "Hello World" -> "hello-world"
	local i = string.gsub(song, "%s", "-")
	i = string.lower(i)
	return i
end

local function magiclines( str ) --seperates the lines
    local pos = 1;
    return function()
        if not pos then return nil end
        local  p1, p2 = string.find( str, "\r?\n", pos )
        local line
        if p1 then
            line = str:sub( pos, p1 - 1 )
            pos = p2 + 1
        else
            line = str:sub( pos )
            pos = nil
        end
        return line
    end
end

local function loadLyrics() --this function gets the lyrics file
	local daLyrics = getTextFromFile('data/'..formattosongpath(songName)..'/lyrics.txt', false);

	for line in magiclines( daLyrics ) do
		table.insert(lyrics,line)
	end
end

function onCreate()

	makeLuaText('setlyric','',5000,screenWidth/2 + xOffset,screenHeight/2 + yOffset);
	setTextSize('setlyric',size);
	setTextAlignment('setlyric','left'); 
	setTextColor('setlyric', setColor)
	setObjectCamera('setlyric', 'hud')
	setTextFont('setlyric', font)
	addLuaText('setlyric');

	makeLuaText('sunglyric','',5000,screenWidth/2 +  xOffset,screenHeight/2 + yOffset);
	setTextSize('sunglyric',size);
	setTextAlignment('sunglyric','left');
	setTextColor('sunglyric', sungColor)
	setObjectCamera('sunglyric', 'hud')
	setTextFont('sunglyric', font)
	addLuaText('sunglyric');
end

function onUpdate()
setProperty('sunglyric.x', getProperty('setlyric.x')) -- make sure sung text is always ontop of set text
end

local seperatedLyrics = {}

local karaokeLine = {}

local curWord = 1

function onEvent(name, value1, value2)
	if name == 'lyrics' then
		if value1 == 'setcolor' then
			setTextColor('setlyric', value2)
		elseif value1 == 'sungcolor' then
			setTextColor('sunglyric', value2)
		end
		if autoMode then
			if value1 == 'hide' then
				setProperty('setlyric.x', screenWidth/2-(#value2*11*centerMod)+ xOffset) --attempt to emulate center alignment
				setTextString('setlyric', '')
			elseif value1 == 'force' then
				setProperty('setlyric.x', screenWidth/2-(#value2*11*centerMod)+ xOffset) --attempt to emulate center alignment
				setTextString('setlyric', value2)
			elseif value1 == 'karaokeauto' then
				
				table.insert(karaokeLine, seperatedLyrics[curWord])
				local combinedString = table.concat(karaokeLine, " ")
				setTextString('sunglyric', combinedString)
				curWord = curWord + 1

			elseif value == "manualMode" then
				autoMode = false
			else
				seperatedLyrics = {}
				karaokeLine = {}
				for k in pairs (seperatedLyrics) do
					seperatedLyrics [k] = nil
				end

				for word in lyrics[curLine]:gmatch("%w+") do table.insert(seperatedLyrics, word) end

				setTextString('sunglyric', '')
				setProperty('setlyric.x', screenWidth/2-(#lyrics[curLine]*11*centerMod)+ xOffset) --attempt to emulate center alignment
				setTextString('setlyric', lyrics[curLine])
				curLine = curLine + 1
				curWord = 1
				
			end
		else
			if value1 == 'set' or value1 == '' then
				setProperty('setlyric.x', screenWidth/2-(#value2*11*centerMod)+ xOffset) --attempt to emulate center alignment
				setTextString('setlyric', value2)
				setTextString('sunglyric', '')
				
			end
			if value1 == 'autoload' then
				loadLyrics()
				autoMode = true
			end
			if value1 == 'sung' then
				setTextString('sunglyric', value2)
			end
		end
	end
end