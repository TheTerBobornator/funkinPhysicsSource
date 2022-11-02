--snagged this from Funk's Justice, can't find a specific author of this script but credit to them
--im still new to lua and was in a rush to make this work so sorry if this upsets anyone!
--ill probably make my own version of this later
function onCreate()
	makeLuaSprite('bartop', nil, 0, -100);
	makeLuaSprite('barbot', nil, 0, 720);
	makeGraphic('bartop', screenWidth, 100, '000000');
	makeGraphic('barbot', screenWidth, 100, '000000');
	setObjectCamera('bartop', 'hud');
	setObjectCamera('barbot', 'hud');
	addLuaSprite('bartop', false);
	addLuaSprite('barbot', false);
	
	setProperty('bartop.y', 720);
	setProperty('barbot.y', -115);
	
	setProperty('bartop.visible', true);
	setProperty('barbot.visible', true);
end

function onEvent(name, value1, value2)
	if name == "Cinematic Bars" then
		whatsup = tonumber(value1)
		duration = tonumber(value2)
		if whatsup == 0 then
			setProperty('bartop.visible', false);
			setProperty('barbot.visible', false);
		elseif whatsup == 1 then
			setProperty('bartop.visible', true);
			setProperty('barbot.visible', true);
			doTweenY('b1', 'bartop', 620, duration, 'quadIn');
			doTweenY('b2', 'barbot', -15, duration, 'quadIn');
		elseif whatsup == 2 then
			setProperty('bartop.visible', true);
			setProperty('barbot.visible', true);
			doTweenY('b1', 'bartop', 720, duration, 'quadOut');
			doTweenY('b2', 'barbot', -115, duration, 'quadOut');
		end
	end
end