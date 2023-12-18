//thanks to @IsItLucas? on YT for this
//https://www.youtube.com/watch?v=HCDvIWtTN00
//pretty sure this might be from vs tabi though so L

package;

import flixel.util.FlxTimer;
import flixel.FlxG;
import openfl.filters.ShaderFilter;

class ShadersHandler
{
	public static var chromaticAberration:ShaderFilter = new ShaderFilter(new Shaders.ChromaticAberration());
	public static var chromaticAberration2:ShaderFilter = new ShaderFilter(new Shaders.ChromaticAberration());
	
	public static function setChrome(chromeOffset:Float):Void
	{
        // before it was chromeOffset on all of them but i dont think thats right?
		chromaticAberration.shader.data.rOffset.value = [chromeOffset];
		chromaticAberration.shader.data.gOffset.value = [0.0];
		chromaticAberration.shader.data.bOffset.value = [chromeOffset * -1];
	}

	public static function setChrome2(chromeOffset:Float):Void
	{
		// before it was chromeOffset on all of them but i dont think thats right?
		chromaticAberration2.shader.data.rOffset.value = [chromeOffset];
		chromaticAberration2.shader.data.gOffset.value = [0.0];
		chromaticAberration2.shader.data.bOffset.value = [chromeOffset * -1];
	}

    public static function setChromeWackyMode(chromeOffset:Float, ?freq:Float = 0.1):Void
	{
		new FlxTimer().start(freq, function(tmr:FlxTimer) 
		{
			chromaticAberration.shader.data.rOffset.value = [chromeOffset * FlxG.random.float(0, 2)];
			chromaticAberration.shader.data.gOffset.value = [0.0];
			chromaticAberration.shader.data.bOffset.value = [(chromeOffset * -1) * FlxG.random.float(0, 2)];
		}, 0);
	}
}