package;

import flixel.system.FlxSound;
import flixel.FlxCamera;
import flixel.effects.FlxFlicker;
import flixel.FlxSprite;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSubState;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;

class GameOverSubstateCY extends MusicBeatSubstate
{
	public var face1:FlxSprite;
	public var face2:FlxSprite;
	public var retry:FlxSprite;

	var canEnd:Bool = false;
	var jumpscareTimer:FlxTimer;
	var stupid:FlxCamera = new FlxCamera();

	public static var instance:GameOverSubstateCY;

	override function create()
	{
		instance = this;
		PlayState.instance.callOnLuas('onGameOverStart', []);

		super.create();
	}

	public function new()
	{
		super();

		PlayState.instance.setOnLuas('inGameOver', true);

		Conductor.songPosition = 0;

		FlxG.camera.bgColor = FlxColor.BLACK;
		FlxG.camera.zoom = 1;
		stupid.bgColor.alpha = 0;
		FlxG.cameras.add(stupid, false);

		face1 = new FlxSprite().loadGraphic(Paths.image('gameOver/face1'));
		face1.antialiasing = ClientPrefs.globalAntialiasing;
		face1.screenCenter();
		face1.cameras = [stupid];
		add(face1);

		face2 = new FlxSprite().loadGraphic(Paths.image('gameOver/face2'));
		face2.antialiasing = ClientPrefs.globalAntialiasing;
		face2.screenCenter();
		face2.visible = false;
		face2.cameras = [stupid];
		add(face2);

		retry = new FlxSprite().loadGraphic(Paths.image('gameOver/retry'));
		retry.antialiasing = ClientPrefs.globalAntialiasing;
		retry.screenCenter();
		retry.alpha = 0.00001;
		retry.cameras = [stupid];
		add(retry);

		FlxG.sound.play(Paths.sound('jumpscareCY'));

		if (PlayState.deathCounter > 1)
			canEnd = true;

		Conductor.changeBPM(100);

		jumpscareTimer = new FlxTimer().start(9.5, function(tmr:FlxTimer)
		{
			jumpscare();
		});
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		PlayState.instance.callOnLuas('onUpdate', [elapsed]);

		if (canEnd)
		{
			if (controls.ACCEPT)
				endBullshit();

			if (controls.BACK)
			{
				PlayState.deathCounter = 0;
				PlayState.seenCutscene = false;
				PlayState.chartingMode = false;

				WeekData.loadTheFirstEnabledMod();

				if(PlayState.isStoryMode) 
					MusicBeatState.switchState(new MainMenuState());
				else
					MusicBeatState.switchState(new FreeplayState(PlayState.songCategory));

				FlxG.sound.playMusic(Paths.music('freakyMenu'));
				PlayState.instance.callOnLuas('onGameOverConfirm', [false]);
			}
		}
		PlayState.instance.callOnLuas('onUpdatePost', [elapsed]);
	}

	override function beatHit()
	{
		super.beatHit();
	}

	var isEnding:Bool = false;

	function endBullshit():Void
	{
		if (!isEnding)
		{
			isEnding = true;
			FlxG.sound.music.stop();
			FlxG.sound.play(Paths.music('gameOverEndCY'));
			new FlxTimer().start(0.5, function(tmr:FlxTimer)
			{
				stupid.fade(FlxColor.BLACK, 4.5, false, function()
				{
					MusicBeatState.resetState();
				});
			});
			PlayState.instance.callOnLuas('onGameOverConfirm', [true]);
		}
	}

	var flickLoop:Int = 1;

	function jumpscare():Void
	{
		face1.visible = false;
		stupid.shake(0.002, 1);
		FlxFlicker.flicker(face2, 1, 0.1, false, false, 
		function(onComplete:FlxFlicker)
		{
			stupid.flash(0x480000, 1);
			FlxTween.tween(retry, {alpha: 2}, 3, {
				ease: FlxEase.quartIn,
				onComplete: function(twn:FlxTween)
				{
					canEnd = true;
					FlxG.sound.playMusic(Paths.music('gameOverCY'), 1);
				},
				startDelay: 2
			});
		},
		function(onAdvance:FlxFlicker)
		{
			face2.setGraphicSize(Std.int(face2.width + (flickLoop * 25)));
			face2.updateHitbox();
			face2.screenCenter();
			++flickLoop;
		});
	}
}