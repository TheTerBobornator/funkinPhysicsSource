function onBeatHit()
   if (curBeat >= 64 and curBeat < 96) or (curBeat >= 160 and curBeat < 192) or (curBeat >= 224 and curBeat < 256) or (curBeat >= 288 and curBeat < 384) then
      triggerEvent('Add Camera Zoom')
   end
   if (curBeat >= 128 and curBeat < 160) or (curBeat >= 192 and curBeat < 224) then
      for i=0,3 do
         if curBeat % 4 == 0 then
            noteTweenAngle('angle'..i, i, 360, 0.5, 'quadOut')
            noteTweenAngle('angle'..i + 4, i + 4, -360, 0.5, 'quadOut')
         end
         if curBeat % 4 == 2 then
            noteTweenAngle('angle'..i, i, 0, 0.5, 'quadOut')
            noteTweenAngle('angle'..i + 4, i + 4, 0, 0.5, 'quadOut')
         end
      end
   end
end