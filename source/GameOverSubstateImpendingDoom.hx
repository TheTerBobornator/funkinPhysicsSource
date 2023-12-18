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

class GameOverSubstateImpendingDoom extends MusicBeatSubstate
{
	public var boyfriend:Boyfriend;
	var camFollow:FlxPoint;
	var camFollowPos:FlxObject;
	var updateCamera:Bool = false;
	var trolled:FlxSprite;
	var scaryTimer:FlxTimer;
	var endSound:FlxSound = new FlxSound(); //used to get the duration of the sfx for the fade to be more seamless
	public static var instance:GameOverSubstateImpendingDoom;

	override function create()
	{
		instance = this;
		PlayState.instance.callOnLuas('onGameOverStart', []);

		super.create();
	}

	var daBPM:Int = 100;
	public function new(x:Float, y:Float, camX:Float, camY:Float)
	{
		super();

		PlayState.instance.setOnLuas('inGameOver', true);

		Conductor.songPosition = 0;

		boyfriend = new Boyfriend(x, y, 'bf-dead');
		boyfriend.x += boyfriend.positionArray[0];
		boyfriend.y += boyfriend.positionArray[1];
		add(boyfriend);

		trolled = new FlxSprite().loadGraphic(Paths.image('trolled'));
		trolled.antialiasing = ClientPrefs.globalAntialiasing;
		trolled.alpha = 0.00001;
		trolled.scale.x = 0.5;
		trolled.scale.y = 0.5;
		trolled.updateHitbox();
		trolled.setPosition(boyfriend.x - 125, boyfriend.y - 100);
		//trolled.blend = ADD; meh
		add(trolled);

		camFollow = new FlxPoint(boyfriend.getGraphicMidpoint().x, boyfriend.getGraphicMidpoint().y);
		
		Conductor.changeBPM(daBPM);
		// FlxG.camera.followLerp = 1;
		// FlxG.camera.focusOn(FlxPoint.get(FlxG.width / 2, FlxG.height / 2));
		FlxG.camera.scroll.set();
		FlxG.camera.target = null;

		FlxG.sound.play(Paths.sound('fnf_loss_shortened'));
		boyfriend.playAnim('firstDeath', true);

		scaryTimer = new FlxTimer().start(0.1, function(tmr:FlxTimer)
		{
			FlxG.sound.play(Paths.sound('fnf_loss_shortened'));
			boyfriend.playAnim('firstDeath', true);
			//FlxG.camera.zoom = FlxG.camera.zoom + 0.05;
			if (scaryTimer.loopsLeft == 0)
			{
				boyfriend.alpha = 0;
				trolled.alpha = 0.1;
				FlxTween.tween(trolled, {alpha: 1}, 60);
				FlxTween.tween(trolled.scale, {x: 2, y: 2}, 300);
			}
		}, 12); //play it 13 times haha unlucky number

		camFollowPos = new FlxObject(0, 0, 1, 1);
		camFollowPos.setPosition(FlxG.camera.scroll.x + (FlxG.camera.width / 2), FlxG.camera.scroll.y + (FlxG.camera.height / 2));
		add(camFollowPos);
	}

	var isFollowingAlready:Bool = false;
	override function update(elapsed:Float)
	{
		super.update(elapsed);

		PlayState.instance.callOnLuas('onUpdate', [elapsed]);
		if(updateCamera) {
			var lerpVal:Float = CoolUtil.boundTo(elapsed * 2.5, 0, 1);
			camFollowPos.setPosition(FlxMath.lerp(camFollowPos.x, camFollow.x, lerpVal), FlxMath.lerp(camFollowPos.y, camFollow.y, lerpVal));
		}

		if (trolled.alpha > 0.2)
		{
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
		}

		if (boyfriend.animation.curAnim != null && boyfriend.animation.curAnim.name == 'firstDeath')
		{
			if(!isFollowingAlready)
			{
				FlxG.camera.follow(camFollowPos, LOCKON, 1);
				updateCamera = true;
				isFollowingAlready = true;
			}
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

	function endBullshit():Void
	{
		if (!isEnding)
		{
			isEnding = true;
			boyfriend.playAnim('deathConfirm', true);
			FlxG.sound.music.stop();

			endSound.loadEmbedded(Paths.music('gameOverTenseEnd'), false, true);
			endSound.play(true, 0);
			FlxG.sound.list.add(endSound);

			new FlxTimer().start(0.7, function(tmr:FlxTimer)
			{
				FlxG.camera.fade(FlxColor.BLACK, (endSound.length / 1000) - 0.7, false, function()
				{
					endSound.destroy();
					MusicBeatState.resetState();
				});
			});
			PlayState.instance.callOnLuas('onGameOverConfirm', [true]);
		}
	}
}