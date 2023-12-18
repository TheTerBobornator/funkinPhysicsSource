local isUp = false;
local isDown = true;
local isLeft = true;
local isRight = false;
local bounceMult = 0;
--it might seem excessive to have all of these values here and set them but i want this to work the same on all monitor resolutions
local monitorWidth = 0;
local monitorHeight = 0;
local windowWidth = 0;
local windowHeight = 0;
local monitorCenterX = 0;
local monitorCenterY = 0;

function onCreate()
    if shaking then
        -- this little set of functions here sets the window to fullscreen really fast, then gets the width and height properties
        -- there might be a better way to get these but for now this is fine
        setPropertyFromClass("openfl.Lib", "application.window.fullscreen", true)
        monitorWidth = getPropertyFromClass("openfl.Lib", "application.window.width")
        monitorHeight = getPropertyFromClass("openfl.Lib", "application.window.height")
        windowWidth = monitorWidth / 2
        windowHeight = monitorHeight / 2
        monitorCenterX = monitorWidth - (getPropertyFromClass("openfl.Lib", "application.window.width") / 2)
        monitorCenterY = monitorHeight - (getPropertyFromClass("openfl.Lib", "application.window.height") / 2)

        curWindowX = getPropertyFromClass("openfl.Lib", "application.window.x")
        curWindowY = getPropertyFromClass("openfl.Lib", "application.window.y")
        setPropertyFromClass("openfl.Lib", "application.window.width", monitorWidth)
        setPropertyFromClass("openfl.Lib", "application.window.height", monitorHeight)
        setPropertyFromClass("openfl.Lib", "application.window.x", 0)
        setPropertyFromClass("openfl.Lib", "application.window.y", 0)
        setPropertyFromClass("openfl.Lib", "application.window.resizable", false)
    end
        setPropertyFromClass("openfl.Lib", "application.window.title", 'You are an idiot!')
end

function onSongStart()
    if shaking then
        --debugPrint(getPropertyFromClass(monitorCenterX));
        triggerEvent('Tween Window Size', windowWidth..', '..windowHeight, '9')
    end
end

function onStepHit()
    if shaking then
        if curStep == 640 then
            bounceMult = 0
        end
        if curStep == 128 or curStep == 960 or curStep == 1460 then
            bounceMult = 1
        end
        if curStep == 384 or curStep == 1458 or curStep == 1600 then
            bounceMult = 2
        end
        if curStep == 1456 then
            bounceMult = 3
        end
        if curStep == 704 or curStep == 1216 or curStep == 1665 then
            bounceMult = 4
        end

        if curStep == 1462 then
            bounceMult = 0
            triggerEvent('Tween Window Position', monitorCenterX..', '..monitorCenterY, '1')
        end
        if curStep == 1467 then
            triggerEvent('Tween Window Size', monitorWidth..', '..monitorHeight, '2')
        end
        if curStep == 1600 then
            triggerEvent('Tween Window Size', windowWidth..', '..windowHeight, '4.5')
        end
        if curStep == 1936 then
            bounceMult = 0
        end
    end
end

function onUpdatePost(elapsed)
    if shaking then
        if (curStep >= 1478 and curStep < 1600) or curStep >= 1936 then
            setPropertyFromClass("openfl.Lib", "application.window.fullscreen", true)
        else
            setPropertyFromClass("openfl.Lib", "application.window.fullscreen", false)
        end
        monitorCenterX = (monitorWidth / 2) - (getPropertyFromClass("openfl.Lib", "application.window.width") / 2)
        monitorCenterY = (monitorHeight / 2) - (getPropertyFromClass("openfl.Lib", "application.window.height") / 2)
        if curBeat < 32 or (curStep >= 1467 and curStep < 1478) or (curStep >= 1600 and curStep < 1664) then
            setPropertyFromClass("openfl.Lib", "application.window.x", monitorCenterX)
            setPropertyFromClass("openfl.Lib", "application.window.y", monitorCenterY)
        end

        if getPropertyFromClass("openfl.Lib", "application.window.x") <= 0 then
            isLeft = true
            isRight = false
        end
        if getPropertyFromClass("openfl.Lib", "application.window.x") >= (monitorWidth - windowWidth) then
            isRight = true
            isLeft = false
        end
        if getPropertyFromClass("openfl.Lib", "application.window.y") <= 0 then
            isUp = true
            isDown = false
        end
        if getPropertyFromClass("openfl.Lib", "application.window.y") >= (monitorHeight - windowHeight) then
            isDown = true
            isUp = false
        end

        if bounceMult ~= 0 then
            if isLeft == true then
                setPropertyFromClass("openfl.Lib", "application.window.x", getPropertyFromClass("openfl.Lib", "application.window.x") + bounceMult)
            end
            if isRight == true then
                setPropertyFromClass("openfl.Lib", "application.window.x", getPropertyFromClass("openfl.Lib", "application.window.x") - bounceMult)
            end
            if isDown == true then
                setPropertyFromClass("openfl.Lib", "application.window.y", getPropertyFromClass("openfl.Lib", "application.window.y") - bounceMult)
            end
            if isUp == true then
                setPropertyFromClass("openfl.Lib", "application.window.y", getPropertyFromClass("openfl.Lib", "application.window.y") + bounceMult)
            end
        end
    end
end