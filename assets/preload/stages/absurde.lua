local epicCoolCameraShit = true;
function onBeatHit()
    if curBeat == 271 or curBeat == 755 or curBeat == 851 then -- one beat less than the real one because yes
        epicCoolCameraShit = false
    end
    if curBeat == 500 or curBeat == 788 then
        epicCoolCameraShit = true
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