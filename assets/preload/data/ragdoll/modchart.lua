function onBeatHit()
   if curBeat == 32 or curBeat == 128 then
      setProperty('boyfriend.cameraPosition[0]', getProperty('boyfriend.cameraPosition[0]') + 200)
      setProperty('dad.cameraPosition[0]', getProperty('dad.cameraPosition[0]') + 200)
   end
   if curBeat == 96 then
      setProperty('boyfriend.cameraPosition[0]', getProperty('boyfriend.cameraPosition[0]') - 200)
      setProperty('dad.cameraPosition[0]', getProperty('dad.cameraPosition[0]') - 200)
      cameraFlash('camGame', '0x000000', 2, true)
   end
end