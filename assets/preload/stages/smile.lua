local epicCoolCameraShit = true;
function onCreate()
    setProperty('camZooming', true)
    setProperty('camHUD.alpha', 0)
end
function onUpdate()
    if epicCoolCameraShit == true then
        if mustHitSection then
            setProperty('defaultCamZoom', 1.0)
        else
            setProperty('defaultCamZoom', 0.6)
        end
    end
end