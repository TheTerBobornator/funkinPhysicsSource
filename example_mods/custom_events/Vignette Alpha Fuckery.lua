function onEvent(name, value1, value2)
	if name == "Vignette Alpha Fuckery" then
		alpha = tonumber(value1)
		duration = tonumber(value2)
		doTweenAlpha('my asshole burns', 'vignette', alpha, duration, 'quadInOut')
	end
end