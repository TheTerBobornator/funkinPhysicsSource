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

class GameOverSubstateIDIOT extends MusicBeatSubstate
{
	var dead:FlxSprite;
	var stupid:FlxCamera = new FlxCamera();

	public static var instance:GameOverSubstateIDIOT;

	override function create()
	{
		instance = this;
		PlayState.instance.callOnLuas('onGameOverStart', []);

		super.create();
	}

	var daBPM:Int = 100;
	public function new()
	{
		super();

		PlayState.instance.setOnLuas('inGameOver', true);

		Conductor.songPosition = 0;

		FlxG.camera.bgColor = FlxColor.BLACK;
		FlxG.camera.zoom = 1;
		stupid.bgColor.alpha = 0;
		FlxG.cameras.add(stupid, false);

		dead = new FlxSprite();
		dead.frames = Paths.getSparrowAtlas('gameOver/yaai_death_thing');
		dead.animation.addByPrefix('loop', "dead loop", 24, true);
		dead.animation.addByPrefix('confirm', "dead retry", 24, false);
		dead.animation.play('loop', true);
		dead.screenCenter();
		dead.antialiasing = ClientPrefs.globalAntialiasing;
		dead.alpha = 0;
		dead.cameras = [stupid];
		add(dead);

		FlxG.sound.play(Paths.sound('fnf_loss_sfx'));
		
		Conductor.changeBPM(daBPM);

		new FlxTimer().start(0.5, function(tmr:FlxTimer)
		{
			coolStartDeath(0);
			FlxG.sound.music.fadeIn(4, 0, 1);
			FlxTween.tween(dead, {alpha: 1}, 4, {ease: FlxEase.linear});
		});
	}

	var isFollowingAlready:Bool = false;
	override function update(elapsed:Float)
	{
		super.update(elapsed);

		PlayState.instance.callOnLuas('onUpdate', [elapsed]);

		if (controls.ACCEPT)
		{
			endBullshit();
		}

		if (controls.BACK)
		{
			FlxG.sound.music.stop();
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

		if (FlxG.sound.music.playing)
		{
			Conductor.songPosition = FlxG.sound.music.time;
		}
		PlayState.instance.callOnLuas('onUpdatePost', [elapsed]);
	}

	override function beatHit()
	{
		super.beatHit();

		//FlxG.log.add('beat');
	}

	var isEnding:Bool = false;

	function coolStartDeath(?volume:Float = 1):Void
	{
		FlxG.sound.playMusic(Paths.music('gameOverIDIOT'), volume);
	}

	function endBullshit():Void
	{
		if (!isEnding)
		{
			isEnding = true;
			dead.animation.play('confirm', true);
			FlxG.sound.music.stop();
			FlxG.sound.play(Paths.music('gameOverChillEnd'));
			new FlxTimer().start(0.7, function(tmr:FlxTimer)
			{
				stupid.fade(FlxColor.BLACK, 2, false, function()
				{
					MusicBeatState.resetState();
				});
			});
			PlayState.instance.callOnLuas('onGameOverConfirm', [true]);
		}
	}
}