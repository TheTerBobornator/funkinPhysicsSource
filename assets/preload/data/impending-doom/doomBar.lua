--healthbar stuff in it's own script file, just makes things easier
--if we decide to add more animated icons in the future i'll make actual support for it in source but for now this is fine because it uses y values too
function onCreatePost()
    setProperty('healthBar.angle', -90)
    updateHitbox('healthBar')
    setProperty('healthBar.x', -200)
    screenCenter('healthBar', 'y')
    setHealthBarColors('0xFFFF0000', '0xFF000000')

    makeLuaSprite('healthBarCover', 'doomBar', 20, 0)
    screenCenter('healthBarCover', 'y')
    setScrollFactor('healthBarCover', 1.0, 1.0)
    setObjectCamera('healthBarCover', 'camHUD')
    addLuaSprite('healthBarCover', true)

    makeAnimatedLuaSprite('fakeIcon', 'icons/icon-terry-insane-animated', 40, 0)
    addAnimationByPrefix('fakeIcon', 'idle', 'idle', 24, true)
    playAnim('fakeIcon', 'idle')
    screenCenter('fakeIcon', 'y')
    setScrollFactor('fakeIcon', 1.0, 1.0)
    setObjectCamera('fakeIcon', 'camHUD')
    addLuaSprite('fakeIcon', true)

    setProperty('iconP1.visible', false)
    setProperty('iconP2.visible', false)
end

function onUpdate(elapsed)
    iconMult = getProperty('healthBar.y') + ((getProperty('healthBar.width') * getProperty('healthBar.percent') * 0.01) - (150 * getProperty('fakeIcon.scale.y')) / 2 - 26 * 2)
    setProperty('fakeIcon.y',iconMult - 240)
    setProperty('fakeIcon.origin.y',-100)
end