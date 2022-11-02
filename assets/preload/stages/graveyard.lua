function onCreate()
    makeLuaSprite('fog', 'backgrounds/graveyard/the-fog-is-coming', -460, -50);
    setScrollFactor('fog', 0.7, 0.7);
    addLuaSprite('fog', false);

    makeLuaSprite('ground', 'backgrounds/graveyard/ground', -460, -100);
    setScrollFactor('ground', 1.0, 1.0);
    addLuaSprite('ground', false);

    makeLuaSprite('headstones', 'backgrounds/graveyard/headstones', -460, -50);
    setScrollFactor('headstones', 1.0, 1.0);
    addLuaSprite('headstones', false);

    makeAnimatedLuaSprite('trollSkele', 'backgrounds/graveyard/TrollSkull_Assets', -400, 450);
    addAnimationByPrefix('trollSkele', 'idle', 'TrollSkull_Assets', 24, false);
    setScrollFactor('trollSkele', 1, 1);
    addLuaSprite('trollSkele', false);

    makeAnimatedLuaSprite('mcSkele', 'backgrounds/graveyard/MCSkeleton_Assets', 1300, 350);
    addAnimationByPrefix('mcSkele', 'idle', 'MCSkeleton_Assets', 24, false);
    setScrollFactor('mcSkele', 1, 1);
    addLuaSprite('mcSkele', false);

  --  makeAnimatedLuaSprite('sans', 'backgrounds/graveyard/Sans_Assets', 1400, 600);
  --  addAnimationByPrefix('sans', 'idle', 'Sans_Assets', 24, false);
  --  setScrollFactor('sans', 1, 1);
  --  addLuaSprite('sans', false);

    makeAnimatedLuaSprite('frontSkele1', 'backgrounds/graveyard/FrontSkeleton1_Assets', -400, 800);
    addAnimationByPrefix('frontSkele1', 'idle', 'FrontSkeleton1_Assets', 24, false);
    setScrollFactor('frontSkele1', 1.1, 1.1);
    addLuaSprite('frontSkele1', true);

    makeAnimatedLuaSprite('frontSkele2', 'backgrounds/graveyard/FrontSkeleton2_Assets', 1500, 900);
    addAnimationByPrefix('frontSkele2', 'idle', 'FrontSkeleton2_Assets', 24, false);
    setScrollFactor('frontSkele2', 1.1, 1.1);
    addLuaSprite('frontSkele2', true);
    
    makeLuaSprite('overlay', 'backgrounds/graveyard/trees', -460, -50);
    setScrollFactor('overlay', 1.2, 1.2);
    addLuaSprite('overlay', true);
end

function onBeatHit()
    if curBeat % 2 == 0 then
        playAnim('frontSkele1', 'idle');
        playAnim('frontSkele2', 'idle');
        playAnim('trollSkele', 'idle');
        playAnim('mcSkele', 'idle');
     --   playAnim('sans', 'idle');
    end
end