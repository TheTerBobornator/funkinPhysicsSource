local epicCoolCameraShit = true;
function onUpdate()
    if epicCoolCameraShit == true then
        if mustHitSection then
            setProperty('defaultCamZoom', 1.1)
        else
            setProperty('defaultCamZoom', 0.8)
        end
    end
end