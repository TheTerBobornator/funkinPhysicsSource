local epicCoolCameraShit = true;
function onUpdate()
    if epicCoolCameraShit == true then
        if mustHitSection then
            setProperty('defaultCamZoom', 0.7)
        else
            setProperty('defaultCamZoom', 1.1)
        end
    end
end