function onEvent(name, value1, value2)
	if name == "Set Game Zoom" then
		zoom = tonumber(value1)
		setProperty('camGame.zoom', zoom)
	end
end