local epicCoolCameraShit = true;
function onBeatHit()
    if curBeat == 168 then
        epicCoolCameraShit = false
        setProperty('defaultCamZoom', 0.7)
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