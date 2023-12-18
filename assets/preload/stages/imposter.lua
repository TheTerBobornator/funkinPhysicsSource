local epicCoolCameraShit = true;
function onUpdate()
    if epicCoolCameraShit == true then
        if mustHitSection then
            setProperty('defaultCamZoom', 0.8)
        else
            setProperty('defaultCamZoom', 0.3)
        end
    end
end