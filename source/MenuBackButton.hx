package;

import flixel.FlxState;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.graphics.frames.FlxAtlasFrames;

class MenuBackButton extends FlxSprite
{
    var returnState:FlxState;
    var selected:Bool = false;
	public function new(returnState:FlxState) 
    {
		super(x, y);

        this.returnState = returnState;

        loadGraphic(Paths.image('backButton'));
        x = FlxG.width * 0.025;
        y = FlxG.height * 0.85;
        antialiasing = ClientPrefs.globalAntialiasing;
    }

    override function update(elapsed:Float)
    {
        if (FlxG.mouse.overlaps(this))
        {
            if (!selected)
            {  
                FlxG.sound.play(Paths.sound('scrollMenu'));
                setGraphicSize(110);
                updateHitbox();
			}
			if (FlxG.mouse.justPressed)
            {
				FlxG.sound.play(Paths.sound('cancelMenu'));
                if (returnState != null)
				    MusicBeatState.switchState(returnState);
            }
            selected = true;
        }
        else
        {
            selected = false;
            setGraphicSize(94);
            updateHitbox();
        }
        super.update(elapsed);
    }
}