local epicCoolCameraShit = true;
function onBeatHit()
    if curBeat == 41 then
        epicCoolCameraShit = false
    end
    if curBeat == 48 then
        epicCoolCameraShit = true
    end
    if curBeat == 144 then
        epicCoolCameraShit = false
        cameraFlash('hud', '0xFF000000', '2')
    end
end

function onUpdate()
    if epicCoolCameraShit == true then
        if mustHitSection then
            setProperty('defaultCamZoom', 0.9)
        else
            setProperty('defaultCamZoom', 0.7)
        end
    end
end