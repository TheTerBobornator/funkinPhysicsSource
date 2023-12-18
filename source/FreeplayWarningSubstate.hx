package;

import options.GraphicsSettingsSubState;
import flixel.util.FlxTimer;
import flixel.effects.FlxFlicker;
import flixel.tweens.FlxEase;
#if desktop
import Discord.DiscordClient;
#end
import editors.ChartingState;
import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxGridOverlay;
import flixel.addons.transition.FlxTransitionableState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.tweens.FlxTween;
import lime.utils.Assets;
import flixel.system.FlxSound;
import openfl.utils.Assets as OpenFlAssets;
import WeekData;
#if MODS_ALLOWED
import sys.FileSystem;
#end

using StringTools;

class FreeplayWarningSubstate extends MusicBeatSubstate
{
	// "is this just flashingstate with xtra shit?"
	// yea :)
	var leftState:Bool = false;
	var canProceed:Bool = false;

	var sign:FlxSprite;
	var warnText:FlxText;
	var bg:FlxSprite;

	public function new()
	{
		super();

		bg = new FlxSprite().makeGraphic(Std.int(FlxG.width), Std.int(FlxG.height), FlxColor.BLACK);
		bg.alpha = 0;
		add(bg);

		sign = new FlxSprite(0, FlxG.height).loadGraphic(Paths.image('freeplay/warningSIGN'));
		sign.setGraphicSize(Std.int(sign.width * 1.2));
		sign.updateHitbox();
		sign.screenCenter(X);
		sign.antialiasing = ClientPrefs.globalAntialiasing;
		add(sign);

		warnText = new FlxText(0, FlxG.height, FlxG.width,
			"Press ENTER to go to Options Menu and disable certain aspects.\nPress ESCAPE to proceed.\nPress ESCAPE + SHIFT to proceed and never see this popup again.",
			24);
		warnText.setFormat(Paths.font("impact.otf"), 24, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		warnText.screenCenter(X);
		warnText.antialiasing = ClientPrefs.globalAntialiasing;
		add(warnText);

		FlxTween.tween(bg, {alpha: 0.5}, 0.8, {ease: FlxEase.quadOut});
		FlxTween.tween(sign, {y: 50}, 1, {ease: FlxEase.quadOut,
			onComplete: function (twn:FlxTween) {
				canProceed = true;
			}
		});
		FlxTween.tween(warnText, {y: 600}, 1.2, {ease: FlxEase.quadOut});
	}

	override function update(elapsed:Float)
	{
		if(!leftState && canProceed) 
		{
			var back:Bool = controls.BACK;
			if (controls.ACCEPT || back) 
			{
				leftState = true;
				if(!back) 
				{
					FlxG.sound.play(Paths.sound('confirmMenu'));
					FlxFlicker.flicker(warnText, 1, 0.1, false, true, function(flk:FlxFlicker) {
						new FlxTimer().start(0.5, function (tmr:FlxTimer) {
							LoadingState.loadAndSwitchState(new options.OptionsState(PlayState.songCategory));
							//openSubState(new options.GraphicsSettingsSubState());
						});
					});
				} 
				else 
				{
					FlxG.sound.play(Paths.sound('confirmMenu'));
					FlxTween.tween(warnText, {alpha: 0}, 1, {
						onComplete: function (twn:FlxTween) {
							LoadingState.loadAndSwitchState(new PlayState());
							FlxG.sound.music.volume = 0; // idk freeplay calls it
						}
					});
					FlxTween.tween(sign, {alpha: 0}, 1);
					FlxTween.tween(bg, {alpha: 0}, 1);
					if (FlxG.keys.pressed.SHIFT)
						FlxG.save.data.freeplayWarning = false;
				}
			}
		}
		super.update(elapsed);
	}
}