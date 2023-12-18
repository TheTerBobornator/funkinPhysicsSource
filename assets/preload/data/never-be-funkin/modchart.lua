function onCreate()
   setProperty('skipCredit', true)
   setProperty('camHUD.alpha', 0)
   setProperty('camGame.zoom', 1.2)
   makeLuaSprite("funnyBlack", "", -800, -400)
   makeGraphic("funnyBlack", 3000, 2000, "0xFF000000")
   addLuaSprite("funnyBlack", true)
end
function onSongStart()
   doTweenAlpha("shiiii", "funnyBlack", 0, 7, "quartIn")
   runHaxeCode("FlxTween.tween(FlxG.camera, {zoom: 0.8}, 7, {ease: FlxEase.quartIn, onComplete: defaultCamZoom = 0.8});")
end
function onBeatHit()
   if (curBeat >= 96 and curBeat < 108) or (curBeat >= 112 and curBeat < 130) or (curBeat >= 196 and curBeat < 224) or (curBeat >= 256 and curBeat < 264) then
      triggerEvent("Add Camera Zoom")
   end
   if (curBeat >= 130 and curBeat < 140) then
      triggerEvent("Add Camera Zoom", '0')
   end
   if curBeat == 51 or curBeat == 78 then
      setProperty('cameraSpeed', '2')
   end
   if curBeat == 52 or curBeat == 79 then
      setProperty('cameraSpeed', '1')
   end
   if curBeat == 108 then
      setProperty('camGame.zoom', 1.2)
      setProperty('cameraSpeed', '100')
   end
   if curBeat == 112 then
      setProperty('camGame.zoom', 0.7)
      setProperty('cameraSpeed', '1')
   end
   if curBeat == 130 then
      setProperty('camZoomingMult', 0)
      runHaxeCode("FlxTween.tween(FlxG.camera, {zoom: 0.8}, 6);")
   end
   if curBeat == 145 then
      setProperty('camHUD.alpha', 0)
      setProperty('camGame.zoom', 1.2)
      setProperty('defaultCamZoom', 1.2)
      setProperty('funnyBlack.alpha', 1)
      setProperty('camZooming', false)
      setProperty('camZoomingMult', 1)
   end
   if curBeat == 148 then
      setProperty('defaultCamZoom', 0.8)
      doTweenAlpha("shiiii", "funnyBlack", 0, 7, "quartIn")
      runHaxeCode("FlxTween.tween(FlxG.camera, {zoom: 0.8}, 7, {ease: FlxEase.quartIn});")
   end
   if curBeat == 232 then
      cameraFlash('game', '0xFF000000', 1, true)
   end
   if curBeat == 233 then
      setProperty('cameraSpeed', '2')
   end
end
function onStepHit()
   if curStep == 188 or curStep == 190 or curStep == 191 or curStep == 719 or curStep == 716 or curStep == 718 
   or curStep == 844 or curStep == 846 or curStep == 847 or curStep == 908 or curStep == 910 or curStep == 911 then
      noteMove()
   end
   if curStep == 192 or curStep == 720 or curStep == 848 or curStep == 912 then
      for i=0,3 do
         setPropertyFromGroup('opponentStrums', i, 'y', _G['defaultOpponentStrumY'..i])
         setPropertyFromGroup('playerStrums', i, 'y', _G['defaultPlayerStrumY'..i])
      end
   end
end
local moved = false
function noteMove()
   if moved then
      for i=0,3 do
         if i % 2 == 0 then
            setPropertyFromGroup('opponentStrums', i, 'y', _G['defaultOpponentStrumY'..i] - 30)
            setPropertyFromGroup('playerStrums', i, 'y', _G['defaultPlayerStrumY'..i] + 30)
         else
            setPropertyFromGroup('opponentStrums', i, 'y', _G['defaultOpponentStrumY'..i] + 30)
            setPropertyFromGroup('playerStrums', i, 'y', _G['defaultPlayerStrumY'..i] - 30)
         end
      end
   else
      for i=0,3 do
         if i % 2 == 0 then
            setPropertyFromGroup('opponentStrums', i, 'y', _G['defaultOpponentStrumY'..i] + 30)
            setPropertyFromGroup('playerStrums', i, 'y', _G['defaultPlayerStrumY'..i] - 30)
         else
            setPropertyFromGroup('opponentStrums', i, 'y', _G['defaultOpponentStrumY'..i] - 30)
            setPropertyFromGroup('playerStrums', i, 'y', _G['defaultPlayerStrumY'..i] + 30)
         end
      end
   end
   moved = not moved
end