function onCreate()
    triggerEvent("Camera Follow Pos", 700, 700)
    makeLuaSprite("funnyBlack", "", -800, -200)
    makeGraphic("funnyBlack", 3000, 2000, "0xFF000000")
    addLuaSprite("funnyBlack", true)
end
function onSongStart()
    doTweenAlpha("shiiii", "funnyBlack", 0, 8.5, "quartIn")
end