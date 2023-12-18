package;

import lime.app.Event;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.graphics.FlxGraphic;
import flixel.util.FlxColor;
import hxcodec.VideoHandler;

/**
 * THIS IS LITERALLY JUST VIDEOSPRITE THAT USES VIDEOHANDLERVOLFIX INSTEAD I HATE THIS BUT I WAS OUT OF OPTIONS IM GOING TO FIX THIS BETTER BUT MEANWHILE IMMA KMS
 */
class VideoSpriteVolFix extends FlxSprite
{
	public var bitmap:VideoHandlerVolFix;
	public var canvasWidth:Null<Int>;
	public var canvasHeight:Null<Int>;

	public var openingCallback:Void->Void = null;
	public var graphicLoadedCallback:Void->Void = null;
	public var finishCallback:Void->Void = null;

	public function new(X:Float = 0, Y:Float = 0)
	{
		super(X, Y);

        trace ('using NEW video sprite loader');
		makeGraphic(1, 1, FlxColor.TRANSPARENT);

		bitmap = new VideoHandlerVolFix();
		bitmap.canUseAutoResize = false;
		bitmap.visible = false;
		bitmap.openingCallback = function()
		{
			if (openingCallback != null)
				openingCallback();
		}
		bitmap.finishCallback = function()
		{
			oneTime = false;

			if (finishCallback != null)
				finishCallback();

			kill();
		}
        //bitmap.volume = Std.int(#if FLX_SOUND_SYSTEM ((FlxG.sound.muted) ? 0 : 1) * #end (FlxG.sound.volume * 100));
	}

	private var oneTime:Bool = false;
	override function update(elapsed:Float)
	{
		super.update(elapsed);

        //bitmap.volume = Std.int(#if FLX_SOUND_SYSTEM ((FlxG.sound.muted) ? 0 : 1) * #end (FlxG.sound.volume * 100));

		if (bitmap.isPlaying && bitmap.isDisplaying && bitmap.bitmapData != null && !oneTime)
		{
            var graphic:FlxGraphic = FlxG.bitmap.add(bitmap.bitmapData, false, bitmap.mrl);
			if (graphic.imageFrame.frame == null)
			{
				#if HXC_DEBUG_TRACE
				trace('the frame of the image is null?');
				#end
				return;
			}

			loadGraphic(graphic);

			if (canvasWidth != null && canvasHeight != null)
			{
				setGraphicSize(canvasWidth, canvasHeight);
				updateHitbox();
			}

			if (graphicLoadedCallback != null)
				graphicLoadedCallback();

			oneTime = true;
		}
	}

	/**
	 * Native video support for Flixel & OpenFL
	 * @param Path Example: `your/video/here.mp4`
	 * @param Loop Loop the video.
	 * @param PauseMusic Pause music until the video ends.
	 */
	public function playVideo(Path:String, Loop:Bool = false, PauseMusic:Bool = false):Void
		bitmap.playVideo(Path, Loop, PauseMusic);
}
